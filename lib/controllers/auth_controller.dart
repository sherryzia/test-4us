// lib/controllers/auth_controller.dart

import 'package:betting_app/view/screens/auth/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:betting_app/services/auth_service.dart';
import 'package:betting_app/view/screens/bottom_nav_bar/bottom_nav_bar.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  
  // Login form
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  // Register form
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController registerEmailController = TextEditingController();
  final TextEditingController registerPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  // UI state
  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;
  final RxMap<String, String> validationErrors = RxMap<String, String>();
  
  // Form validation
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }
  
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }
  
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != registerPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
  
  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
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
  
  // Login method
  Future<void> login() async {
    if (loginFormKey.currentState?.validate() ?? false) {
      isLoading.value = true;
      validationErrors.clear();
      
      try {
        final result = await _authService.login(
          emailController.text.trim(),
          passwordController.text,
        );
        
        if (result['success']) {
          // Clear form
          emailController.clear();
          passwordController.clear();
          
          // Navigate to home
          Get.offAll(() => BottomNavBar());
        } else {
          // Handle validation errors
          if (result['validation_errors'] != null) {
            final errors = result['validation_errors'] as Map<String, dynamic>;
            errors.forEach((key, value) {
              if (value is List && value.isNotEmpty) {
                validationErrors[key] = value.first.toString();
              }
            });
          }
          
          // Show general error message
          Get.snackbar(
            'Login Failed',
            result['message'],
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'An unexpected error occurred. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }
  
  // Register method
  Future<void> register() async {
    if (registerFormKey.currentState?.validate() ?? false) {
      isLoading.value = true;
      validationErrors.clear();
      
      try {
        final result = await _authService.register(
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          phone: phoneController.text.trim(),
          email: registerEmailController.text.trim(),
          password: registerPasswordController.text,
          passwordConfirmation: confirmPasswordController.text,
        );
        
        if (result['success']) {
          // Clear form
          firstNameController.clear();
          lastNameController.clear();
          phoneController.clear();
          registerEmailController.clear();
          registerPasswordController.clear();
          confirmPasswordController.clear();
          
          // Navigate to home
          Get.offAll(() => BottomNavBar());
        } else {
          // Handle validation errors
          if (result['validation_errors'] != null) {
            final errors = result['validation_errors'] as Map<String, dynamic>;
            errors.forEach((key, value) {
              if (value is List && value.isNotEmpty) {
                validationErrors[key] = value.first.toString();
              }
            });
          }
          
          // Show general error message
          Get.snackbar(
            'Registration Failed',
            result['message'],
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'An unexpected error occurred. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }
  
  // Logout method
  // lib/controllers/auth_controller.dart

// Update the logout method to call the API
Future<void> logout() async {
  try {
    isLoading.value = true;
    
    final result = await _authService.logout();
    
    if (result['success']) {
      // Navigate to login screen
      Get.offAll(() => LoginScreen());
      
      // Show success message
      Get.snackbar(
        'Success',
        'Logged out successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Error',
        result['message'],
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    Get.snackbar(
      'Error',
      'An unexpected error occurred during logout',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    isLoading.value = false;
  }
}
  // Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }
  
  // Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }
  
  @override
  void onClose() {
    // Dispose of controllers
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    registerEmailController.dispose();
    registerPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}