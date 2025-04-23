import 'package:ecomanga/controllers/controllers.dart';
import 'package:ecomanga/features/auth/screens/login_screen.dart';
import 'package:ecomanga/features/home/root_screen.dart';
import 'package:ecomanga/features/utils/utils.dart';
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
    
    // Wait for first frame to be rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSessionAndNavigate();
    });
  }

  Future<void> _checkSessionAndNavigate() async {
    // Add a slight delay for better user experience
    await Future.delayed(const Duration(seconds: 2));
    
    // Wait until app is ready (GlobalController initialized)
    await _waitUntilAppReady();
    
    // Check if user is logged in
    if (Controllers.global.checkIfLoggedIn()) {
      // If session is expired, navigate to login
      if (Controllers.global.isSessionExpired()) {
        _navigateToLogin();
      } else {
        // Refresh user data in the background and navigate to home
        Controllers.global.refreshUserData();
        _navigateToHome();
      }
    } else {
      _navigateToLogin();
    }
  }
  
  Future<void> _waitUntilAppReady() async {
    // If app is not ready yet, wait until it is
    while (!Controllers.global.isAppReady.value) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }
  
  void _navigateToLogin() {
    Utils.go(
      context: context,
      screen: const LoginScreen(),
      replace: true,
    );
  }
  
  void _navigateToHome() {
    Utils.go(
      context: context,
      screen: const RootScreen(),
      replace: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/icons/app_icon.png",
              height: 150,
              width: 150,
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            const Text(
              "Starting EcoManga...",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}