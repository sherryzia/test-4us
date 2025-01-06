import 'package:forus_app/view/auth/login_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:forus_app/services/auth/reset_password_service.dart';

class ResetPasswordController extends GetxController {
  RxBool isLoading = false.obs;

  final ResetPasswordService _resetPasswordService = ResetPasswordService();
  // Form fields
  TextEditingController otpTextController = TextEditingController();

  Future<void> resetPassword(String otp, String email, String password, String confirmPassword) async {
    isLoading.value = true;

    try {

      final response = await _resetPasswordService.resetPassword(otp, email, password, confirmPassword);

      // Password is reset, Show login screen.
      if(response.statusCode == 200 && !response.data.containsKey('errors')){

        Get.snackbar(
          'Success',
          'Password reset successfully, Please login.',
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.offAll(() => LoginScreen());
      }
      else{
        Get.snackbar(
          'Error',
          '${response.data["message"]}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }

    } catch (e) {
      Get.snackbar('Error', '$e');
    } finally {
      isLoading.value = false;
    }
  }
}