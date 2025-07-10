import 'dart:ui';

import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class ProfileVideoController extends GetxController {
  // Observable maps for video state
  final RxMap<int, VideoPlayerController> _videoControllers = <int, VideoPlayerController>{}.obs;
  final RxMap<int, bool> _isVideoInitialized = <int, bool>{}.obs;
  final RxMap<int, bool> _isVideoPlaying = <int, bool>{}.obs;
  
  // Track which videos are currently visible
  final RxSet<int> _visibleVideoIds = <int>{}.obs;
  
  // Maximum number of concurrent video controllers
  static const int maxControllers = 2;
  
  // Getters for reactive access
  Map<int, VideoPlayerController> get videoControllers => _videoControllers;
  Map<int, bool> get isVideoInitialized => _isVideoInitialized;
  Map<int, bool> get isVideoPlaying => _isVideoPlaying;
  Set<int> get visibleVideoIds => _visibleVideoIds;

  @override
  void onInit() {
    super.onInit();
    // Listen to app lifecycle changes
    ever(_visibleVideoIds, (_) => _manageVideoControllers());
  }

  @override
  void onClose() {
    disposeAllVideoControllers();
    super.onClose();
  }

  void onAppLifecycleChanged(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      pauseAllVideos();
      // Aggressively dispose controllers when app goes to background
      disposeAllVideoControllers();
    }
  }

  // Add this method to be called when navigating away from Profile
  void onNavigateAway() {
    print('ProfileVideoController: Disposing all controllers on navigation');
    pauseAllVideos();
    disposeAllVideoControllers();
  }

  Future<void> initializeVideoController(int videoId, String videoUrl) async {
    try {
      // Don't initialize if we already have too many controllers
      if (_videoControllers.length >= maxControllers && !_videoControllers.containsKey(videoId)) {
        return;
      }

      if (_videoControllers.containsKey(videoId)) return;

      // Dispose oldest controller if we're at the limit
      if (_videoControllers.length >= maxControllers) {
        final oldestId = _videoControllers.keys.first;
        await disposeVideoController(oldestId);
      }

      final controller = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: false,
          allowBackgroundPlayback: false,
        ),
      );
      
      await controller.initialize();
      controller.setLooping(true);
      controller.setVolume(0.0); // Muted by default to save resources
      
      _videoControllers[videoId] = controller;
      _isVideoInitialized[videoId] = true;
      _isVideoPlaying[videoId] = false;
      
      update(); // Trigger UI update
      
    } catch (e) {
      print('Error initializing video $videoId: $e');
      _isVideoInitialized[videoId] = false;
      update();
    }
  }

  Future<void> disposeVideoController(int videoId) async {
    final controller = _videoControllers[videoId];
    if (controller != null) {
      try {
        // More aggressive cleanup
        if (controller.value.isPlaying) {
          await controller.pause();
        }
        await controller.setVolume(0.0);
        await controller.dispose();
        
        // Force garbage collection hint
        print('Disposed video controller for ID: $videoId');
      } catch (e) {
        print('Error disposing video controller $videoId: $e');
      }
      
      _videoControllers.remove(videoId);
      _isVideoInitialized.remove(videoId);
      _isVideoPlaying.remove(videoId);
      _visibleVideoIds.remove(videoId);
      
      update();
    }
  }

  void toggleVideoPlayback(int videoId) {
    final controller = _videoControllers[videoId];
    if (controller != null && controller.value.isInitialized) {
      if (controller.value.isPlaying) {
        controller.pause();
        _isVideoPlaying[videoId] = false;
      } else {
        // Pause all other videos first
        pauseAllVideos();
        controller.play();
        _isVideoPlaying[videoId] = true;
      }
      update();
    }
  }

  void pauseAllVideos() {
    for (var entry in _videoControllers.entries) {
      if (entry.value.value.isPlaying) {
        entry.value.pause();
        _isVideoPlaying[entry.key] = false;
      }
    }
    update();
  }

  void disposeAllVideoControllers() {
    print('ProfileVideoController: Disposing ${_videoControllers.length} video controllers');
    
    for (var entry in _videoControllers.entries) {
      try {
        final controller = entry.value;
        if (controller.value.isPlaying) {
          controller.pause();
        }
        controller.setVolume(0.0);
        controller.dispose();
        print('Disposed controller for video ID: ${entry.key}');
      } catch (e) {
        print('Error disposing controller ${entry.key}: $e');
      }
    }
    
    _videoControllers.clear();
    _isVideoInitialized.clear();
    _isVideoPlaying.clear();
    _visibleVideoIds.clear();
    
    print('All video controllers disposed. Memory should be freed.');
  }

  void addVisibleVideo(int videoId) {
    _visibleVideoIds.add(videoId);
  }

  void removeVisibleVideo(int videoId) {
    _visibleVideoIds.remove(videoId);
  }

  void _manageVideoControllers() {
    // Clean up controllers for videos that are no longer visible
    final controllersToRemove = <int>[];
    for (var videoId in _videoControllers.keys) {
      if (!_visibleVideoIds.contains(videoId)) {
        controllersToRemove.add(videoId);
      }
    }
    
    for (var videoId in controllersToRemove) {
      disposeVideoController(videoId);
    }
  }

  bool isVideoControllerInitialized(int videoId) {
    return _isVideoInitialized[videoId] == true;
  }

  bool isVideoCurrentlyPlaying(int videoId) {
    return _isVideoPlaying[videoId] == true;
  }

  VideoPlayerController? getVideoController(int videoId) {
    return _videoControllers[videoId];
  }
}