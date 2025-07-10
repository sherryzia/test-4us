// File: lib/utils/app_initialization.dart

import 'package:candid/controller/reels_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:candid/utils/crash_handler.dart';
import 'package:candid/utils/performance_manager.dart';

class AppInitialization {
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    print('Initializing app systems...');

    // Ensure Flutter is ready
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize crash handler first
    CrashHandler.instance.initialize(
      enableCrashReporting: true,
      enableAutoRecovery: true,
    );

    // Set up global error handlers with crash handler integration
    _setupGlobalErrorHandling();
Get.put(ReelsController());
    // Initialize performance manager
    Get.put(PerformanceManager(), permanent: true);

    // Set up recovery callbacks
    _setupRecoveryCallbacks();

    // Configure system UI
    _configureSystemUI();

    // Set up app lifecycle management
    _setupAppLifecycleManagement();

    // Initialize video player optimizations
    _initializeVideoOptimizations();

    _isInitialized = true;
    print('App initialization completed successfully');
  }

  static void _setupGlobalErrorHandling() {
    // Register recovery callbacks for different error types
    CrashHandler.instance.registerRecoveryCallback(
      'video_recovery',
      () => _handleVideoRecovery(),
    );

    CrashHandler.instance.registerRecoveryCallback(
      'memory_recovery', 
      () => _handleMemoryRecovery(),
    );

    CrashHandler.instance.registerRecoveryCallback(
      'navigation_recovery',
      () => _handleNavigationRecovery(),
    );

    // Listen to crash reports for additional handling
    CrashHandler.instance.crashStream.listen((report) {
      _handleCrashReport(report);
    });
  }

  static void _setupRecoveryCallbacks() {
    // Video recovery
    CrashHandler.instance.registerRecoveryCallback(
      'dispose_video_controllers',
      () {
        try {
          if (Get.isRegistered<dynamic>()) {
            final controller = Get.find<dynamic>();
            controller?.disposeAllVideoControllers?.call();
          }
        } catch (e) {
          print('Failed to dispose video controllers: $e');
        }
      },
    );

    // Memory cleanup
    CrashHandler.instance.registerRecoveryCallback(
      'memory_cleanup',
      () {
        try {
          PaintingBinding.instance.imageCache.clear();
          PaintingBinding.instance.imageCache.maximumSize = 50;
          PaintingBinding.instance.imageCache.maximumSizeBytes = 10 << 20; // 10MB
        } catch (e) {
          print('Failed to clean up memory: $e');
        }
      },
    );
  }

  static void _configureSystemUI() {
    // Set preferred orientations
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Configure system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  static void _setupAppLifecycleManagement() {
    // This will be handled by individual screens
    // But we can set up global lifecycle management here if needed
  }

  static void _initializeVideoOptimizations() {
    // Configure video player for better performance
    
    // Set up image cache limits based on device capabilities
    final performanceManager = Get.find<PerformanceManager>();
    
    // Configure image cache based on performance capabilities
    if (performanceManager.supportsHighPerformance) {
      PaintingBinding.instance.imageCache.maximumSize = 200;
      PaintingBinding.instance.imageCache.maximumSizeBytes = 50 << 20; // 50MB
    } else {
      PaintingBinding.instance.imageCache.maximumSize = 100;
      PaintingBinding.instance.imageCache.maximumSizeBytes = 25 << 20; // 25MB
    }
  }

  // Recovery handlers
  static void _handleVideoRecovery() {
    print('Executing video recovery...');
    
    try {
      // Find and reset video controllers
      if (Get.isRegistered<dynamic>()) {
        final reelsController = Get.find<dynamic>();
        
        // Dispose all controllers
        reelsController?.disposeAllVideoControllers?.call();
        
        // Refresh reels after a delay
        Future.delayed(const Duration(seconds: 2), () {
          reelsController?.refreshReels?.call();
        });
      }
    } catch (e) {
      print('Video recovery failed: $e');
    }
  }

  static void _handleMemoryRecovery() {
    print('Executing memory recovery...');
    
    try {
      final performanceManager = Get.find<PerformanceManager>();
      performanceManager.emergencyCleanup();
    } catch (e) {
      print('Memory recovery failed: $e');
    }
  }

  static void _handleNavigationRecovery() {
    print('Executing navigation recovery...');
    
    try {
      // Reset to home screen
      if (Get.currentRoute != '/') {
        Get.offAllNamed('/');
      }
    } catch (e) {
      print('Navigation recovery failed: $e');
    }
  }

  static void _handleCrashReport(CrashReport report) {
    // Additional crash handling logic
    print('Handling crash report: ${report.type}');
    
    // You can add custom analytics or reporting here
    if (kDebugMode) {
      print('Crash details: ${report.error}');
    }
  }

  // Safe app restart
  static Future<void> safeRestart() async {
    print('Performing safe app restart...');
    
    try {
      // Clean up resources
      final performanceManager = Get.find<PerformanceManager>();
      performanceManager.forceCleanup();
      
      // Reset navigation
      Get.reset();
      
      // Re-initialize
      await initialize();
      
      // Navigate to home
      Get.offAllNamed('/');
      
    } catch (e) {
      print('Safe restart failed: $e');
      CrashHandler.instance.reportError(e, StackTrace.current, context: 'safe_restart');
    }
  }

  // Emergency mode - minimal functionality
  static void enterEmergencyMode() {
    print('Entering emergency mode...');
    
    try {
      // Disable all video playback
      if (Get.isRegistered<dynamic>()) {
        final reelsController = Get.find<dynamic>();
        reelsController?.disposeAllVideoControllers?.call();
      }
      
      // Clear all caches
      PaintingBinding.instance.imageCache.clear();
      
      // Set minimal memory limits
      PaintingBinding.instance.imageCache.maximumSize = 10;
      PaintingBinding.instance.imageCache.maximumSizeBytes = 5 << 20; // 5MB
      
      // Show emergency mode indicator
      Get.snackbar(
        'Emergency Mode',
        'App is running in safe mode with limited features',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        isDismissible: false,
      );
      
    } catch (e) {
      print('Failed to enter emergency mode: $e');
    }
  }

  // Health check
  static Future<AppHealthStatus> performHealthCheck() async {
    final issues = <String>[];
    
    try {
      // Check memory usage
      final performanceManager = Get.find<PerformanceManager>();
      if (performanceManager.isLowMemory.value) {
        issues.add('Low memory detected');
      }
      
      // Check video controllers
      if (Get.isRegistered<dynamic>()) {
        final reelsController = Get.find<dynamic>();
        final activeControllers = performanceManager.activeVideoControllers.value;
        if (activeControllers > 5) {
          issues.add('Too many active video controllers');
        }
      }
      
      // Check crash reports
      final recentCrashes = CrashHandler.instance.crashReports
          .where((report) => DateTime.now().difference(report.timestamp).inMinutes < 5)
          .length;
      
      if (recentCrashes > 3) {
        issues.add('Multiple recent crashes detected');
      }
      
      // Check frame rate
      if (performanceManager.frameRate.value < 24) {
        issues.add('Poor performance detected');
      }
      
      return AppHealthStatus(
        isHealthy: issues.isEmpty,
        issues: issues,
        timestamp: DateTime.now(),
      );
      
    } catch (e) {
      print('Health check failed: $e');
      return AppHealthStatus(
        isHealthy: false,
        issues: ['Health check system failure'],
        timestamp: DateTime.now(),
      );
    }
  }

  // Cleanup on app termination
  static void cleanup() {
    print('Cleaning up app resources...');
    
    try {
      // Dispose crash handler
      CrashHandler.instance.dispose();
      
      // Clean up performance manager
      if (Get.isRegistered<PerformanceManager>()) {
        Get.delete<PerformanceManager>();
      }
      
      // Clean up video controllers
      if (Get.isRegistered<dynamic>()) {
        final reelsController = Get.find<dynamic>();
        reelsController?.disposeAllVideoControllers?.call();
      }
      
      print('App cleanup completed');
    } catch (e) {
      print('Cleanup failed: $e');
    }
  }

  // Get system information for debugging
  static Map<String, dynamic> getSystemInfo() {
    try {
      final performanceManager = Get.find<PerformanceManager>();
      
      return {
        'timestamp': DateTime.now().toIso8601String(),
        'platform': defaultTargetPlatform.name,
        'debug_mode': kDebugMode,
        'memory_usage': performanceManager.memoryUsage.value,
        'is_low_memory': performanceManager.isLowMemory.value,
        'frame_rate': performanceManager.frameRate.value,
        'active_video_controllers': performanceManager.activeVideoControllers.value,
        'crash_reports_count': CrashHandler.instance.crashReports.length,
        'image_cache_size': PaintingBinding.instance.imageCache.currentSize,
        'image_cache_max_size': PaintingBinding.instance.imageCache.maximumSize,
      };
    } catch (e) {
      return {
        'error': 'Failed to get system info: $e',
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  // Performance tuning based on device capabilities
  static void tunePerformance() {
    try {
      final performanceManager = Get.find<PerformanceManager>();
      final summary = performanceManager.getPerformanceSummary();
      
      if (summary['isLowMemory'] == true) {
        // Low memory mode
        performanceManager.setPerformanceMode('battery_saver');
        _reduceFunctionality();
      } else if (summary['frameRate'] < 30) {
        // Performance mode
        performanceManager.setPerformanceMode('balanced');
        _optimizeForPerformance();
      } else {
        // High performance mode
        performanceManager.setPerformanceMode('high_performance');
        _enableAllFeatures();
      }
      
      print('Performance tuned based on device capabilities');
    } catch (e) {
      print('Performance tuning failed: $e');
    }
  }

  static void _reduceFunctionality() {
    // Reduce video quality, disable animations, etc.
    print('Reducing functionality for low-end device');
  }

  static void _optimizeForPerformance() {
    // Balance between features and performance
    print('Optimizing for balanced performance');
  }

  static void _enableAllFeatures() {
    // Enable all features for high-end devices
    print('Enabling all features for high-performance device');
  }
}

class AppHealthStatus {
  final bool isHealthy;
  final List<String> issues;
  final DateTime timestamp;

  AppHealthStatus({
    required this.isHealthy,
    required this.issues,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'AppHealthStatus(healthy: $isHealthy, issues: ${issues.length})';
  }
}

// Extension methods for safe operations
extension SafeOperations on Future {
  Future<T?> safely<T>({
    String? context,
    T? fallback,
  }) async {
    return CrashHandler.instance.safeExecute<T>(
      () async => await this as T,
      context: context,
      fallback: fallback,
    );
  }
}

extension SafeSyncOperations<T> on T Function() {
  T? safely({
    String? context,
    T? fallback,
  }) {
    return CrashHandler.instance.safeExecuteSync<T>(
      this,
      context: context,
      fallback: fallback,
    );
  }
}

// Widget wrapper for safe UI operations
class SafeWidget extends StatelessWidget {
  final Widget child;
  final Widget? errorWidget;
  final String? context;

  const SafeWidget({
    Key? key,
    required this.child,
    this.errorWidget,
    this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      return child;
    } catch (error, stackTrace) {
      CrashHandler.instance.reportError(
        error,
        stackTrace,
        context: this.context ?? 'SafeWidget',
      );
      
      return errorWidget ?? 
        Container(
          color: Colors.grey[300],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.grey[600]),
                SizedBox(height: 8),
                Text(
                  'Content unavailable',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        );
    }
  }
}

// Debug panel for development
class DebugPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return SizedBox.shrink();
    
    return Material(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Debug Panel',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            
            // Performance info
            _buildDebugSection('Performance', () {
              final info = AppInitialization.getSystemInfo();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: info.entries.map((e) => 
                  Text('${e.key}: ${e.value}', style: TextStyle(fontSize: 12))
                ).toList(),
              );
            }),
            
            // Action buttons
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => AppInitialization.performHealthCheck(),
                  child: Text('Health Check'),
                ),
                ElevatedButton(
                  onPressed: () => Get.to(() => CrashReportViewer()),
                  child: Text('Crash Reports'),
                ),
                ElevatedButton(
                  onPressed: () => AppInitialization.tunePerformance(),
                  child: Text('Tune Performance'),
                ),
                ElevatedButton(
                  onPressed: () => AppInitialization.enterEmergencyMode(),
                  child: Text('Emergency Mode'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDebugSection(String title, Widget Function() builder) {
    return ExpansionTile(
      title: Text(title),
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: builder(),
        ),
      ],
    );
  }
}

// Usage in main.dart:
/*
void main() async {
  // Initialize app systems
  await AppInitialization.initialize();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Candid',
      home: SafeWidget(
        context: 'main_app',
        child: YourHomeScreen(),
      ),
      // Add debug panel in debug mode
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            if (kDebugMode)
              Positioned(
                top: 50,
                right: 10,
                child: FloatingActionButton(
                  mini: true,
                  onPressed: () => Get.bottomSheet(DebugPanel()),
                  child: Icon(Icons.bug_report),
                ),
              ),
          ],
        );
      },
    );
  }
}
*/