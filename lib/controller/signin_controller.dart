import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swim_strive/Services/supabase_service.dart';
import 'package:swim_strive/constants/app_urls.dart';
import 'package:swim_strive/controller/CompleteProfileController.dart';
import 'package:swim_strive/controller/AuthController.dart';
import 'package:swim_strive/view/screens/bottom_nav_bar/a_nav_bar.dart';
import 'package:swim_strive/view/screens/bottom_nav_bar/awc_nav_bar.dart';
import 'package:swim_strive/view/screens/bottom_nav_bar/c_nav_bar.dart';
import 'package:swim_strive/view/screens/launch/login_options.dart';

class SignInController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  final profileController = Get.find<CompleteProfileController>();
 final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final SupabaseService _supabaseService = SupabaseService();
  final authController = Get.find<AuthController>();
  String? userId;


  
  Future<void> _initializeFirebaseMessaging(String userId) async {
    // Get FCM token
    print("FCM token pushed to Supabase from login");
    final fcmToken = await _firebaseMessaging.getToken();
    if (fcmToken != null) {
      print("FCM Token: $fcmToken");
      userId = await _supabaseService.saveFcmToken(fcmToken, userId);
    }
  }


  // Function to handle user login
  Future<void> login(String email, String password) async {
    try {
      // Step 1: Attempt to sign in the user using Supabase Auth
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception("Invalid email or password.");
      }

      final String uid = response.user!.id;
      authController.uid.value = "$uid";
      print("User ID: ${authController.uid}");


      // Step 2: Fetch user profile after successful login
      await profileController.fetchUserProfile(uid);

      // Step 3: Navigate based on user role
      if (profileController.role.value == 'coach') {
                  _initializeFirebaseMessaging(uid);

        Get.offAll(() => CoachNavBar());
      } else if (profileController.role.value == 'athlete_with_coach') {
                  _initializeFirebaseMessaging(uid);

        Get.offAll(() => AWCNavBar());
      } else if (profileController.role.value == 'athlete') {
                  _initializeFirebaseMessaging(uid);

        Get.offAll(() => AthleteNavBar());
      } else {
        throw Exception("Invalid user role: ${profileController.role.value}");
      }
      
    } catch (e) {
      Get.snackbar('Login Failed', e.toString(), backgroundColor: Colors.red);
      print("Login Error: $e");
    }
  }

  // Function to handle user logout
  Future<void> logout() async {
    try {
      // Step 1: Sign out the user from Supabase
      final response = await supabase.auth.signOut();

     
      // Step 2: Clear the CompleteProfileController data
      profileController.clearProfileData();

      // Step 3: Navigate to the login screen
      Get.offAll(() => ChooseLoginOption());

      Get.snackbar('Logged Out', 'You have been logged out successfully.',
          backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar('Logout Failed', e.toString(), backgroundColor: Colors.red);
      print("Logout Error: $e");
    }
  }
}
