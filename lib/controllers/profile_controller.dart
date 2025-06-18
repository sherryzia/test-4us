import 'package:expensary/views/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
  final supabase = Supabase.instance.client;

  // User information
  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxString currency = ''.obs;

  // Text controllers for editable fields
  final nameController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();


  final isCurrentPasswordVisible = false.obs;
  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  // Currency options
  final List<String> currencies = [
    'PKR (₨)',
    'USD (\$)',
    'EUR (€)',
    'GBP (£)',
    'JPY (¥)'
  ];

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> fetchUserProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    email.value = user.email ?? '';

    final response = await supabase
        .from('users')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (response != null) {
      name.value = response['name'] ?? '';
      currency.value = response['currency'] ?? currencies.first;
      nameController.text = name.value;
    }
  }
Future<void> updateName() async {
  final userId = supabase.auth.currentUser?.id;
  if (userId == null || nameController.text.isEmpty) return;

  try {
    await supabase
        .from('users')
        .update({'full_name': nameController.text})
        .eq('id', userId);

    name.value = nameController.text;

    Get.snackbar('Success', 'Name updated successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
    );
  } catch (e) {
    Get.snackbar('Error', e.toString(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
    );
  }
}


  Future<void> updatePassword() async {
    if (currentPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all password fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white);
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'New password and confirmation do not match',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white);
      return;
    }

    final response = await supabase.auth.updateUser(
      UserAttributes(password: newPasswordController.text),
    );

    if (response.user != null) {
      Get.snackbar('Success', 'Password updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white);
    } else {
      Get.snackbar('Error', 'Failed to update password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white);
    }

    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }
Future<void> changeCurrency(String newCurrency) async {
  final userId = supabase.auth.currentUser?.id;
  if (userId == null) return;

  try {
    await supabase
        .from('users')
        .update({'currency': newCurrency})
        .eq('id', userId);

    currency.value = newCurrency;

    Get.snackbar('Success', 'Currency changed to $newCurrency',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
    );
  } catch (e) {
    Get.snackbar('Error', e.toString(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
    );
  }
}

  Future<void> logout() async {
    await supabase.auth.signOut();
    Get.to(() => LoginScreen()); // Change this route as per your routing setup
  }
}