import 'package:forus_app/controllers/GlobalController.dart';
import 'package:forus_app/utils/shared_preferences_util.dart';
import 'package:forus_app/view/auth/authentication_point.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:forus_app/services/auth/signup_service.dart';
import 'package:forus_app/view/auth/verification_otp.dart';

class SignUpController extends GetxController {
  final SignUpService _signupService = SignUpService();

  // Form fields
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  RxString selectedCountryCode = '+1'.obs; // Default country code
  RxBool isLoading = false.obs;
  RxBool isPasswordHidden = true.obs;
  RxBool isConfirmPasswordHidden = true.obs;
  RxString selectedUserType = 'customer'.obs; // Default to 'Customer'

  // Validation
  bool validateInputs() {
    if (fullNameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Full name is required.',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (emailController.text.trim().isEmpty ||
        !GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar('Error', 'Please enter a valid email address.',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (phoneNumberController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter a valid phone number.',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Password and confirm password are required.',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match.',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    return true;
  }

  // Signup logic
  Future<void> signUp() async {
    if (!validateInputs()) return;

    isLoading.value = true;

    try {
      final response = await _signupService.signUp(
        fullNameController.text.trim(),
        emailController.text.trim(),
        passwordController.text,
        confirmPasswordController.text,
        'true',
        selectedUserType.value, // Use selected user type
        selectedCountryCode.value,
        phoneNumberController.text.trim(),
      );

      if (response.statusCode == 200 && !response.data.containsKey('errors')) {
        // Update the GlobalController with the response data
        final globalController = Get.find<GlobalController>();
        globalController.updateFromResponse(response.data);
        await globalController.saveToSharedPreferences();

        globalController.logValues();
        // Save the token in SharedPreferences
        await SharedPreferencesUtil.saveData<String>('authToken', response.data['token']);

        //print the token in console
        Get.snackbar(
          'Success',
          'Account created successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.offAll(() => AuthenticationPoint());
      } else {
        Get.snackbar(
          'Error',
          '${response.data["message"]}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar('Error', '$e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
