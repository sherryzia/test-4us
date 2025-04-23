import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/config/appConfigs.dart';
import 'package:restaurant_finder/controller/global_controller.dart';

import 'config/routes/routes.dart';
import 'config/theme/light_theme.dart';

void main() {
  AppConfigs.initializeSupabase();
  Get.put(GlobalController());
  runApp(MyApp());
}

//DO NOT REMOVE Unless you find their usage.
String dummyImg =
    'https://images.unsplash.com/photo-1647109063447-e01ab743ee8f?q=80&w=1932&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      title: 'TITLE',
      theme: lightTheme,
      themeMode: ThemeMode.light,
      initialRoute: AppLinks.splash_screen,
      getPages: AppRoutes.pages,
      defaultTransition: Transition.fadeIn,
    );
  }
}
