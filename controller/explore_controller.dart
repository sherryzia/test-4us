import 'dart:async';
import 'package:get/get.dart';
import 'package:restaurant_finder/controller/global_controller.dart';
import 'package:restaurant_finder/model/explore_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExploreController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  final GlobalController globalController = Get.find<GlobalController>();
  
  // Observables
  var isLoading = true.obs;
  var searchQuery = ''.obs;
  var topProfiles = <ProfileModel>[].obs;
  var recommendedRestaurants = <RestaurantModel>[].obs;
  var trendingRestaurants = <RestaurantModel>[].obs;
  
  // Search debounce timer
  Timer? _searchDebounce;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  // Fetch all data needed for the explore screen
  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      // Fetch data in parallel
      await Future.wait([
        fetchTopProfiles(),
        fetchRecommendedRestaurants(),
        fetchTrendingRestaurants(),
      ]);
    } catch (e) {
      print("Error fetching explore data: $e");
      Get.snackbar('Error', 'Failed to load data. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Fetch top profiles
  Future<void> fetchTopProfiles() async {
    try {
      final response = await supabase
          .from('profiles')
          .select()
          .order('followers_count', ascending: false)
          .limit(10);
      
      final profiles = response.map((profile) => ProfileModel.fromJson(profile)).toList();
      topProfiles.assignAll(profiles);
    } catch (e) {
      print("Error fetching top profiles: $e");
    }
  }
  
  // Fetch recommended restaurants
  Future<void> fetchRecommendedRestaurants() async {
    try {
      final response = await supabase
          .from('restaurants')
          .select()
          .eq('is_recommended', true)
          .order('rating', ascending: false)
          .limit(10);
      
      final restaurants = response.map((restaurant) => RestaurantModel.fromJson(restaurant)).toList();
      recommendedRestaurants.assignAll(restaurants);
    } catch (e) {
      print("Error fetching recommended restaurants: $e");
    }
  }
  
  // Fetch trending restaurants
  Future<void> fetchTrendingRestaurants() async {
    try {
      final response = await supabase
          .from('restaurants')
          .select()
          .eq('is_trending', true)
          .order('created_at', ascending: false)
          .limit(10);
      
      final restaurants = response.map((restaurant) => RestaurantModel.fromJson(restaurant)).toList();
      trendingRestaurants.assignAll(restaurants);
    } catch (e) {
      print("Error fetching trending restaurants: $e");
    }
  }
  
  // Search restaurants with debounce
  void searchRestaurants(String query) {
    // Cancel any existing debounce timer
    _searchDebounce?.cancel();

    // Set a new debounce timer
    _searchDebounce = Timer(Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        // Reset to default data if query is empty
        await fetchData();
        return;
      }

      try {
        // Start loading
        isLoading.value = true;

        final response = await supabase
            .from('restaurants')
            .select()
            .ilike('name', '%$query%')
            .order('rating', ascending: false);
        
        final restaurants = response.map((restaurant) => RestaurantModel.fromJson(restaurant)).toList();
        
        // Efficiently update lists without rebuilding entire UI
        recommendedRestaurants.value = restaurants.where((restaurant) => restaurant.isRecommended).toList();
        trendingRestaurants.value = restaurants.where((restaurant) => restaurant.isTrending).toList();
      } catch (e) {
        print("Error searching restaurants: $e");
        Get.snackbar('Error', 'Failed to search restaurants');
      } finally {
        // Stop loading
        isLoading.value = false;
      }
    });
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
    // Update in recommended list
    recommendedRestaurants.value = recommendedRestaurants.map((restaurant) {
      return restaurant.id == restaurantId 
        ? restaurant.copyWith(isFavorite: isFavorite)
        : restaurant;
    }).toList();
    
    // Update in trending list
    trendingRestaurants.value = trendingRestaurants.map((restaurant) {
      return restaurant.id == restaurantId 
        ? restaurant.copyWith(isFavorite: isFavorite)
        : restaurant;
    }).toList();
  }

  @override
  void onClose() {
    // Cancel the timer when the controller is closed
    _searchDebounce?.cancel();
    super.onClose();
  }
}

// Add this extension to RestaurantModel to support copyWith
extension RestaurantModelExtension on RestaurantModel {
  RestaurantModel copyWith({
    String? id,
    String? name,
    String? location,
    String? image,
    double? rating,
    bool? isFavorite,
    bool? isRecommended,
    bool? isTrending,
    DateTime? createdAt,
  }) {
    return RestaurantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
      isRecommended: isRecommended ?? this.isRecommended,
      isTrending: isTrending ?? this.isTrending,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}