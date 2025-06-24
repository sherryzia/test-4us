import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_images.dart';
import 'package:restaurant_finder/controller/session_checker.dart';
import 'package:restaurant_finder/controller/language_controller.dart';
import 'package:restaurant_finder/view/screens/launch/on_boarding.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LanguageController languageController = Get.find<LanguageController>();

  @override
  void initState() {
    super.initState();
    setLanguageFromPrefs();
    splashScreenHandler();
  }

  void setLanguageFromPrefs() async {
    // Wait for prefs to be initialized in LanguageController
    await Future.delayed(Duration(milliseconds: 100));
    int? languageIndex = languageController.currentLanguageIndex.value;
    if (languageIndex != null) {
      languageController.currentLocale.value = AppLocale.values[languageIndex];
      languageController.isEnglish.value = languageIndex == 0;
      Localization().selectedLocale(AppLocale.values[languageIndex]);
    } else {
      // Default to English if no language is set
      languageController.currentLocale.value = AppLocale.en;
      languageController.isEnglish.value = true;
      Localization().selectedLocale(AppLocale.en);
    }
  }

  void splashScreenHandler() {
    Timer(
      Duration(seconds: 2),
      SessionChecker().checkSession,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      body: Center(child: Image.asset(Assets.imagesLogo, height: 287)),
    );
  }
}
