import 'package:candid/config/routes/routes.dart';
import 'package:candid/config/theme/light_theme.dart';
import 'package:candid/utils/init.dart';
import 'package:candid/view/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:candid/view/screens/explore/explore.dart';     
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Future<void> main() async {
  await init();
  runApp(MyApp());
}

//DO NOT REMOVE Unless you find their usage.
String dummyImg =
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=764&q=80';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (p0, p1, p2) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          debugShowMaterialGrid: false,
          title: 'Candid',
          theme: lightTheme,
          themeMode: ThemeMode.light,
          initialRoute: AppLinks.splash_screen,
          getPages: AppRoutes.pages,
          // home: BottomNavBar(),
          defaultTransition: Transition.fadeIn,
        );
      },
    );
  }
}
 