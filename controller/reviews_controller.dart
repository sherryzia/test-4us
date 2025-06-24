
// lib/controller/reviews_controller.dart
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewsController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  final String restaurantId;
  
  bool isLoading = true;
  List<ReviewModel> reviews = [];
  
  ReviewsController(this.restaurantId);
  
  @override
  void onInit() {
    super.onInit();
    fetchReviews();
  }
  
  Future<void> fetchReviews() async {
    isLoading = true;
    update();
    
    try {
      // Fetch reviews first
      final response = await supabase
          .from('reviews')
          .select()
          .eq('restaurant_id', restaurantId)
          .order('created_at', ascending: false);
      
      // Add null check for response
      if (response == null || response.isEmpty) {
        reviews = [];
        return;
      }
      
      // Create a list to store our reviews
      List<ReviewModel> reviewsList = [];
      
      // Process each review
      for (var review in response) {
        if (review == null) continue; // Skip null reviews
        
        // Get the user_id from the review
        final userId = review['user_id']?.toString();
        
        // Default user data
        String userName = 'Unknown User';
        String userProfileImage = 'https://via.placeholder.com/150';
        
        // Try to fetch user data if we have a user_id
        if (userId != null && userId.isNotEmpty) {
          try {
            final userData = await supabase
                .from('users')
                .select('name')
                .eq('id', userId)
                .maybeSingle(); // Use maybeSingle instead of single
            
            if (userData != null && userData['name'] != null) {
              userName = userData['name'].toString();
            }
          } catch (userError) {
            print("Error fetching user data for user $userId: $userError");
          }
        }
        
        // Create ReviewModel with user data
        reviewsList.add(ReviewModel(
          id: review['id']?.toString() ?? '',
          restaurantId: review['restaurant_id']?.toString() ?? '',
          userId: userId ?? '',
          userName: userName,
          userProfileImage: userProfileImage,
          rating: _parseInt(review['rating']),
          comment: review['comment']?.toString() ?? '',
          createdAt: _parseDateTime(review['created_at']),
        ));
      }
      
      reviews = reviewsList;
    } catch (e) {
      print("Error fetching reviews: $e");
      reviews = []; // Ensure empty list on error
    } finally {
      isLoading = false;
      update();
    }
  }
  
  int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }
  
  DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }
}

// lib/model/review_model.dart
class ReviewModel {
  final String id;
  final String restaurantId;
  final String userId;
  final String userName;
  final String userProfileImage;
  final int rating;
  final String comment;
  final DateTime createdAt;
  
  ReviewModel({
    required this.id,
    required this.restaurantId,
    required this.userId,
    required this.userName,
    required this.userProfileImage,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
  
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id']?.toString() ?? '',
      restaurantId: json['restaurant_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      userName: json['user_name']?.toString() ?? 'Unknown User',
      userProfileImage: json['user_profile_image']?.toString() ?? 'https://via.placeholder.com/150',
      rating: _parseInt(json['rating']),
      comment: json['comment']?.toString() ?? '',
      createdAt: _parseDateTime(json['created_at']),
    );
  }
  
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }
  
  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurant_id': restaurantId,
      'user_id': userId,
      'user_name': userName,
      'user_profile_image': userProfileImage,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
    };
  }
}