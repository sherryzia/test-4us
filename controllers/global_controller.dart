// lib/controllers/global_controller.dart - Fixed with Proper Currency Notification
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
  final RxString previousCurrency = 'PKR'.obs;
  final RxDouble monthlyBudget = 0.0.obs;

  // Network status
  final RxBool isOnline = true.obs;

  // Session management
  Timer? _sessionTimer;
  final RxBool isSessionActive = false.obs;
  final Rx<DateTime> lastActivity = DateTime.now().obs;
  final int sessionTimeoutMinutes = 30;

  // Categories and payment methods cache
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> paymentMethods = <Map<String, dynamic>>[].obs;

  // Currency exchange rates (base: USD)
  final RxMap<String, double> exchangeRates = <String, double>{
    'USD': 1.0,
    'EUR': 0.85,
    'GBP': 0.73,
    'JPY': 110.0,
    'PKR': 280.0,
  }.obs;

  // For auth state changes
  late StreamSubscription<AuthState> _authSubscription;

  @override
  void onInit() {
    super.onInit();
    _monitorConnectivity();
    _initializeAuth();
    _setupAuthListener();
    _startSessionTimer();
    _loadExchangeRates();
  }

  @override
  void onClose() {
    _authSubscription.cancel();
    _sessionTimer?.cancel();
    super.onClose();
  }

  // Load exchange rates (in production, fetch from API)
  void _loadExchangeRates() {
    exchangeRates.value = {
      'USD': 1.0,
      'EUR': 0.85,
      'GBP': 0.73,
      'JPY': 110.0,
      'PKR': 280.0,
    };
  }

  // Convert amount between currencies
  double convertCurrency(double amount, String fromCurrency, String toCurrency) {
    if (fromCurrency == toCurrency) return amount;
    
    final fromRate = exchangeRates[fromCurrency] ?? 1.0;
    final toRate = exchangeRates[toCurrency] ?? 1.0;
    
    // Convert to USD first, then to target currency
    final usdAmount = amount / fromRate;
    final convertedAmount = usdAmount * toRate;
    
    debugPrint('Converting $amount from $fromCurrency to $toCurrency = $convertedAmount');
    return convertedAmount;
  }

  // Get currency symbol
  String getCurrencySymbol(String? currencyCode) {
    switch (currencyCode ?? currentCurrency.value) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      case 'PKR':
      default:
        return '₨';
    }
  }

  // Monitor network connectivity
  void _monitorConnectivity() {
    Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> result,
    ) {
      isOnline.value =
          result.isNotEmpty && result.first != ConnectivityResult.none;
      debugPrint(
        'Connectivity changed: ${isOnline.value ? 'Online' : 'Offline'}',
      );
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
        _createSession();
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
      final profile = await SupabaseService.getUserProfileWithAvatar(
        currentUser.value!.id,
      );
      if (profile != null) {
        userProfile.value = profile;
        
        // Store previous currency for conversion
        String newCurrency = profile['currency'] ?? 'PKR';
        if (currentCurrency.value != newCurrency) {
          previousCurrency.value = currentCurrency.value;
          currentCurrency.value = newCurrency;
          debugPrint('Currency changed from ${previousCurrency.value} to $newCurrency');
        }
        
        monthlyBudget.value = (profile['monthly_budget'] ?? 0).toDouble();
      } else {
        final userData = {
          'id': currentUser.value!.id,
          'full_name': currentUser.value!.userMetadata?['full_name'] ?? 'User',
          'currency': 'PKR',
          'monthly_budget': 0,
        };

        await SupabaseService.updateUserProfile(
          currentUser.value!.id,
          userData,
        );
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
      final categoriesData = await SupabaseService.getCategories(
        currentUser.value?.id,
      );
      final paymentMethodsData = await SupabaseService.getPaymentMethods(
        currentUser.value?.id,
      );

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

        final timeSinceLastActivity = DateTime.now().difference(
          lastActivity.value,
        );
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
        'ip_address': 'Unknown',
      });

      isSessionActive.value = true;
      lastActivity.value = DateTime.now();
    } catch (e) {
      debugPrint('Error creating session: $e');
    }
  }

  Future<void> _updateSessionActivity() async {
    if (currentUser.value == null) return;

    try {
      await SupabaseService.updateSessionActivity(currentUser.value!.id);
      lastActivity.value = DateTime.now();
    } catch (e) {
      debugPrint('Error updating session activity: $e');
    }
  }

  Future<void> _endSession() async {
    if (currentUser.value == null) return;

    try {
      await SupabaseService.endSession(currentUser.value!.id);
      isSessionActive.value = false;
    } catch (e) {
      debugPrint('Error ending session: $e');
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

  // Update user profile with currency conversion
  Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    if (currentUser.value == null) return;

    isLoading.value = true;

    try {
      // Check if currency is being changed
      final String? newCurrency = updates['currency'];
      bool currencyChanged = false;
      
      if (newCurrency != null && newCurrency != currentCurrency.value) {
        currencyChanged = true;
        previousCurrency.value = currentCurrency.value;
        
        // Convert monetary values if currency is changing
        if (updates.containsKey('monthly_budget')) {
          final double currentBudget = updates['monthly_budget'].toDouble();
          final double convertedBudget = convertCurrency(
            currentBudget, 
            previousCurrency.value, 
            newCurrency
          );
          updates['monthly_budget'] = convertedBudget;
        }
        
        if (updates.containsKey('monthly_income')) {
          final double currentIncome = updates['monthly_income'].toDouble();
          final double convertedIncome = convertCurrency(
            currentIncome, 
            previousCurrency.value, 
            newCurrency
          );
          updates['monthly_income'] = convertedIncome;
        }
      }

      await SupabaseService.updateUserProfile(currentUser.value!.id, updates);
      await _loadUserProfile();

      // Notify other controllers about currency change AFTER profile is updated
      if (currencyChanged) {
        debugPrint('Notifying currency change from ${previousCurrency.value} to $newCurrency');
        _notifyAllControllersCurrencyChange(previousCurrency.value, newCurrency!);
      }

      Get.snackbar(
        'Success',
        currencyChanged 
          ? 'Profile updated and amounts converted to $newCurrency'
          : 'Profile updated successfully',
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

  // Enhanced notification method for currency change
  void _notifyAllControllersCurrencyChange(String fromCurrency, String toCurrency) {
    try {
      // Delay slightly to ensure currency change is processed
      Future.delayed(Duration(milliseconds: 100), () {
        // Update home controller if it exists
        try {
          final homeController = Get.find<dynamic>(tag: 'HomeController');
          if (homeController != null && homeController.hasMethod('onCurrencyChanged')) {
            homeController.onCurrencyChanged(fromCurrency, toCurrency);
          }
        } catch (e) {
          // Try without tag
          try {
            final homeController = Get.find<dynamic>();
            if (homeController.runtimeType.toString().contains('HomeController')) {
              homeController.onCurrencyChanged(fromCurrency, toCurrency);
            }
          } catch (e2) {
            debugPrint('HomeController not found for currency change notification');
          }
        }
        
        // Force refresh of all registered controllers
        Get.forceAppUpdate();
      });
    } catch (e) {
      debugPrint('Error notifying currency change: $e');
    }
  }

  // Force currency change notification (can be called from profile controller)
  void notifyCurrencyChange(String fromCurrency, String toCurrency) {
    currentCurrency.value = toCurrency;
    _notifyAllControllersCurrencyChange(fromCurrency, toCurrency);
  }

  Future<void> refreshData() async {
    if (!isAuthenticated.value) return;

    await _loadUserProfile();
    await _loadBasicData();
  }

  // Method to refresh user avatar after photo update
  Future<void> refreshUserAvatar() async {
    if (!isAuthenticated.value || currentUser.value == null) return;
    
    try {
      final profile = await SupabaseService.getUserProfileWithAvatar(
        currentUser.value!.id,
      );
      if (profile != null) {
        userProfile.value = profile;
        userProfile.refresh();
      }
    } catch (e) {
      debugPrint('Error refreshing user avatar: $e');
    }
  }

  // Utility methods
  String get userName =>
      userProfile['full_name'] ??
      currentUser.value?.email?.split('@').first ??
      'User';
  String get userEmail => currentUser.value?.email ?? '';
  String get userId => currentUser.value?.id ?? '';

  bool get hasUser => currentUser.value != null;

  // Category methods
  List<String> get categoryNames =>
      categories.map((c) => c['name'] as String).toList();

  String? getCategoryId(String categoryName) {
    final category = categories.firstWhereOrNull(
      (c) => c['name'] == categoryName,
    );
    return category?['id'];
  }

  Map<String, dynamic>? getCategoryByName(String name) {
    return categories.firstWhereOrNull((c) => c['name'] == name);
  }

  // Payment method methods
  List<String> get paymentMethodNames =>
      paymentMethods.map((pm) => pm['name'] as String).toList();

  String? getPaymentMethodId(String methodName) {
    final method = paymentMethods.firstWhereOrNull(
      (pm) => pm['name'] == methodName,
    );
    return method?['id'];
  }

  Map<String, dynamic>? getPaymentMethodByName(String name) {
    return paymentMethods.firstWhereOrNull((pm) => pm['name'] == name);
  }

  // Enhanced currency formatting
  String formatCurrency(double amount, {String? currencyCode}) {
    final String currency = currencyCode ?? currentCurrency.value;
    String symbol = getCurrencySymbol(currency);
    int decimalPlaces;

    // Determine decimal places based on currency
    switch (currency) {
      case 'USD':
      case 'EUR':
      case 'GBP':
        decimalPlaces = 2;
        break;
      case 'JPY':
      case 'PKR':
      default:
        decimalPlaces = 0;
    }

    // Format the number with appropriate decimal places
    String formattedNumber;
    if (decimalPlaces == 0) {
      formattedNumber = amount.round().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
    } else {
      formattedNumber = amount
          .toStringAsFixed(decimalPlaces)
          .replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
    }

    return '$symbol$formattedNumber';
  }

  // Convert and format currency
  String formatCurrencyWithConversion(
    double amount, 
    String fromCurrency, 
    {String? toCurrency}
  ) {
    final String targetCurrency = toCurrency ?? currentCurrency.value;
    final double convertedAmount = convertCurrency(amount, fromCurrency, targetCurrency);
    return formatCurrency(convertedAmount, currencyCode: targetCurrency);
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

  String? get userAvatarUrl {
    final avatarUrl = userProfile['avatar_url'];
    if (avatarUrl != null && avatarUrl.toString().isNotEmpty) {
      return avatarUrl.toString();
    }
    return null;
  }
}