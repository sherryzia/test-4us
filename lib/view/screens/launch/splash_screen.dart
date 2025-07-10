import 'dart:async';

import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/view/screens/auth/authentication_point.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(3.seconds, () {
      // Navigate to AuthenticationPoint which will handle session validation
      Get.offAll(() => AuthenticationPoint());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              kBlueColor.withOpacity(0.35),
              kSecondaryColor.withOpacity(0.72),
            ],
          ),
        ),
        child: Center(
          child: Image.asset(
            Assets.imagesAppLogo,
            height: 60,
          ),
        ),
      ),
    );
  }
}