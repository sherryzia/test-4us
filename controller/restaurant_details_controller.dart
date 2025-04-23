// lib/controller/restaurant_details_controller.dart
import 'package:get/get.dart';
import 'package:restaurant_finder/controller/global_controller.dart';
import 'package:restaurant_finder/model/explore_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RestaurantDetailsController extends GetxController {
  final String? restaurantId;
  final SupabaseClient supabase = Supabase.instance.client;
  final GlobalController globalController = Get.find<GlobalController>();
  
  // Observables
  var isLoading = true.obs;
  var restaurant = Rxn<RestaurantModel>();
  var isFavorite = false.obs;
  
  RestaurantDetailsController({this.restaurantId});
  
  @override
  void onInit() {
    super.onInit();
    // Use the restaurantId passed during initialization
    if (restaurantId != null) {
      fetchRestaurantDetails(restaurantId!);
    } else {
      // Fallback to getting restaurantId from arguments
      final String? passedRestaurantId = Get.arguments?['restaurantId'];
      if (passedRestaurantId != null) {
        fetchRestaurantDetails(passedRestaurantId);
      } else {
        Get.snackbar('Error', 'Restaurant not found');
        Get.back();
      }
    }
  }
  
  // Rest of the methods remain the same

  // Fetch restaurant details
  Future<void> fetchRestaurantDetails(String restaurantId) async {
    isLoading.value = true;
    try {
      // Fetch restaurant data
      final response = await supabase
          .from('restaurants')
          .select()
          .eq('id', restaurantId)
          .single();
      
      if (response != null) {
        restaurant.value = RestaurantModel.fromJson(response);
        
        // Check if restaurant is in user's favorites
        if (globalController.isAuthenticated.value) {
          await checkFavoriteStatus(restaurantId);
        }
      } else {
        Get.snackbar('Error', 'Restaurant not found');
        Get.back();
      }
    } catch (e) {
      print("Error fetching restaurant details: $e");
      Get.snackbar('Error', 'Failed to load restaurant details');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Check if restaurant is in user's favorites
  Future<void> checkFavoriteStatus(String restaurantId) async {
    try {
      final userId = globalController.userId.value;
      
      final existingFavorite = await supabase
          .from('user_favorites')
          .select()
          .eq('user_id', userId)
          .eq('restaurant_id', restaurantId)
          .maybeSingle();
      
      isFavorite.value = existingFavorite != null;
      
      // Update restaurant model with favorite status
      if (restaurant.value != null) {
        restaurant.value = RestaurantModel(
          id: restaurant.value!.id,
          name: restaurant.value!.name,
          location: restaurant.value!.location,
          image: restaurant.value!.image,
          rating: restaurant.value!.rating,
          isFavorite: isFavorite.value,
          isRecommended: restaurant.value!.isRecommended,
          isTrending: restaurant.value!.isTrending,
          createdAt: restaurant.value!.createdAt,
        );
      }
    } catch (e) {
      print("Error checking favorite status: $e");
    }
  }
  
  // Toggle favorite status
  Future<void> toggleFavorite() async {
    try {
      if (!globalController.isAuthenticated.value) {
        Get.snackbar('Authentication Required', 'Please login to add favorites');
        return;
      }
      
      if (restaurant.value == null) return;
      
      final userId = globalController.userId.value;
      final restaurantId = restaurant.value!.id;
      
      if (isFavorite.value) {
        // Remove from favorites
        await supabase
            .from('user_favorites')
            .delete()
            .eq('user_id', userId)
            .eq('restaurant_id', restaurantId);
        
        isFavorite.value = false;
        Get.snackbar('Success', 'Removed from favorites');
      } else {
        // Add to favorites
        await supabase.from('user_favorites').insert({
          'user_id': userId,
          'restaurant_id': restaurantId,
        });
        
        isFavorite.value = true;
        Get.snackbar('Success', 'Added to favorites');
      }
      
      // Update restaurant model
      if (restaurant.value != null) {
        restaurant.value = RestaurantModel(
          id: restaurant.value!.id,
          name: restaurant.value!.name,
          location: restaurant.value!.location,
          image: restaurant.value!.image,
          rating: restaurant.value!.rating,
          isFavorite: isFavorite.value,
          isRecommended: restaurant.value!.isRecommended,
          isTrending: restaurant.value!.isTrending,
          createdAt: restaurant.value!.createdAt,
        );
      }
    } catch (e) {
      print("Error toggling favorite: $e");
      Get.snackbar('Error', 'Failed to update favorite status');
    }
  }
}
