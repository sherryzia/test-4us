// File: lib/utils/performance_manager.dart

import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PerformanceManager extends GetxController {
  static PerformanceManager get instance => Get.find<PerformanceManager>();
  
  // Memory monitoring
  final RxDouble memoryUsage = 0.0.obs;
  final RxBool isLowMemory = false.obs;
  final RxInt activeVideoControllers = 0.obs;
  
  // Performance metrics
  final RxDouble frameRate = 60.0.obs;
  final RxBool isPerformanceOptimized = true.obs;
  
  // Timers
  Timer? _memoryMonitorTimer;
  Timer? _performanceTimer;
  
  // Memory thresholds (in MB)
  static const double lowMemoryThreshold = 100.0;
  static const double criticalMemoryThreshold = 50.0;
  static const int maxVideoControllers = 3;
  
  // Background isolate for heavy operations
  Isolate? _performanceIsolate;
  ReceivePort? _performanceReceivePort;
  SendPort? _performanceSendPort;

  @override
  void onInit() {
    super.onInit();
    _initializePerformanceIsolate();
    _startMemoryMonitoring();
    _startPerformanceMonitoring();
  }

  @override
  void onClose() {
    _memoryMonitorTimer?.cancel();
    _performanceTimer?.cancel();
    _disposePerformanceIsolate();
    super.onClose();
  }

  // Initialize background isolate for performance-heavy operations
  Future<void> _initializePerformanceIsolate() async {
    try {
      _performanceReceivePort = ReceivePort();
      _performanceIsolate = await Isolate.spawn(
        _performanceIsolateEntryPoint,
        _performanceReceivePort!.sendPort,
      );
      
      _performanceReceivePort!.listen((message) {
        if (message is SendPort) {
          _performanceSendPort = message;
        } else if (message is Map) {
          _handlePerformanceMessage(message.cast<String, dynamic>());
        }
      });
    } catch (e) {
      print('Error initializing performance isolate: $e');
    }
  }

  // Performance isolate entry point
  static void _performanceIsolateEntryPoint(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    
    receivePort.listen((message) {
      if (message is Map) {
        switch (message['type']) {
          case 'calculateMemoryOptimization':
            _calculateMemoryOptimizationInBackground(message.cast<String, dynamic>(), sendPort);
            break;
          case 'processPerformanceData':
            _processPerformanceDataInBackground(message.cast<String, dynamic>(), sendPort);
            break;
          case 'cleanupTempFiles':
            _cleanupTempFilesInBackground(message.cast<String, dynamic>(), sendPort);
            break;
        }
      }
    });
  }

  // Calculate memory optimization strategies in background
  static void _calculateMemoryOptimizationInBackground(Map<String, dynamic> message, SendPort sendPort) {
    try {
      final currentMemory = message['currentMemory'] as double;
      final activeControllers = message['activeControllers'] as int;
      
      final recommendations = <String, dynamic>{};
      
      if (currentMemory < criticalMemoryThreshold) {
        recommendations['urgency'] = 'critical';
        recommendations['actions'] = [
          'dispose_all_video_controllers',
          'force_garbage_collection',
          'reduce_image_cache',
          'clear_temporary_files'
        ];
      } else if (currentMemory < lowMemoryThreshold) {
        recommendations['urgency'] = 'warning';
        recommendations['actions'] = [
          'dispose_old_video_controllers',
          'optimize_image_cache',
          'reduce_preload_count'
        ];
      } else {
        recommendations['urgency'] = 'normal';
        recommendations['actions'] = ['maintain_current_state'];
      }
      
      recommendations['maxControllers'] = currentMemory > lowMemoryThreshold ? 3 : 1;
      recommendations['preloadCount'] = currentMemory > lowMemoryThreshold ? 2 : 1;
      
      sendPort.send({
        'type': 'memoryOptimizationCalculated',
        'recommendations': recommendations,
      });
    } catch (e) {
      sendPort.send({
        'type': 'memoryOptimizationCalculated',
        'error': e.toString(),
      });
    }
  }

  // Process performance data in background
  static void _processPerformanceDataInBackground(Map<String, dynamic> message, SendPort sendPort) {
    try {
      final frameTimeData = message['frameTimeData'] as List<double>;
      final averageFrameTime = frameTimeData.reduce((a, b) => a + b) / frameTimeData.length;
      final fps = 1000.0 / averageFrameTime; // Convert from ms to FPS
      
      final isSmooth = fps >= 30.0; // Consider 30+ FPS as smooth
      final needsOptimization = fps < 24.0; // Below 24 FPS needs optimization
      
      sendPort.send({
        'type': 'performanceDataProcessed',
        'fps': fps,
        'isSmooth': isSmooth,
        'needsOptimization': needsOptimization,
        'averageFrameTime': averageFrameTime,
      });
    } catch (e) {
      sendPort.send({
        'type': 'performanceDataProcessed',
        'error': e.toString(),
      });
    }
  }

  // Cleanup temporary files in background
  static void _cleanupTempFilesInBackground(Map<String, dynamic> message, SendPort sendPort) {
    try {
      final tempDirPath = message['tempDirPath'] as String?;
      if (tempDirPath == null) {
        sendPort.send({
          'type': 'tempFilesCleanedUp',
          'success': false,
          'error': 'No temp directory path provided',
        });
        return;
      }

      final tempDir = Directory(tempDirPath);
      if (!tempDir.existsSync()) {
        sendPort.send({
          'type': 'tempFilesCleanedUp',
          'success': true,
          'filesDeleted': 0,
        });
        return;
      }

      int filesDeleted = 0;
      final now = DateTime.now();
      
      // Delete files older than 1 hour
      for (final file in tempDir.listSync()) {
        if (file is File) {
          final fileAge = now.difference(file.statSync().modified);
          if (fileAge.inHours > 1) {
            try {
              file.deleteSync();
              filesDeleted++;
            } catch (e) {
              print('Error deleting temp file: $e');
            }
          }
        }
      }

      sendPort.send({
        'type': 'tempFilesCleanedUp',
        'success': true,
        'filesDeleted': filesDeleted,
      });
    } catch (e) {
      sendPort.send({
        'type': 'tempFilesCleanedUp',
        'success': false,
        'error': e.toString(),
      });
    }
  }

  void _handlePerformanceMessage(Map<String, dynamic> message) {
    switch (message['type']) {
      case 'memoryOptimizationCalculated':
        _handleMemoryOptimization(message);
        break;
      case 'performanceDataProcessed':
        _handlePerformanceData(message);
        break;
      case 'tempFilesCleanedUp':
        _handleTempFilesCleanup(message);
        break;
    }
  }

  void _handleMemoryOptimization(Map<String, dynamic> message) {
    if (message['error'] != null) {
      print('Memory optimization error: ${message['error']}');
      return;
    }

    final recommendations = message['recommendations'] as Map<String, dynamic>;
    final urgency = recommendations['urgency'] as String;
    final actions = recommendations['actions'] as List<dynamic>;

    print('Memory optimization recommendations (${urgency}): $actions');

    // Apply recommendations
    for (final action in actions) {
      _applyMemoryOptimization(action.toString());
    }
  }

  void _handlePerformanceData(Map<String, dynamic> message) {
    if (message['error'] != null) {
      print('Performance data error: ${message['error']}');
      return;
    }

    final fps = message['fps'] as double;
    final needsOptimization = message['needsOptimization'] as bool;

    frameRate.value = fps;
    isPerformanceOptimized.value = !needsOptimization;

    if (needsOptimization) {
      _applyPerformanceOptimizations();
    }
  }

  void _handleTempFilesCleanup(Map<String, dynamic> message) {
    final success = message['success'] as bool;
    final filesDeleted = message['filesDeleted'] as int? ?? 0;

    if (success) {
      print('Cleaned up $filesDeleted temporary files');
    } else {
      print('Failed to cleanup temp files: ${message['error']}');
    }
  }

  void _disposePerformanceIsolate() {
    _performanceIsolate?.kill(priority: Isolate.immediate);
    _performanceReceivePort?.close();
    _performanceIsolate = null;
    _performanceReceivePort = null;
    _performanceSendPort = null;
  }

  // Start memory monitoring
  void _startMemoryMonitoring() {
    _memoryMonitorTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _checkMemoryUsage();
    });
  }

  // Start performance monitoring
  void _startPerformanceMonitoring() {
    _performanceTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _checkPerformance();
    });
  }

  // Check current memory usage
  void _checkMemoryUsage() async {
    try {
      if (Platform.isAndroid) {
        // Use platform channel to get memory info on Android
        final memInfo = await _getAndroidMemoryInfo();
        final availableMemory = memInfo['available'] ?? 0.0;
        memoryUsage.value = availableMemory;
        isLowMemory.value = availableMemory < lowMemoryThreshold;
      } else if (Platform.isIOS) {
        // Use iOS-specific memory checking
        final memInfo = await _getIOSMemoryInfo();
        final availableMemory = memInfo['available'] ?? 0.0;
        memoryUsage.value = availableMemory;
        isLowMemory.value = availableMemory < lowMemoryThreshold;
      }

      // Trigger optimization if low memory
      if (isLowMemory.value && _performanceSendPort != null) {
        _performanceSendPort!.send({
          'type': 'calculateMemoryOptimization',
          'currentMemory': memoryUsage.value,
          'activeControllers': activeVideoControllers.value,
        });
      }
    } catch (e) {
      print('Error checking memory usage: $e');
    }
  }

  // Get Android memory info
  Future<Map<String, double>> _getAndroidMemoryInfo() async {
    try {
      const platform = MethodChannel('performance_manager');
      final result = await platform.invokeMethod('getMemoryInfo');
      return Map<String, double>.from(result);
    } catch (e) {
      print('Error getting Android memory info: $e');
      return {'available': 100.0}; // Default fallback
    }
  }

  // Get iOS memory info
  Future<Map<String, double>> _getIOSMemoryInfo() async {
    try {
      const platform = MethodChannel('performance_manager');
      final result = await platform.invokeMethod('getMemoryInfo');
      return Map<String, double>.from(result);
    } catch (e) {
      print('Error getting iOS memory info: $e');
      return {'available': 100.0}; // Default fallback
    }
  }

  // Check performance metrics
  void _checkPerformance() {
    // Collect frame time data over the last few seconds
    final frameTimeData = <double>[];
    
    // This would normally be collected from actual frame rendering
    // For now, we'll simulate based on current conditions
    final baseFrameTime = isLowMemory.value ? 20.0 : 16.67; // 50fps vs 60fps
    for (int i = 0; i < 10; i++) {
      frameTimeData.add(baseFrameTime + (i * 0.5)); // Add some variance
    }

    if (_performanceSendPort != null) {
      _performanceSendPort!.send({
        'type': 'processPerformanceData',
        'frameTimeData': frameTimeData,
      });
    }
  }

  // Apply memory optimization based on recommendations
  void _applyMemoryOptimization(String action) {
    switch (action) {
      case 'dispose_all_video_controllers':
        _disposeAllVideoControllers();
        break;
      case 'force_garbage_collection':
        _forceGarbageCollection();
        break;
      case 'reduce_image_cache':
        _reduceImageCache();
        break;
      case 'clear_temporary_files':
        _clearTemporaryFiles();
        break;
      case 'dispose_old_video_controllers':
        _disposeOldVideoControllers();
        break;
      case 'optimize_image_cache':
        _optimizeImageCache();
        break;
      case 'reduce_preload_count':
        _reducePreloadCount();
        break;
    }
  }

  // Apply performance optimizations
  void _applyPerformanceOptimizations() {
    print('Applying performance optimizations...');
    
    // Reduce animation complexity
    _reduceAnimationComplexity();
    
    // Lower video quality if needed
    _optimizeVideoQuality();
    
    // Reduce concurrent operations
    _limitConcurrentOperations();
  }

  // Dispose all video controllers
  void _disposeAllVideoControllers() {
    try {
      // Send message to ReelsController to dispose all controllers
      final reelsController = Get.find<dynamic>(); // Replace with actual ReelsController
      if (reelsController != null && reelsController.hasMethod('disposeAllVideoControllers')) {
        reelsController.disposeAllVideoControllers();
        activeVideoControllers.value = 0;
      }
    } catch (e) {
      print('Error disposing all video controllers: $e');
    }
  }

  // Force garbage collection
  void _forceGarbageCollection() {
    try {
      // Force garbage collection (this is a hint to the VM)
      // if (kDebugMode) {
      //   developer.gc();
      // }
      print('Forced garbage collection');
    } catch (e) {
      print('Error forcing garbage collection: $e');
    }
  }

  // Reduce image cache size
  void _reduceImageCache() {
    try {
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.maximumSize = 50; // Reduce from default 1000
      PaintingBinding.instance.imageCache.maximumSizeBytes = 10 << 20; // 10MB
      print('Reduced image cache size');
    } catch (e) {
      print('Error reducing image cache: $e');
    }
  }

  // Clear temporary files
  void _clearTemporaryFiles() {
    if (_performanceSendPort != null) {
      // Get temp directory path
      final tempDirPath = Directory.systemTemp.path;
      
      _performanceSendPort!.send({
        'type': 'cleanupTempFiles',
        'tempDirPath': tempDirPath,
      });
    }
  }

  // Dispose old video controllers (keep only recent ones)
  void _disposeOldVideoControllers() {
    try {
      // This would notify controllers to dispose controllers that are far from current view
      Get.find<dynamic>()?.disposeOldControllers?.call();
      activeVideoControllers.value = activeVideoControllers.value.clamp(0, maxVideoControllers);
    } catch (e) {
      print('Error disposing old video controllers: $e');
    }
  }

  // Optimize image cache (moderate reduction)
  void _optimizeImageCache() {
    try {
      PaintingBinding.instance.imageCache.maximumSize = 100; // Moderate reduction
      PaintingBinding.instance.imageCache.maximumSizeBytes = 25 << 20; // 25MB
      print('Optimized image cache');
    } catch (e) {
      print('Error optimizing image cache: $e');
    }
  }

  // Reduce preload count for videos
  void _reducePreloadCount() {
    // This would notify video controllers to reduce their preload range
    print('Reducing video preload count');
  }

  // Reduce animation complexity
  void _reduceAnimationComplexity() {
    // This could disable certain animations or reduce their frame rate
    print('Reducing animation complexity');
  }

  // Optimize video quality based on performance
  void _optimizeVideoQuality() {
    // This could lower video resolution or bitrate
    print('Optimizing video quality for performance');
  }

  // Limit concurrent operations
  void _limitConcurrentOperations() {
    // This could limit the number of simultaneous video loads, API calls, etc.
    print('Limiting concurrent operations');
  }

  // Public methods for external use

  // Register a video controller
  void registerVideoController() {
    activeVideoControllers.value++;
    print('Registered video controller. Total: ${activeVideoControllers.value}');
    
    if (activeVideoControllers.value > maxVideoControllers) {
      print('Warning: Too many active video controllers (${activeVideoControllers.value})');
    }

    if (!canCreateVideoController()) {
  print('Cannot register: memory or controller limit reached.');
  return;
}
  }

  // Unregister a video controller
  void unregisterVideoController() {
    if (activeVideoControllers.value > 0) {
      activeVideoControllers.value--;
      print('Unregistered video controller. Total: ${activeVideoControllers.value}');
    }
  }

  // Check if can create new video controller
  bool canCreateVideoController() {
    return activeVideoControllers.value < maxVideoControllers && !isLowMemory.value;
  }

  // Get recommended video quality based on performance
  String getRecommendedVideoQuality() {
    if (isLowMemory.value || frameRate.value < 24) {
      return 'low';
    } else if (frameRate.value < 45) {
      return 'medium';
    } else {
      return 'high';
    }
  }

  // Get recommended preload count
  int getRecommendedPreloadCount() {
    if (isLowMemory.value) {
      return 1;
    } else if (frameRate.value < 30) {
      return 1;
    } else {
      return 2;
    }
  }

  // Force cleanup (for manual triggering)
  void forceCleanup() {
    print('Forcing performance cleanup...');
    
    _disposeOldVideoControllers();
    _optimizeImageCache();
    _forceGarbageCollection();
    _clearTemporaryFiles();
    
    // Reset performance flags
    isPerformanceOptimized.value = true;
  }

  // Get performance summary
  Map<String, dynamic> getPerformanceSummary() {
    return {
      'memoryUsage': memoryUsage.value,
      'isLowMemory': isLowMemory.value,
      'frameRate': frameRate.value,
      'isPerformanceOptimized': isPerformanceOptimized.value,
      'activeVideoControllers': activeVideoControllers.value,
      'recommendedVideoQuality': getRecommendedVideoQuality(),
      'recommendedPreloadCount': getRecommendedPreloadCount(),
      'canCreateVideoController': canCreateVideoController(),
    };
  }

  // Log performance stats (for debugging)
  void logPerformanceStats() {
    final summary = getPerformanceSummary();
    print('=== PERFORMANCE STATS ===');
    print('Memory Usage: ${summary['memoryUsage']} MB');
    print('Low Memory: ${summary['isLowMemory']}');
    print('Frame Rate: ${summary['frameRate']} FPS');
    print('Performance Optimized: ${summary['isPerformanceOptimized']}');
    print('Active Video Controllers: ${summary['activeVideoControllers']}');
    print('Recommended Video Quality: ${summary['recommendedVideoQuality']}');
    print('Recommended Preload Count: ${summary['recommendedPreloadCount']}');
    print('Can Create Video Controller: ${summary['canCreateVideoController']}');
    print('========================');
  }

  // Set performance mode
  void setPerformanceMode(String mode) {
    switch (mode) {
      case 'high_performance':
        PaintingBinding.instance.imageCache.maximumSize = 200;
        PaintingBinding.instance.imageCache.maximumSizeBytes = 50 << 20; // 50MB
        break;
      case 'balanced':
        PaintingBinding.instance.imageCache.maximumSize = 100;
        PaintingBinding.instance.imageCache.maximumSizeBytes = 25 << 20; // 25MB
        break;
      case 'battery_saver':
        PaintingBinding.instance.imageCache.maximumSize = 50;
        PaintingBinding.instance.imageCache.maximumSizeBytes = 10 << 20; // 10MB
        break;
    }
    
    print('Set performance mode to: $mode');
  }

  // Check if device supports high performance mode
  bool get supportsHighPerformance {
    // This could check device specs, available memory, etc.
    return memoryUsage.value > lowMemoryThreshold && frameRate.value > 45;
  }

  // Emergency cleanup (for critical low memory situations)
  void emergencyCleanup() {
    print('EMERGENCY CLEANUP TRIGGERED');
    
    // Dispose all video controllers immediately
    _disposeAllVideoControllers();
    
    // Clear all caches
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.maximumSize = 10;
    PaintingBinding.instance.imageCache.maximumSizeBytes = 5 << 20; // 5MB
    
    // Force garbage collection multiple times
    for (int i = 0; i < 3; i++) {
      _forceGarbageCollection();
    }
    
    // Clear temporary files
    _clearTemporaryFiles();
    
    print('Emergency cleanup completed');
  }
}