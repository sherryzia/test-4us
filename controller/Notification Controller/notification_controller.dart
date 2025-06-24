// lib/controller/notification_controller.dart
import 'package:get/get.dart';
import 'package:restaurant_finder/controller/global_controller.dart';
import 'package:restaurant_finder/model/notification_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  final GlobalController globalController = Get.find<GlobalController>();
  
  var isLoading = true.obs;
  var notifications = <NotificationModel>[].obs;
  
  // Grouped notifications for UI
  var todayNotifications = <NotificationModel>[].obs;
  var yesterdayNotifications = <NotificationModel>[].obs;
  var earlierNotifications = <NotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    setupRealtimeListener();
  }

  // Fetch notifications from the database
  Future<void> fetchNotifications() async {
  
  isLoading.value = true;
  try {
    final userId = globalController.userId.value;
    print("Fetching notifications for user ID: $userId");
    
    final response = await supabase
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    
    print("Raw response from Supabase: $response");
    print("Response length: ${response.length}");
    
    final notificationsList = response
        .map((notification) => NotificationModel.fromJson(notification))
        .toList();
    
    print("Parsed notifications count: ${notificationsList.length}");
    
    // Update the notifications list
    notifications.assignAll(notificationsList);
    
    // Group notifications by date
    groupNotifications();
    
    print("Today notifications: ${todayNotifications.length}");
    print("Yesterday notifications: ${yesterdayNotifications.length}");
    print("Earlier notifications: ${earlierNotifications.length}");
  } catch (e) {
    print("Error fetching notifications: $e");
  } finally {
    isLoading.value = false;
  }
}

  // Save notification to database
  Future<void> saveNotification(String title, String body, String? imageUrl) async {
    try {
      if (!globalController.isAuthenticated.value) {
        return;
      }
      
      final userId = globalController.userId.value;
      
      await supabase.from('notifications').insert({
        'user_id': userId,
        'title': title,
        'body': body,
        'image_url': imageUrl,
      });
      
      // Notification will be added via the realtime listener
    } catch (e) {
      print("Error saving notification: $e");
    }
  }

  // Delete a notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await supabase
          .from('notifications')
          .delete()
          .eq('id', notificationId);
      
      // Update local state
      notifications.removeWhere((n) => n.id == notificationId);
      
      // Update grouped lists
      groupNotifications();
    } catch (e) {
      print("Error deleting notification: $e");
    }
  }

  // Group notifications by date (Today, Yesterday, Earlier)
  void groupNotifications() {
    final today = <NotificationModel>[];
    final yesterday = <NotificationModel>[];
    final earlier = <NotificationModel>[];
    
    for (final notification in notifications) {
      switch (notification.getDateGroup()) {
        case 'TODAY':
          today.add(notification);
          break;
        case 'YESTERDAY':
          yesterday.add(notification);
          break;
        case 'EARLIER':
          earlier.add(notification);
          break;
      }
    }
    
    todayNotifications.assignAll(today);
    yesterdayNotifications.assignAll(yesterday);
    earlierNotifications.assignAll(earlier);
  }

  // Setup realtime listener for new notifications
  // Setup realtime listener for new notifications
void setupRealtimeListener() {
  if (!globalController.isAuthenticated.value) {
    return;
  }
  
  final userId = globalController.userId.value;
  
  supabase
      .from('notifications')
      .stream(primaryKey: ['id'])
      .eq('user_id', userId)
      .listen((data) {
        // When we receive new data, refresh the notifications
        fetchNotifications();
      });
}
}