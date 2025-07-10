import 'dart:io';
import 'package:candid/controller/GlobalController.dart';
import 'package:candid/services/profile_service.dart';
import 'package:candid/view/screens/auth/sign_up/complete_profile/steps/birthday.dart';
import 'package:candid/view/screens/auth/sign_up/complete_profile/steps/email_address.dart';
import 'package:candid/view/screens/auth/sign_up/complete_profile/steps/gender.dart';
import 'package:candid/view/screens/auth/sign_up/complete_profile/steps/hoping_to_find.dart';
import 'package:candid/view/screens/auth/sign_up/complete_profile/steps/interest.dart';
import 'package:candid/view/screens/auth/sign_up/complete_profile/steps/looking_for.dart';
import 'package:candid/view/screens/auth/sign_up/complete_profile/steps/name.dart';
import 'package:candid/view/screens/auth/authentication_point.dart';
import 'package:candid/view/screens/auth/sign_up/complete_profile/steps/upload_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  static ProfileController instance = Get.find<ProfileController>();
  
  final ProfileService _profileService = ProfileService();
  final GlobalController globalController = Get.find<GlobalController>();

  RxInt currentStep = 0.obs;
  RxBool isLoading = false.obs;

  // Form data properties
  RxString name = ''.obs;
  RxString email = ''.obs;
  RxString dateOfBirth = ''.obs;
  RxString gender = ''.obs; // 'M', 'F', 'NB'
  RxString idealMatchGender = ''.obs; // 'M', 'F', 'NB'
  RxString relationshipExpectation = ''.obs; // 'REL', 'CAS', etc.
  RxList<int> interests = <int>[].obs;
  RxList<int> preferences = <int>[].obs;
  RxString tagline = ''.obs;
  RxString bio = ''.obs;
  // Profile image
  Rx<File?> profileImage = Rx<File?>(null);

  // Gender options for UI
  final List<String> genderOptions = ['Male', 'Female', 'Non-binary'];
  final List<String> relationshipOptions = [
    'Long-term relationship', 
    'Casual dating', 
    'Friendship', 
    'Not sure'
  ];
  
  // Current selected indices for UI
  RxInt selectedGenderIndex = 0.obs;
  RxInt selectedIdealMatchIndex = 0.obs;
  RxInt selectedRelationshipIndex = 0.obs;

  // Method to set gender from UI (with index)
  void setGenderByIndex(int index) {
    if (index >= 0 && index < genderOptions.length) {
      selectedGenderIndex.value = index;
      gender.value = genderMap[genderOptions[index]] ?? 'M';
      print('Gender set to: ${genderOptions[index]} -> ${gender.value}');
    }
  }

  // Method to set ideal match gender from UI (with index)
  void setIdealMatchGenderByIndex(int index) {
    if (index >= 0 && index < genderOptions.length) {
      selectedIdealMatchIndex.value = index;
      idealMatchGender.value = genderMap[genderOptions[index]] ?? 'M';
      print('Ideal match gender set to: ${genderOptions[index]} -> ${idealMatchGender.value}');
    }
  }

  // Method to set relationship expectation by index
  void setRelationshipExpectationByIndex(int index) {
    if (index >= 0 && index < relationshipOptions.length) {
      selectedRelationshipIndex.value = index;
      relationshipExpectation.value = relationshipMap[relationshipOptions[index]] ?? 'REL';
      print('Relationship expectation set to: ${relationshipOptions[index]} -> ${relationshipExpectation.value}');
    }
  }

  final List<Map<String, dynamic>> items = [
    {
      'title': 'What\'s your first name?',
      'subTitle': 'Choose wisely you won\'t get a redo',
    },
    {
      'title': 'Let\'s get Candid and show us that beautiful face',
      'subTitle':
          'Show off your true self! Whether you\'re hanging with your pet, munching on your favorite food, or chilling at a place you adore.',
    },
    {
      'title': 'When\'s your birthday? And no, you can\'t say you\'re timeless!',
      'subTitle': '',
    },
    {
      'title': '',
      'subTitle': '',
    },
    {
      'title': '',
      'subTitle': '',
    },
    {
      'title': 'What are you hoping to find?',
      'subTitle':
          'This helps us match you with people who align with what you\'re looking for in a potential partner.',
    },
    {
      'title': 'Your interests',
      'subTitle':
          'Explore your interests: From hobbies and passions to activities you love, share what excites you and connect with others who have similar interests.',
    },
    {
      'title': 'What is your email address?',
      'subTitle': 'This will be used to recover your account.',
    },
  ];

  final List<Widget> steps = [
    Name(),           // 0
    UploadProfileImage(), // 1
    Birthday(),       // 2
    Gender(),         // 3
    LookingFor(),     // 4
    HopingToFind(),   // 5
    Interest(),       // 6
    EmailAddress(),   // 7
    // RecordVideo() removed
  ];

  // Gender mapping for API
  Map<String, String> genderMap = {
    'Male': 'MA',
    'Female': 'FE',
    'Non-binary': 'NB',
  };

  // Relationship expectation mapping
  Map<String, String> relationshipMap = {
    'Long-term relationship': 'REL',
    'Casual dating': 'CAS',
    'Friendship': 'FRI',
    'Not sure': 'UNS',
  };

  void onNext() {
    if (currentStep.value == items.length - 1) {
      // Last step - complete profile
      completeProfile();
    } else {
      currentStep.value++;
    }
  }

  void onBack() {
    if (currentStep.value == 0) {
      Get.back();
    } else {
      currentStep.value--;
    }
  }

  // Method to set gender from UI
  void setGender(String genderName) {
    gender.value = genderMap[genderName] ?? 'M';
  }

  // Method to set ideal match gender from UI  
  void setIdealMatchGender(String genderName) {
    idealMatchGender.value = genderMap[genderName] ?? 'M';
  }

  // Method to set relationship expectation from UI
  void setRelationshipExpectation(String expectationName) {
    relationshipExpectation.value = relationshipMap[expectationName] ?? 'REL';
  }

  // Method to add/remove interests
  void toggleInterest(int interestId) {
    if (interests.contains(interestId)) {
      interests.remove(interestId);
    } else {
      interests.add(interestId);
    }
  }

  // Method to add/remove preferences
  void togglePreference(int preferenceId) {
    if (preferences.contains(preferenceId)) {
      preferences.remove(preferenceId);
    } else {
      preferences.add(preferenceId);
    }
  }

  // Method to set profile image
  void setProfileImage(File image) {
    profileImage.value = image;
  }

  // Method to validate current step
  bool validateCurrentStep() {
    // Debug current values
    debugCurrentStep();
    
    switch (currentStep.value) {
      case 0: // Name
        if (name.value.trim().isEmpty) {
          Get.snackbar('Error', 'Please enter your name',
              snackPosition: SnackPosition.BOTTOM);
          return false;
        }
        break;
      case 1: // Profile Image
        if (profileImage.value == null) {
          Get.snackbar('Error', 'Please select a profile image',
              snackPosition: SnackPosition.BOTTOM);
          return false;
        }
        break;
      case 2: // Birthday
        if (dateOfBirth.value.isEmpty) {
          Get.snackbar('Error', 'Please select your date of birth',
              snackPosition: SnackPosition.BOTTOM);
          return false;
        }
        break;
      case 3: // Gender
        if (gender.value.isEmpty) {
          Get.snackbar('Error', 'Please select your gender',
              snackPosition: SnackPosition.BOTTOM);
          return false;
        }
        break;
      case 4: // Looking For
        if (idealMatchGender.value.isEmpty) {
          Get.snackbar('Error', 'Please select your ideal match',
              snackPosition: SnackPosition.BOTTOM);
          return false;
        }
        break;
      case 5: // Hoping to Find
        if (relationshipExpectation.value.isEmpty) {
          Get.snackbar('Error', 'Please select what you\'re hoping to find',
              snackPosition: SnackPosition.BOTTOM);
          return false;
        }
        break;
      case 6: // Interests
        if (interests.isEmpty) {
          Get.snackbar('Error', 'Please select at least one interest',
              snackPosition: SnackPosition.BOTTOM);
          return false;
        }
        break;
      case 7: // Email
        if (email.value.trim().isEmpty || !email.value.contains('@')) {
          Get.snackbar('Error', 'Please enter a valid email address',
              snackPosition: SnackPosition.BOTTOM);
          return false;
        }
        break;
    }
    return true;
  }

  // Method to complete profile and submit to API
  Future<void> completeProfile() async {
    if (!validateCurrentStep()) return;

    isLoading.value = true;

    try {
      // Prepare the data for API
      Map<String, dynamic> profileData = {
        'name': name.value.trim(),
        'email': email.value.trim(),
        'date_of_birth': dateOfBirth.value,
        'gender': gender.value,
        'ideal_match_gender': idealMatchGender.value,
        'relationship_expectation': relationshipExpectation.value,
        'interests': interests.toList(),
        'preferences': preferences.toList(),
        'is_onboarded': true,
      };

      // Add optional fields if they exist
      if (tagline.value.isNotEmpty) {
        profileData['tagline'] = tagline.value;
      }
      if (bio.value.isNotEmpty) {
        profileData['bio'] = bio.value;
      }

      // Call API to update profile
      final response = await _profileService.updateProfile(
        profileData,
        profileImage.value,
      );

      if (response.statusCode == 200) {
        // Update GlobalController with new data
        if (response.data != null && response.data is Map) {
          globalController.updateFromResponse(response.data, deleteToken: false);
          await globalController.saveToSharedPreferences();
        }

        Get.snackbar(
          'Success',
          'Profile completed successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );

        // Navigate to main app through AuthenticationPoint
        Get.offAll(() => AuthenticationPoint());
      } else {
        String errorMessage = 'Failed to complete profile';
        if (response.data != null && response.data is Map) {
          errorMessage = response.data['message'] ?? 
                        response.data['error'] ?? 
                        response.data['detail'] ?? 
                        errorMessage;
        }
        
        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to complete profile: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Method to save progress (optional - for partial saves)
  Future<void> saveProgress() async {
    try {
      Map<String, dynamic> progressData = {};
      
      if (name.value.isNotEmpty) progressData['name'] = name.value;
      if (email.value.isNotEmpty) progressData['email'] = email.value;
      if (dateOfBirth.value.isNotEmpty) progressData['date_of_birth'] = dateOfBirth.value;
      if (gender.value.isNotEmpty) progressData['gender'] = gender.value;
      if (idealMatchGender.value.isNotEmpty) progressData['ideal_match_gender'] = idealMatchGender.value;
      if (relationshipExpectation.value.isNotEmpty) progressData['relationship_expectation'] = relationshipExpectation.value;
      if (interests.isNotEmpty) progressData['interests'] = interests.toList();
      if (preferences.isNotEmpty) progressData['preferences'] = preferences.toList();

      if (progressData.isNotEmpty) {
        await _profileService.updateProfile(progressData, null);
      }
    } catch (e) {
      // Silent fail for progress save
      print('Failed to save progress: $e');
    }
  }

  // Clear all data
  void clearData() {
    name.value = '';
    email.value = '';
    dateOfBirth.value = '';
    gender.value = '';
    idealMatchGender.value = '';
    relationshipExpectation.value = '';
    interests.clear();
    preferences.clear();
    tagline.value = '';
    bio.value = '';
    profileImage.value = null;
    currentStep.value = 0;
    selectedGenderIndex.value = 0;
    selectedIdealMatchIndex.value = 0;
    selectedRelationshipIndex.value = 0;
  }

  // Debug method to print all values
  void debugCurrentStep() {
    print('=== DEBUG PROFILE CONTROLLER ===');
    print('Current Step: ${currentStep.value}');
    print('Name: "${name.value}" (length: ${name.value.length})');
    print('Email: "${email.value}"');
    print('Date of Birth: "${dateOfBirth.value}"');
    print('Gender: "${gender.value}"');
    print('Ideal Match Gender: "${idealMatchGender.value}"');
    print('Relationship Expectation: "${relationshipExpectation.value}"');
    print('Interests: ${interests.length} items - ${interests.toList()}');
    print('Profile Image: ${profileImage.value != null ? "Selected" : "Not selected"}');
    print('================================');
  }

  @override
  void onClose() {
    clearData();
    super.onClose();
  }
}