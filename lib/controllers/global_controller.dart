// lib/controllers/global_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  
  // Session management
  Timer? _sessionTimer;
  final RxBool isSessionActive = false.obs;
  final Rx<DateTime> lastActivity = DateTime.now().obs;
  
  // Categories and payment methods cache
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> paymentMethods = <Map<String, dynamic>>[].obs;
  
  late StreamSubscription<AuthState> _authSubscription;
  
  @override
  void onInit() {
    super.onInit();
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
        _navigateToMain();
      } else {
        _navigateToLogin();
      }
    } catch (e) {
      print('Auth initialization error: $e');
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
  
  // Load user profile from database
  Future<void> _loadUserProfile() async {
    if (currentUser.value == null) return;
    
    try {
      final profile = await SupabaseService.getUserProfile(currentUser.value!.id);
      if (profile != null) {
        userProfile.value = profile;
        currentCurrency.value = profile['currency'] ?? 'PKR';
        monthlyBudget.value = (profile['monthly_budget'] ?? 0).toDouble();
      }
    } catch (e) {
      print('Error loading user profile: $e');
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
      print('Error loading basic data: $e');
    }
  }
  
  // Session management methods
  void _startSessionTimer() {
    _sessionTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (isAuthenticated.value) {
        _updateSessionActivity();
        
        // Auto logout after 30 minutes of inactivity
        final timeSinceLastActivity = DateTime.now().difference(lastActivity.value);
        if (timeSinceLastActivity.inMinutes > 30) {
          signOut();
        }
      }
    });
  }
  
  Future<void> _createSession() async {
    if (currentUser.value == null) return;
    
    try {
      await SupabaseService.createSession(currentUser.value!.id, {
        'device_info': 'Flutter App', // You can enhance this with actual device info
        'ip_address': 'Unknown', // You can get actual IP if needed
      });
      isSessionActive.value = true;
      lastActivity.value = DateTime.now();
    } catch (e) {
      print('Error creating session: $e');
    }
  }
  
  Future<void> _updateSessionActivity() async {
    if (currentUser.value == null) return;
    
    try {
      await SupabaseService.updateSessionActivity(currentUser.value!.id);
      lastActivity.value = DateTime.now();
    } catch (e) {
      print('Error updating session activity: $e');
    }
  }
  
  Future<void> _endSession() async {
    if (currentUser.value == null) return;
    
    try {
      await SupabaseService.endSession(currentUser.value!.id);
      isSessionActive.value = false;
    } catch (e) {
      print('Error ending session: $e');
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
      await SupabaseService.signOut();
    } catch (e) {
      print('Sign out error: $e');
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
      print('Error updating profile: $e');
      Get.snackbar(
        'Error',
        'Failed to update profile: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
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
  String get userName => userProfile['full_name'] ?? currentUser.value?.email ?? 'User';
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
        symbol = '\'';
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
    