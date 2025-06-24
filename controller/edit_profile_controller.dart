// lib/controller/profile/edit_profile_controller.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_finder/controller/global_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileController extends GetxController {
  // Text editing controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  // Global controller for user info
  final GlobalController globalController = Get.find<GlobalController>();
  
  // Supabase client
  final supabase = Supabase.instance.client;
  
  // Observables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString successMessage = ''.obs;
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxString currentImageUrl = ''.obs;
  final RxBool isPasswordChanged = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }
  
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
  
  // Load current user data
  Future<void> loadUserData() async {
    isLoading.value = true;
    try {
      final userId = globalController.userId.value;
      
      // Fetch user data from database
      final response = await supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();
      
      // Populate text controllers with current data
      nameController.text = response['name'] ?? '';
      emailController.text = response['email'] ?? '';
      
      // Set current profile image URL if exists
      if (response['profile_image'] != null) {
        currentImageUrl.value = response['profile_image'];
      }
      
    } catch (e) {
      errorMessage.value = 'Failed to load profile data';
      print('Error loading user data: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Pick image from gallery
  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      
      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      errorMessage.value = 'Failed to select image';
      print('Error picking image: $e');
    }
  }
  
  // Upload image to storage
  Future<String?> uploadProfileImage() async {
    if (selectedImage.value == null) {
      return currentImageUrl.value; // Return current URL if no new image
    }
    
    try {
      final userId = globalController.userId.value;
      final fileExt = selectedImage.value!.path.split('.').last;
      final fileName = 'profile_$userId.$fileExt';
      
      // Upload file to storage bucket
      final response = await supabase.storage
          .from('profile_images')
          .upload(fileName, selectedImage.value!);
      
      // Get public URL
      final String imageUrl = supabase.storage
          .from('profile_images')
          .getPublicUrl(fileName);
      
      return imageUrl;
    } catch (e) {
      errorMessage.value = 'Failed to upload image';
      print('Error uploading image: $e');
      return null;
    }
  }
  
  // Update password if changed
  Future<bool> updatePasswordIfChanged() async {
    if (passwordController.text.isNotEmpty) {
      try {
        // Update password in auth
        await supabase.auth.updateUser(
          UserAttributes(
            password: passwordController.text,
          ),
        );
        
        isPasswordChanged.value = true;
        return true;
      } catch (e) {
        errorMessage.value = 'Failed to update password: ${e.toString()}';
        return false;
      }
    }
    return true; // No password change attempted
  }
  
  // Update profile
  Future<void> updateProfile() async {
    errorMessage.value = '';
    successMessage.value = '';
    
    // Validate name
    if (nameController.text.trim().isEmpty) {
      errorMessage.value = 'Name cannot be empty';
      return;
    }
    
    isLoading.value = true;
    
    try {
      final userId = globalController.userId.value;
      
      // 1. Upload profile image if selected
      final profileImageUrl = await uploadProfileImage();
      
      // 2. Update password if changed
      final passwordUpdateSuccess = await updatePasswordIfChanged();
      if (!passwordUpdateSuccess) {
        isLoading.value = false;
        return;
      }
      
      // 3. Update user data in database
      await supabase
          .from('users')
          .update({
            'name': nameController.text.trim(),
            if (profileImageUrl != null) 'profile_image': profileImageUrl,
          })
          .eq('id', userId);
      
      // Update profile table if it exists (for social functionality)
      try {
        await supabase
            .from('profiles')
            .update({
              'name': nameController.text.trim(),
              if (profileImageUrl != null) 'profile_image': profileImageUrl,
            })
            .eq('user_id', userId);
      } catch (e) {
        // Ignore error if profiles table doesn't exist or doesn't have this user
        print('Note: Could not update profiles table: $e');
      }
      
      // Update global controller data if needed
      if (globalController.userName is RxString) {
        globalController.userName.value = nameController.text.trim();
      }
      
      // Show success message
      successMessage.value = 'Profile updated successfully';
      if (isPasswordChanged.value) {
        successMessage.value += ' (Password changed)';
      }
      
      // Navigate back after successful update
      Future.delayed(Duration(seconds: 2), () {
        Get.back();
      });
      
    } catch (e) {
      errorMessage.value = 'Failed to update profile: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }
}