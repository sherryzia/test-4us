// File: lib/controller/camera_recording_controller.dart

import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:candid/constants/filter.dart';
import 'package:draggable_float_widget/draggable_float_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:candid/constants/app_colors.dart';
import 'package:candid/view/screens/upload_video/unified_preview_screen.dart';


class CameraRecordingController extends GetxController with GetTickerProviderStateMixin {
  // Camera related - using reactive variables
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  final _isRecording = false.obs;
  final _isInitialized = false.obs;
  final _isFrontCamera = true.obs;
  final _isFlashOn = false.obs;
  
  // Category information
  final Rxn<Map<String, dynamic>> _currentCategory = Rxn<Map<String, dynamic>>();
  final Rx<dynamic> _currentCategoryId = Rx<dynamic>(null);
  
  // Timer related
  Timer? _recordingTimer;
  final _recordingDuration = 0.obs;
  static const int _maxRecordingDuration = 60;
  
  // Animation controllers
  late AnimationController recordButtonAnimationController;
  late Animation<double> recordButtonAnimation;
  
  // Speed settings
  final _recordingSpeed = 1.0.obs;
  final List<double> _speedOptions = [0.5, 1.0, 1.5, 2.0];
  int _currentSpeedIndex = 1;
  
  // Timer countdown
  Timer? _countdownTimer;
  final _timerCountdown = 0.obs;
  final _isCountingDown = false.obs;

  // Filter related
  final _showFilters = false.obs;
  late final Rx<FilterOption> _currentFilter;

  // Event stream for draggable widget
  late StreamController<OperateEvent> eventStreamController;

  // Getters - now reactive
  CameraController? get cameraController => _cameraController;
  bool get isRecording => _isRecording.value;
  bool get isInitialized => _isInitialized.value;
  bool get isFrontCamera => _isFrontCamera.value;
  bool get isFlashOn => _isFlashOn.value;
  int get recordingDuration => _recordingDuration.value;
  double get recordingSpeed => _recordingSpeed.value;
  int get timerCountdown => _timerCountdown.value;
  bool get isCountingDown => _isCountingDown.value;
  bool get showFilters => _showFilters.value;
  FilterOption get currentFilter => _currentFilter.value;
  Map<String, dynamic>? get currentCategory => _currentCategory.value;
  dynamic get currentCategoryId => _currentCategoryId.value;

  // Method to set category information
  void setCategoryInfo(Map<String, dynamic>? category, dynamic categoryId) {
    _currentCategory.value = category;
    _currentCategoryId.value = categoryId;
    print('Category info set: ${category?['name']} (ID: $categoryId)');
  }

  @override
  void onInit() {
    super.onInit();
    
    // Initialize current filter
    _currentFilter = FilterOption(
      id: 0,
      name: 'None',
      icon: Icons.filter_none,
      description: 'Original camera view',
      overlayColor: Colors.transparent,
    ).obs;
    
    eventStreamController = StreamController.broadcast();
    
    recordButtonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    recordButtonAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: recordButtonAnimationController,
      curve: Curves.easeInOut,
    ));
    
    initializeCamera();
  }

  @override
  void onClose() {
    // Stop any ongoing recording first
    if (_isRecording.value) {
      _cameraController?.stopVideoRecording().catchError((e) {
        print('Error stopping recording during disposal: $e');
      });
    }
    
    // Cancel timers
    _recordingTimer?.cancel();
    _countdownTimer?.cancel();
    
    // Dispose animation controller
    recordButtonAnimationController.dispose();
    
    // Close event stream
    eventStreamController.close();
    
    // Dispose camera controller with proper error handling
    if (_cameraController != null) {
      _cameraController!.dispose().catchError((e) {
        print('Error disposing camera: $e');
      }).whenComplete(() {
        _cameraController = null;
      });
    }
    
    super.onClose();
  }

  Future<void> initializeCamera() async {
    try {
      final cameraPermission = await Permission.camera.request();
      final microphonePermission = await Permission.microphone.request();
      
      if (cameraPermission.isDenied || microphonePermission.isDenied) {
        Get.snackbar(
          'Permission Required',
          'Camera and microphone permissions are required to record videos.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final cameras = await availableCameras();
      _cameras = cameras;
      
      if (_cameras.isNotEmpty) {
        final frontCamera = _cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
          orElse: () => _cameras.first,
        );
        
        // Dispose existing controller if any
        if (_cameraController != null) {
          await _cameraController!.dispose();
          _cameraController = null;
        }
        
        _cameraController = CameraController(
          frontCamera,
          ResolutionPreset.low,
          enableAudio: true,
          imageFormatGroup: ImageFormatGroup.jpeg,
        );
        
        await _cameraController!.initialize();
        
        // Only set additional settings if controller is still valid
        if (_cameraController != null && _cameraController!.value.isInitialized) {
          await _cameraController!.setFocusMode(FocusMode.auto);
          await _cameraController!.setExposureMode(ExposureMode.auto);
          _isInitialized.value = true;
        }
      }
    } catch (e) {
      print('Error initializing camera: $e');
      _isInitialized.value = false;
      Get.snackbar(
        'Camera Error',
        'Failed to initialize camera: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> toggleCamera() async {
    if (_cameras.length < 2) return;
    
    try {
      _isFrontCamera.value = !_isFrontCamera.value;
      _isInitialized.value = false;
      
      // Stop any ongoing recording
      if (_isRecording.value) {
        await stopRecording();
      }
      
      // Properly dispose of the old controller
      if (_cameraController != null) {
        await _cameraController!.dispose();
        _cameraController = null;
        // Small delay to ensure proper cleanup
        await Future.delayed(const Duration(milliseconds: 200));
      }
      
      final camera = _cameras.firstWhere(
        (camera) => camera.lensDirection == 
            (_isFrontCamera.value ? CameraLensDirection.front : CameraLensDirection.back),
        orElse: () => _cameras.first,
      );
      
      _cameraController = CameraController(
        camera,
        ResolutionPreset.low,
        enableAudio: true,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      
      await _cameraController!.initialize();
      
      // Set camera settings after initialization
      if (_cameraController != null && _cameraController!.value.isInitialized) {
        await _cameraController!.setFocusMode(FocusMode.auto);
        await _cameraController!.setExposureMode(ExposureMode.auto);
        _isInitialized.value = true;
      }
    } catch (e) {
      print('Error toggling camera: $e');
      _isInitialized.value = false;
      Get.snackbar(
        'Camera Error',
        'Failed to switch camera: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> toggleFlash() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;
    
    try {
      _isFlashOn.value = !_isFlashOn.value;
      await _cameraController!.setFlashMode(
        _isFlashOn.value ? FlashMode.torch : FlashMode.off,
      );
      update(['flash']);
    } catch (e) {
      print('Error toggling flash: $e');
      _isFlashOn.value = !_isFlashOn.value; // Revert the change
    }
  }

  void changeSpeed() {
    _currentSpeedIndex = (_currentSpeedIndex + 1) % _speedOptions.length;
    _recordingSpeed.value = _speedOptions[_currentSpeedIndex];
    update(['speed']);
  }

  void startCountdown(int seconds) {
    _timerCountdown.value = seconds;
    _isCountingDown.value = true;
    update(['countdown']);
    
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _timerCountdown.value--;
      update(['countdown']);
      
      if (_timerCountdown.value <= 0) {
        timer.cancel();
        _isCountingDown.value = false;
        update(['countdown']);
        startRecording();
      }
    });
  }

  Future<void> startRecording() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      Get.snackbar(
        'Camera Error',
        'Camera is not ready for recording',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    try {
      if (!_isRecording.value) {
        await _cameraController!.startVideoRecording();
        recordButtonAnimationController.forward();
        
        _isRecording.value = true;
        _recordingDuration.value = 0;
        _showFilters.value = false; // Hide filters during recording
        update(['record_button', 'recording']);
        
        _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          _recordingDuration.value++;
          update(['recording']);
          
          if (_recordingDuration.value >= _maxRecordingDuration) {
            stopRecording();
          }
        });
      }
    } catch (e) {
      print('Error starting recording: $e');
      _isRecording.value = false;
      recordButtonAnimationController.reverse();
      Get.snackbar(
        'Recording Error',
        'Failed to start recording: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> stopRecording() async {
    if (_cameraController == null || !_isRecording.value) return;
    
    try {
      final XFile videoFile = await _cameraController!.stopVideoRecording();
      recordButtonAnimationController.reverse();
      _recordingTimer?.cancel();
      
      _isRecording.value = false;
      final duration = _recordingDuration.value;
      _recordingDuration.value = 0;
      update(['record_button', 'recording']);
      
      showVideoPreview(videoFile, duration);
      
    } catch (e) {
      print('Error stopping recording: $e');
      _isRecording.value = false;
      _recordingDuration.value = 0;
      recordButtonAnimationController.reverse();
      _recordingTimer?.cancel();
      update(['record_button', 'recording']);
      Get.snackbar(
        'Recording Error',
        'Failed to stop recording: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void showVideoPreview(XFile videoFile, int duration) {
    Get.to(() => UnifiedPreviewScreen(
      filePath: videoFile.path,
      fileType: 'video',
      category: _currentCategory.value,
      source: PreviewSource.regularCamera,
      duration: duration,
      filterId: _currentFilter.value.id,
      onRetake: () {
        File(videoFile.path).delete().catchError((e) {
          print('Error deleting video file: $e');
        });
        Navigator.of(Get.context!).pop();
      },
      onSave: (String filePath, String fileType) {
        Get.snackbar(
          'Success',
          'Video saved successfully with ${_currentFilter.value.name} filter!',
          snackPosition: SnackPosition.BOTTOM,
        );
        Navigator.of(Get.context!).pop();
        Navigator.of(Get.context!).pop();
      },
    ));
  }

  void toggleFilters() {
    _showFilters.value = !_showFilters.value;
    update(['filter_button']);
  }

  void selectFilter(FilterOption filter) {
    _currentFilter.value = filter;
    update(['filter', 'filter_selection', 'filter_button', 'record_button']);
  }

  Color getFilterDisplayColor() {
    if (_currentFilter.value.overlayColor == Colors.transparent) {
      return kSecondaryColor;
    }
    return _currentFilter.value.overlayColor;
  }

  String formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}