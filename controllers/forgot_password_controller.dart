// lib/controllers/forgot_password_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expensary/services/supabase_service.dart';
import 'package:expensary/controllers/global_controller.dart';

class ForgotPasswordController extends GetxController {
  // Text controllers
  final emailController = TextEditingController();
  final tokenController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  // Observable variables
  final RxBool isLoading = false.obs;
  final RxBool isNewPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final RxInt currentStep = 0.obs; // 0 = email, 1 = reset
  
  // Form validation
  final RxBool isEmailValid = true.obs;
  final RxString emailErrorText = ''.obs;
  final RxBool isTokenValid = true.obs;
  final RxString tokenErrorText = ''.obs;
  final RxBool isNewPasswordValid = true.obs;
  final RxString newPasswordErrorText = ''.obs;
  final RxBool isConfirmPasswordValid = true.obs;
  final RxString confirmPasswordErrorText = ''.obs;
  
  @override
  void onClose() {
    emailController.dispose();
    tokenController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
  
  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }
  
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }
  
  // Validate email field
  bool validateEmail() {
    final email = emailController.text.trim();
    
    if (email.isEmpty) {
      isEmailValid.value = false;
      emailErrorText.value = 'Email is required';
      return false;
    }
    
    if (!GetUtils.isEmail(email)) {
      isEmailValid.value = false;
      emailErrorText.value = 'Please enter a valid email';
      return false;
    }
    
    isEmailValid.value = true;
    emailErrorText.value = '';
    return true;
  }
  
  // Validate token field
  bool validateToken() {
    final token = tokenController.text.trim();
    
    if (token.isEmpty) {
      isTokenValid.value = false;
      tokenErrorText.value = 'Reset token is required';
      return false;
    }
    
    isTokenValid.value = true;
    tokenErrorText.value = '';
    return true;
  }
  
  // Validate new password field
  bool validateNewPassword() {
    final password = newPasswordController.text;
    
    if (password.isEmpty) {
      isNewPasswordValid.value = false;
      newPasswordErrorText.value = 'New password is required';
      return false;
    }
    
    if (password.length < 6) {
      isNewPasswordValid.value = false;
      newPasswordErrorText.value = 'Password must be at least 6 characters';
      return false;
    }
    
    isNewPasswordValid.value = true;
    newPasswordErrorText.value = '';
    return true;
  }
  
  // Validate confirm password field
  bool validateConfirmPassword() {
    final confirmPassword = confirmPasswordController.text;
    final password = newPasswordController.text;
    
    if (confirmPassword.isEmpty) {
      isConfirmPasswordValid.value = false;
      confirmPasswordErrorText.value = 'Please confirm your password';
      return false;
    }
    
    if (confirmPassword != password) {
      isConfirmPasswordValid.value = false;
      confirmPasswordErrorText.value = 'Passwords do not match';
      return false;
    }
    
    isConfirmPasswordValid.value = true;
    confirmPasswordErrorText.value = '';
    return true;
  }
  
  // Validate email step
  bool validateEmailStep() {
    return validateEmail();
  }
  
  // Validate reset step
  bool validateResetStep() {
    final isTokenValidated = validateToken();
    final isNewPasswordValidated = validateNewPassword();
    final isConfirmPasswordValidated = validateConfirmPassword();
    
    return isTokenValidated && isNewPasswordValidated && isConfirmPasswordValidated;
  }
  
  // Send reset email
  Future<void> sendResetEmail() async {
    if (!validateEmailStep()) {
      return;
    }
    
    isLoading.value = true;
    
    try {
      // Send password reset email
      await SupabaseService.resetPasswordForEmail(emailController.text.trim());
      
      // Move to reset step
      currentStep.value = 1;
      
      Get.snackbar(
        'Success',
        'Reset instructions sent to your email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } catch (e) {
      // Use global controller to handle error
      Get.find<GlobalController>().handleError(
        e, 
        customMessage: 'Failed to send reset email. Please try again.'
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Reset password
  Future<void> resetPassword() async {
    if (!validateResetStep()) {
      return;
    }
    
    isLoading.value = true;
    
    try {
      // Update user's password
      await SupabaseService.updateUserPasswordWithToken(
        token: tokenController.text.trim(),
        newPassword: newPasswordController.text,
      );
      
      // Clear form fields
      tokenController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
      
      Get.snackbar(
        'Success',
        'Password reset successfully! You can now log in with your new password.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
      
      // Navigate back to login
      Get.back();
    } catch (e) {
      // Use global controller to handle error
      Get.find<GlobalController>().handleError(
        e, 
        customMessage: 'Failed to reset password. Please try again or request a new token.'
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  void goBackToEmailStep() {
    currentStep.value = 0;
    // Clear reset form
    tokenController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }
}