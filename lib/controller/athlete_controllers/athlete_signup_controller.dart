import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swim_strive/controller/AuthController.dart';
import 'package:swim_strive/controller/emailSender.dart';
import 'dart:math';

import 'package:swim_strive/view/screens/athlete/a_sign_up/a_verify_account.dart';

class AthleteSignUpController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  final globalcontroller = Get.find<AuthController>();
  final emailcontroller = Get.put(EmailSenderController());

  // Generate a unique 6-digit OTP
  Future<String> generateUniqueOTP() async {
    final random = Random();
    String otp;
    do {
      otp = List.generate(6, (_) => random.nextInt(10)).join();
      final response = await supabase.from('users').select('id').eq('otp', otp).maybeSingle();
      if (response == null) break; // Unique OTP generated
    } while (true);
    return otp;
  }

  // Function to sign up user in Supabase Auth and store additional details in the users table
  Future<void> signUpUser(String email, String password, String role) async {
    try {
      // Step 1: Register user in Supabase Auth
      final authResponse = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (authResponse.user == null) {
        throw Exception("Unable to sign up user. Please try again.");
      }

      // Get the UID from the authenticated user
      final uid = authResponse.user!.id;
      globalcontroller.uid.value = uid;
      

      // Step 2: Generate a unique OTP
      final otp = await generateUniqueOTP();
      // Step 3: Insert user details into the users table
      final response = await supabase.from('users').insert({
        'id': uid, // Use the UID from Supabase Auth
        'email': email,
        'otp': otp,
        'role': role,
      });

            emailcontroller.sendEmail(otp, email);

      print("User Id: ${globalcontroller.uid}");
      // Step 4: Navigate to verification screen
      Get.to(() => AthleteVerifyAccount(), arguments: {'email': email, 'otp': otp} );
    } catch (e) {
      // Show error to user and log it
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
      print("Error Signing up: $e");
    }
  }
}
