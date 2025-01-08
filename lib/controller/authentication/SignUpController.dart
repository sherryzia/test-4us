import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swim_strive/controller/authentication/AuthController.dart';
import 'package:swim_strive/controller/emailSender.dart';
import 'package:swim_strive/utils/supabase_utility.dart';
import 'package:swim_strive/services/AuthService.dart';
import 'package:swim_strive/view/screens/athlete/a_sign_up/a_verify_account.dart';
import 'package:swim_strive/view/screens/athlete_with_coach/awc_sign_up/awc_verify_account.dart';
import 'package:swim_strive/view/screens/coach/c_sign_up/c_verify_account.dart';

class SignUpController extends GetxController {
  final SupabaseUtil _supabaseUtil = SupabaseUtil();
  final AuthService _authService = AuthService(); // Use AuthService for auth actions
  final globalController = Get.find<AuthController>();
  final emailController = Get.put(EmailSenderController());

  // Generate a unique 6-digit OTP
  Future<String> _generateUniqueOtp() async {
    final random = Random();
    String otp;
    do {
      otp = List.generate(6, (_) => random.nextInt(10)).join();
      final response = await _supabaseUtil.fetchSingle(
        table: 'users',
        match: {'otp': otp},
        selectFields: 'id',
      );
      if (response == null) break; // Unique OTP generated
    } while (true);
    return otp;
  }

  // Function to sign up user in Supabase Auth and store additional details in the database
  Future<void> signUpUser({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      // Step 1: Register user in Supabase Auth using AuthService
      final authResponse = await _authService.signUp(email, password);

      if (authResponse.user == null) {
        throw Exception("Unable to sign up user. Please try again.");
      }

      // Step 2: Get the UID from the authenticated user
      final uid = authResponse.user!.id;
      globalController.uid.value = uid;

      // Step 3: Generate a unique OTP
      final otp = await _generateUniqueOtp();

      // Step 4: Insert user details into the users table
      await _supabaseUtil.insert(
        table: 'users',
        data: {
          'id': uid, // Use the UID from Supabase Auth
          'email': email,
          'otp': otp,
          'role': role,
        },
      );

      // Step 5: Send OTP to the user's email
      emailController.sendEmail(otp, email);

      // Step 6: Navigate to the respective verification screen based on the user role
      switch (role) {
        case 'coach':
          Get.to(() => CoachVerifyAccount(), arguments: {'email': email, 'otp': otp});
          break;
        case 'athlete_with_coach':
          Get.to(() => AWCVerifyAccount(), arguments: {'email': email, 'otp': otp});
          break;
        case 'athlete':
          Get.to(() => AthleteVerifyAccount(), arguments: {'email': email, 'otp': otp});
          break;
        default:
          throw Exception("Invalid role: $role");
      }
    } catch (e) {
      // Show error to user and log it
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
      print("Error Signing up: $e");
    }
  }
}
