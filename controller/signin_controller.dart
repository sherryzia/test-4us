// lib/controller/auth/login_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/controller/session_checker.dart';
import 'package:restaurant_finder/view/screens/launch/on_boarding.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:restaurant_finder/model/user_model.dart';
import 'package:restaurant_finder/view/screens/bottom_nav_bar/bottom_nav_bar.dart';

class LoginController extends GetxController {
  // Text editing controllers
  final emailPhoneController = TextEditingController();
  final passwordController = TextEditingController();
  
  // Observables
  final RxBool isLoading = false.obs;
  final RxBool rememberMe = true.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isObSecure = true.obs;
  
  // Get Supabase client
  final supabase = Supabase.instance.client;
  
  @override
  void onClose() {
    emailPhoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
  
  // Toggle remember me
  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }
  
  // Validate form fields
  bool validateFields() {
    if (emailPhoneController.text.isEmpty) {
      errorMessage.value = 'Email/Phone cannot be empty';
      return false;
    }
    
    if (passwordController.text.isEmpty) {
      errorMessage.value = 'Password cannot be empty';
      return false;
    }
    
    return true;
  }
  
  // Check session and load user data

  // Login with email/phone and password
  Future<void> login() async {
    errorMessage.value = '';
    
    if (!validateFields()) {
      return;
    }
    
    try {
      isLoading.value = true;
      
      // Assume input is email (you can add phone validation/handling if needed)
      final email = emailPhoneController.text.trim();
      final password = passwordController.text;
      
      // Attempt to sign in with Supabase
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user == null) {
        errorMessage.value = 'Invalid credentials';
        isLoading.value = false;
        return;
      }try {
      final userData = await supabase
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .single();
      
      print("Existing user found in users table");
    } catch (e) {
      // User doesn't exist in your custom table, create them
      print("User not found in users table, creating...");
      
      final newUser = UserModel(
        name: email.split('@')[0], // Default name from email
        email: email,
        phoneNumber: "", // Default empty phone
      );
      
      // Create user in your custom table
      await supabase
          .from('users')
          .insert({
            'id': response.user!.id, // Important: use the auth user ID
            ...newUser.toJson()
          });
      
      print("New user created in users table");
    }
    
    // Now check session (user should exist in both tables)
    await SessionChecker().checkSession();
    
  }  catch (e) {
      errorMessage.value = e.toString();
      isLoading.value = false;
    }
  }
  
  // Login with Google
  Future<void> loginWithGoogle() async {
    // Implement Google login logic
  }
  
  // Login with Facebook
  Future<void> loginWithFacebook() async {
    // Implement Facebook login logic
  }
  
  // Login with Apple
  Future<void> loginWithApple() async {
    // Implement Apple login logic
  }
  
  // Guest login (Sign in later)
  void signInLater() {
    // Navigate to bottom nav bar as guest
    Get.off(() => BottomNavBar());
  }
}