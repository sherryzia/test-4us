import 'package:candid/services/signup_service.dart';
import 'package:candid/view/screens/auth/sign_up/phone_number.dart';
import 'package:candid/view/screens/auth/sign_up/verify_phone_number.dart';
import 'package:candid/view/screens/auth/sign_up/complete_profile/complete_profile.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

class SignUpController extends GetxController {
  final SignUpService _signupService = SignUpService();

  // Form fields
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  RxString selectedCountryCode = '+92'.obs; // Default to Pakistan
  RxBool isLoading = false.obs;
  RxBool isPasswordHidden = true.obs;
  RxBool isConfirmPasswordHidden = true.obs;

  // Store signup data temporarily (not in global controller yet)
  String? tempPhoneNumber;
  String? tempPassword;

  // Getter to safely access temp phone number
  String? get getTempPhoneNumber => tempPhoneNumber;

  // Method to get complete phone number with country code
  String getCompletePhoneNumber() {
    String phoneNumber = phoneNumberController.text.trim();
    
    // Remove any leading zeros or country code if user entered it
    if (phoneNumber.startsWith('0')) {
      phoneNumber = phoneNumber.substring(1);
      @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneNumberController.dispose();
    clearTempData();
    super.onClose();
  }
}
    
    // Remove country code if user typed it
    if (phoneNumber.startsWith(selectedCountryCode.value.replaceAll('+', ''))) {
      phoneNumber = phoneNumber.substring(selectedCountryCode.value.replaceAll('+', '').length);
    }
    
    // Remove + if user typed it
    if (phoneNumber.startsWith('+')) {
      phoneNumber = phoneNumber.substring(1);
    }
    
    return '${selectedCountryCode.value}${phoneNumber}';
  }

  // Method to handle country selection
  void onCountryChanged(Country country) {
    selectedCountryCode.value = '+${country.phoneCode}';
    print('Country changed to: ${country.displayName} (${selectedCountryCode.value})');
  }

  // Validation
  bool validateInputs() {
    if (phoneNumberController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter a valid phone number.',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    
    String completePhone = getCompletePhoneNumber();
    if (completePhone.length < 10) {
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

  // Initial signup - just sends OTP
  Future<void> signUp() async {
    if (!validateInputs()) return;

    isLoading.value = true;

    final response = await _signupService.signUp(
      passwordController.text,
      getCompletePhoneNumber(),
    );

    isLoading.value = false;

    // Check for successful response
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Verify the response contains the expected data
      if (response.data != null && response.data is Map) {
        final responseData = response.data as Map<String, dynamic>;
        
        // Check if we have the expected fields (id and phone_number)
        if (responseData.containsKey('id') && responseData.containsKey('phone_number')) {
          // Store data temporarily for OTP verification
          tempPhoneNumber = responseData['phone_number'] ?? getCompletePhoneNumber();
          tempPassword = passwordController.text;

          Get.snackbar(
            'Success',
            'OTP sent successfully to ${tempPhoneNumber}',
            snackPosition: SnackPosition.BOTTOM,
          );

          // Navigate to OTP verification
          Get.to(() => VerifyPhoneNumber());
          return;
        }
        
        // Check if phone number already exists (user exists, proceed to OTP)
        if (responseData.containsKey('phone_number') && 
            responseData['phone_number'] is List &&
            responseData['phone_number'].toString().contains('unique')) {
          
          // Store data temporarily for OTP verification (existing user)
          tempPhoneNumber = getCompletePhoneNumber();
          tempPassword = passwordController.text;

          Get.snackbar(
            'Info',
            'Account already exists. Please verify with OTP.',
            snackPosition: SnackPosition.BOTTOM,
          );

          // Navigate to OTP verification for existing user
          Get.to(() => VerifyPhoneNumber());
          return;
        }
      }
      
      // If we reach here, the response format was unexpected
      Get.snackbar(
        'Error',
        'Unexpected response format from server',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      // For non-200 status codes, check if it's the "phone number must be unique" case
      if (response.data != null && response.data is Map) {
        final responseData = response.data as Map<String, dynamic>;
        
        // Check if phone number already exists (even with non-200 status)
        if (responseData.containsKey('phone_number') && 
            responseData['phone_number'] is List &&
            responseData['phone_number'].toString().contains('unique')) {
          
          // Store data temporarily for OTP verification (existing user)
          tempPhoneNumber = getCompletePhoneNumber();
          tempPassword = passwordController.text;

          Get.snackbar(
            'Info',
            'Account already exists. Please verify with OTP.',
            snackPosition: SnackPosition.BOTTOM,
          );

          // Navigate to OTP verification for existing user
          Get.to(() => VerifyPhoneNumber());
          return;
        }
        
        // Other error cases
        String errorMessage = 'Failed to create account';
        errorMessage = responseData['message'] ?? 
                      responseData['error'] ?? 
                      responseData['detail'] ?? 
                      errorMessage;
        
        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to create account',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  // OTP verification - this will return the token and user data
  Future<void> verifyOTP(String otpCode) async {
    if (tempPhoneNumber == null) {
      Get.snackbar('Error', 'Phone number not found. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;

    final response = await _signupService.verifyOTP(
      otpCode,
      tempPhoneNumber!,
    );

    isLoading.value = false;

    // Check for successful response
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Clear temporary data since verification is successful
      clearTempData();

      Get.snackbar(
        'Success',
        'Account verified successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Navigate to complete profile or login screen
      // Since you mentioned after OTP verification, we go to login screen
      Get.offAll(() => PhoneNumber(signUp: false)); // Go to login after signup OTP verification
    } else {
      // Error handling
      String errorMessage = 'Invalid OTP code';
      if (response.data != null && response.data is Map) {
        errorMessage = response.data['message'] ?? 
                      response.data['error'] ?? 
                      response.data['detail'] ?? 
                      errorMessage;
      }
      
      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Resend OTP
  Future<void> resendOTP() async {
    if (tempPhoneNumber == null) {
      Get.snackbar('Error', 'Phone number not found. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;

    final response = await _signupService.resendOTP(tempPhoneNumber!);

    isLoading.value = false;

    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.snackbar(
        'Success',
        'OTP resent successfully to ${tempPhoneNumber}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      String errorMessage = 'Failed to resend OTP';
      if (response.data != null && response.data is Map) {
        errorMessage = response.data['message'] ?? 
                      response.data['error'] ?? 
                      response.data['detail'] ?? 
                      errorMessage;
      }
      
      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Clear temporary data
  void clearTempData() {
    tempPhoneNumber = null;
    tempPassword = null;
  }
}