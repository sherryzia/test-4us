// lib/main.dart
import 'package:expensary/configs/supabase_config.dart';
import 'package:expensary/controllers/global_controller.dart';
import 'package:expensary/views/screens/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await SupabaseConfig.initialize();
  
  // Initialize GetX controllers
  Get.put(GlobalController(), permanent: true);
  
  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Expensary',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Use dark theme by default
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF6200EE),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Onboarding(),
    );
  }
}