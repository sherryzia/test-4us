import 'dart:async';
import 'package:affirmation_app/constants/app_colors.dart';
import 'package:affirmation_app/constants/app_images.dart';
import 'package:affirmation_app/view/screens/auth/login/login.dart';
import 'package:affirmation_app/view/screens/launch/on_boarding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    splashScreenHandler();
  }

  Future<void> splashScreenHandler() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final onboarding = prefs.getBool("onboarding") ?? false;

      Timer(
        Duration(seconds: 3),
        () => Get.offAll(
          () => onboarding ? LoginView() : OnBoarding(),
        ),
      );
    } catch (e) {
      print("Error accessing SharedPreferences: $e");
      Get.offAll(
        () => OnBoarding(),
      ); // Fallback to OnBoarding if there's an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            Assets.imagesBgImage,
            height: Get.height,
            width: Get.width,
            fit: BoxFit.cover,
          ),
          Positioned.fill(
            child: Container(
              color: kBlackColor.withOpacity(0.62),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              Assets.imagesAppLogo,
              height: 150,
            ),
          ),
        ],
      ),
    );
  }
}
