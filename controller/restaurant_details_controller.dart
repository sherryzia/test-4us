
// lib/controller/restaurant_details_controller.dart (Updated with better null safety)
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
    if (restaurantId != null && restaurantId!.isNotEmpty) {
      fetchRestaurantDetails(restaurantId!);
    } else {
      // Fallback to getting restaurantId from arguments
      final String? passedRestaurantId = Get.arguments?['restaurantId']?.toString();
      if (passedRestaurantId != null && passedRestaurantId.isNotEmpty) {
        fetchRestaurantDetails(passedRestaurantId);
      } else {
        isLoading.value = false;
        Get.snackbar('Error', 'Restaurant ID not provided');
        Get.back();
      }
    }
  }

  // Fetch restaurant details
  Future<void> fetchRestaurantDetails(String restaurantId) async {
    isLoading.value = true;
    try {
      // Fetch restaurant data
      final response = await supabase
          .from('restaurants')
          .select()
          .eq('id', restaurantId)
          .maybeSingle(); // Use maybeSingle instead of single
      
      if (response != null) {
        // Fetch categories for this restaurant
        List<String> categories = [];
        try {
          final categoriesResponse = await supabase
              .from('restaurant_categories')
              .select('category_id')
              .eq('restaurant_id', restaurantId);

          if (categoriesResponse != null && categoriesResponse.isNotEmpty) {
            for (var categoryItem in categoriesResponse) {
              if (categoryItem?['category_id'] != null) {
                final categoryResponse = await supabase
                    .from('categories')
                    .select('name')
                    .eq('id', categoryItem['category_id'])
                    .maybeSingle();

                if (categoryResponse?['name'] != null) {
                  categories.add(categoryResponse!['name'].toString());
                }
              }
            }
          }
        } catch (e) {
          print("Error fetching categories: $e");
        }
        
        // Add categories and country to response
        response['categories'] = categories;
        
        // Get country name
        if (response['country_id'] != null) {
          try {
            final countryResponse = await supabase
                .from('countries')
                .select('name')
                .eq('id', response['country_id'])
                .maybeSingle();

            if (countryResponse?['name'] != null) {
              response['country'] = countryResponse!['name'].toString();
            }
          } catch (e) {
            print("Error fetching country: $e");
          }
        }
        
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
      Get.back();
    } finally {
      isLoading.value = false;
    }
  }
  
  // Check if restaurant is in user's favorites
  Future<void> checkFavoriteStatus(String restaurantId) async {
    try {
      final userId = globalController.userId.value;
      
      if (userId.isEmpty) {
        isFavorite.value = false;
        return;
      }
      
      final existingFavorite = await supabase
          .from('user_favorites')
          .select()
          .eq('user_id', userId)
          .eq('restaurant_id', restaurantId)
          .maybeSingle();
      
      isFavorite.value = existingFavorite != null;
      
      // Update restaurant model with favorite status
      if (restaurant.value != null) {
        final currentRestaurant = restaurant.value!;
        restaurant.value = RestaurantModel(
  id: currentRestaurant.id,
  name: currentRestaurant.name,
  location: currentRestaurant.location,
  image: currentRestaurant.image,
  rating: currentRestaurant.rating,
  isFavorite: isFavorite.value,
  isRecommended: currentRestaurant.isRecommended,
  isTrending: currentRestaurant.isTrending,
  createdAt: currentRestaurant.createdAt,
  latitude: currentRestaurant.latitude,
  longitude: currentRestaurant.longitude,
  priceRange: currentRestaurant.priceRange,
  categories: currentRestaurant.categories,
  country: currentRestaurant.country,
  hasHours: currentRestaurant.hasHours,     // Add this
  hours: currentRestaurant.hours,           // Add this
);

      }
    } catch (e) {
      print("Error checking favorite status: $e");
      isFavorite.value = false;
    }
  }
  
  // Toggle favorite status
  Future<void> toggleFavorite() async {
    try {
      if (!globalController.isAuthenticated.value) {
        Get.snackbar('Authentication Required', 'Please login to add favorites');
        return;
      }
      
      if (restaurant.value == null) {
        Get.snackbar('Error', 'Restaurant data not available');
        return;
      }
      
      final userId = globalController.userId.value;
      final currentRestaurantId = restaurant.value!.id;
      
      if (userId.isEmpty || currentRestaurantId.isEmpty) {
        Get.snackbar('Error', 'Invalid user or restaurant data');
        return;
      }
      
      if (isFavorite.value) {
        // Remove from favorites
        await supabase
            .from('user_favorites')
            .delete()
            .eq('user_id', userId)
            .eq('restaurant_id', currentRestaurantId);
        
        isFavorite.value = false;
        Get.snackbar('Success', 'Removed from favorites');
      } else {
        // Add to favorites
        await supabase.from('user_favorites').insert({
          'user_id': userId,
          'restaurant_id': currentRestaurantId,
        });
        
        isFavorite.value = true;
        Get.snackbar('Success', 'Added to favorites');
      }
      
      // Update restaurant model
      if (restaurant.value != null) {
        final currentRestaurant = restaurant.value!;
        restaurant.value = RestaurantModel(
  id: currentRestaurant.id,
  name: currentRestaurant.name,
  location: currentRestaurant.location,
  image: currentRestaurant.image,
  rating: currentRestaurant.rating,
  isFavorite: isFavorite.value,
  isRecommended: currentRestaurant.isRecommended,
  isTrending: currentRestaurant.isTrending,
  createdAt: currentRestaurant.createdAt,
  latitude: currentRestaurant.latitude,
  longitude: currentRestaurant.longitude,
  priceRange: currentRestaurant.priceRange,
  categories: currentRestaurant.categories,
  country: currentRestaurant.country,
  hasHours: currentRestaurant.hasHours,     // Add this
  hours: currentRestaurant.hours,           // Add this
);

      }
    } catch (e) {
      print("Error toggling favorite: $e");
      Get.snackbar('Error', 'Failed to update favorite status');
    }
  }
}