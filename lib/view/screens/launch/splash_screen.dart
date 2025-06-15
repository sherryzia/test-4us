
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../generated/assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _animationController.forward().then((_) {
     // Get.offAll(() => const WelcomeScreen(), transition: Transition.fadeIn, duration: const Duration(seconds: 2));
      // Add any additional logic you want to execute after the animation completes
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: kPrimaryColor,
        height: Get.height,
        width: Get.width,
        child: Center(
            child: Image.asset(
          Assets.imagesSplashLogo,
          height: 50,
        )),
      ),
    );
  }
}
