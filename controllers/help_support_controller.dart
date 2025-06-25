// lib/controllers/help_support_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpSupportController extends GetxController {
  // Text controller for the support message
  final messageController = TextEditingController();
  
  // List of support topics/categories
  final RxList<String> supportTopics = [
    'Technical Issue',
    'Account Problem',
    'Feature Request',
    'Billing Question',
    'Data Recovery',
    'App Feedback',
    'Other',
  ].obs;
  
  // Currently selected topic
  final RxString selectedTopic = 'Technical Issue'.obs;
  
  // Loading state for the send button
  final RxBool isLoading = false.obs;
  
  // Change the selected topic
  void changeTopic(String topic) {
    selectedTopic.value = topic;
  }
  
  // Send support request
  Future<void> sendSupportRequest() async {
    if (messageController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your message',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }
    
    // Show loading
    isLoading.value = true;
    
    try {
      // Simulate network request
      await Future.delayed(Duration(seconds: 2));
      
      // Clear the text field
      messageController.clear();
      
      // Show success message
      Get.snackbar(
        'Success',
        'Your message has been sent. Our support team will get back to you soon.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
      
      // Go back to previous screen
      Get.back();
    } catch (e) {
      // Show error message
      Get.snackbar(
        'Error',
        'Failed to send message. Please try again later.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      // Hide loading
      isLoading.value = false;
    }
  }
  
  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
