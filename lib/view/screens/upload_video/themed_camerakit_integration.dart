import 'dart:io';
import 'package:candid/view/screens/upload_video/unified_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:camerakit_flutter/camerakit_flutter.dart';
import 'package:camerakit_flutter/lens_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';

// Your existing imports
import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/view/widget/my_text_widget.dart';

class ThemedCameraKitScreen extends StatefulWidget {
  final Map<String, dynamic>? category;
  final categoryId;
  final VoidCallback? onBack;

  const ThemedCameraKitScreen({
    super.key,
    this.category,
    required this.categoryId,
    this.onBack,
  });

  @override
  State<ThemedCameraKitScreen> createState() => _ThemedCameraKitScreenState();
}

class _ThemedCameraKitScreenState extends State<ThemedCameraKitScreen> 
    implements CameraKitFlutterEvents {
  late final CameraKitFlutterImpl _cameraKitFlutterImpl;
  bool _hasPermissions = false;
  bool _isLoading = false;
  bool _hasError = false; // ADD THIS - was missing
  String _errorMessage = ''; // ADD THIS - was missing
  bool _isReopeningCamera = false; // ADD THIS - was missing
  String? _filePath;
  String? _fileType;

  // Replace with your actual CameraKit group IDs
  static const List<String> groupIdList = ['ec2711e5-1c4f-49c8-aec9-77c0042affff'];

  @override
  void initState() {
    super.initState();
    _cameraKitFlutterImpl = CameraKitFlutterImpl(cameraKitFlutterEvents: this);
    _checkAndRequestPermissions();
  }

  Future<void> _checkAndRequestPermissions() async {
    setState(() {
      _isLoading = true;
    });

    final cameraStatus = await Permission.camera.status;
    final microphoneStatus = await Permission.microphone.status;

    if (!cameraStatus.isGranted || !microphoneStatus.isGranted) {
      final cameraResult = await Permission.camera.request();
      final microphoneResult = await Permission.microphone.request();
      
      _hasPermissions = cameraResult.isGranted && microphoneResult.isGranted;
    } else {
      _hasPermissions = true;
    }

    setState(() {
      _isLoading = false;
    });

    if (_hasPermissions) {
      _openCameraKit();
    }
  }

  void _openCameraKit() {
    _cameraKitFlutterImpl.openCameraKit(
      groupIds: groupIdList,
      isHideCloseButton: true, // We'll use our own close button
    );
  }

  void _retryPermissions() {
    _checkAndRequestPermissions();
  }

  void _openSettings() {
    openAppSettings();
  }

  @override
  void receivedLenses(List<Lens> lensList) {
    // Handle received lenses if needed
    print('Received ${lensList.length} lenses');
  }

  @override
  void onCameraKitResult(Map<dynamic, dynamic> result) {
    setState(() {
      _filePath = result["path"] as String?;
      _fileType = result["type"] as String?;
    });

    if (_filePath != null && _fileType != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => UnifiedPreviewScreen(
            filePath: _filePath!,
            fileType: _fileType!,
            category: widget.category,
            source: PreviewSource.effectsCamera, // Specify effects source
            onRetake: () {
              Navigator.of(context).pop(); // Close preview
              _reopenCameraKit(); // Reopen effects camera
            },
            onSave: (String filePath, String fileType) {
              Navigator.of(context).pop(); // Close preview
              Navigator.of(context).pop(); // Close CameraKit, back to StartRecording
            },
          ),
        ),
      );
    }
  }

  void _reopenCameraKit() {
    print('Reopening CameraKit after retake...');
    setState(() {
      _isReopeningCamera = true;
      _hasError = false;
      _errorMessage = '';
    });
    
    // Small delay to ensure preview screen is fully closed
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) { // FIXED: removed _cameraKitFlutterImpl check
        try {
          print('Attempting to reopen CameraKit...');
          _cameraKitFlutterImpl.openCameraKit(
            groupIds: groupIdList,
            isHideCloseButton: true,
          );
          print('CameraKit reopened successfully');
          
          // Reset the reopening flag after a short delay
          Future.delayed(Duration(milliseconds: 1000), () {
            if (mounted) {
              setState(() {
                _isReopeningCamera = false;
              });
            }
          });
        } catch (e) {
          print('Error reopening CameraKit: $e');
          setState(() {
            _hasError = true;
            _errorMessage = 'Failed to reopen camera effects: ${e.toString()}';
            _isReopeningCamera = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ADD ERROR HANDLING
    if (_hasError) {
      return _buildErrorScreen();
    }

    if (_isLoading) {
      return _buildLoadingScreen();
    }

    if (!_hasPermissions) {
      return _buildPermissionScreen();
    }

    // This shows briefly before CameraKit opens
    return _buildInitializingScreen();
  }

  // ADD THIS METHOD - was missing
  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Top controls
          Positioned(
            top: 55,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    widget.onBack?.call();
                    Get.back();
                  },
                  child: Image.asset(Assets.imagesClose, height: 20),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Effects Error',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          
          // Error content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 80,
                    color: Colors.red,
                  ),
                  SizedBox(height: 32),
                  MyText(
                    text: 'Effects Unavailable',
                    size: 24,
                    color: kPrimaryColor,
                    weight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  MyText(
                    text: _errorMessage.isNotEmpty 
                        ? _errorMessage 
                        : 'Camera effects are currently unavailable. Please try again later.',
                    size: 16,
                    color: kPrimaryColor.withOpacity(0.7),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 48),
                  
                  // Retry button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [kSecondaryColor, kPurpleColor],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          setState(() {
                            _hasError = false;
                            _errorMessage = '';
                          });
                          _checkAndRequestPermissions();
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.refresh, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            MyText(
                              text: 'Try Again',
                              size: 16,
                              color: Colors.white,
                              weight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Match your recording screen's top controls
          Positioned(
            top: 55,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    widget.onBack?.call();
                    Get.back();
                  },
                  child: Image.asset(Assets.imagesClose, height: 20),
                ),
                if (widget.category != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: kSecondaryColor.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.category!['name'] ?? 'Category',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Effects',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          
          // Loading indicator
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: kSecondaryColor,
                  strokeWidth: 3,
                ),
                SizedBox(height: 24),
                MyText(
                  text: 'Loading Effects...',
                  size: 16,
                  color: kPrimaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Top controls matching your theme
          Positioned(
            top: 55,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    widget.onBack?.call();
                    Get.back();
                  },
                  child: Image.asset(Assets.imagesClose, height: 20),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Effects Permission',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          
          // Permission request content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(Assets.imagesEffects, height: 80),
                  SizedBox(height: 32),
                  MyText(
                    text: 'Camera & Microphone Access Required',
                    size: 24,
                    color: kPrimaryColor,
                    weight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  MyText(
                    text: 'Effects need camera and microphone permissions to apply filters and record videos.',
                    size: 16,
                    color: kPrimaryColor.withOpacity(0.7),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 48),
                  
                  // Grant permissions button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [kSecondaryColor, kPurpleColor],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: MaterialButton(
                        onPressed: _retryPermissions,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.refresh, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            MyText(
                              text: 'Grant Permissions',
                              size: 16,
                              color: Colors.white,
                              weight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Open settings button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: MaterialButton(
                      onPressed: _openSettings,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(color: kSecondaryColor, width: 2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.settings, color: kSecondaryColor, size: 20),
                          SizedBox(width: 8),
                          MyText(
                            text: 'Open Settings',
                            size: 16,
                            color: kSecondaryColor,
                            weight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitializingScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Top controls
          Positioned(
            top: 55,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    widget.onBack?.call();
                    Get.back();
                  },
                  child: Image.asset(Assets.imagesClose, height: 20),
                ),
                if (widget.category != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: kSecondaryColor.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.category!['name'] ?? 'Category',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _isReopeningCamera ? 'Reopening Effects...' : 'Effects', // UPDATED
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          
          // Opening effects message
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(Assets.imagesEffects, height: 80),
                SizedBox(height: 24),
                MyText(
                  text: _isReopeningCamera ? 'Reopening Effects...' : 'Opening Effects...', // UPDATED
                  size: 18,
                  color: kPrimaryColor,
                  weight: FontWeight.w600,
                ),
                SizedBox(height: 24),
                CircularProgressIndicator(
                  color: kSecondaryColor,
                  strokeWidth: 2,
                ),
                // ADD RETRY BUTTON
                if (!_isReopeningCamera) ...[
                  SizedBox(height: 32),
                  GestureDetector(
                    onTap: () {
                      print('Manual retry requested');
                      _openCameraKit();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: kSecondaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: kSecondaryColor, width: 1),
                      ),
                      child: MyText(
                        text: 'Tap to retry',
                        size: 14,
                        color: kSecondaryColor,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}