import 'dart:async';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swim_strive/controller/user/CompleteProfileController.dart';
import 'package:swim_strive/controller/authentication/AuthController.dart';
import 'package:swim_strive/view/screens/bottom_nav_bar/a_nav_bar.dart';
import 'package:swim_strive/view/screens/bottom_nav_bar/awc_nav_bar.dart';
import 'package:swim_strive/view/screens/bottom_nav_bar/c_nav_bar.dart';
import 'package:swim_strive/view/screens/launch/get_started.dart';

class Sessioncontroller extends GetxController {

   final CompleteProfileController profileController =
      Get.find<CompleteProfileController>();

      final authController = Get.find<AuthController>();
 Future<void> checkUserSession() async {


  
    // Get the current session from Supabase Auth
    final session = Supabase.instance.client.auth.currentSession;

    if (session != null && session.user != null) {
      final String uid = session.user!.id;

      authController.uid.value = "$uid";

      // Fetch user profile using the CompleteProfileController
      await profileController.fetchUserProfile(uid);

      // Navigate based on the user's role
      if (profileController.role.value == 'coach') {
        Get.offAll(() => CoachNavBar());
      } else if (profileController.role.value == 'athlete_with_coach') {
        Get.offAll(() => AWCNavBar());
      } else if (profileController.role.value == 'athlete') {
        Get.offAll(() => AthleteNavBar());
      } else {
        // Fallback in case of an invalid role
        Get.offAll(() => const GetStarted());
      }
    } else {
      // If no session exists, navigate to the Get Started screen
      Timer(const Duration(seconds: 3), () {
        Get.offAll(() => const GetStarted());
      });
    }
  }

}
