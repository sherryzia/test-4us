// lib/model/notification_model.dart

import 'package:intl/intl.dart';

class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String body;
  final String? imageUrl;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.imageUrl,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
  print("Parsing notification JSON: $json");
  return NotificationModel(
    id: json['id'] ?? '',
    userId: json['user_id'] ?? '',
    title: json['title'] ?? '',
    body: json['body'] ?? '',
    imageUrl: json['image_url'],
    createdAt: json['created_at'] != null 
        ? DateTime.parse(json['created_at']) 
        : DateTime.now(),
  );
}

  String getFormattedTime() {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else {
      return DateFormat('MMM dd, yyyy').format(createdAt);
    }
  }

  String getDateGroup() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final notificationDate = DateTime(
      createdAt.year, 
      createdAt.month, 
      createdAt.day
    );

    if (notificationDate == today) {
      return 'TODAY';
    } else if (notificationDate == yesterday) {
      return 'YESTERDAY';
    } else {
      return 'EARLIER';
    }
  }
}