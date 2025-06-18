// lib/controllers/otp_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expensary/services/supabase_service.dart';
import 'package:expensary/controllers/global_controller.dart';
import 'package:expensary/views/screens/main_navigation_screen.dart';

class OTPController extends GetxController {
  // OTP input controllers for each digit
  final List<TextEditingController> otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  
  // List of FocusNodes for each OTP input field
  final List<FocusNode> otpFocusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );
  
  // Timer for countdown
  Timer? _timer;
  final RxInt countdown = 60.obs;
  final RxBool canResend = false.obs;
  final RxBool isLoading = false.obs;
  
  // User ID for OTP verification
  final String userId;
  final String email;
  
  OTPController({
    required this.userId,
    required this.email,
  });
  
  @override
  void onInit() {
    super.onInit();
    startTimer();
  }
  
  @override
  void onClose() {
    // Dispose controllers and focus nodes
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in otpFocusNodes) {
      node.dispose();
    }
    
    // Cancel timer if active
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    
    super.onClose();
  }
  
  void startTimer() {
    countdown.value = 60;
    canResend.value = false;
    
    // Cancel any existing timer
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    
    // Start countdown timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }
  
  Future<void> resendOTP() async {
    if (!canResend.value) return;
    
    isLoading.value = true;
    
    try {
      // Clear existing OTP
      for (var controller in otpControllers) {
        controller.clear();
      }
      
      // Set focus to first field
      otpFocusNodes[0].requestFocus();
      
      // Generate and save a new OTP
      await SupabaseService.resendOTP(userId: userId);
      
      // Restart timer
      startTimer();
      
      // Show success message
      Get.snackbar(
        'OTP Resent',
        'A new verification code has been sent',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      // Show error message
      Get.find<GlobalController>().handleError(
        e,
        customMessage: 'Failed to resend verification code. Please try again.'
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Handle input in OTP fields
  void otpDigitInput(String value, int index) {
    if (value.length == 1) {
      // Move to next field
      if (index < 3) {
        otpFocusNodes[index + 1].requestFocus();
      } else {
        // Last digit entered, check if all filled
        verifyOTP();
      }
    }
  }
  
  // Verify the entered OTP
  Future<void> verifyOTP() async {
    // Combine all digits
    String otp = '';
    for (var controller in otpControllers) {
      otp += controller.text;
    }
    
    // Check if all digits are entered
    if (otp.length != 4) {
      return;
    }
    
    isLoading.value = true;
    
    try {
      // Verify OTP with Supabase
      final isValid = await SupabaseService.verifyOTP(
        userId: userId,
        otp: otp,
      );
      
      if (isValid) {
        // OTP is valid, navigate to main screen
        Get.offAll(() => MainNavigationScreen());
        
        Get.snackbar(
          'Success',
          'Account verified successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        // OTP is invalid
        Get.snackbar(
          'Invalid Code',
          'The verification code is incorrect or expired',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        
        // Clear the OTP fields
        for (var controller in otpControllers) {
          controller.clear();
        }
        
        // Set focus to first field
        otpFocusNodes[0].requestFocus();
      }
    } catch (e) {
      // Show error message
      Get.find<GlobalController>().handleError(
        e,
        customMessage: 'Failed to verify code. Please try again.'
      );
    } finally {
      isLoading.value = false;
    }
  }
}