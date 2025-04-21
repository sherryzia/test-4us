import 'package:ecomanga/features/auth/screens/login_screen.dart';
import 'package:ecomanga/features/utils/utils.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });

    super.initState();
  }

  _init() {
    Future.delayed(Duration(seconds: 2), () {
      Utils.go(
        context: context,
        screen: const LoginScreen(),
        replace: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Image.asset(
        "assets/icons/app_icon.png",
        height: 250,
        width: 250,
      )),
    );
  }
}
