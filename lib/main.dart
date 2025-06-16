// lib/main.dart

import 'package:betting_app/bindings/app_bindings.dart';
import 'package:betting_app/view/screens/auth/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'config/theme/light_theme.dart';
import 'services/auth_service.dart';
import 'view/screens/bottom_nav_bar/bottom_nav_bar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
        Get.put(AuthService(), permanent: true);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      title: 'BetVault',
      theme: lightTheme,
      themeMode: ThemeMode.light,
      initialBinding: AppBinding(),
      home: FutureBuilder(
        future: Get.find<AuthService>().loadFromStorage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Obx(() {
              final authService = Get.find<AuthService>();
              return authService.isLoggedIn.value 
                ? BottomNavBar() 
                : LoginScreen();
            });
          }
          
          // Loading state while checking auth
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      ),
    );
  }
}