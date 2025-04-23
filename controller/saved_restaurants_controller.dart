// lib/controller/saved_restaurants_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/controller/global_controller.dart';
import 'package:restaurant_finder/model/explore_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SavedRestaurantsController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  final GlobalController globalController = Get.find<GlobalController>();
  
  // Observables
  var isLoading = true.obs;
  var savedRestaurants = <RestaurantModel>[].obs;
  var collections = <CollectionModel>[].obs;
  var collectionNameTextController = Rx<TextEditingController>(TextEditingController());
  
  @override
  void onInit() {
    super.onInit();
    fetchSavedRestaurants();
    fetchCollections();
  }
  
  @override
  void onClose() {
    collectionNameTextController.value.dispose();
    super.onClose();
  }
  
  // Fetch saved restaurants (favorites)
  Future<void> fetchSavedRestaurants() async {
    if (!globalController.isAuthenticated.value) {
      savedRestaurants.clear();
      isLoading.value = false;
      return;
    }
    
    isLoading.value = true;
    try {
      final userId = globalController.userId.value;
      
      // Fetch favorites with restaurant details using a join
      final response = await supabase
          .from('user_favorites')
          .select('''
            *,
            restaurants:restaurant_id (*)
          ''')
          .eq('user_id', userId);
      
      final restaurants = response.map<RestaurantModel>((item) {
        final restaurantData = item['restaurants'] ?? {};
        
        // Create restaurant model and mark as favorite
        RestaurantModel restaurant = RestaurantModel.fromJson(restaurantData);
        restaurant = RestaurantModel(
          id: restaurant.id,
          name: restaurant.name,
          location: restaurant.location,
          image: restaurant.image,
          rating: restaurant.rating,
          isFavorite: true,  // Since it's in favorites
          isRecommended: restaurant.isRecommended,
          isTrending: restaurant.isTrending,
          createdAt: restaurant.createdAt,
        );
        
        return restaurant;
      }).toList();
      
      savedRestaurants.assignAll(restaurants);
    } catch (e) {
      print("Error fetching saved restaurants: $e");
      Get.snackbar('Error', 'Failed to load saved restaurants');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Fetch user collections
  Future<void> fetchCollections() async {
    if (!globalController.isAuthenticated.value) {
      collections.clear();
      return;
    }
    
    try {
      final userId = globalController.userId.value;
      
      final response = await supabase
          .from('collections')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      
      final userCollections = response.map<CollectionModel>((collection) => 
          CollectionModel.fromJson(collection)).toList();
      
      collections.assignAll(userCollections);
    } catch (e) {
      print("Error fetching collections: $e");
      Get.snackbar('Error', 'Failed to load collections');
    }
  }
  
  // Create a new collection
  Future<void> createCollection(String name) async {
    if (!globalController.isAuthenticated.value) {
      Get.snackbar('Authentication Required', 'Please login to create collections');
      return;
    }
    
    if (name.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter a collection name');
      return;
    }
    
    try {
      final userId = globalController.userId.value;
      
      // Insert new collection
      final response = await supabase.from('collections').insert({
        'name': name.trim(),
        'user_id': userId,
      }).select().single();
      
      // Add to local list
      final newCollection = CollectionModel.fromJson(response);
      collections.add(newCollection);
      
      Get.back(); // Close dialog
      Get.snackbar('Success', 'Collection created');
      
      // Clear text field
      collectionNameTextController.value.clear();
    } catch (e) {
      print("Error creating collection: $e");
      Get.snackbar('Error', 'Failed to create collection');
    }
  }
  
  // Remove restaurant from favorites
  Future<void> removeFromFavorites(String restaurantId) async {
    if (!globalController.isAuthenticated.value) return;
    
    try {
      final userId = globalController.userId.value;
      
      // Delete from database
      await supabase
          .from('user_favorites')
          .delete()
          .eq('user_id', userId)
          .eq('restaurant_id', restaurantId);
      
      // Remove from local list
      savedRestaurants.removeWhere((restaurant) => restaurant.id == restaurantId);
      
      Get.snackbar('Success', 'Removed from saved restaurants');
    } catch (e) {
      print("Error removing from favorites: $e");
      Get.snackbar('Error', 'Failed to remove from saved restaurants');
    }
  }
}

// lib/model/collection_model.dart
class CollectionModel {
  final String id;
  final String userId;
  final String name;
  final DateTime createdAt;
  
  CollectionModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.createdAt,
  });
  
  factory CollectionModel.fromJson(Map<String, dynamic> json) {
    return CollectionModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      name: json['name'] ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
