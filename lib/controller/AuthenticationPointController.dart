import 'dart:developer';
import 'package:candid/controller/GlobalController.dart';
import 'package:candid/services/login_service.dart';
import 'package:candid/services/reel_categories_service.dart';
import 'package:candid/utils/shared_preferences_util.dart';
import 'package:candid/view/screens/launch/on_boarding.dart';
import 'package:candid/view/screens/auth/sign_up/complete_profile/complete_profile.dart';
import 'package:candid/view/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthenticationPointController extends GetxController {
  final LoginService _loginService = LoginService();
  final ReelCategoriesService _reelCategoriesService = ReelCategoriesService();
  final globalController = Get.find<GlobalController>();

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      validateAuthentication();
    });
  }

  Future<void> validateAuthentication() async {
    try {
      // First, load any existing data from SharedPreferences
      await globalController.loadFromSharedPreferences();
      
      // Check if we have a stored auth token
      final storedToken = await SharedPreferencesUtil.getData<String>('authToken');
      
      if (storedToken == null || storedToken.isEmpty) {
        // No token found, redirect to onboarding
        log("No auth token found, redirecting to onboarding");
        await globalController.clear();
        Get.offAll(() => OnBoarding());
        return;
      }

      // Token exists, verify it's still valid by fetching user data
      log("Token found, validating session...");
      await _validateSessionAndNavigate();
      
    } catch (e) {
      log("Error during authentication validation: $e");
      // On any error, clear data and redirect to onboarding
      await globalController.clear();
      Get.offAll(() => OnBoarding());
    }
  }

  Future<void> _validateSessionAndNavigate() async {
    try {
      // Try to fetch user data using the stored token
      final userResponse = await _loginService.fetchUserData();
      
      if (userResponse.statusCode == 200) {
        // Token is valid, update GlobalController with fresh user data
        if (userResponse.data != null && userResponse.data is Map) {
          final userData = userResponse.data as Map<String, dynamic>;
          
          log("Session valid, updating user data");
          globalController.updateFromResponse(userData, deleteToken: false);
          await globalController.saveToSharedPreferences();
          
          globalController.logValues();
          
          // Navigate based on onboarding status
          await _navigateBasedOnOnboardingStatus(userData);
        } else {
          // Unexpected response format
          log("Unexpected user data format");
          await globalController.clear();
          Get.offAll(() => OnBoarding());
        }
      } else if (userResponse.statusCode == 401) {
        // Token is invalid/expired
        log("Token expired or invalid (401), redirecting to onboarding");
        await globalController.clear();
        Get.offAll(() => OnBoarding());
      } else if (userResponse.statusCode == 403) {
        // Account needs verification (if your API uses this status)
        log("Account needs verification (403)");
        // You can handle OTP verification here if needed
        await globalController.clear();
        Get.offAll(() => OnBoarding());
      } else {
        // Other error status codes
        log("API error with status: ${userResponse.statusCode}");
        await globalController.clear();
        Get.offAll(() => OnBoarding());
      }
      
    } catch (e) {
      // Network error or other exception
      log("Error validating session: $e");
      
      // Check if we have cached user data to work offline
      if (globalController.isLoggedIn && globalController.userId.value > 0) {
        log("Using cached data due to network error");
        // Use cached data and navigate based on stored onboarding status
        await _navigateBasedOnCachedData();
      } else {
        // No valid cached data, redirect to onboarding
        await globalController.clear();
        Get.offAll(() => OnBoarding());
      }
    }
  }

  Future<void> _navigateBasedOnOnboardingStatus(Map<String, dynamic> userData) async {
    final isOnboarded = userData['is_onboarded'] ?? false;

    // Load additional authenticated data
    await _loadAuthenticatedData();

    if (isOnboarded) {
      // User has completed onboarding, go to main app
      log("User onboarded, navigating to main app");
      Get.offAll(() => BottomNavBar());
    } else {
      // User needs to complete onboarding
      log("User not onboarded, navigating to complete profile");
      Get.offAll(() => CompleteProfile());
    }
  }

  Future<void> _navigateBasedOnCachedData() async {
    // Use cached onboarding status if available
    final isOnboarded = globalController.isOnboarded.value;
    
    // Try to load additional data even with cached user data
    await _loadAuthenticatedData();
    
    if (isOnboarded) {
      log("Using cached data - user onboarded, navigating to main app");
      Get.offAll(() => BottomNavBar());
    } else {
      log("Using cached data - user not onboarded, navigating to complete profile");
      Get.offAll(() => CompleteProfile());
    }
  }

  // Load additional data that requires authentication
  Future<void> _loadAuthenticatedData() async {
    try {
      log("Loading authenticated data...");
      
      // Load reel categories
      await _loadReelCategories();
      
      // Add other authenticated data loading here
      // await _loadOtherData();
      
      log("Authenticated data loaded successfully");
    } catch (e) {
      log("Error loading authenticated data: $e");
      // Don't block navigation if additional data fails to load
    }
  }

  // Load reel categories
  Future<void> _loadReelCategories() async {
    try {
      final reelResponse = await _reelCategoriesService.getReelCategories();
      
      if (reelResponse.statusCode == 200 && reelResponse.data != null) {
        if (reelResponse.data is List) {
          globalController.updateReelCategories(reelResponse.data);
          log("Reel categories loaded: ${(reelResponse.data as List).length} categories");
          log("Reel categories: ${globalController.reelCategories.map((c) => c['name']).toList()}");
        }
      } else {
        log("Failed to load reel categories: ${reelResponse.statusCode}");
      }
    } catch (e) {
      log("Error loading reel categories: $e");
    }
  }

  // Method to refresh user data (can be called from other parts of the app)
  Future<bool> refreshUserData() async {
    try {
      final userResponse = await _loginService.fetchUserData();
      
      if (userResponse.statusCode == 200) {
        if (userResponse.data != null && userResponse.data is Map) {
          final userData = userResponse.data as Map<String, dynamic>;
          
          globalController.updateFromResponse(userData, deleteToken: false);
          await globalController.saveToSharedPreferences();
          
          return true;
        }
      }
      return false;
    } catch (e) {
      log("Error refreshing user data: $e");
      return false;
    }
  }

  // Enhanced logout method for AuthenticationPointController

// Add loading state variable at the top of your class
final RxBool isLoggingOut = false.obs;

Future<void> logout({bool showLoading = true, bool showSnackbar = true}) async {
  // Prevent multiple logout calls
  if (isLoggingOut.value) {
    log("Logout already in progress, ignoring duplicate call");
    return;
  }

  try {
    isLoggingOut.value = true;
    log("Starting logout process...");

    // Show loading dialog if requested
    if (showLoading) {
      Get.dialog(
        AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text("Logging out..."),
            ],
          ),
        ),
        barrierDismissible: false,
      );
    }

    // Call logout API
    try {
      log("Calling logout API...");
      final logoutResponse = await _loginService.logout();
      
      if (logoutResponse.statusCode == 200) {
        log("Logout API successful");
      } else {
        log("Logout API failed with status code: ${logoutResponse.statusCode}");
        // Continue with local logout even if API fails
      }
    } catch (apiError) {
      log("Logout API error: $apiError");
      // Continue with local logout even if API call fails
    }

    // Clear all local data (this should always happen regardless of API response)
    await _performLocalCleanup();

    // Close loading dialog if it was shown
    if (showLoading && Get.isDialogOpen == true) {
      Get.back();
    }

    // Navigate to onboarding screen
    Get.offAll(() => OnBoarding());

    // Show success message
    if (showSnackbar) {
      Get.snackbar(
        "Logged Out",
        "You have been successfully logged out",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    }

    log("Logout process completed successfully");

  } catch (e) {
    log("Error during logout: $e");
    
    // Close loading dialog if open
    if (showLoading && Get.isDialogOpen == true) {
      Get.back();
    }

    // Even if there's an error, clear local data and redirect
    try {
      await _performLocalCleanup();
      Get.offAll(() => OnBoarding());
      
      if (showSnackbar) {
        Get.snackbar(
          "Logout Error",
          "There was an issue logging out, but you've been signed out locally",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.withOpacity(0.8),
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      }
    } catch (cleanupError) {
      log("Critical error during cleanup: $cleanupError");
      // Force navigation even if cleanup fails
      Get.offAll(() => OnBoarding());
    }
    
  } finally {
    isLoggingOut.value = false;
  }
}

// Separate method for local cleanup
Future<void> _performLocalCleanup() async {
  try {
    log("Performing local cleanup...");
    
    // Clear global controller data
    await globalController.clear();
    
    // Clear image cache to free memory
    try {
      PaintingBinding.instance.imageCache.clear();
    } catch (e) {
      log("Error clearing image cache: $e");
    }
    
    log("Local cleanup completed");
    
  } catch (e) {
    log("Error during local cleanup: $e");
    throw e; // Re-throw to handle in calling method
  }
}

  Future<void> logoutWithConfirmation() async {
  Get.dialog(
    AlertDialog(
      title: Text("Confirm Logout"),
      content: Text("Are you sure you want to log out?"),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            
            logout(); // Perform logout
            
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
          ),
          child: Text("Log Out"),
        ),
      ],
    ),
  );
}

  // Method to check if session is still valid (can be called periodically)
  Future<bool> isSessionValid() async {
    try {
      final userResponse = await _loginService.fetchUserData();
      return userResponse.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}