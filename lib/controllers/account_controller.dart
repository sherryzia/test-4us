// lib/controllers/account_controller.dart

import 'dart:io';
import 'package:betting_app/controllers/ticket_controller.dart';
import 'package:betting_app/view/screens/auth/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:betting_app/services/auth_service.dart';

class AccountController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  
  // Form keys
  final GlobalKey<FormState> editNameFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> editPhoneFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> editEmailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> deleteAccountFormKey = GlobalKey<FormState>();
  
  // Text controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  // UI state
  final RxBool isLoading = false.obs;
  final Rx<File?> profileImage = Rx<File?>(null);
  final RxBool obscurePassword = true.obs;
  final RxMap<String, String> validationErrors = RxMap<String, String>();
  
  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }
  
  // Load user data into form
  void loadUserData() {
    final userData = _authService.getUserData();
    
    if (userData.isNotEmpty) {
      firstNameController.text = userData['first_name'] ?? '';
      lastNameController.text = userData['last_name'] ?? '';
      phoneController.text = userData['phone'] ?? '';
      emailController.text = userData['email'] ?? '';
    }
  }
  
  // Validation methods
  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
  
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }
  
  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!GetUtils.isPhoneNumber(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }
  
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }
  
  // Select profile image
  Future<void> pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 80,
      );
      
      if (image != null) {
        profileImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  // Update user name
  // lib/controllers/account_controller.dart

// Update the updateName method
Future<bool> updateName() async {
  if (editNameFormKey.currentState?.validate() ?? false) {
    isLoading.value = true;
    validationErrors.clear();
    
    try {
      final result = await _authService.updateUserProfile({
        'first_name': firstNameController.text.trim(),
        'last_name': lastNameController.text.trim(),
      });
      
      if (result['success']) {
        Get.back(); // Close the dialog
        
        // Notify other controllers that user data has changed
        Get.find<TicketController>().refreshControllerOnUserUpdate();
        
        Get.snackbar(
          'Success',
          'Name updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        _handleValidationErrors(result);
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  return false;
}
  // Update phone number
  Future<bool> updatePhone() async {
    if (editPhoneFormKey.currentState?.validate() ?? false) {
      isLoading.value = true;
      validationErrors.clear();
      
      try {
        final result = await _authService.updateUserProfile({
          'phone': phoneController.text.trim(),
        });
        
        if (result['success']) {
          Get.back(); // Close the dialog
          Get.snackbar(
            'Success',
            'Phone number updated successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          // Notify other controllers that user data has changed
          Get.find<TicketController>().refreshControllerOnUserUpdate();
          return true;
        } else {
          _handleValidationErrors(result);
          return false;
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'An unexpected error occurred',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      } finally {
        isLoading.value = false;
      }
    }
    return false;
  }
  
  // Update email
  Future<bool> updateEmail() async {
    if (editEmailFormKey.currentState?.validate() ?? false) {
      isLoading.value = true;
      validationErrors.clear();
      
      try {
        final result = await _authService.updateUserProfile({
          'email': emailController.text.trim(),
        });
        
        if (result['success']) {
          Get.back(); // Close the dialog
          Get.snackbar(
            'Success',
            'Email updated successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          // Notify other controllers that user data has changed
          Get.find<TicketController>().refreshControllerOnUserUpdate();
          return true;
        } else {
          _handleValidationErrors(result);
          return false;
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'An unexpected error occurred',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      } finally {
        isLoading.value = false;
      }
    }
    return false;
  }
  
  // Update profile image
  Future<bool> updateProfileImage() async {
    if (profileImage.value != null) {
      isLoading.value = true;
      
      try {
        final result = await _authService.updateUserProfile({
          'profile_image': profileImage.value,
        });
        
        if (result['success']) {
          Get.snackbar(
            'Success',
            'Profile image updated successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          // Notify other controllers that user data has changed
          Get.find<TicketController>().refreshControllerOnUserUpdate();
          return true;
        } else {
          Get.snackbar(
            'Error',
            result['message'],
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'An unexpected error occurred',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      } finally {
        isLoading.value = false;
      }
    }
    return false;
  }
  
  // Delete account
  Future<bool> deleteAccount() async {
    if (deleteAccountFormKey.currentState?.validate() ?? false) {
      isLoading.value = true;
      validationErrors.clear();
      
      try {
        final result = await _authService.deleteAccount(
          passwordController.text,
        );
        
        if (result['success']) {
          Get.offAll(() => LoginScreen());
          Get.snackbar(
            'Success',
            'Account deleted successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          // Notify other controllers that user data has changed
          Get.find<TicketController>().refreshControllerOnUserUpdate();
          return true;
        } else {
          Get.back(); // Close the dialog
          _handleValidationErrors(result);
          return false;
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'An unexpected error occurred',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      } finally {
        isLoading.value = false;
      }
    }
    return false;
  }
  
  // Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }
  
  // Helper method to handle validation errors
  void _handleValidationErrors(Map<String, dynamic> result) {
    if (result['validation_errors'] != null) {
      final errors = result['validation_errors'] as Map<String, dynamic>;
      errors.forEach((key, value) {
        if (value is List && value.isNotEmpty) {
          validationErrors[key] = value.first.toString();
        }
      });
    }
    
    Get.snackbar(
      'Error',
      result['message'],
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
  
  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}