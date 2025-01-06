import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forus_app/services/auth/forgot_password_service.dart';
import 'package:forus_app/view/auth/forgot_password/confirm_password.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final ForgotPasswordService _forgotPasswordService = ForgotPasswordService();

  // Form fields
  TextEditingController emailController = TextEditingController();

  RxBool isLoading = false.obs;

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
    return true;
  }

  // Login logic
  Future<void> sendEmail() async {
    if (!validateInputs()) return;

    isLoading.value = true;

    try {
      final response = await _forgotPasswordService.sendEmail(
        emailController.text.trim()
      );

      if(response.statusCode == 200 && !response.data.containsKey('errors')){
        Get.off(() => ConfirmPasswordScreen(), arguments: {"email": emailController.text.trim()});
      }else{
        Get.snackbar(
          'Error',
          '${response.data["message"]}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }

    } catch (e) {

      Get.snackbar(
        'Error',
        'Request failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );

      if (kDebugMode) {
        print('Error: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }
}
