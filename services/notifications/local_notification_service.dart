import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Create Android notification channel
  static Future<void> createAndroidNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // name
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Initialize local notifications
  static Future<void> initialize() async {
    // Create the notification channel for Android
    await createAndroidNotificationChannel();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@drawable/ic_notifications_icon');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings settings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _notificationsPlugin.initialize(settings,
        onDidReceiveNotificationResponse: (response) {
      // Handle notification tapped
      final payload = response.payload;
      if (payload != null) {
        print("Notification Payload: $payload");
      }
    });
  }

  /// Show an expandable local notification
  static Future<void> showExpandableNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    // Use BigTextStyleInformation for expandable content
    final BigTextStyleInformation bigTextStyle = BigTextStyleInformation(
      body,
      htmlFormatBigText: true,
      contentTitle: title,
      htmlFormatContentTitle: true,
    );

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel', // Use the created channel id
      'High Importance Notifications', // Channel name
      styleInformation: bigTextStyle, // Add expandable style
      priority: Priority.high,
      importance: Importance.max,
      enableLights: true,
      enableVibration: true,
      playSound: true,
    );

    final NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(id, title, body, platformDetails,
        payload: payload);
  }

  /// Show a basic local notification
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel', // Use the created channel id
      'High Importance Notifications', // Channel name
      priority: Priority.high,
      importance: Importance.max,
      enableLights: true,
      enableVibration: true,
      playSound: true,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(id, title, body, platformDetails,
        payload: payload);
  }
}
