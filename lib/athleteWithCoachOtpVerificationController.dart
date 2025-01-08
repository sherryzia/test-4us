import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swim_strive/controller/AuthController.dart';
import 'package:swim_strive/view/screens/athlete/a_sign_up/a_welcome.dart';
import 'package:swim_strive/view/screens/athlete_with_coach/awc_sign_up/awc_welcome.dart';

class AthleteWithCoachOTPVerificationController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

final globalController = Get.find<AuthController>();
  // Function to verify OTP
  Future<void> verifyOTP(String enteredOTP) async {
    try {
      // Fetch the uid from the global controller
      final uid = globalController.uid;

      // Query the users table to get the OTP for the given UID
      final response = await supabase
          .from('users')
          .select('otp')
          .eq('id', "$uid")
          .maybeSingle();

      if (response == null) {
        throw Exception("User not found.");
      }

      final String storedOTP = response['otp'];

      if (enteredOTP == storedOTP) {
        // OTP matches, navigate to the next screen
        Get.to(() => AWCWelcome());
      } else {
        // OTP does not match
        Get.snackbar('Error', 'Invalid OTP. Please try again.', backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
      print("Error verifying OTP: $e");
    }
  }

  // Function to resend OTP
  Future<void> resendOTP() async {
    try {
      // Fetch the uid from the global controller
      final uid = globalController.uid;

      // Generate a new OTP
      final String newOTP = List.generate(6, (_) => (Random().nextInt(10))).join();

      // Update the OTP in the database
      final response = await supabase
          .from('users')
          .update({'otp': newOTP})
          .eq('id', "$uid");

      if (response.error != null) {
        throw Exception(response.error!.message);
      }

      // Notify the user
      Get.snackbar('Success', 'A new OTP has been sent to your email.', backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
      print("Error resending OTP: $e");
    }
  }
}
