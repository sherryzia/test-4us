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
      // Fetch reviews with user details using a join
      final response = await supabase
          .from('reviews')
          .select('''
            *,
            profiles:user_id (
              name,
              profile_image
            )
          ''')
          .eq('restaurant_id', restaurantId)
          .order('created_at', ascending: false);
      
      reviews = response.map<ReviewModel>((review) {
        // Extract profile data from the joined result
        final profileData = review['profiles'] ?? {};
        
        return ReviewModel(
          id: review['id'] ?? '',
          restaurantId: review['restaurant_id'] ?? '',
          userId: review['user_id'] ?? '',
          userName: profileData['name'] ?? 'Unknown User',
          userProfileImage: profileData['profile_image'] ?? '',
          rating: review['rating'] ?? 0,
          comment: review['comment'] ?? '',
          createdAt: review['created_at'] != null 
              ? DateTime.parse(review['created_at']) 
              : DateTime.now(),
        );
      }).toList();
    } catch (e) {
      print("Error fetching reviews: $e");
    } finally {
      isLoading = false;
      update();
    }
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
}
