// lib/controllers/user_controller.dart

import 'dart:io';
import 'package:get/get.dart';
import 'package:betting_app/services/auth_service.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();
  
  final AuthService _authService = Get.find<AuthService>();
  
  // Reactive user data
  final RxMap<String, dynamic> userData = RxMap<String, dynamic>();
  final RxString profileImageUrl = ''.obs;
  final RxString fullName = ''.obs;
  final RxString email = ''.obs;
  final RxString phone = ''.obs;
  final RxBool isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    _initializeUserData();
    _listenToAuthChanges();
  }
  
  /// Initialize user data from AuthService
  void _initializeUserData() {
    final authUserData = _authService.user.value;
    if (authUserData.isNotEmpty) {
      updateUserData(authUserData);
    }
  }
  
  /// Listen to authentication changes
  void _listenToAuthChanges() {
    // Listen to user data changes from AuthService
    ever(_authService.user, (Map<String, dynamic> newUserData) {
      print("🔄 AuthService user data changed: ${newUserData['email']}");
      if (newUserData.isNotEmpty) {
        updateUserData(newUserData);
      } else {
        clearUserData();
      }
    });
    
    // Listen to login status changes
    ever(_authService.isLoggedIn, (bool isLoggedIn) {
      print("🔄 AuthService login status changed: $isLoggedIn");
      if (!isLoggedIn) {
        clearUserData();
      }
    });
    
    // Also listen to token changes as a backup
    ever(_authService.token, (String newToken) {
      if (newToken.isNotEmpty && _authService.user.value.isNotEmpty) {
        print("🔄 Token changed, refreshing user data");
        updateUserData(_authService.user.value);
      }
    });
  }
  
  /// Update user data and notify all listeners
  void updateUserData(Map<String, dynamic> newData) {
    print("🔄 Updating user data in UserController: ${newData['email']}");
    
    // Force reactive update by assigning new map
    userData.value = Map<String, dynamic>.from(newData);
    
    // Update individual reactive variables for easy access
    fullName.value = "${newData['first_name'] ?? ''} ${newData['last_name'] ?? ''}".trim();
    email.value = newData['email'] ?? '';
    phone.value = newData['phone'] ?? '';
    profileImageUrl.value = newData['profile_picture'] ?? newData['profile_image'] ?? '';
    
    print("👤 User data updated globally: ${email.value}");
    print("📷 Profile image URL: ${profileImageUrl.value}");
  }
  
  /// Manually refresh user data from AuthService
  void refreshFromAuthService() {
    print("🔄 Manually refreshing user data from AuthService");
    final authUserData = _authService.user.value;
    if (authUserData.isNotEmpty) {
      updateUserData(authUserData);
    }
  }
  
  /// Clear user data on logout
  void clearUserData() {
    userData.clear();
    fullName.value = '';
    email.value = '';
    phone.value = '';
    profileImageUrl.value = '';
    print("🚫 User data cleared globally");
  }
  
  /// Update profile information
  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? newEmail,
    String? newPhone,
    File? profileImage,
  }) async {
    try {
      isLoading.value = true;
      print("🔄 Starting profile update...");
      
      Map<String, dynamic> updateData = {};
      
      if (firstName != null) updateData['first_name'] = firstName;
      if (lastName != null) updateData['last_name'] = lastName;
      if (newEmail != null) updateData['email'] = newEmail;
      if (newPhone != null) updateData['phone'] = newPhone;
      if (profileImage != null) updateData['profile_image'] = profileImage;
      
      print("📝 Update data: ${updateData.keys.toList()}");
      
      final result = await _authService.updateUserProfile(updateData);
      
      if (result['success']) {
        print("✅ Profile update successful");
        
        // Force refresh from AuthService as backup
        await Future.delayed(Duration(milliseconds: 500));
        refreshFromAuthService();
        
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      } else {
        print("❌ Profile update failed: ${result['message']}");
        Get.snackbar(
          'Error',
          result['message'],
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      print("❌ Profile update exception: $e");
      Get.snackbar(
        'Error',
        'Failed to update profile: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Get user's first name
  String get firstName => userData['first_name'] ?? '';
  
  /// Get user's last name  
  String get lastName => userData['last_name'] ?? '';
  
  /// Get user's initials for avatar
  String get initials {
    if (fullName.value.isEmpty) return '';
    final names = fullName.value.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return names[0].substring(0, 1).toUpperCase();
  }
  
  /// Check if user has profile image
  bool get hasProfileImage => profileImageUrl.value.isNotEmpty;
  
  /// Get subscription info
  Map<String, dynamic> get subscription => userData['subscription'] ?? {};
  
  /// Check if user has active subscription
  bool get hasActiveSubscription {
    final sub = subscription;
    return sub['is_active'] == true;
  }
}