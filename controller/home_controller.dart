// lib/controller/home_controller.dart
import 'package:get/get.dart';
import 'package:restaurant_finder/controller/global_controller.dart';
import 'package:restaurant_finder/model/explore_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  final GlobalController globalController = Get.find<GlobalController>();
  
  // Observables
  var isLoading = true.obs;
  var searchQuery = ''.obs;
  var nearbyRestaurants = <RestaurantModel>[].obs;
  var selectedRestaurant = Rxn<RestaurantModel>();
  
  // Filter variables
  var minPrice = 50.0.obs;
  var maxPrice = 500.0.obs;
  var selectedCategories = <String>[].obs;
  var selectedRestaurantNames = <String>[].obs;
  var minDistance = 'Min Distance'.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchNearbyRestaurants();
  }
  
  // Fetch nearby restaurants
  Future<void> fetchNearbyRestaurants() async {
    isLoading.value = true;
    try {
      final response = await supabase
          .from('restaurants')
          .select()
          .order('rating', ascending: false)
          .limit(10);
      
      final restaurants = response.map((restaurant) => RestaurantModel.fromJson(restaurant)).toList();
      nearbyRestaurants.assignAll(restaurants);
      
      // Set a default selected restaurant for the map marker
      if (nearbyRestaurants.isNotEmpty) {
        selectedRestaurant.value = nearbyRestaurants[0];
      }
    } catch (e) {
      print("Error fetching nearby restaurants: $e");
      Get.snackbar('Error', 'Failed to load nearby restaurants');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Search restaurants
  Future<void> searchRestaurants(String query) async {
    if (query.isEmpty) {
      // Reset to default data if query is empty
      await fetchNearbyRestaurants();
      return;
    }
    
    searchQuery.value = query;
    isLoading.value = true;
    
    try {
      final response = await supabase
          .from('restaurants')
          .select()
          .ilike('name', '%$query%')
          .order('rating', ascending: false);
      
      final restaurants = response.map((restaurant) => RestaurantModel.fromJson(restaurant)).toList();
      nearbyRestaurants.assignAll(restaurants);
    } catch (e) {
      print("Error searching restaurants: $e");
      Get.snackbar('Error', 'Failed to search restaurants');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Select restaurant for marker
  void selectRestaurant(RestaurantModel restaurant) {
    selectedRestaurant.value = restaurant;
  }
  
  // Toggle favorite status for a restaurant
  Future<void> toggleFavorite(String restaurantId) async {
    try {
      if (!globalController.isAuthenticated.value) {
        Get.snackbar('Authentication Required', 'Please login to add favorites');
        return;
      }
      
      final userId = globalController.userId.value;
      
      // Check if already favorited
      final existingFavorite = await supabase
          .from('user_favorites')
          .select()
          .eq('user_id', userId)
          .eq('restaurant_id', restaurantId)
          .maybeSingle();
      
      if (existingFavorite == null) {
        // Add to favorites
        await supabase.from('user_favorites').insert({
          'user_id': userId,
          'restaurant_id': restaurantId,
        });
        
        // Update local state
        updateRestaurantFavoriteStatus(restaurantId, true);
        Get.snackbar('Success', 'Added to favorites');
      } else {
        // Remove from favorites
        await supabase
            .from('user_favorites')
            .delete()
            .eq('user_id', userId)
            .eq('restaurant_id', restaurantId);
        
        // Update local state
        updateRestaurantFavoriteStatus(restaurantId, false);
        Get.snackbar('Success', 'Removed from favorites');
      }
    } catch (e) {
      print("Error toggling favorite: $e");
      Get.snackbar('Error', 'Failed to update favorite status');
    }
  }
  
  // Update restaurant favorite status in local lists
  void updateRestaurantFavoriteStatus(String restaurantId, bool isFavorite) {
    // Update in nearby restaurants list
    for (int i = 0; i < nearbyRestaurants.length; i++) {
      if (nearbyRestaurants[i].id == restaurantId) {
        final restaurant = nearbyRestaurants[i];
        nearbyRestaurants[i] = RestaurantModel(
          id: restaurant.id,
          name: restaurant.name,
          location: restaurant.location,
          image: restaurant.image,
          rating: restaurant.rating,
          isFavorite: isFavorite,
          isRecommended: restaurant.isRecommended,
          isTrending: restaurant.isTrending,
          createdAt: restaurant.createdAt,
        );
        break;
      }
    }
    
    // Update selected restaurant if it matches
    if (selectedRestaurant.value?.id == restaurantId) {
      final restaurant = selectedRestaurant.value!;
      selectedRestaurant.value = RestaurantModel(
        id: restaurant.id,
        name: restaurant.name,
        location: restaurant.location,
        image: restaurant.image,
        rating: restaurant.rating,
        isFavorite: isFavorite,
        isRecommended: restaurant.isRecommended,
        isTrending: restaurant.isTrending,
        createdAt: restaurant.createdAt,
      );
    }
  }
  
  // Apply filters
  Future<void> applyFilters() async {
    isLoading.value = true;
    
    try {
      var query = supabase
          .from('restaurants')
          .select();
      
      // Apply category filter if selected
      if (selectedCategories.isNotEmpty) {
        // Assuming you have a 'category' column or a related table
        // This is a simplified example - you might need to adapt based on your schema
        query = query.filter('category', 'in', '(${selectedCategories.join(",")})');
      }
      
      // Apply restaurant name filter if selected
      if (selectedRestaurantNames.isNotEmpty) {
        query = query.filter('name', 'in', '(${selectedRestaurantNames.join(",")})');
      }
      
      // Execute query
      final response = await query.order('rating', ascending: false);
      
      // Process results
      final restaurants = response.map((restaurant) => RestaurantModel.fromJson(restaurant)).toList();
      
      // Post-processing filters (for price range, etc.)
      // This assumes you have price data in your model
      // You may need to adapt this based on your specific schema
      
      nearbyRestaurants.assignAll(restaurants);
      
      Get.back(); // Close filter sheet
      Get.snackbar('Success', 'Filters applied');
    } catch (e) {
      print("Error applying filters: $e");
      Get.snackbar('Error', 'Failed to apply filters');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Reset filters
  void resetFilters() {
    minPrice.value = 50.0;
    maxPrice.value = 500.0;
    selectedCategories.clear();
    selectedRestaurantNames.clear();
    minDistance.value = 'Min Distance';
  }
  
  // Update price range
  void updatePriceRange(double min, double max) {
    minPrice.value = min;
    maxPrice.value = max;
  }
  
  // Toggle category selection
  void toggleCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
  }
  
  // Toggle restaurant name selection
  void toggleRestaurantName(String name) {
    if (selectedRestaurantNames.contains(name)) {
      selectedRestaurantNames.remove(name);
    } else {
      selectedRestaurantNames.add(name);
    }
  }
}
