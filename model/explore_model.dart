// lib/model/profile_model.dart
import 'package:flutter/material.dart';
import 'dart:convert' as js;

class ProfileModel {
  final String id;
  final String name;
  final String profileImage;
  final DateTime createdAt;
  final int followersCount;

  ProfileModel({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.createdAt,
        required this.followersCount,

  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profile_image'] ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
                followersCount: json['followers_count'] ?? 0,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile_image': profileImage,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
// lib/model/explore_model.dart - Updated RestaurantModel
class RestaurantModel {
  final String id;
  final String name;
  final String location;
  final String image;
  final double rating;
  final bool isFavorite;
  final bool isRecommended;
  final bool isTrending;
  final DateTime createdAt;
  final double? latitude;
  final double? longitude;
  final int? priceRange;
  final List<String> categories;
  final String? country;
  final bool? hasHours;
  final Map<String, dynamic>? hours;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.location,
    required this.image,
    required this.rating,
    required this.isFavorite,
    required this.isRecommended,
    required this.isTrending,
    required this.createdAt,
    this.latitude,
    this.longitude,
    this.priceRange,
    this.categories = const [],
    this.country,
    this.hasHours,
    this.hours,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    // Handle categories properly based on the actual data type
    List<String> categoryList = [];
    if (json['categories'] != null) {
      if (json['categories'] is List) {
        categoryList = List<String>.from(json['categories']);
      } else if (json['categories'] is Map) {
        categoryList = [json['categories']['name']];
      }
    }

    // Parse hours if available
    Map<String, dynamic>? hoursData;
    if (json['hours'] != null) {
      if (json['hours'] is String) {
        try {
          hoursData = Map<String, dynamic>.from(
            js.json.decode(json['hours'])
          );
        } catch (e) {
          print("Error parsing hours JSON string: $e");
        }
      } else if (json['hours'] is Map) {
        hoursData = Map<String, dynamic>.from(json['hours']);
      }
    }
    
    return RestaurantModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      image: json['image'] ?? '',
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
      isFavorite: json['is_favorite'] ?? false,
      isRecommended: json['is_recommended'] ?? false,
      isTrending: json['is_trending'] ?? false,
      createdAt: json['created_at'] != null
          ? (json['created_at'] is String 
              ? DateTime.parse(json['created_at'])
              : DateTime.fromMillisecondsSinceEpoch(0))
          : DateTime.now(),
      latitude: json['latitude'] != null 
          ? double.tryParse(json['latitude'].toString()) 
          : null,
      longitude: json['longitude'] != null 
          ? double.tryParse(json['longitude'].toString()) 
          : null,
      priceRange: json['price_range'] != null
          ? int.tryParse(json['price_range'].toString())
          : null,
      categories: categoryList,
      country: json['country'],
      hasHours: json['has_hours'] ?? false,
      hours: hoursData,
    );
  }

  // Helper method to get current day's hours
  String getCurrentDayHours() {
    if (hasHours != true || hours == null) {
      return 'Hours not available';
    }

    final now = DateTime.now();
    final dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final currentDay = dayNames[now.weekday - 1];

    if (hours!.containsKey(currentDay)) {
      final dayHours = hours![currentDay];
      if (dayHours is List && dayHours.isNotEmpty) {
        return dayHours.first.toString();
      }
    }
    
    return 'Closed today';
  }

  // Helper method to check if restaurant is open now
  bool isOpenNow() {
    if (hasHours != true || hours == null) {
      return false;
    }

    final now = DateTime.now();
    final dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final currentDay = dayNames[now.weekday - 1];
    final currentTime = TimeOfDay.fromDateTime(now);

    if (hours!.containsKey(currentDay)) {
      final dayHours = hours![currentDay];
      if (dayHours is List && dayHours.isNotEmpty) {
        final hoursString = dayHours.first.toString();
        // Parse "9:00 AM - 10:00 PM" format
        final parts = hoursString.split(' - ');
        if (parts.length == 2) {
          try {
            final openTime = _parseTime(parts[0].trim());
            final closeTime = _parseTime(parts[1].trim());
            
            final currentMinutes = currentTime.hour * 60 + currentTime.minute;
            final openMinutes = openTime.hour * 60 + openTime.minute;
            final closeMinutes = closeTime.hour * 60 + closeTime.minute;
            
            if (closeMinutes > openMinutes) {
              // Same day (normal case)
              return currentMinutes >= openMinutes && currentMinutes <= closeMinutes;
            } else {
              // Crosses midnight
              return currentMinutes >= openMinutes || currentMinutes <= closeMinutes;
            }
          } catch (e) {
            print("Error parsing time: $e");
          }
        }
      }
    }
    
    return false;
  }

  TimeOfDay _parseTime(String timeString) {
    // Parse "9:00 AM" or "10:00 PM" format
    final parts = timeString.split(' ');
    final timePart = parts[0];
    final amPm = parts.length > 1 ? parts[1].toUpperCase() : 'AM';
    
    final timeParts = timePart.split(':');
    int hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    
    if (amPm == 'PM' && hour != 12) {
      hour += 12;
    } else if (amPm == 'AM' && hour == 12) {
      hour = 0;
    }
    
    return TimeOfDay(hour: hour, minute: minute);
  }
}
// lib/model/user_favorite_model.dart
class UserFavoriteModel {
  final String id;
  final String userId;
  final String restaurantId;
  final DateTime createdAt;

  UserFavoriteModel({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.createdAt,
  });

  factory UserFavoriteModel.fromJson(Map<String, dynamic> json) {
    return UserFavoriteModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      restaurantId: json['restaurant_id'] ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'restaurant_id': restaurantId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
