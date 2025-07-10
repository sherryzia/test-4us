import 'dart:io';
import 'package:candid/controller/GlobalController.dart';
import 'package:candid/services/profile_service.dart';
// import 'package:candid/services/user_update_service.dart'; // Uncomment if you want to use the new service
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  final ProfileService _profileService = ProfileService();
  // final UserUpdateService _userUpdateService = UserUpdateService(); // Uncomment if using new service
  final GlobalController globalController = Get.find<GlobalController>();
  final ImagePicker _picker = ImagePicker();

  // Form controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController taglineController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController aboutMeController = TextEditingController();

  // Loading state
  RxBool isLoading = false.obs;
  RxBool isPasswordVisible = false.obs;

  // Profile image
  Rx<File?> selectedImage = Rx<File?>(null);
  RxString currentProfilePicture = ''.obs;

  // Track changes
  RxBool hasChanges = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialValues();
    setupChangeListeners();
  }

  // Load initial values from GlobalController
  void loadInitialValues() {
    nameController.text = globalController.name.value;
    emailController.text = globalController.email.value;
    taglineController.text = globalController.tagline.value;
    locationController.text = globalController.location.value;
    aboutMeController.text = globalController.bio.value;
    currentProfilePicture.value = globalController.profilePicture.value;
    
    print('Loaded initial values:');
    print('Name: ${nameController.text}');
    print('Email: ${emailController.text}');
    print('Tagline: ${taglineController.text}');
    print('Location: ${locationController.text}');
    print('About Me: ${aboutMeController.text}');
    print('Profile Picture: ${currentProfilePicture.value}');
  }

  // Setup listeners to detect changes
  void setupChangeListeners() {
    nameController.addListener(checkForChanges);
    emailController.addListener(checkForChanges);
    taglineController.addListener(checkForChanges);
    locationController.addListener(checkForChanges);
    aboutMeController.addListener(checkForChanges);
  }

  // Check if any field has changed
  void checkForChanges() {
    bool changed = nameController.text != globalController.name.value ||
                  emailController.text != globalController.email.value ||
                  taglineController.text != globalController.tagline.value ||
                  locationController.text != globalController.location.value ||
                  aboutMeController.text != globalController.bio.value ||
                  selectedImage.value != null;
    
    hasChanges.value = changed;
    print('Has changes: $changed');
  }

  // Pick image from gallery
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null) {
        selectedImage.value = File(image.path);
        checkForChanges();
        
        Get.snackbar(
          'Success',
          'Image selected successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Take photo with camera
  Future<void> takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null) {
        selectedImage.value = File(image.path);
        checkForChanges();
        
        Get.snackbar(
          'Success',
          'Photo taken successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to take photo: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Remove selected image
  void removeImage() {
    selectedImage.value = null;
    checkForChanges();
  }

  // Validate inputs
  bool validateInputs() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Name cannot be empty',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (emailController.text.trim().isEmpty || !emailController.text.contains('@')) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }

  // Update profile
  Future<void> updateProfile() async {
    if (!validateInputs()) return;
    
    if (!hasChanges.value) {
      Get.snackbar(
        'Info',
        'No changes to update',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Prepare data for update - only include changed fields
      Map<String, dynamic> updateData = {};

      // Check each field for changes and add to update data
      if (nameController.text != globalController.name.value) {
        updateData['name'] = nameController.text.trim();
      }

      if (emailController.text != globalController.email.value) {
        updateData['email'] = emailController.text.trim();
      }

      if (taglineController.text != globalController.tagline.value) {
        updateData['tagline'] = taglineController.text.trim();
      }

      if (locationController.text != globalController.location.value) {
        updateData['location'] = locationController.text.trim();
      }

      if (aboutMeController.text != globalController.bio.value) {
        updateData['bio'] = aboutMeController.text.trim();
      }

      // Add password if provided (always sent if not empty)
      if (passwordController.text.isNotEmpty) {
        updateData['password'] = passwordController.text;
      }

      print('Update data: $updateData');
      print('Has image: ${selectedImage.value != null}');

      // Call API to update profile
      final response = await _profileService.updateProfile(
        updateData,
        selectedImage.value,
      );

      if (response.statusCode == 200) {
        // Update GlobalController with new data
        if (response.data != null && response.data is Map) {
          globalController.updateFromResponse(response.data, deleteToken: false);
          await globalController.saveToSharedPreferences();
          
          // Update local values to match new global values
          loadInitialValues();
          selectedImage.value = null;
          passwordController.clear();
          hasChanges.value = false;
        }

        Get.snackbar(
          'Success',
          'Profile updated successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );

        // Optionally go back
        // Get.back();
      } else {
        String errorMessage = 'Failed to update profile';
        if (response.data != null && response.data is Map) {
          final responseData = response.data as Map<String, dynamic>;
          
          // Handle field-specific errors
          if (responseData.containsKey('errors')) {
            final errors = responseData['errors'];
            if (errors is Map) {
              List<String> errorMessages = [];
              errors.forEach((field, fieldErrors) {
                if (fieldErrors is List) {
                  errorMessages.addAll(fieldErrors.map((e) => '$field: $e'));
                } else {
                  errorMessages.add('$field: $fieldErrors');
                }
              });
              errorMessage = errorMessages.join('\n');
            }
          } else {
            errorMessage = responseData['message'] ?? 
                          responseData['error'] ?? 
                          responseData['detail'] ?? 
                          errorMessage;
          }
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
        'Failed to update profile: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Update profile error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Show image picker options
  void showImagePickerOptions() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Profile Picture',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                      takePhoto();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.camera_alt, size: 30),
                          SizedBox(height: 8),
                          Text('Camera'),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                      pickImage();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.photo_library, size: 30),
                          SizedBox(height: 8),
                          Text('Gallery'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (selectedImage.value != null || currentProfilePicture.value.isNotEmpty) ...[
              SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  Get.back();
                  removeImage();
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Remove Picture', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ),
            ],
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // Reset form to original values
  void resetForm() {
    loadInitialValues();
    selectedImage.value = null;
    passwordController.clear();
    hasChanges.value = false;
    
    Get.snackbar(
      'Info',
      'Form reset to original values',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    taglineController.dispose();
    locationController.dispose();
    aboutMeController.dispose();
    super.onClose();
  }
}