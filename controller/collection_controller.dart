// lib/controller/collection_controller.dart
import 'package:get/get.dart';
import 'package:restaurant_finder/controller/global_controller.dart';
import 'package:restaurant_finder/controller/saved_restaurants_controller.dart';
import 'package:restaurant_finder/model/explore_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CollectionController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  final GlobalController globalController = Get.find<GlobalController>();
  
  // Collection ID
  final String collectionId;
  
  // Observables
  var isLoading = true.obs;
  var collection = Rxn<CollectionModel>();
  var restaurants = <RestaurantModel>[].obs;
  
  CollectionController(this.collectionId);
  
  @override
  void onInit() {
    super.onInit();
    fetchCollectionDetails();
    fetchCollectionRestaurants();
  }
  
  // Fetch collection details
  Future<void> fetchCollectionDetails() async {
    isLoading.value = true;
    try {
      final response = await supabase
          .from('collections')
          .select()
          .eq('id', collectionId)
          .single();
      
      collection.value = CollectionModel.fromJson(response);
    } catch (e) {
      print("Error fetching collection details: $e");
      Get.snackbar('Error', 'Failed to load collection details');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Fetch restaurants in collection
  Future<void> fetchCollectionRestaurants() async {
    try {
      final response = await supabase
          .from('collection_restaurants')
          .select('''
            *,
            restaurants:restaurant_id (*)
          ''')
          .eq('collection_id', collectionId);
      
      final collectionRestaurants = response.map<RestaurantModel>((item) {
        final restaurantData = item['restaurants'] ?? {};
        
        // Create restaurant model and mark as saved
        RestaurantModel restaurant = RestaurantModel.fromJson(restaurantData);
        restaurant = RestaurantModel(
          id: restaurant.id,
          name: restaurant.name,
          location: restaurant.location,
          image: restaurant.image,
          rating: restaurant.rating,
          isFavorite: true,  // Since it's saved
          isRecommended: restaurant.isRecommended,
          isTrending: restaurant.isTrending,
          createdAt: restaurant.createdAt,
        );
        
        return restaurant;
      }).toList();
      
      restaurants.assignAll(collectionRestaurants);
    } catch (e) {
      print("Error fetching collection restaurants: $e");
      Get.snackbar('Error', 'Failed to load restaurants in this collection');
    }
  }
  
  // Remove restaurant from collection
  Future<void> removeFromCollection(String restaurantId) async {
    try {
      await supabase
          .from('collection_restaurants')
          .delete()
          .eq('collection_id', collectionId)
          .eq('restaurant_id', restaurantId);
      
      // Remove from local list
      restaurants.removeWhere((restaurant) => restaurant.id == restaurantId);
      
      Get.snackbar('Success', 'Removed from collection');
    } catch (e) {
      print("Error removing from collection: $e");
      Get.snackbar('Error', 'Failed to remove from collection');
    }
  }
  
  // Add restaurant to collection
  Future<void> addToCollection(String restaurantId) async {
    try {
      // Check if already in collection
      final existing = await supabase
          .from('collection_restaurants')
          .select()
          .eq('collection_id', collectionId)
          .eq('restaurant_id', restaurantId)
          .maybeSingle();
      
      if (existing != null) {
        Get.snackbar('Info', 'Restaurant is already in this collection');
        return;
      }
      
      // Add to collection
      await supabase.from('collection_restaurants').insert({
        'collection_id': collectionId,
        'restaurant_id': restaurantId,
        'user_id': globalController.userId.value,
      });
      
      // Refresh collection
      await fetchCollectionRestaurants();
      
      Get.snackbar('Success', 'Added to collection');
    } catch (e) {
      print("Error adding to collection: $e");
      Get.snackbar('Error', 'Failed to add to collection');
    }
  }
  
  // Delete collection
  Future<void> deleteCollection() async {
    try {
      // Delete collection from database
      await supabase
          .from('collections')
          .delete()
          .eq('id', collectionId);
      
      Get.back();
      Get.snackbar('Success', 'Collection deleted');
    } catch (e) {
      print("Error deleting collection: $e");
      Get.snackbar('Error', 'Failed to delete collection');
    }
  }
}
