// lib/controllers/profile_controller.dart - Fixed Complete Version
import 'package:expensary/views/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:expensary/controllers/global_controller.dart';
import 'package:expensary/controllers/home_controller.dart';

class ProfileController extends GetxController {
  final supabase = Supabase.instance.client;

  // User information
  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxString currency = ''.obs;
  final RxDouble monthlyBudget = 0.0.obs;
  final RxDouble monthlyIncome = 0.0.obs;

  // Text controllers for editable fields
  final nameController = TextEditingController();
  final budgetController = TextEditingController();
  final incomeController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observable states
  final isCurrentPasswordVisible = false.obs;
  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;

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
    budgetController.dispose();
    incomeController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> fetchUserProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    // Get email from auth user
    email.value = user.email ?? '';

    try {
      final response = await supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (response != null) {
        name.value = response['full_name'] ?? '';
        currency.value = response['currency'] ?? currencies.first;
        monthlyBudget.value = (response['monthly_budget'] ?? 0).toDouble();
        monthlyIncome.value = (response['monthly_income'] ?? 0).toDouble();
        
        // Update text controllers
        nameController.text = name.value;
        budgetController.text = monthlyBudget.value.toString();
        incomeController.text = monthlyIncome.value.toString();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> updateName() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null || nameController.text.isEmpty) return;

    isLoading.value = true;

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
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    isLoading.value = true;

    try {
      await supabase
          .from('users')
          .update({
            'full_name': nameController.text,
            'monthly_budget': double.tryParse(budgetController.text) ?? 0,
            'monthly_income': double.tryParse(incomeController.text) ?? 0,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);

      // Update local values
      name.value = nameController.text;
      monthlyBudget.value = double.tryParse(budgetController.text) ?? 0;
      monthlyIncome.value = double.tryParse(incomeController.text) ?? 0;

      // Update global controller
      try {
        final globalController = Get.find<GlobalController>();
        await globalController.refreshData();

        // Update home controller
        final homeController = Get.find<HomeController>();
        homeController.monthlyBudget.value = monthlyBudget.value;
        await homeController.loadData();
      } catch (e) {
        debugPrint('Error updating other controllers: $e');
      }

      Get.snackbar('Success', 'Profile updated successfully',
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
    } finally {
      isLoading.value = false;
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

    isLoading.value = true;

    try {
      final response = await supabase.auth.updateUser(
        UserAttributes(password: newPasswordController.text),
      );

      if (response.user != null) {
        Get.snackbar('Success', 'Password updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white);
        
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update password: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
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

  Future<void> resetAllExpenses() async {
    // Show confirmation dialog
    final bool? confirmed = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: Color(0xFF2A2D40),
        title: Text('Reset All Expenses', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to delete all your expenses? This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text('Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    isLoading.value = true;

    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      // Delete all expenses for this user
      await supabase
          .from('expenses')
          .delete()
          .eq('user_id', userId);

      // Refresh home controller data
      try {
        final homeController = Get.find<HomeController>();
        await homeController.loadData();
      } catch (e) {
        debugPrint('Error refreshing home controller: $e');
      }

      Get.snackbar('Success', 'All expenses have been reset',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to reset expenses: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
    Get.offAll(() => LoginScreen());
  }
}