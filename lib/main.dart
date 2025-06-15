import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'config/routes/routes.dart';
import 'config/theme/light_theme.dart';

void main() {
  runApp(MyApp());
}

const String dummyImage2 =
    'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';
const String dummyImage =
    'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      title: 'Betting App',
      theme: lightTheme,

      themeMode: ThemeMode.light,
      initialRoute: AppLinks.splash_screen,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
      getPages: AppRoutes.pages,
    );
  }
}
