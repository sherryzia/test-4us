import 'package:flutter/material.dart';
import 'package:forus_app/controllers/GlobalController.dart';
import 'package:forus_app/view/auth/authentication_point.dart';
import 'package:get/get.dart';
import 'package:forus_app/services/auth/login_service.dart';
import 'package:forus_app/utils/shared_preferences_util.dart';

class LoginController extends GetxController {
  final LoginService _loginService = LoginService();

  // Form fields
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isPasswordHidden = true.obs;

  // Validation
  bool validateInputs() {
    if (emailController.text.trim().isEmpty ||
        !GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    if (passwordController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Password is required.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    return true;
  }

  // Login logic
  Future<void> login() async {
    if (!validateInputs()) return;

    isLoading.value = true;

    try {
      final response = await _loginService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if(response.statusCode == 200 && !response.data.containsKey('errors')){
        // Save token and user data in SharedPreferences
        await SharedPreferencesUtil.saveData<String>('authToken', response.data['token']);
        await SharedPreferencesUtil.saveData<Map<String, dynamic>>('userData', response.data['user']);

        // Update GlobalController with the response data
        final globalController = Get.find<GlobalController>();
        globalController.updateFromResponse(response.data);
        globalController.saveToSharedPreferences();

        Get.snackbar(
          'Success',
          'Login successful!',
          snackPosition: SnackPosition.BOTTOM,
        );

        globalController.logValues();

        // Navigate to the AuthenticationPoint
        Get.offAll(() => AuthenticationPoint()); // Replace with actual route

      }
      else{
        Get.snackbar(
          'Error',
          '${response.data["message"]}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }

    } catch (e) {
      Get.snackbar(
        'Error',
        'Login failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );

      print('Error during login: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }
}
