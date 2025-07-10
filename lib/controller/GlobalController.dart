import 'dart:developer';

import 'package:get/get.dart';
import 'package:candid/utils/shared_preferences_util.dart';

class GlobalController extends GetxController {
  // Reactive properties for global state - updated to match API response
  RxString email = ''.obs;
  RxInt userId = 0.obs;
  RxString name = ''.obs;
  RxString phoneNumber = ''.obs;
  RxString profilePicture = ''.obs;
  RxBool isOnboarded = false.obs;
  RxString tagline = ''.obs;
  RxString bio = ''.obs;
  RxString dateOfBirth = ''.obs;
  RxString gender = ''.obs;
  RxString idealMatchGender = ''.obs;
  RxString relationshipExpectation = ''.obs;
  RxList interests = [].obs;
  RxList preferences = [].obs;
  RxString facebookHandle = ''.obs;
  RxString instagramHandle = ''.obs;
  RxString tikTokHandle = ''.obs;
  RxString location = ''.obs;
  RxDouble locationLatitude = 0.0.obs;
  RxDouble locationLongitude = 0.0.obs;
  RxList blockedUsers = [].obs;
  RxList crushed = [].obs;
  RxBool isActive = true.obs;
  RxString dateJoined = ''.obs;
  RxString lastLogin = ''.obs;
  RxString authToken = ''.obs;

  RxBool isPremium = true.obs; // New property for premium status

  // Reel categories data
  RxList<Map<String, dynamic>> reelCategories = <Map<String, dynamic>>[].obs;

  int profileCompletion(){
    int completedFields = 100;

    // Check each field and increment completedFields if not empty
    if (email.value.isEmpty) completedFields-=10;
    if (name.value.isEmpty) completedFields-=10;
    if (profilePicture.value.isEmpty) completedFields-=10;
    if (tagline.value.isEmpty) completedFields-=10;
    if (bio.value.isEmpty) completedFields-=10;
  return completedFields; 
  } 


  // Method to update reel categories
  void updateReelCategories(List<dynamic> categories) {
    try {
      reelCategories.clear();
      for (var category in categories) {
        if (category is Map<String, dynamic>) {
          reelCategories.add(category);
        }
      }
      print('Reel categories updated: ${reelCategories.length} categories loaded');
    } catch (e) {
      print('Error updating reel categories: $e');
    }
  }
  void updateFromResponse(Map<String, dynamic> response, {String userDataKey = "user", bool deleteToken = true}) {
    try {
      Map<String, dynamic> user;
      
      // Check if response has the userDataKey wrapper or is direct user data
      if (response.containsKey(userDataKey)) {
        user = response[userDataKey];
      } else {
        // Direct user data (like from /users/me/ endpoint)
        user = response;
      }
      
      if (user.isNotEmpty) {
        // Map API response fields to controller properties
        email.value = user['email']?.toString() ?? '';
        userId.value = user['id'] ?? 0;
        name.value = user['name']?.toString() ?? '';
        phoneNumber.value = user['phone_number']?.toString() ?? '';
        profilePicture.value = user['profile_picture']?.toString() ?? '';
        isOnboarded.value = user['is_onboarded'] ?? false;
        tagline.value = user['tagline']?.toString() ?? '';
        bio.value = user['bio']?.toString() ?? '';
        dateOfBirth.value = user['date_of_birth']?.toString() ?? '';
        gender.value = user['gender']?.toString() ?? '';
        idealMatchGender.value = user['ideal_match_gender']?.toString() ?? '';
        relationshipExpectation.value = user['relationship_expectation']?.toString() ?? '';
        
        // Handle list fields
        interests.value = user['interests'] ?? [];
        preferences.value = user['preferences'] ?? [];
        blockedUsers.value = user['blocked_users'] ?? [];
        crushed.value = user['crushed'] ?? [];
        
        // Social handles
        facebookHandle.value = user['facebook_handle']?.toString() ?? '';
        instagramHandle.value = user['instagram_handle']?.toString() ?? '';
        tikTokHandle.value = user['tik_tok_handle']?.toString() ?? '';
        
        // Location data
        location.value = user['location']?.toString() ?? '';
        locationLatitude.value = user['location_latitude']?.toDouble() ?? 0.0;
        locationLongitude.value = user['location_longitude']?.toDouble() ?? 0.0;
        
        // Status and timestamps
        isActive.value = user['is_active'] ?? true;
        dateJoined.value = user['date_joined']?.toString() ?? '';
        lastLogin.value = user['last_login']?.toString() ?? '';
      }
      
      // Handle token separately (for login responses)
      if (deleteToken && response.containsKey('token')) {
        authToken.value = response['token'] ?? '';
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update global state: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Method to clear all state values
  Future<void> clear({bool deleteToken = true}) async {
    email.value = '';
    userId.value = 0;
    name.value = '';
    phoneNumber.value = '';
    profilePicture.value = '';
    isOnboarded.value = false;
    tagline.value = '';
    bio.value = '';
    dateOfBirth.value = '';
    gender.value = '';
    idealMatchGender.value = '';
    relationshipExpectation.value = '';
    interests.clear();
    preferences.clear();
    facebookHandle.value = '';
    instagramHandle.value = '';
    tikTokHandle.value = '';
    location.value = '';
    locationLatitude.value = 0.0;
    locationLongitude.value = 0.0;
    blockedUsers.clear();
    crushed.clear();
    isActive.value = true;
    dateJoined.value = '';
    lastLogin.value = '';
    authToken.value = '';
    reelCategories.clear();

    // Clear from SharedPreferences
    await SharedPreferencesUtil.removeData('email');
    await SharedPreferencesUtil.removeData('userId');
    await SharedPreferencesUtil.removeData('name');
    await SharedPreferencesUtil.removeData('phoneNumber');
    await SharedPreferencesUtil.removeData('profilePicture');
    await SharedPreferencesUtil.removeData('isOnboarded');
    await SharedPreferencesUtil.removeData('tagline');
    await SharedPreferencesUtil.removeData('bio');
    await SharedPreferencesUtil.removeData('dateOfBirth');
    await SharedPreferencesUtil.removeData('gender');
    await SharedPreferencesUtil.removeData('idealMatchGender');
    await SharedPreferencesUtil.removeData('relationshipExpectation');
    await SharedPreferencesUtil.removeData('facebookHandle');
    await SharedPreferencesUtil.removeData('instagramHandle');
    await SharedPreferencesUtil.removeData('tikTokHandle');
    await SharedPreferencesUtil.removeData('location');
    await SharedPreferencesUtil.removeData('locationLatitude');
    await SharedPreferencesUtil.removeData('locationLongitude');
    await SharedPreferencesUtil.removeData('isActive');
    await SharedPreferencesUtil.removeData('dateJoined');
    await SharedPreferencesUtil.removeData('lastLogin');
    
    if (deleteToken) {
      await SharedPreferencesUtil.removeData("authToken");
    }
  }

  // Method to save global state to SharedPreferences
  Future<void> saveToSharedPreferences() async {
    try {
      await SharedPreferencesUtil.saveData<String>('email', email.value);
      await SharedPreferencesUtil.saveData<int>('userId', userId.value);
      await SharedPreferencesUtil.saveData<String>('name', name.value);
      await SharedPreferencesUtil.saveData<String>('phoneNumber', phoneNumber.value);
      await SharedPreferencesUtil.saveData<String>('profilePicture', profilePicture.value);
      await SharedPreferencesUtil.saveData<bool>('isOnboarded', isOnboarded.value);
      await SharedPreferencesUtil.saveData<String>('tagline', tagline.value);
      await SharedPreferencesUtil.saveData<String>('bio', bio.value);
      await SharedPreferencesUtil.saveData<String>('dateOfBirth', dateOfBirth.value);
      await SharedPreferencesUtil.saveData<String>('gender', gender.value);
      await SharedPreferencesUtil.saveData<String>('idealMatchGender', idealMatchGender.value);
      await SharedPreferencesUtil.saveData<String>('relationshipExpectation', relationshipExpectation.value);
      await SharedPreferencesUtil.saveData<String>('facebookHandle', facebookHandle.value);
      await SharedPreferencesUtil.saveData<String>('instagramHandle', instagramHandle.value);
      await SharedPreferencesUtil.saveData<String>('tikTokHandle', tikTokHandle.value);
      await SharedPreferencesUtil.saveData<String>('location', location.value);
      await SharedPreferencesUtil.saveData<double>('locationLatitude', locationLatitude.value);
      await SharedPreferencesUtil.saveData<double>('locationLongitude', locationLongitude.value);
      await SharedPreferencesUtil.saveData<bool>('isActive', isActive.value);
      await SharedPreferencesUtil.saveData<String>('dateJoined', dateJoined.value);
      await SharedPreferencesUtil.saveData<String>('lastLogin', lastLogin.value);
      await SharedPreferencesUtil.saveData<String>("authToken", authToken.value);
    } catch (e) {
      Get.snackbar('Error', 'Failed to save data to SharedPreferences: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Method to load data from SharedPreferences into global state
  Future<void> loadFromSharedPreferences() async {
    try {
      email.value = await SharedPreferencesUtil.getData<String>('email') ?? '';
      userId.value = await SharedPreferencesUtil.getData<int>('userId') ?? 0;
      name.value = await SharedPreferencesUtil.getData<String>('name') ?? '';
      phoneNumber.value = await SharedPreferencesUtil.getData<String>('phoneNumber') ?? '';
      profilePicture.value = await SharedPreferencesUtil.getData<String>('profilePicture') ?? '';
      isOnboarded.value = await SharedPreferencesUtil.getData<bool>('isOnboarded') ?? false;
      tagline.value = await SharedPreferencesUtil.getData<String>('tagline') ?? '';
      bio.value = await SharedPreferencesUtil.getData<String>('bio') ?? '';
      dateOfBirth.value = await SharedPreferencesUtil.getData<String>('dateOfBirth') ?? '';
      gender.value = await SharedPreferencesUtil.getData<String>('gender') ?? '';
      idealMatchGender.value = await SharedPreferencesUtil.getData<String>('idealMatchGender') ?? '';
      relationshipExpectation.value = await SharedPreferencesUtil.getData<String>('relationshipExpectation') ?? '';
      facebookHandle.value = await SharedPreferencesUtil.getData<String>('facebookHandle') ?? '';
      instagramHandle.value = await SharedPreferencesUtil.getData<String>('instagramHandle') ?? '';
      tikTokHandle.value = await SharedPreferencesUtil.getData<String>('tikTokHandle') ?? '';
      location.value = await SharedPreferencesUtil.getData<String>('location') ?? '';
      locationLatitude.value = await SharedPreferencesUtil.getData<double>('locationLatitude') ?? 0.0;
      locationLongitude.value = await SharedPreferencesUtil.getData<double>('locationLongitude') ?? 0.0;
      isActive.value = await SharedPreferencesUtil.getData<bool>('isActive') ?? true;
      dateJoined.value = await SharedPreferencesUtil.getData<String>('dateJoined') ?? '';
      lastLogin.value = await SharedPreferencesUtil.getData<String>('lastLogin') ?? '';
      authToken.value = await SharedPreferencesUtil.getData<String>("authToken") ?? '';
    } catch (e) {
      Get.snackbar('Error', 'Failed to load data from SharedPreferences: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Method to log all values for debugging
  void logValues() {
    log('GlobalController Values:');
    log('Email: ${email.value}');
    log('User ID: ${userId.value}');
    log('Name: ${name.value}');
    log('Phone Number: ${phoneNumber.value}');
    log('Profile Picture: ${profilePicture.value}');
    log('Is Onboarded: ${isOnboarded.value}');
    log('Tagline: ${tagline.value}');
    log('Bio: ${bio.value}');
    log('Date of Birth: ${dateOfBirth.value}');
    log('Gender: ${gender.value}');
    log('Ideal Match Gender: ${idealMatchGender.value}');
    log('Relationship Expectation: ${relationshipExpectation.value}');
    log('Interests: ${interests.value}');
    log('Preferences: ${preferences.value}');
    log('Facebook Handle: ${facebookHandle.value}');
    log('Instagram Handle: ${instagramHandle.value}');
    log('TikTok Handle: ${tikTokHandle.value}');
    log('Location: ${location.value}');
    log('Location Latitude: ${locationLatitude.value}');
    log('Location Longitude: ${locationLongitude.value}');
    log('Blocked Users: ${blockedUsers.value}');
    log('Crushed: ${crushed.value}');
    log('Is Active: ${isActive.value}');
    log('Date Joined: ${dateJoined.value}');
    log('Last Login: ${lastLogin.value}');
    log('Auth Token: ${authToken.value}');
    log('Reel Categories: ${reelCategories.length} categories loaded');
    log('Reel Categories: ${reelCategories.map((c) => c['name']).toList()}');
  }

  // Convenience getters for commonly used properties
  bool get hasCompletedOnboarding => isOnboarded.value;
  bool get hasName => name.value.isNotEmpty;
  bool get hasEmail => email.value.isNotEmpty;
  bool get hasProfilePicture => profilePicture.value.isNotEmpty;
  bool get isLoggedIn => authToken.value.isNotEmpty;
  
  // Convenience getters for reel categories
  List<Map<String, dynamic>> get getReelCategories => reelCategories.toList();
  bool get hasReelCategories => reelCategories.isNotEmpty;
  
  // Get specific reel category by ID
  Map<String, dynamic>? getReelCategoryById(int id) {
    try {
      return reelCategories.firstWhere((category) => category['id'] == id);
    } catch (e) {
      return null;
    }
  }
  
  // Get reel category names for dropdown/picker
  List<String> get getReelCategoryNames {
    return reelCategories.map((category) => category['name'].toString()).toList();
  }
}