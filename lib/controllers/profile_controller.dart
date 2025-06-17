// Create a new file: views/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  // User information
  final RxString name = 'Harpreet Singh'.obs;
  final RxString email = 'harpreet.singh@example.com'.obs;
  final RxString currency = 'INR (₹)'.obs;
  
  // Text controllers for editable fields
  final nameController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  // Currency options
  final List<String> currencies = [
    'INR (₹)',
    'USD (\$)',
    'EUR (€)',
    'GBP (£)',
    'JPY (¥)'
  ];
  
  @override
  void onInit() {
    super.onInit();
    nameController.text = name.value;
  }
  
  @override
  void onClose() {
    nameController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
  
  void updateName() {
    if (nameController.text.isNotEmpty) {
      name.value = nameController.text;
      Get.snackbar(
        'Success',
        'Name updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
  
  void updatePassword() {
    if (currentPasswordController.text.isNotEmpty &&
        newPasswordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty) {
      
      if (newPasswordController.text != confirmPasswordController.text) {
        Get.snackbar(
          'Error',
          'New password and confirmation do not match',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
        return;
      }
      
      // Clear password fields
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
      
      Get.snackbar(
        'Success',
        'Password updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Error',
        'Please fill all password fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
  
  void changeCurrency(String newCurrency) {
    currency.value = newCurrency;
    Get.snackbar(
      'Success',
      'Currency changed to $newCurrency',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
    );
  }
  
  void logout() {
    Get.snackbar(
      'Logged Out',
      'You have been logged out',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.withOpacity(0.8),
      colorText: Colors.white,
    );
    // Here you would implement actual logout logic
  }
}
