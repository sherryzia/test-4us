// lib/controllers/signup_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expensary/services/supabase_service.dart';
import 'package:expensary/controllers/global_controller.dart';
import 'package:expensary/views/screens/otp_verification_screen.dart';

class SignupController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final RxBool agreeToTerms = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final RxBool isLoading = false.obs;
  
  // Form validation
  final RxBool isNameValid = true.obs;
  final RxString nameErrorText = ''.obs;
  final RxBool isEmailValid = true.obs;
  final RxString emailErrorText = ''.obs;
  final RxBool isPasswordValid = true.obs;
  final RxString passwordErrorText = ''.obs;
  final RxBool isConfirmPasswordValid = true.obs;
  final RxString confirmPasswordErrorText = ''.obs;
  
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
  
  void toggleAgreeToTerms() {
    agreeToTerms.value = !agreeToTerms.value;
  }
  
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }
  
  // Validate name field
  bool validateName() {
    final name = nameController.text.trim();
    
    if (name.isEmpty) {
      isNameValid.value = false;
      nameErrorText.value = 'Name is required';
      return false;
    }
    
    if (name.length < 2) {
      isNameValid.value = false;
      nameErrorText.value = 'Name must be at least 2 characters';
      return false;
    }
    
    isNameValid.value = true;
    nameErrorText.value = '';
    return true;
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
  
  // Validate password field
  bool validatePassword() {
    final password = passwordController.text;
    
    if (password.isEmpty) {
      isPasswordValid.value = false;
      passwordErrorText.value = 'Password is required';
      return false;
    }
    
    if (password.length < 6) {
      isPasswordValid.value = false;
      passwordErrorText.value = 'Password must be at least 6 characters';
      return false;
    }
    
    isPasswordValid.value = true;
    passwordErrorText.value = '';
    return true;
  }
  
  // Validate confirm password field
  bool validateConfirmPassword() {
    final confirmPassword = confirmPasswordController.text;
    final password = passwordController.text;
    
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
  
  // Validate terms agreement
  bool validateTerms() {
    if (!agreeToTerms.value) {
      Get.snackbar(
        'Terms & Conditions',
        'Please agree to the Terms & Conditions to continue',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return false;
    }
    return true;
  }
  
  // Validate entire form
  bool validateForm() {
    final isNameValidated = validateName();
    final isEmailValidated = validateEmail();
    final isPasswordValidated = validatePassword();
    final isConfirmPasswordValidated = validateConfirmPassword();
    final isTermsValidated = validateTerms();
    
    return isNameValidated && 
           isEmailValidated && 
           isPasswordValidated && 
           isConfirmPasswordValidated &&
           isTermsValidated;
  }
  
  // Signup using Supabase
  Future<void> signup() async {
    if (!validateForm()) {
      return;
    }
    
    isLoading.value = true;
    
    try {
      // Attempt to sign up
      final response = await SupabaseService.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
        fullName: nameController.text.trim(),
      );
      
      if (response.user != null) {
        // Generate and save OTP
        await SupabaseService.saveOTP(userId: response.user!.id);
        
        // If email confirmation is required
        if (response.session == null) {
          // Navigate to OTP verification screen
          Get.to(() => OTPVerificationScreen(
            email: emailController.text.trim(),
            userId: response.user!.id,
          ));
          
          Get.snackbar(
            'Success',
            'Please check your email for verification code',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
          );
        } 
        // If no email verification is required (session is created immediately)
        else {
          // Clear form fields
          nameController.clear();
          emailController.clear();
          passwordController.clear();
          confirmPasswordController.clear();
          
          Get.snackbar(
            'Success',
            'Account created successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      // Use global controller to handle error
      Get.find<GlobalController>().handleError(
        e, 
        customMessage: 'Failed to create account. Please try again.'
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  void viewTerms() {
    Get.snackbar(
      'Terms & Conditions',
      'Terms & Conditions coming soon',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.withOpacity(0.8),
      colorText: Colors.white,
    );
  }
}