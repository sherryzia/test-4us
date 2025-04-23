// lib/controller/auth/otp_verification_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/controller/signup_controller.dart';
import 'package:restaurant_finder/view/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:restaurant_finder/utils/otp_util.dart';

class OtpVerificationController extends GetxController {
  // For Pinput widget
  final TextEditingController pinController = TextEditingController();
  
  // Observables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString enteredOtp = ''.obs;
  
  // Get arguments
  final String email = Get.arguments['email'] ?? '';
  final String otp = Get.arguments['otp'] ?? '';
  
  // Get Supabase client
  final supabase = Supabase.instance.client;
  
  // Get signup controller for resending OTP
  final SignUpController _signUpController = Get.find<SignUpController>();
  
  @override
  void onInit() {
    super.onInit();
    
    // Listen to pin changes
    pinController.addListener(() {
      enteredOtp.value = pinController.text;
    });
    
    // For testing purposes, you can uncomment to pre-fill the OTP
    /*
    if (otp.length == 4) {
      pinController.text = otp;
    }
    */
  }
  
  @override
  void onClose() {
    pinController.dispose();
    super.onClose();
  }
  
  // Verify OTP
  Future<void> verifyOtp() async {
    // Check if OTP is complete (4 digits)
    if (enteredOtp.value.length != 4) {
      errorMessage.value = 'Please enter all 4 digits';
      return;
    }
    
    // Validate OTP format
    if (!OtpUtil.isValidOtp(enteredOtp.value)) {
      errorMessage.value = 'Invalid OTP format';
      return;
    }
    
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // Query the OTP from database
      final response = await supabase
          .from('otps')
          .select()
          .eq('email', email)
          .eq('otp', enteredOtp.value)
          .eq('is_verified', false)
          .limit(1)
          .maybeSingle();
      
      if (response == null) {
        errorMessage.value = 'Invalid OTP';
        isLoading.value = false;
        return;
      }
      
      // Mark OTP as verified
      await supabase
          .from('otps')
          .update({'is_verified': true})
          .eq('id', response['id']);
      
      // Show success dialog
      Get.dialog(const _SuccessDialog());
      
    } catch (e) {
      errorMessage.value = e.toString();
      isLoading.value = false;
    }
  }
  
  // Resend OTP
  Future<void> resendOtp() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // Use the signup controller to generate and save a new OTP
      final newOtp = await _signUpController.resendOtp(email);
      
      // Update arguments with new OTP (for testing purposes)
      Get.arguments['otp'] = newOtp;
      
      // Show success message
      Get.snackbar(
        'OTP Sent',
        'A new verification code has been sent to your email',
        snackPosition: SnackPosition.BOTTOM,
      );
      
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  
  // Continue after successful verification
  void continueAfterVerification() {
    // Navigate to the appropriate screen after verification
                    Get.off(() => BottomNavBar());
  }
}

// Import the SuccessDialog class from the UI
class _SuccessDialog extends StatelessWidget {
  const _SuccessDialog();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          margin: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/images/congrats_check.png', // Make sure this asset exists
                  height: 118,
                ),
                const Text(
                  'Verification Successful!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2ECC71), // kSecondaryColor
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                const Text(
                  'Your account has been verified, and you\'re all set to explore the app.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF858585), // kQuaternaryColor
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Get the controller
                    final controller = Get.find<OtpVerificationController>();
                    // Close dialog
                    Get.back();
                    // Navigate to next screen
                    controller.continueAfterVerification();
                  },
                  child: const Text('Continue'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}