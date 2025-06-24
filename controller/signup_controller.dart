// lib/controller/auth/signup_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/controller/emailSender.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:restaurant_finder/model/user_model.dart';
import 'package:restaurant_finder/model/otp_model.dart';
import 'package:restaurant_finder/utils/otp_util.dart';
import 'package:restaurant_finder/view/screens/auth/sign_up/email_verification.dart';

class SignUpController extends GetxController {
  // Text editing controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  // Observables
  final RxBool isLoading = false.obs;
  final RxBool termsAccepted = true.obs;
  final RxString errorMessage = ''.obs;

  final RxBool isObSecure = true.obs;
  final RxBool isObSecure2 = true.obs;
  
  // Get Supabase client
  final supabase = Supabase.instance.client;
  final EmailSenderController emailSenderController = Get.put(EmailSenderController());
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
  
  // Toggle terms acceptance
  void toggleTerms() {
    termsAccepted.value = !termsAccepted.value;
  }
  
  // Validate form fields
  bool validateFields() {
    if (nameController.text.isEmpty) {
      errorMessage.value = 'Name cannot be empty';
      return false;
    }
    
    if (emailController.text.isEmpty || !GetUtils.isEmail(emailController.text)) {
      errorMessage.value = 'Please enter a valid email';
      return false;
    }
    
    if (phoneController.text.isEmpty) {
      errorMessage.value = 'Phone number cannot be empty';
      return false;
    }
    
    if (passwordController.text.isEmpty || passwordController.text.length < 6) {
      errorMessage.value = 'Password must be at least 6 characters';
      return false;
    }
    
    if (passwordController.text != confirmPasswordController.text) {
      errorMessage.value = 'Passwords do not match';
      return false;
    }
    
    if (!termsAccepted.value) {
      errorMessage.value = 'You must accept the terms and conditions';
      return false;
    }
    
    return true;
  }
  
  // Generate and save OTP
  Future<String> generateAndSaveOtp(String email) async {
    // Generate a 4-digit OTP
    final String generatedOtp = OtpUtil.generateOtp();
    
    // Create OTP model (without expiry time since we don't need a timer)
    final otpModel = OtpModel(
      email: email,
      otp: generatedOtp,
      isVerified: false,
    );
    
    // Save OTP to database
    await supabase
        .from('otps')
        .insert(otpModel.toJson());
    
    emailSenderController.sendEmail(generatedOtp, email);
    return generatedOtp;
  }
  
  // Sign up with email and password
  Future<void> signUp() async {
    errorMessage.value = '';
    
    if (!validateFields()) {
      return;
    }
    
    try {
      isLoading.value = true;
      
      // 1. Create auth user with Supabase auth
      final authResponse = await supabase.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      
      if (authResponse.user == null) {
        errorMessage.value = 'Failed to create account';
        isLoading.value = false;
        return;
      }
      
      // 2. Create user model with auth user ID
      final user = UserModel(
        id: authResponse.user!.id,  // Include the auth user ID here
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phoneNumber: phoneController.text.trim(),
      );
      
      // 3. Insert user data into the users table
      // Explicitly include the ID in the insert to ensure it matches the auth ID
      await supabase
          .from('users')
          .insert({
            'id': authResponse.user!.id,
            'name': user.name,
            'email': user.email,
            'phone_number': user.phoneNumber
          });
      
      // 4. Generate and save OTP
      final generatedOtp = await generateAndSaveOtp(emailController.text.trim());
      
      // 5. Navigate to email verification screen with email and otp
      isLoading.value = false;
      Get.to(() => EmailVerification(), arguments: {
        'email': emailController.text.trim(),
        'otp': generatedOtp
      });
      
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
    }
  }
  
  // Resend OTP (can be called from OTP verification screen)
  Future<String> resendOtp(String email) async {
    
    return await generateAndSaveOtp(email);
  }
  
  // Sign up with Google
  Future<void> signUpWithGoogle() async {
    // Implement Google sign up logic
  }
  
  // Sign up with Facebook
  Future<void> signUpWithFacebook() async {
    // Implement Facebook sign up logic
  }
  
  // Sign up with Apple
  Future<void> signUpWithApple() async {
    // Implement Apple sign up logic
  }
}