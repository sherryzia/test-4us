// lib/controller/home_controller.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_images.dart';
import 'package:restaurant_finder/controller/global_controller.dart';
import 'package:restaurant_finder/model/explore_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  final GlobalController globalController = Get.find<GlobalController>();
  GoogleMapController? mapController;
  
  // Map and geo tracking
  var currentBounds = Rxn<LatLngBounds>();
  var lastFetchTime = Rxn<DateTime>();
  var totalRestaurantsCount = 0.obs;
  
  // Observables
  var isLoading = true.obs;
  var searchQuery = ''.obs;
  var nearbyRestaurants = <RestaurantModel>[].obs;
  var selectedRestaurant = Rxn<RestaurantModel>();
  var searchResults = <dynamic>[].obs;
  var isSearching = false.obs;
  var showSearchResults = false.obs;

  // Filter variables
  var minPrice = 50.0.obs;
  var maxPrice = 500.0.obs;
  var selectedCategories = <String>[].obs;
  var selectedRestaurantNames = <String>[].obs;
  var minDistance = 'Min Distance'.obs;
  var availableCategories = <String>[].obs;
  var minPriceFilter = 1.obs; // Corresponds to $ (cheap)
  var maxPriceFilter = 4.obs; // Corresponds to $$$$ (expensive)
  late BitmapDescriptor customMarker;
  var countries = <Map<String, dynamic>>[].obs;
  var selectedCountry = ''.obs;
  var noRestaurantsFound = false.obs;

  // Country coordinates mapping
  final Map<String, Map<String, double>> countryCoordinates = {
    'Qatar': {'lat': 25.3548, 'lng': 51.1839},
    'Saudi Arabia': {'lat': 23.8859, 'lng': 45.0792},
    'United Arab Emirates': {'lat': 23.4241, 'lng': 53.8478},
    'Kuwait': {'lat': 29.3117, 'lng': 47.4818},
    'Oman': {'lat': 21.4735, 'lng': 55.9754},
    'Bahrain': {'lat': 25.9304, 'lng': 50.6378},
    'Pakistan': {'lat': 30.3753, 'lng': 69.3451},
    'India': {'lat': 20.5937, 'lng': 78.9629},
    'Bangladesh': {'lat': 23.6850, 'lng': 90.3563},
    'Sri Lanka': {'lat': 7.8731, 'lng': 80.7718},
    'Nepal': {'lat': 28.3949, 'lng': 84.1240},
    'Egypt': {'lat': 26.8206, 'lng': 30.8025},
    'Turkey': {'lat': 38.9637, 'lng': 35.2433},
    'Iran': {'lat': 32.4279, 'lng': 53.6880},
    'Jordan': {'lat': 30.5852, 'lng': 36.2384},
    'Lebanon': {'lat': 33.8547, 'lng': 35.8623},
    'United States': {'lat': 37.0902, 'lng': -95.7129},
    'United Kingdom': {'lat': 55.3781, 'lng': -3.4360},
    'Canada': {'lat': 56.1304, 'lng': -106.3468},
    'Germany': {'lat': 51.1657, 'lng': 10.4515},
    'France': {'lat': 46.6034, 'lng': 1.8883},
    'Italy': {'lat': 41.8719, 'lng': 12.5674},
    'Spain': {'lat': 40.4637, 'lng': -3.7492},
    'Australia': {'lat': -25.2744, 'lng': 133.7751},
    'New Zealand': {'lat': -40.9006, 'lng': 174.8860},
    'Japan': {'lat': 36.2048, 'lng': 138.2529},
    'South Korea': {'lat': 35.9078, 'lng': 127.7669},
    'Malaysia': {'lat': 4.2105, 'lng': 101.9758},
    'Singapore': {'lat': 1.3521, 'lng': 103.8198},
    'Indonesia': {'lat': -0.7893, 'lng': 113.9213},
  };

  // Get center coordinates for selected country
  Map<String, double> getCountryCenter(String countryName) {
    return countryCoordinates[countryName] ?? {'lat': 25.3548, 'lng': 51.1839}; // Default to Qatar
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

  // Add method to handle country selection with premium check
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
      availableCategories.value =
          List<String>.from(response.map((c) => c['name']));
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    _loadCustomMarker();
    fetchCountries();
    fetchCategories();
    fetchNearbyRestaurants();
  }

  Future<void> _loadCustomMarker() async {
    customMarker = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(38, 38)),
      Assets.imagesRestaurantMarker,
    );
  }

  /// MAIN OPTIMIZED RESTAURANT FETCHING METHOD
  Future<void> fetchRestaurants({
    // Geographic parameters
    double? minLat,
    double? minLng, 
    double? maxLat,
    double? maxLng,
    double? centerLat,
    double? centerLng,
    double radiusKm = 30,
    
    // Filters
    bool applyFilters = true,
    String? searchTerm,
    
    // Pagination
    int pageSize = 50,
    int pageNumber = 1,
    String sortBy = 'rating', // 'rating', 'distance', 'name'
    
    // UI state
    bool showLoading = true,
  }) async {
    
    if (showLoading) isLoading.value = true;
    noRestaurantsFound.value = false;
    
    try {
      // Get country ID if selected
      String? countryId;
      if (selectedCountry.value.isNotEmpty) {
        final countryResponse = await supabase
            .from('countries')
            .select('id')
            .eq('name', selectedCountry.value)
            .maybeSingle();
        
        if (countryResponse != null) {
          countryId = countryResponse['id'];
        }
      }
      
      // If no center coordinates provided, use country center
      if (centerLat == null || centerLng == null) {
        final countryCenter = getCountryCenter(selectedCountry.value);
        centerLat = countryCenter['lat'];
        centerLng = countryCenter['lng'];
      }
      
      // Build parameters
      final params = <String, dynamic>{
        'page_size': pageSize,
        'page_number': pageNumber,
        'sort_by': sortBy,
      };
      
      // Add geographic parameters
      if (minLat != null && minLng != null && maxLat != null && maxLng != null) {
        params.addAll({
          'min_lat': minLat,
          'min_lng': minLng,
          'max_lat': maxLat,
          'max_lng': maxLng,
        });
      } else if (centerLat != null && centerLng != null) {
        params.addAll({
          'center_lat': centerLat,
          'center_lng': centerLng,
          'radius_km': radiusKm,
        });
      }
      
      // Add filters
      if (countryId != null) {
        params['country_id'] = countryId;
      }
      
      if (searchTerm != null && searchTerm.isNotEmpty) {
        params['search_text'] = searchTerm;
      }
      
      if (applyFilters) {
        if (minPriceFilter.value > 1) {
          params['min_price'] = minPriceFilter.value;
        }
        if (maxPriceFilter.value < 4) {
          params['max_price'] = maxPriceFilter.value;
        }
        if (selectedCategories.isNotEmpty) {
          params['category_names'] = selectedCategories.toList();
        }
      }
      
      print("Calling get_restaurants with params: $params");
      
      // Call the RPC function
      final response = await supabase.rpc('get_restaurants', params: params);
      
      print("Found ${response.length} restaurants");
      
      // Process results
      final List<RestaurantModel> restaurants = [];
      for (var restaurant in response) {
        try {
          restaurants.add(RestaurantModel.fromJson(restaurant));
          
          // Update total count from first record
          if (restaurants.length == 1 && restaurant['total_count'] != null) {
            totalRestaurantsCount.value = restaurant['total_count'];
          }
        } catch (e) {
          print("Error processing restaurant: $e");
        }
      }
      
      // Update UI state
      nearbyRestaurants.assignAll(restaurants);
      
      if (restaurants.isNotEmpty) {
        selectedRestaurant.value = restaurants[0];
        
        // Center map on first restaurant if this is initial load
        if (mapController != null && pageNumber == 1 && minLat == null) {
          mapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(restaurants[0].latitude!, restaurants[0].longitude!),
                zoom: 13.0,
              ),
            ),
          );
        }
      } else {
        selectedRestaurant.value = null;
        noRestaurantsFound.value = true;
        
        // Center map on country center if no restaurants found
        if (mapController != null && pageNumber == 1) {
          final countryCenter = getCountryCenter(selectedCountry.value);
          mapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(countryCenter['lat']!, countryCenter['lng']!),
                zoom: 6.0, // Country level view
              ),
            ),
          );
        }
      }
      
    } catch (e) {
      print("Error fetching restaurants: $e");
      Get.snackbar('Error', 'Failed to load restaurants');
      nearbyRestaurants.clear();
      selectedRestaurant.value = null;
      noRestaurantsFound.value = true;
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  // WRAPPER METHODS FOR DIFFERENT USE CASES
  
  // 1. Initial load (replaces your current fetchNearbyRestaurants)
  Future<void> fetchNearbyRestaurants() async {
    final countryCenter = getCountryCenter(selectedCountry.value);
    return fetchRestaurants(
      centerLat: countryCenter['lat'],
      centerLng: countryCenter['lng'],
      radiusKm: 100, // Larger radius for country-level search
      sortBy: 'rating',
    );
  }
  
  // 2. Map viewport change (fast, no loading indicator)
  Future<void> fetchRestaurantsInViewport() async {
    if (mapController == null) return;
    
    // Debounce frequent calls
    final now = DateTime.now();
    if (lastFetchTime.value != null && 
        now.difference(lastFetchTime.value!).inSeconds < 2) {
      return;
    }
    lastFetchTime.value = now;
    
    try {
      final bounds = await mapController!.getVisibleRegion();
      currentBounds.value = bounds;
      
      return fetchRestaurants(
        minLat: bounds.southwest.latitude,
        minLng: bounds.southwest.longitude,
        maxLat: bounds.northeast.latitude,
        maxLng: bounds.northeast.longitude,
        pageSize: 30, // Fewer for viewport
        showLoading: false, // No loading spinner for map movement
        applyFilters: false, // Skip filters for performance
      );
    } catch (e) {
      print("Error fetching viewport restaurants: $e");
    }
  }
  
  // 3. Search (replaces your searchRestaurants method)
  Future<void> searchRestaurants(String searchText) async {
    if (searchText.isEmpty) {
      searchResults.clear();
      showSearchResults.value = false;
      return;
    }
    
    searchQuery.value = searchText;
    isSearching.value = true;
    showSearchResults.value = true;
    
    try {
      final countryCenter = getCountryCenter(selectedCountry.value);
      await fetchRestaurants(
        searchTerm: searchText,
        centerLat: countryCenter['lat'],
        centerLng: countryCenter['lng'],
        radiusKm: 200, // Large radius for search
        pageSize: 20,
        sortBy: 'rating',
        showLoading: false,
      );
      
      // Convert to search results format
      searchResults.clear();
      final results = nearbyRestaurants.map((restaurant) => {
        'type': 'restaurant',
        'data': restaurant
      }).toList();
      searchResults.assignAll(results);
      
    } catch (e) {
      print("Error searching: $e");
      searchResults.clear();
    } finally {
      isSearching.value = false;
    }
  }
  
  // 4. Apply filters (replaces your applyFilters method)
  Future<void> applyFilters() async {
    try {
      final countryCenter = getCountryCenter(selectedCountry.value);
      await fetchRestaurants(
        centerLat: countryCenter['lat'],
        centerLng: countryCenter['lng'],
        radiusKm: 100,
        applyFilters: true,
        sortBy: 'rating',
      );
      
      Get.back(); // Close filter sheet
      Get.snackbar('Success', 'Filters applied');
    } catch (e) {
      print("Error applying filters: $e");
      Get.snackbar('Error', 'Failed to apply filters');
    }
  }
  
  // 5. Map camera idle callback
  void onCameraIdle() {
    fetchRestaurantsInViewport();
  }
  
  // 6. Map camera move callback
  void onCameraMove(CameraPosition position) {
    // Optionally update some state, but don't fetch here (too frequent)
  }
  
  // 7. Change country (updated to use country center)
  void changeCountry(String country) {
    if (selectedCountry.value != country) {
      selectedCountry.value = country;
      isLoading.value = true;
      
      // Get country center coordinates
      final countryCenter = getCountryCenter(country);
      
      // Move map to country center first
      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(countryCenter['lat']!, countryCenter['lng']!),
              zoom: 8.0, // Country level view
            ),
          ),
        );
      }
      
      // Fetch restaurants for new country
      Future.delayed(Duration(milliseconds: 500), () {
        fetchNearbyRestaurants();
      });
      
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

  // Select restaurant for marker
  void selectRestaurant(RestaurantModel restaurant) {
    selectedRestaurant.value = restaurant;
  }

  // Zoom to restaurant on map
  void zoomToRestaurant(RestaurantModel restaurant) {
    if (mapController != null &&
        restaurant.latitude != null &&
        restaurant.longitude != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(restaurant.latitude!, restaurant.longitude!),
            zoom: 16.0,
          ),
        ),
      );
    }
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
          latitude: restaurant.latitude,
          longitude: restaurant.longitude,
          priceRange: restaurant.priceRange,
          categories: restaurant.categories,
          country: restaurant.country,
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
        latitude: restaurant.latitude,
        longitude: restaurant.longitude,
        priceRange: restaurant.priceRange,
        categories: restaurant.categories,
        country: restaurant.country,
      );
    }
  }

  // Reset filters
  void resetFilters() {
    minPrice.value = 50.0;
    maxPrice.value = 500.0;
    selectedCategories.clear();
    selectedRestaurantNames.clear();
    minDistance.value = 'Min Distance';
    minPriceFilter.value = 1;
    maxPriceFilter.value = 4;
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