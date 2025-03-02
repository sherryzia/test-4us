import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quran_app/config/globalBinding.dart';
import 'package:quran_app/config/routes/routes.dart';
import 'package:quran_app/config/theme/light_theme.dart';
import 'package:quran_app/services/notifications/firebase_fcm_saving_service.dart';
import 'package:quran_app/services/notifications/local_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // ✅ Initialize Local Notifications
  await LocalNotificationService.initialize();

  // ✅ Setup Firebase Messaging
  final FirebaseService firebaseService = FirebaseService();
  await firebaseService.saveFcmToken();
  firebaseService.setupTokenRefresh();
  firebaseService.setupFirebaseMessagingListeners();

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      theme: lightTheme,
      initialBinding: GlobalBinding(),
      themeMode: ThemeMode.dark,
      initialRoute: AppLinks.splashScreen, // ✅ Starts with SplashScreen
      getPages: AppRoutes.pages, // ✅ Includes routes for navigation
      defaultTransition: Transition.fadeIn,
    );
  }
}
