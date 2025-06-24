import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/model/user_model.dart';
import 'package:restaurant_finder/model/session_model.dart';
import 'package:restaurant_finder/controller/global_controller.dart';
import 'package:restaurant_finder/services/supabase_service.dart';
import 'package:restaurant_finder/view/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:restaurant_finder/view/screens/launch/on_boarding.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SessionChecker extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  final GlobalController globalController = Get.find<GlobalController>();
  final SupabaseService _supabaseService = SupabaseService();

  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Future<void> _initializeFirebaseMessaging(String userId) async {
  //   // Get FCM token
  //   print("FCM token pushed to Supabase from login");
  //   final fcmToken = await _firebaseMessaging.getToken();
  //   if (fcmToken != null) {
  //     print("FCM Token: $fcmToken");
  //     userId = await _supabaseService.saveFcmToken(fcmToken, userId);
  //   }
  // }

  Future<void> checkSession() async {
    try {
      // Get current session
      final Session? session = supabase.auth.currentSession;

      print("Session check - Session exists: ${session != null}");

      if (session != null) {
        // Session exists, load user data
        final userId = session.user.id;
        print("User ID from session: $userId");

        try {
          final userData =
              await supabase.from('users').select().eq('id', userId).single();

          print("User data retrieved: ${userData != null}");

          if (userData != null) {
            // Create user model from data
            final user = UserModel.fromJson(userData);
            print("User model created: ${user.email}");

            // Create session model from supabase session
            final sessionModel = SessionModel(
              sessionId: session.user.id,
              accessToken: session.accessToken,
              refreshToken: session.refreshToken,
              expiresAt: session.expiresAt != null
                  ? DateTime.fromMillisecondsSinceEpoch(
                      session.expiresAt! * 1000)
                  : null,
              user: user,
            );

            // Check if session is valid
            if (sessionModel.isValid) {
              // Update global controller with user data
              await globalController.checkAndLoadSession();
              // _initializeFirebaseMessaging(userId);
              // Navigate to bottom nav bar
              Get.off(() => BottomNavBar());
              return;
            } else {
              print("Session is no longer valid");
              globalController.clearUserData();
            }
          }
        } catch (userDataError) {
          print("Error fetching user data: $userDataError");
          // Continue to OnBoarding in case of user data error
        }
      } else {
        // Clear global controller if no session exists
        globalController.clearUserData();
      }

      // If we reach here, either no session, no user data, or an error occurred
      print("Redirecting to OnBoarding");
      Get.off(() => OnBoarding());
    } catch (e) {
      print("Session check error: $e");
      // Error handling, go to onboarding
      globalController.clearUserData();
      Get.off(() => OnBoarding());
    }
  }
}
