import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swim_strive/controller/authentication/AuthController.dart';
import 'package:swim_strive/utils/supabase_utility.dart';
import 'package:swim_strive/view/screens/athlete/a_sign_up/a_welcome.dart';
import 'package:swim_strive/view/screens/athlete_with_coach/awc_sign_up/awc_welcome.dart';
import 'package:swim_strive/view/screens/coach/c_sign_up/c_welcome.dart';

class OtpVerificationController extends GetxController {
  final SupabaseUtil _supabaseUtil = SupabaseUtil();
  final globalController = Get.find<AuthController>();

  // Function to verify OTP
  Future<void> verifyOtp(String enteredOtp, String userType) async {
    try {
      // Fetch the UID from the global controller
      final uid = globalController.uid;

      // Fetch OTP from the database
      final response = await _supabaseUtil.fetchSingle(
        table: 'users',
        match: {'id': uid},
        selectFields: 'otp',
      );

      if (response == null) {
        throw Exception("User not found.");
      }

      final String storedOtp = response['otp'];

      if (enteredOtp == storedOtp) {
        // Navigate to the respective welcome screen based on user type
        if (userType == 'athlete') {
          Get.to(() => AthleteWelcome());
        } else if (userType == 'athlete_with_coach') {
          Get.to(() => AWCWelcome());
        } else if (userType == 'coach') {
          Get.to(() => CoachWelcome());
        } else {
          throw Exception("Invalid user type: $userType");
        }
      } else {
        // OTP does not match
        Get.snackbar('Error', 'Invalid OTP. Please try again.',
            backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
      print("Error verifying OTP: $e");
    }
  }

  // Function to resend OTP
  Future<void> resendOtp() async {
    try {
      // Fetch the UID from the global controller
      final uid = globalController.uid;

      // Generate a new OTP
      final String newOtp = List.generate(6, (_) => Random().nextInt(10)).join();

      // Update the OTP in the database
      await _supabaseUtil.update(
        table: 'users',
        data: {'otp': newOtp},
        match: {'id': uid},
      );

      // Notify the user
      Get.snackbar('Success', 'A new OTP has been sent to your email.',
          backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
      print("Error resending OTP: $e");
    }
  }
}
