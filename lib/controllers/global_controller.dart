// lib/controllers/global_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../configs/supabase_config.dart';
import '../services/supabase_service.dart';
import '../views/screens/login_screen.dart';
import '../views/screens/main_navigation_screen.dart';

class GlobalController extends GetxController {
  static GlobalController get to => Get.find();
  
  // Observable variables
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxMap<String, dynamic> userProfile = <String, dynamic>{}.obs;
  final RxBool isLoading = false.obs;
  final RxBool isAuthenticated = false.obs;
  final RxString currentCurrency = 'PKR'.obs;
  final RxDouble monthlyBudget = 0.0.obs;
  
  // Network status
  final RxBool isOnline = true.obs;
  
  // Session management
  Timer? _sessionTimer;
  final RxBool isSessionActive = false.obs;
  final Rx<DateTime> lastActivity = DateTime.now().obs;
  final int sessionTimeoutMinutes = 30; // Auto logout after 30 minutes of inactivity
  
  // Categories and payment methods cache
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> paymentMethods = <Map<String, dynamic>>[].obs;
  
  // For auth state changes
  late StreamSubscription<AuthState> _authSubscription;
  
  
  @override
  void onInit() {
    super.onInit();
    _monitorConnectivity();
    _initializeAuth();
    _setupAuthListener();
    _startSessionTimer();
  }
  
  @override
  void onClose() {
    _authSubscription.cancel();
    _sessionTimer?.cancel();
    super.onClose();
  }
  
  // Monitor network connectivity
  void _monitorConnectivity() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      isOnline.value = result.isNotEmpty && result.first != ConnectivityResult.none;
      debugPrint('Connectivity changed: ${isOnline.value ? 'Online' : 'Offline'}');
    });
  }
  
  // Initialize authentication state
  void _initializeAuth() async {
    isLoading.value = true;
    
    try {
      final session = SupabaseConfig.auth.currentSession;
      if (session != null) {
        currentUser.value = session.user;
        isAuthenticated.value = true;
        await _loadUserProfile();
        await _loadBasicData();
        _createSession(); // Create a new session or update the existing one
        _navigateToMain();
      } else {
        _navigateToLogin();
      }
    } catch (e) {
      debugPrint('Auth initialization error: $e');
      _navigateToLogin();
    } finally {
      isLoading.value = false;
    }
  }
  
  // Setup auth state listener
  void _setupAuthListener() {
    _authSubscription = SupabaseConfig.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;
      
      debugPrint('Auth state change: $event');
      
      switch (event) {
        case AuthChangeEvent.signedIn:
          _handleSignIn(session);
          break;
        case AuthChangeEvent.signedOut:
          _handleSignOut();
          break;
        case AuthChangeEvent.tokenRefreshed:
          _handleTokenRefresh(session);
          break;
        case AuthChangeEvent.userUpdated:
          _handleUserUpdated(session);
          break;
        case AuthChangeEvent.userDeleted:
          _handleUserDeleted();
          break;
        default:
          break;
      }
    });
  }
  
  // Handle sign in
  void _handleSignIn(Session? session) async {
    if (session?.user != null) {
      currentUser.value = session!.user;
      isAuthenticated.value = true;
      
      await _loadUserProfile();
      await _loadBasicData();
      await _createSession();
      
      _navigateToMain();
      
      Get.snackbar(
        'Welcome!',
        'Successfully signed in',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
  
  // Handle sign out
  void _handleSignOut() {
    currentUser.value = null;
    userProfile.clear();
    isAuthenticated.value = false;
    isSessionActive.value = false;
    categories.clear();
    paymentMethods.clear();
    
    _endSession();
    _navigateToLogin();
    
    Get.snackbar(
      'Logged Out',
      'You have been logged out',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.withOpacity(0.8),
      colorText: Colors.white,
    );
  }
  
  // Handle token refresh
  void _handleTokenRefresh(Session? session) {
    if (session?.user != null) {
      currentUser.value = session!.user;
      _updateSessionActivity();
    }
  }
  
  // Handle user updated
  void _handleUserUpdated(Session? session) async {
    if (session?.user != null) {
      currentUser.value = session!.user;
      await _loadUserProfile();
    }
  }
  
  // Handle user deleted
  void _handleUserDeleted() {
    _handleSignOut();
  }
  
  // Load user profile from database
  Future<void> _loadUserProfile() async {
    if (currentUser.value == null) return;
    
    try {
      final profile = await SupabaseService.getUserProfile(currentUser.value!.id);
      if (profile != null) {
        userProfile.value = profile;
        currentCurrency.value = profile['currency'] ?? 'PKR';
        monthlyBudget.value = (profile['monthly_budget'] ?? 0).toDouble();
      } else {
        // If profile doesn't exist yet, create it
        final userData = {
          'id': currentUser.value!.id,
          'full_name': currentUser.value!.userMetadata?['full_name'] ?? 'User',
          'currency': 'PKR',
          'monthly_budget': 0,
        };
        
        await SupabaseService.updateUserProfile(currentUser.value!.id, userData);
        userProfile.value = userData;
      }
    } catch (e) {
      debugPrint('Error loading user profile: $e');
      handleError(e, customMessage: 'Failed to load your profile');
    }
  }
  
  // Load categories and payment methods
  Future<void> _loadBasicData() async {
    try {
      final categoriesData = await SupabaseService.getCategories(currentUser.value?.id);
      final paymentMethodsData = await SupabaseService.getPaymentMethods(currentUser.value?.id);
      
      categories.value = categoriesData;
      paymentMethods.value = paymentMethodsData;
    } catch (e) {
      debugPrint('Error loading basic data: $e');
      handleError(e, customMessage: 'Failed to load app data');
    }
  }
  
  // Session management methods
  void _startSessionTimer() {
    _sessionTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (isAuthenticated.value) {
        _updateSessionActivity();
        
        // Auto logout after specified minutes of inactivity
        final timeSinceLastActivity = DateTime.now().difference(lastActivity.value);
        if (timeSinceLastActivity.inMinutes > sessionTimeoutMinutes) {
          signOut();
          Get.snackbar(
            'Session Expired',
            'You have been logged out due to inactivity',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange.withOpacity(0.8),
            colorText: Colors.white,
          );
        }
      }
    });
  }
  
  Future<void> _createSession() async {
    if (currentUser.value == null) return;
    
    try {
      // Get device info
      final deviceInfoPlugin = DeviceInfoPlugin();
      String deviceInfo = 'Unknown device';
      
      try {
        if (GetPlatform.isAndroid) {
          final androidInfo = await deviceInfoPlugin.androidInfo;
          deviceInfo = '${androidInfo.brand} ${androidInfo.model}';
        } else if (GetPlatform.isIOS) {
          final iosInfo = await deviceInfoPlugin.iosInfo;
          deviceInfo = '${iosInfo.name} ${iosInfo.systemVersion}';
        } else if (GetPlatform.isWeb) {
          final webInfo = await deviceInfoPlugin.webBrowserInfo;
          deviceInfo = '${webInfo.browserName} on ${webInfo.platform}';
        }
      } catch (e) {
        debugPrint('Error getting device info: $e');
      }
      
      await SupabaseService.createSession(currentUser.value!.id, {
        'device_info': deviceInfo,
        'ip_address': 'Unknown', // Getting real IP requires a server
      });
      
      isSessionActive.value = true;
      lastActivity.value = DateTime.now();
    } catch (e) {
      debugPrint('Error creating session: $e');
      // Not critical, continue anyway
    }
  }
  
  Future<void> _updateSessionActivity() async {
    if (currentUser.value == null) return;
    
    try {
      await SupabaseService.updateSessionActivity(currentUser.value!.id);
      lastActivity.value = DateTime.now();
    } catch (e) {
      debugPrint('Error updating session activity: $e');
      // Not critical, continue anyway
    }
  }
  
  Future<void> _endSession() async {
    if (currentUser.value == null) return;
    
    try {
      await SupabaseService.endSession(currentUser.value!.id);
      isSessionActive.value = false;
    } catch (e) {
      debugPrint('Error ending session: $e');
      // Not critical, continue anyway
    }
  }
  
  // Navigation methods
  void _navigateToLogin() {
    Get.offAll(() => const LoginScreen());
  }
  
  void _navigateToMain() {
    Get.offAll(() => const MainNavigationScreen());
  }
  
  // Public methods for other controllers
  Future<void> signOut() async {
    isLoading.value = true;
    
    try {
      await _endSession();
      await SupabaseService.signOut();
    } catch (e) {
      debugPrint('Sign out error: $e');
      Get.snackbar(
        'Error',
        'Failed to sign out: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Method to handle user activity and update session
  void recordUserActivity() {
    lastActivity.value = DateTime.now();
    if (isAuthenticated.value) {
      _updateSessionActivity();
    }
  }
  
  Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    if (currentUser.value == null) return;
    
    isLoading.value = true;
    
    try {
      await SupabaseService.updateUserProfile(currentUser.value!.id, updates);
      await _loadUserProfile(); // Reload profile
      
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('Error updating profile: $e');
      handleError(e, customMessage: 'Failed to update profile');
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> refreshData() async {
    if (!isAuthenticated.value) return;
    
    await _loadUserProfile();
    await _loadBasicData();
  }
  
  // Utility methods
  String get userName => userProfile['full_name'] ?? currentUser.value?.email?.split('@').first ?? 'User';
  String get userEmail => currentUser.value?.email ?? '';
  String get userId => currentUser.value?.id ?? '';
  
  bool get hasUser => currentUser.value != null;
  
  // Category methods
  List<String> get categoryNames => categories.map((c) => c['name'] as String).toList();
  
  String? getCategoryId(String categoryName) {
    final category = categories.firstWhereOrNull((c) => c['name'] == categoryName);
    return category?['id'];
  }
  
  Map<String, dynamic>? getCategoryByName(String name) {
    return categories.firstWhereOrNull((c) => c['name'] == name);
  }
  
  // Payment method methods
  List<String> get paymentMethodNames => paymentMethods.map((pm) => pm['name'] as String).toList();
  
  String? getPaymentMethodId(String methodName) {
    final method = paymentMethods.firstWhereOrNull((pm) => pm['name'] == methodName);
    return method?['id'];
  }
  
  Map<String, dynamic>? getPaymentMethodByName(String name) {
    return paymentMethods.firstWhereOrNull((pm) => pm['name'] == name);
  }
  
  // Currency formatting
  String formatCurrency(double amount) {
    String symbol = '₨';
    switch (currentCurrency.value) {
      case 'USD':
        symbol = '\$';
        break;
      case 'EUR':
        symbol = '€';
        break;
      case 'GBP':
        symbol = '£';
        break;
      case 'JPY':
        symbol = '¥';
        break;
      default:
        symbol = '₨';
    }
    
    return '$symbol${amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2)}';
  }
  
  // Error handling
  void handleError(dynamic error, {String? customMessage}) {
    String message = customMessage ?? 'An error occurred';
    
    if (error is PostgrestException) {
      message = error.message;
    } else if (error is AuthException) {
      message = error.message;
    } else if (error.toString().isNotEmpty) {
      message = error.toString();
    }
    
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }
  
  // Success message
  void showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
  
  // Info message
  void showInfo(String message) {
    Get.snackbar(
      'Info',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
  
  // Check if user has completed profile setup
  bool get isProfileComplete {
    return userProfile.isNotEmpty && 
           userProfile['full_name'] != null && 
           userProfile['currency'] != null;
  }
  
  // Get user avatar URL or initials
  String get userInitials {
    final name = userName;
    if (name.length >= 2) {
      return name.substring(0, 2).toUpperCase();
    }
    return 'U';
  }
  
  String? get userAvatarUrl => userProfile['avatar_url'];
}