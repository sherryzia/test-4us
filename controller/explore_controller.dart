import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/controller/collection_controller.dart';
import 'package:restaurant_finder/controller/global_controller.dart';
import 'package:restaurant_finder/controller/saved_restaurants_controller.dart';
import 'package:restaurant_finder/model/explore_model.dart';
import 'package:restaurant_finder/view/screens/saved_restaurants/saved_restaurants.dart';
import 'package:restaurant_finder/view/widget/my_button_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';
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

  // Filter-related observables
  var minPrice = 50.0.obs;
  var maxPrice = 500.0.obs;
  var selectedCategories = <String>[].obs;
  var selectedRestaurantNames = <String>[].obs;
  var minDistance = 'Min Distance'.obs;
  var isFilterActive = false.obs;
  var availableCategories = <String>[].obs;

  // Search debounce timer
  Timer? _searchDebounce;
  var countries = <Map<String, dynamic>>[].obs;
  var selectedCountry = ''.obs;
  var noRestaurantsFound = false.obs;
  @override
  void onInit() {
    super.onInit();
    fetchCountries();
    fetchCategories();
    fetchData();
  }

  Future<void> fetchCountries() async {
    try {
      final response = await supabase
          .from('countries')
          .select('*, is_premium') // Include is_premium column
          .order('name');
      countries.value = List<Map<String, dynamic>>.from(response);

      if (countries.isNotEmpty && selectedCountry.isEmpty) {
        // Try to find Qatar first
        final qatarCountry = countries.firstWhere(
          (country) => country['name'].toString().toLowerCase() == 'qatar',
          orElse: () => <String, dynamic>{},
        );

        if (qatarCountry.isNotEmpty) {
          selectedCountry.value = qatarCountry['name'];
        } else {
          // Fallback to first country if Qatar is not found
          selectedCountry.value = countries.first['name'];
        }
      }
    } catch (e) {
      print('Error fetching countries: $e');
      Get.snackbar('Error', 'Failed to load countries');
    }
  }

  // Add this new method for handling country selection with premium check
  void handleCountrySelection(String countryName, bool isPremium) {
    if (isPremium && !globalController.isSubscribed.value) {
      // Show subscription message for premium countries
      Get.snackbar(
        'Premium Content',
        'Subscribe to view restaurants in $countryName',
        backgroundColor: Colors.orange.withOpacity(0.8),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
        icon: Icon(Icons.star, color: Colors.white),
      );
      return;
    }

    // If not premium or user is subscribed, proceed with normal country change
    changeCountry(countryName);
  }

  Future<void> fetchCategories() async {
    try {
      final response =
          await supabase.from('categories').select('name').order('name');

      final categories = response
          .map<String>((category) => category['name'] as String)
          .toList();
      availableCategories.assignAll(categories);
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  // Fetch all data needed for the explore screen
  // Replace your current fetchData method with this fixed version

  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      // Fetch profiles first
      await fetchTopProfiles();

      // Then fetch restaurants sequentially to ensure proper handling
      await fetchRecommendedRestaurants();
      await fetchTrendingRestaurants();
    } catch (e) {
      print("Error fetching explore data: $e");
      Get.snackbar('Error', 'Failed to load data. Please try again.');
    } finally {
      // Always ensure loading is set to false, even if there was an error
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

      final profiles =
          response.map((profile) => ProfileModel.fromJson(profile)).toList();
      topProfiles.assignAll(profiles);
    } catch (e) {
      print("Error fetching top profiles: $e");
    }
  }

  // Fetch recommended restaurants with favorite status
  Future<void> fetchRecommendedRestaurants() async {
    print(
        "Starting fetchRecommendedRestaurants for country: ${selectedCountry.value}");

    try {
      // Get user ID if authenticated
      final userId = globalController.isAuthenticated.value
          ? globalController.userId.value
          : null;

      // Start with base query

      var query = supabase
          .from('restaurants')
          .select('*, has_hours, hours') // Add hours fields
          .eq('is_recommended', true); // or is_trending for trending method

      // Apply country filter if selected
      if (selectedCountry.value.isNotEmpty) {
        // First get the country ID
        final countryResponse = await supabase
            .from('countries')
            .select('id')
            .eq('name', selectedCountry.value)
            .maybeSingle();

        if (countryResponse != null && countryResponse['id'] != null) {
          final countryId = countryResponse['id'];
          // Filter restaurants by country_id
          query = query.eq('country_id', countryId);
        }
      }

      // Execute the query with ordering
      final restaurantsResponse =
          await query.order('rating', ascending: false).limit(10);

      // Convert to models
      final restaurants = restaurantsResponse
          .map((restaurant) => RestaurantModel.fromJson(restaurant))
          .toList();

      // If authenticated, check favorites status
      if (userId != null) {
        // Get all user favorites in one query
        final favoritesResponse = await supabase
            .from('user_favorites')
            .select('restaurant_id')
            .eq('user_id', userId);

        // Create a set of favorited restaurant IDs for quick lookup
        final favoriteIds = favoritesResponse
            .map<String>((item) => item['restaurant_id'].toString())
            .toSet();

        // Mark restaurants as favorites if they're in the user's favorites
        final updatedRestaurants = restaurants.map((restaurant) {
          return restaurant.copyWith(
              isFavorite: favoriteIds.contains(restaurant.id));
        }).toList();

        recommendedRestaurants.assignAll(updatedRestaurants);
      } else {
        recommendedRestaurants.assignAll(restaurants);
      }

      print(
          "Successfully loaded ${restaurants.length} recommended restaurants for ${selectedCountry.value}");

      // Update noRestaurantsFound flag
      noRestaurantsFound.value = restaurants.isEmpty;
    } catch (e) {
      print("Error fetching recommended restaurants: $e");
      recommendedRestaurants.clear();
      noRestaurantsFound.value = true;
    }
  }

  void changeCountry(String country) {
    print("[changeCountry] Triggered for $country");

    if (selectedCountry.value != country) {
      selectedCountry.value = country;
      // Show loading indicator
      isLoading.value = true;

      // Use proper Promise chaining with error handling instead of Future.delayed
      fetchRecommendedRestaurants()
          .then((_) => fetchTrendingRestaurants())
          .catchError((error) {
        print("Error changing country: $error");
        Get.snackbar(
          'Error',
          'Failed to load restaurants for $country',
          backgroundColor: Colors.red.withOpacity(0.7),
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      }).whenComplete(() {
        // Always ensure loading indicator is hidden
        isLoading.value = false;
      });

      // Show feedback to user
      Get.snackbar(
        'Filtering',
        'Showing restaurants in $country',
        backgroundColor: kSecondaryColor.withOpacity(0.8),
        colorText: Colors.white,
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Fetch trending restaurants with favorite status
  Future<void> fetchTrendingRestaurants() async {
    print(
        "Starting fetchTrendingRestaurants for country: ${selectedCountry.value}");
    try {
      // Get user ID if authenticated
      final userId = globalController.isAuthenticated.value
          ? globalController.userId.value
          : null;

      // Start with base query
      var query = supabase.from('restaurants').select().eq('is_trending', true);

      // Apply country filter if selected
      if (selectedCountry.value.isNotEmpty) {
        // First get the country ID
        final countryResponse = await supabase
            .from('countries')
            .select('id')
            .eq('name', selectedCountry.value)
            .maybeSingle();

        if (countryResponse != null && countryResponse['id'] != null) {
          final countryId = countryResponse['id'];
          // Filter restaurants by country_id
          query = query.eq('country_id', countryId);
        }
      }

      // Execute the query with ordering
      final restaurantsResponse =
          await query.order('created_at', ascending: false).limit(10);

      // Convert to models
      final restaurants = restaurantsResponse
          .map((restaurant) => RestaurantModel.fromJson(restaurant))
          .toList();

      // If authenticated, check favorites status
      if (userId != null) {
        // Get all user favorites in one query
        final favoritesResponse = await supabase
            .from('user_favorites')
            .select('restaurant_id')
            .eq('user_id', userId);

        // Create a set of favorited restaurant IDs for quick lookup
        final favoriteIds = favoritesResponse
            .map<String>((item) => item['restaurant_id'].toString())
            .toSet();

        // Mark restaurants as favorites if they're in the user's favorites
        final updatedRestaurants = restaurants.map((restaurant) {
          return restaurant.copyWith(
              isFavorite: favoriteIds.contains(restaurant.id));
        }).toList();

        trendingRestaurants.assignAll(updatedRestaurants);
      } else {
        trendingRestaurants.assignAll(restaurants);
      }
      print(
          "Successfully loaded ${restaurants.length} trending restaurants for ${selectedCountry.value}");
    } catch (e) {
      print(
          "Error fetching trending restaurants for ${selectedCountry.value}: $e");
      trendingRestaurants.clear();
    } finally {
      // Important: Make sure to set isLoading to false here to handle errors
      // This ensures the loading indicator gets dismissed even if there's an error
      isLoading.value = false;
      print("Completed fetchTrendingRestaurants, isLoading set to false");
    }
  }

  // Search restaurants with debounce
  // Search restaurants with debounce
  void searchRestaurants(String query) {
    searchQuery.value = query;

    // Cancel any existing debounce timer
    _searchDebounce?.cancel();

    // Set a new debounce timer
    _searchDebounce = Timer(Duration(milliseconds: 500), () async {
      if (query.isEmpty && !isFilterActive.value) {
        // Reset to default data if query is empty and no filter is active
        await fetchData();
        return;
      }

      // If filters are active, use applyFilters method to handle both search and filters
      if (isFilterActive.value) {
        await applyFilters();
        return;
      }

      try {
        // Start loading
        isLoading.value = true;

        // Create a query for just search (no filters)
        var restaurantQuery = supabase
            .from('restaurants')
            .select()
            .ilike('name', '%$query%')
            .order('rating', ascending: false);

        // Execute the query
        final response = await restaurantQuery;

        // Process the results
        final restaurants = response
            .map((restaurant) => RestaurantModel.fromJson(restaurant))
            .toList();

        // Apply user favorites if authenticated
        final userId = globalController.isAuthenticated.value
            ? globalController.userId.value
            : null;

        if (userId != null) {
          final favoritesResponse = await supabase
              .from('user_favorites')
              .select('restaurant_id')
              .eq('user_id', userId);

          final favoriteIds = favoritesResponse
              .map<String>((item) => item['restaurant_id'].toString())
              .toSet();

          final updatedRestaurants = restaurants.map((restaurant) {
            return restaurant.copyWith(
                isFavorite: favoriteIds.contains(restaurant.id));
          }).toList();

          // Update lists
          recommendedRestaurants.value =
              updatedRestaurants.where((r) => r.isRecommended).toList();
          trendingRestaurants.value =
              updatedRestaurants.where((r) => r.isTrending).toList();
        } else {
          // Update lists without favorite status
          recommendedRestaurants.value =
              restaurants.where((r) => r.isRecommended).toList();
          trendingRestaurants.value =
              restaurants.where((r) => r.isTrending).toList();
        }
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
        Get.snackbar(
            'Authentication Required', 'Please login to add favorites');
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
        // Show bottom sheet with collections
        _showCollectionsBottomSheet(restaurantId);
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

  // Show collections bottom sheet
  void _showCollectionsBottomSheet(String restaurantId) {
    final savedController = Get.find<SavedRestaurantsController>();
    final RxBool isLoading = false.obs;

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                  text: 'Save to Collection',
                  size: 18,
                  weight: FontWeight.w600,
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            SizedBox(height: 16),

            /// Save to general favorites
            GestureDetector(
              onTap: () async {
                isLoading.value = true;
                try {
                  await supabase.from('user_favorites').insert({
                    'user_id': globalController.userId.value,
                    'restaurant_id': restaurantId,
                  });

                  updateRestaurantFavoriteStatus(restaurantId, true);
                  Get.back();
                  Get.snackbar('Success', 'Added to favorites');
                } catch (e) {
                  print("Error adding to favorites: $e");
                  Get.snackbar('Error', 'Failed to add to favorites');
                } finally {
                  isLoading.value = false;
                }
              },
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: kBorderColor),
                ),
                child: Row(
                  children: [
                    Icon(Icons.favorite, color: kSecondaryColor),
                    SizedBox(width: 12),
                    MyText(
                      text: 'Save to Favorites',
                      size: 16,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),
            MyText(
              text: 'Or save to collection:',
              size: 16,
              weight: FontWeight.w500,
            ),
            SizedBox(height: 12),

            // Collections list with proper Obx usage
            Obx(() {
              if (savedController.collections.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: MyText(
                      text: 'No collections yet',
                      size: 14,
                      color: kGreyColor,
                    ),
                  ),
                );
              }

              return Container(
                constraints: BoxConstraints(maxHeight: Get.height * 0.3),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: savedController.collections.length,
                  itemBuilder: (context, index) {
                    final collection = savedController.collections[index];
                    return GestureDetector(
                      onTap: () async {
                        isLoading.value = true;
                        try {
                          final collectionController = Get.put(
                            CollectionController(collection.id),
                            tag: collection.id,
                          );

                          await supabase.from('user_favorites').insert({
                            'user_id': globalController.userId.value,
                            'restaurant_id': restaurantId,
                          }).onError((error, stackTrace) => null);

                          await collectionController
                              .addToCollection(restaurantId);

                          updateRestaurantFavoriteStatus(restaurantId, true);
                          Get.back();
                          Get.snackbar('Success', 'Added to collection');
                        } catch (e) {
                          print("Error adding to collection: $e");
                          Get.snackbar('Error', 'Failed to add to collection');
                        } finally {
                          isLoading.value = false;
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 8),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: kBorderColor),
                        ),
                        child: MyText(
                          text: collection.name,
                          size: 14,
                          weight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
              );
            }),

            // Loading indicator with separate Obx
            Obx(() => isLoading.value
                ? Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        CircularProgressIndicator(color: kSecondaryColor),
                        SizedBox(height: 16),
                        MyText(
                          text: 'Please wait...',
                          size: 16,
                          weight: FontWeight.w500,
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink()),

            SizedBox(height: 20),

            /// Create new collection
            MyButton(
              buttonText: 'Create New Collection',
              onTap: () {
                Get.back();
                Get.dialog(EnterCollectionNameDialog(
                  controller: savedController,
                  onCollectionCreated: (CollectionModel newCollection) {
                    Get.put(
                      CollectionController(newCollection.id),
                      tag: newCollection.id,
                    ).addToCollection(restaurantId);
                    updateRestaurantFavoriteStatus(restaurantId, true);
                  },
                ));
              },
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
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

  // Update price range values
  void updatePriceRange(dynamic lowerValue, dynamic upperValue) {
    minPrice.value = lowerValue;
    maxPrice.value = upperValue;
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
  void toggleRestaurantName(String restaurantName) {
    if (selectedRestaurantNames.contains(restaurantName)) {
      selectedRestaurantNames.remove(restaurantName);
    } else {
      selectedRestaurantNames.add(restaurantName);
    }
  }

  // Apply all filters and search
// Apply all filters and run search
  Future<void> applyFilters() async {
    isLoading.value = true;
    isFilterActive.value = true;

    try {
      // First, get restaurant IDs that have menu items in the specified price range
      final menuItemsResponse = await supabase
          .from('menu_items')
          .select('restaurant_id')
          .gte('price', minPrice.value)
          .lte('price', maxPrice.value)
          .limit(100);

      // Extract unique restaurant IDs
      final List<String> restaurantIds = menuItemsResponse
          .map<String>((item) => item['restaurant_id'] as String)
          .toSet() // Remove duplicates
          .toList();

      // If no restaurants match the menu item price range, show empty results
      if (restaurantIds.isEmpty && minPrice.value != 50.0) {
        recommendedRestaurants.clear();
        trendingRestaurants.clear();
        Get.back(); // Close the filter sheet
        Get.snackbar('No Results',
            'No restaurants found with items in this price range');
        isLoading.value = false;
        return;
      }

      // Start building the query
var query = supabase.from('restaurants').select('*, has_hours, hours');

      // Apply price filter if we found matching restaurants
      if (restaurantIds.isNotEmpty && minPrice.value != 50.0) {
        query = query.inFilter('id', restaurantIds);
      }

      // Apply search query if present
      if (searchQuery.value.isNotEmpty) {
        query = query.ilike('name', '%${searchQuery.value}%');
      }
      if (selectedCountry.value.isNotEmpty) {
        // First get the country ID
        final countryResponse = await supabase
            .from('countries')
            .select('id')
            .eq('name', selectedCountry.value)
            .maybeSingle();

        if (countryResponse != null && countryResponse['id'] != null) {
          final countryId = countryResponse['id'];
          // Filter restaurants by country_id
          query = query.eq('country_id', countryId);
        }
      }

      // Apply category filter if selected
      if (selectedCategories.isNotEmpty) {
        // Get restaurants that have the selected categories
        final categoryResponse = await supabase
            .from('restaurant_categories')
            .select('restaurant_id, categories:category_id(name)');

        // Filter restaurant IDs that match the selected categories
        final List<String> categoryFilteredIds = [];

        for (final record in categoryResponse) {
          final categoryName = record['categories']['name'] as String;
          final restaurantId = record['restaurant_id'] as String;

          if (selectedCategories.contains(categoryName) &&
              !categoryFilteredIds.contains(restaurantId)) {
            categoryFilteredIds.add(restaurantId);
          }
        }

        // Apply category filter if we have results
        if (categoryFilteredIds.isNotEmpty) {
          query = query.inFilter('id', categoryFilteredIds);
        }
      }

      // Apply restaurant name filter if selected
      if (selectedRestaurantNames.isNotEmpty) {
        query = query.inFilter('name', selectedRestaurantNames.toList());
      }

      // Execute the query with ordering
      final response = await query.order('rating', ascending: false);

      // Process the results
      final List<RestaurantModel> filteredRestaurants = response
          .map((restaurant) => RestaurantModel.fromJson(restaurant))
          .toList();

      // Apply user favorites if authenticated
      final userId = globalController.isAuthenticated.value
          ? globalController.userId.value
          : null;

      if (userId != null) {
        final favoritesResponse = await supabase
            .from('user_favorites')
            .select('restaurant_id')
            .eq('user_id', userId);

        final favoriteIds = favoritesResponse
            .map<String>((item) => item['restaurant_id'].toString())
            .toSet();

        final updatedRestaurants = filteredRestaurants.map((restaurant) {
          return restaurant.copyWith(
              isFavorite: favoriteIds.contains(restaurant.id));
        }).toList();

        // Split into recommended and trending
        recommendedRestaurants.value =
            updatedRestaurants.where((r) => r.isRecommended).toList();
        trendingRestaurants.value =
            updatedRestaurants.where((r) => r.isTrending).toList();
      } else {
        // Split without favorites status
        recommendedRestaurants.value =
            filteredRestaurants.where((r) => r.isRecommended).toList();
        trendingRestaurants.value =
            filteredRestaurants.where((r) => r.isTrending).toList();
      }

      Get.back(); // Close the filter sheet
      if (filteredRestaurants.isEmpty) {
        Get.snackbar('No Results', 'No restaurants found with these filters');
      }
    } catch (e) {
      print("Error applying filters: $e");
      Get.snackbar('Error', 'Failed to apply filters');
    } finally {
      isLoading.value = false;
    }
  }

  // Reset all filters
  // Reset all filters
  void resetFilters() {
    minPrice.value = 50.0;
    maxPrice.value = 500.0;
    selectedCategories.clear();
    selectedRestaurantNames.clear();
    minDistance.value = 'Min Distance';

    // If filter was active, we need to refresh
    if (isFilterActive.value) {
      isFilterActive.value = false;

      // If there's a search query, run search without filters
      if (searchQuery.value.isNotEmpty) {
        searchRestaurants(searchQuery.value);
      } else {
        // Otherwise, load default data
        fetchData();
      }
    }

    // If we're in the filter sheet, close it
    if (Get.isBottomSheetOpen ?? false) {
      Get.back();
    }
  }

  @override
  void onClose() {
    // Cancel the timer when the controller is closed
    _searchDebounce?.cancel();
    super.onClose();
  }
}

// Add this extension to RestaurantModel to support copyWith
// Replace your current RestaurantModel.copyWith extension with this complete version

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
    double? latitude,
    double? longitude,
    int? priceRange,
    List<String>? categories,
    String? country,
    bool? hasHours, // Add this
    Map<String, dynamic>? hours, // Add this
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
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      priceRange: priceRange ?? this.priceRange,
      categories: categories ?? this.categories,
      country: country ?? this.country,
      hasHours: hasHours ?? this.hasHours, // Add this
      hours: hours ?? this.hours, // Add this
    );
  }
}
