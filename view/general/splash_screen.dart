import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/config/routes/routes.dart';
import 'package:quran_app/controllers/GlobalController.dart';
import 'package:quran_app/utilities/shared_preferences_util.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final globalController = Get.find<GlobalController>();
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  // ✅ Check if user data exists and navigate accordingly
  Future<void> _navigateToNextScreen() async {
  await Future.delayed(const Duration(seconds: 2));

  bool hasUserData = await _isUserDataPresent();

  if (hasUserData) {
    globalController.loadUserData();
    Get.offAllNamed(AppLinks.mainScreen); // ✅ Use toNamed for named routes
  } else {
    Get.offAllNamed(AppLinks.generalScreen); // ✅ Use toNamed for named routes
  }
}

  // ✅ Check SharedPreferences for stored user data
  Future<bool> _isUserDataPresent() async {
  
        // SharedPreferencesUtil.clearAll();

        // await SharedPreferencesUtil.removeData('bookmarks');
    
    String? name = await SharedPreferencesUtil.getData<String>("user_name");
    String? country = await SharedPreferencesUtil.getData<String>("user_country");
    String? city = await SharedPreferencesUtil.getData<String>("user_city");

    return name != null && country != null && city != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App Title
            const Center(
              child: Text(
                "Quran App",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF672CBC),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Quran Image
            Image.asset(
              "assets/images/splash_image.png",
              height: Get.height * .5,
            ),

            const SizedBox(height: 20),

            // Subtitle
            const Text(
              "Learn Quran and\nRecite once everyday",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
