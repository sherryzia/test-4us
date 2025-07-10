// File: lib/utils/crash_handler.dart

import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CrashHandler {
  static CrashHandler? _instance;
  static CrashHandler get instance => _instance ??= CrashHandler._();
  
  CrashHandler._();

  // Error tracking
  final List<CrashReport> _crashReports = [];
  final StreamController<CrashReport> _crashController = StreamController.broadcast();
  
  // Recovery callbacks
  final Map<String, VoidCallback> _recoveryCallbacks = {};
  
  // Configuration
  bool _isInitialized = false;
  bool _enableCrashReporting = true;
  bool _enableAutoRecovery = true;

  Stream<CrashReport> get crashStream => _crashController.stream;
  List<CrashReport> get crashReports => List.unmodifiable(_crashReports);

  void initialize({
    bool enableCrashReporting = true,
    bool enableAutoRecovery = true,
  }) {
    if (_isInitialized) return;
    
    _enableCrashReporting = enableCrashReporting;
    _enableAutoRecovery = enableAutoRecovery;
    
    // Set up global error handlers
    _setupErrorHandlers();
    
    _isInitialized = true;
    print('CrashHandler initialized');
  }

  void _setupErrorHandlers() {
    // Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      _handleFlutterError(details);
    };
    
    // Async errors not caught by Flutter
    PlatformDispatcher.instance.onError = (error, stack) {
      _handleAsyncError(error, stack);
      return true;
    };
    
    // Zone errors (fallback)
    runZonedGuarded(() {
      // This will catch any remaining errors
    }, (error, stack) {
      _handleZoneError(error, stack);
    });
  }

  void _handleFlutterError(FlutterErrorDetails details) {
    final crashReport = CrashReport(
      type: CrashType.flutter,
      error: details.exception,
      stackTrace: details.stack,
      context: details.context?.toString(),
      timestamp: DateTime.now(),
      library: details.library,
    );
    
    _recordCrash(crashReport);
    
    // In debug mode, show the red screen
    if (kDebugMode) {
      FlutterError.presentError(details);
    } else {
      // In release mode, try to recover gracefully
      _attemptRecovery(crashReport);
    }
  }

  void _handleAsyncError(Object error, StackTrace stack) {
    final crashReport = CrashReport(
      type: CrashType.async,
      error: error,
      stackTrace: stack,
      timestamp: DateTime.now(),
    );
    
    _recordCrash(crashReport);
    _attemptRecovery(crashReport);
  }

  void _handleZoneError(Object error, StackTrace stack) {
    final crashReport = CrashReport(
      type: CrashType.zone,
      error: error,
      stackTrace: stack,
      timestamp: DateTime.now(),
    );
    
    _recordCrash(crashReport);
    _attemptRecovery(crashReport);
  }

  void _recordCrash(CrashReport report) {
    if (!_enableCrashReporting) return;
    
    _crashReports.add(report);
    _crashController.add(report);
    
    // Keep only last 50 crash reports
    if (_crashReports.length > 50) {
      _crashReports.removeAt(0);
    }
    
    // Log crash details
    _logCrash(report);
    
    // Send to analytics (implement your own)
    _sendCrashToAnalytics(report);
  }

  void _logCrash(CrashReport report) {
    print('=== CRASH REPORT ===');
    print('Type: ${report.type}');
    print('Time: ${report.timestamp}');
    print('Error: ${report.error}');
    if (report.context != null) {
      print('Context: ${report.context}');
    }
    if (report.library != null) {
      print('Library: ${report.library}');
    }
    print('Stack trace:');
    print(report.stackTrace);
    print('==================');
  }

  void _sendCrashToAnalytics(CrashReport report) {
    // TODO: Implement crash reporting to your analytics service
    // Examples: Firebase Crashlytics, Sentry, etc.
    
    if (kDebugMode) {
      print('Crash would be sent to analytics: ${report.error}');
    }
  }

  void _attemptRecovery(CrashReport report) {
    if (!_enableAutoRecovery) return;
    
    final errorString = report.error.toString().toLowerCase();
    
    // Video-related errors
    if (errorString.contains('video') || 
        errorString.contains('player') || 
        errorString.contains('controller')) {
      _recoverFromVideoError();
      return;
    }
    
    // Network-related errors
    if (errorString.contains('socket') || 
        errorString.contains('network') || 
        errorString.contains('connection')) {
      _recoverFromNetworkError();
      return;
    }
    
    // Memory-related errors
    if (errorString.contains('memory') || 
        errorString.contains('out of memory')) {
      _recoverFromMemoryError();
      return;
    }
    
    // Navigation errors
    if (errorString.contains('navigator') || 
        errorString.contains('route')) {
      _recoverFromNavigationError();
      return;
    }
    
    // Generic recovery
    _genericRecovery(report);
  }

  void _recoverFromVideoError() {
    print('Attempting video error recovery...');
    
    try {
      // Find ReelsController and reset video controllers
      final reelsController = Get.find<dynamic>();
      if (reelsController != null) {
        reelsController.disposeAllVideoControllers?.call();
      }
      
      _showRecoveryMessage('Video issue resolved. Reloading content...');
    } catch (e) {
      print('Video recovery failed: $e');
      _genericRecovery(null);
    }
  }

  void _recoverFromNetworkError() {
    print('Attempting network error recovery...');
    
    _showRecoveryMessage('Connection issue detected. Retrying...');
    
    // Retry network operations after a delay
    Future.delayed(const Duration(seconds: 2), () {
      try {
        final reelsController = Get.find<dynamic>();
        reelsController?.refreshReels?.call();
      } catch (e) {
        print('Network recovery failed: $e');
      }
    });
  }

  void _recoverFromMemoryError() {
    print('Attempting memory error recovery...');
    
    try {
      // Force garbage collection (only if available)
      // if (kDebugMode && dev.gc is Function) {
      //   dev.gc();
      // }
      
      // Clear image cache
      PaintingBinding.instance.imageCache.clear();
      
      // Dispose old video controllers
      final reelsController = Get.find<dynamic>();
      reelsController?.disposeAllVideoControllers?.call();
      
      _showRecoveryMessage('Memory optimized. Performance improved.');
    } catch (e) {
      print('Memory recovery failed: $e');
      _genericRecovery(null);
    }
  }

  void _recoverFromNavigationError() {
    print('Attempting navigation error recovery...');
    
    try {
      // Reset navigation stack
      if (Get.isRegistered<dynamic>()) {
        Get.until((route) => route.isFirst);
      }
      
      _showRecoveryMessage('Navigation reset. Starting fresh...');
    } catch (e) {
      print('Navigation recovery failed: $e');
      _genericRecovery(null);
    }
  }

  void _genericRecovery(CrashReport? report) {
    print('Attempting generic recovery...');
    
    _showRecoveryMessage('Something went wrong. Recovering...');
    
    // Execute registered recovery callbacks
    for (final callback in _recoveryCallbacks.values) {
      try {
        callback();
      } catch (e) {
        print('Recovery callback failed: $e');
      }
    }
    
    // Last resort: restart the app section
    Future.delayed(const Duration(seconds: 3), () {
      try {
        // Navigate to safe screen
        Get.offAllNamed('/'); // Adjust based on your routing
      } catch (e) {
        print('Last resort navigation failed: $e');
      }
    });
  }

  void _showRecoveryMessage(String message) {
    try {
      Get.snackbar(
        'Recovering',
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(10),
        borderRadius: 8,
        isDismissible: true,
      );
    } catch (e) {
      print('Failed to show recovery message: $e');
    }
  }

  // Public methods for manual error handling
  void reportError(Object error, StackTrace? stackTrace, {
    String? context,
    Map<String, dynamic>? extras,
  }) {
    final crashReport = CrashReport(
      type: CrashType.manual,
      error: error,
      stackTrace: stackTrace,
      context: context,
      timestamp: DateTime.now(),
      extras: extras,
    );
    
    _recordCrash(crashReport);
  }

  void registerRecoveryCallback(String key, VoidCallback callback) {
    _recoveryCallbacks[key] = callback;
  }

  void unregisterRecoveryCallback(String key) {
    _recoveryCallbacks.remove(key);
  }

  void clearCrashReports() {
    _crashReports.clear();
  }

  // Safe execution wrapper
  Future<T?> safeExecute<T>(
    Future<T> Function() operation, {
    String? context,
    T? fallback,
  }) async {
    try {
      return await operation();
    } catch (error, stackTrace) {
      reportError(error, stackTrace, context: context);
      return fallback;
    }
  }

  T? safeExecuteSync<T>(
    T Function() operation, {
    String? context,
    T? fallback,
  }) {
    try {
      return operation();
    } catch (error, stackTrace) {
      reportError(error, stackTrace, context: context);
      return fallback;
    }
  }

  void dispose() {
    _crashController.close();
    _recoveryCallbacks.clear();
    _crashReports.clear();
  }
}

enum CrashType {
  flutter,
  async,
  zone,
  manual,
}

class CrashReport {
  final CrashType type;
  final Object error;
  final StackTrace? stackTrace;
  final String? context;
  final String? library;
  final DateTime timestamp;
  final Map<String, dynamic>? extras;

  CrashReport({
    required this.type,
    required this.error,
    this.stackTrace,
    this.context,
    this.library,
    required this.timestamp,
    this.extras,
  });

  @override
  String toString() {
    return 'CrashReport(type: $type, error: $error, timestamp: $timestamp)';
  }
}

// Widget for displaying crash reports (useful for debugging)
class CrashReportViewer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crash Reports'),
        actions: [
          IconButton(
            icon: Icon(Icons.clear_all),
            onPressed: () {
              CrashHandler.instance.clearCrashReports();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: StreamBuilder<CrashReport>(
        stream: CrashHandler.instance.crashStream,
        builder: (context, snapshot) {
          final reports = CrashHandler.instance.crashReports;
          
          if (reports.isEmpty) {
            return Center(
              child: Text('No crash reports'),
            );
          }
          
          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ExpansionTile(
                  title: Text(
                    '${report.type.name.toUpperCase()}: ${report.error.toString()}',
                    style: TextStyle(fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    'Time: ${report.timestamp.toString()}',
                    style: TextStyle(fontSize: 10),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (report.context != null) ...[
                            Text('Context:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(report.context!),
                            SizedBox(height: 8),
                          ],
                          if (report.library != null) ...[
                            Text('Library:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(report.library!),
                            SizedBox(height: 8),
                          ],
                          Text('Stack Trace:', style: TextStyle(fontWeight: FontWeight.bold)),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              report.stackTrace?.toString() ?? 'No stack trace',
                              style: TextStyle(fontFamily: 'monospace', fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}