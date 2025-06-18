// lib/controllers/login_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expensary/services/supabase_service.dart';
import 'package:expensary/controllers/global_controller.dart';
import 'package:expensary/views/screens/forgot_password_screen.dart';
import 'package:expensary/views/screens/signup_screen.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final RxBool rememberMe = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isLoading = false.obs;
  
  // Form validation
  final RxBool isEmailValid = true.obs;
  final RxString emailErrorText = ''.obs;
  final RxBool isPasswordValid = true.obs;
  final RxString passwordErrorText = ''.obs;
  
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
  
  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }
  
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
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
  
  // Validate entire form
  bool validateForm() {
    final isEmailValidated = validateEmail();
    final isPasswordValidated = validatePassword();
    
    return isEmailValidated && isPasswordValidated;
  }
  
  // Login using Supabase
  Future<void> login() async {
    if (!validateForm()) {
      return;
    }
    
    isLoading.value = true;
    
    try {
      // Get the global controller
      final globalController = Get.find<GlobalController>();
      
      // Attempt to sign in
      await SupabaseService.signIn(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      
      // Clear form fields
      emailController.clear();
      passwordController.clear();
      
    } catch (e) {
      // Use global controller to handle error
      Get.find<GlobalController>().handleError(
        e, 
        customMessage: 'Failed to sign in. Please check your email and password.'
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Navigate to forgot password screen
  void forgotPassword() {
    Get.to(() => ForgotPasswordScreen());
  }
  
  // Navigate to signup screen
  void goToSignup() {
    Get.to(() => SignupScreen());
  }
}