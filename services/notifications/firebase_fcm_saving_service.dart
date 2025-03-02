import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:quran_app/services/notifications/local_notification_service.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

   Future<void> requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print("🔴 Notification permission denied.");
    } else {
      print("✅ Notification permission granted.");
    }
  }

  /// ✅ Save FCM Token
  Future<void> saveFcmToken() async {
    try {
      await requestPermission(); // Request permission before getting token
      String? token = await _firebaseMessaging.getToken();

      if (token != null) {
        print("✅ FCM Token: $token");
        // Store token in Firestore (if needed)
      } else {
        print("❌ Failed to get FCM Token.");
      }
    } catch (e) {
      print("❌ Error saving FCM token: $e");
    }
  }

  /// ✅ Auto-Update Token if it Changes
  void setupTokenRefresh() {
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      print("FCM Token refreshed: $newToken");
      await saveFcmToken();
    }).onError((err) {
      print("Error on token refresh: $err");
    });
  }



void setupFirebaseMessagingListeners() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("📩 Foreground Notification Received: ${message.notification?.title}");

    if (message.notification != null) {
      // Show local notification when the app is open
      LocalNotificationService.showNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000, // Unique ID
        title: message.notification!.title ?? "New Notification",
        body: message.notification!.body ?? "",
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("🔄 Opened App from Notification: ${message.notification?.title}");
  });

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      print("📥 App Launched from Notification: ${message.notification?.title}");
    }
  });
}

}


/*   Service With UserID

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveFcmToken(String userId, String token) async {
    try {
      // Store the token against the user's ID in Firestore
      await _firestore.collection('user_tokens').doc(userId).set({
        'fcm_token': token,
      });
      print("Token saved successfully for userId: $userId");
    } catch (e) {
      print("Error saving token to Firestore: $e");
      rethrow;
    }
  }

  Future<String?> getFcmTokenByUserId(String userId) async {
    try {
      // Fetch the FCM token by userId
      final DocumentSnapshot<Map<String, dynamic>> doc =
          await _firestore.collection('user_tokens').doc(userId).get();

      if (doc.exists && doc.data() != null) {
        return doc.data()!['fcm_token'];
      } else {
        print("No FCM token found for userId: $userId");
        return null;
      }
    } catch (e) {
      print("Error fetching FCM token for userId $userId: $e");
      return null;
    }
  }
}
*/