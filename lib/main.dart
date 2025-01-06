import 'package:flutter/material.dart';
import 'package:forus_app/controllers/GlobalController.dart';
import 'package:get/get.dart';
import 'package:forus_app/config/routes/routes.dart';
import 'package:forus_app/config/theme/light_theme.dart';
import 'package:forus_app/utils/dio_util.dart';

void main() {
  DioUtil.init();
  Get.put(GlobalController()); // Initialize GlobalController
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      theme: lightTheme,
      themeMode: ThemeMode.light,
      initialRoute: AppLinks.splashScreen,
      getPages: AppRoutes.pages,
      defaultTransition: Transition.fadeIn,
    );
  }

}