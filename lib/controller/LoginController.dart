import 'package:candid/controller/GlobalController.dart';
import 'package:candid/services/login_service.dart';
import 'package:candid/utils/shared_preferences_util.dart';
import 'package:candid/view/screens/auth/authentication_point.dart';
import 'package:candid/view/screens/auth/sign_up/complete_profile/complete_profile.dart';
import 'package:candid/view/screens/auth/sign_up/verify_phone_number.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

class LoginController extends GetxController {
  final LoginService _loginService = LoginService();

  // Form fields
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  RxString selectedCountryCode = '+92'.obs; // Default to Pakistan
  RxBool isLoading = false.obs;
  RxBool isPasswordHidden = true.obs;

  // Store login data temporarily for OTP verification if needed
  String? tempPhoneNumber;
  String? tempPassword;
  bool isFromLogin = true; // Track if we're coming from login flow

  // Getter to safely access temp phone number
  String? get getTempPhoneNumber => tempPhoneNumber;

  // Method to get complete phone number with country code
  String getCompletePhoneNumber() {
    String phoneNumber = phoneNumberController.text.trim();
    
    // Remove any leading zeros or country code if user entered it
    if (phoneNumber.startsWith('0')) {
      phoneNumber = phoneNumber.substring(1);
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
    
    if (passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Password is required.',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    
    return true;
  }

  // Login method
  Future<void> login() async {
    if (!validateInputs()) return;

    isLoading.value = true;

    final response = await _loginService.login(
      passwordController.text,
      getCompletePhoneNumber(),
    );

    isLoading.value = false;

    // Check for successful response
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data != null && response.data is Map) {
        final responseData = response.data as Map<String, dynamic>;
        
        // Check if we have token (successful login)
        if (responseData.containsKey('token') && responseData.containsKey('expiry')) {
          // Store the token
          await SharedPreferencesUtil.saveData<String>('authToken', responseData['token']);
          
          // Update global controller if needed
          final globalController = Get.find<GlobalController>();
          // Note: Login response doesn't have user data, you might need to fetch user data separately
          
          Get.snackbar(
            'Success',
            'Login successful!',
            snackPosition: SnackPosition.BOTTOM,
          );

          // Navigate to main app or onboarding
          Get.offAll(() => AuthenticationPoint()); // Change to your main app screen
          return;
        }
        
        // Check if we need OTP verification
        if (responseData.containsKey('message') && 
            (responseData['message'].toString().toLowerCase().contains('verify') ||
             responseData['message'].toString().toLowerCase().contains('otp'))) {
          
          // Store data temporarily for OTP verification
          tempPhoneNumber = getCompletePhoneNumber();
          tempPassword = passwordController.text;
          isFromLogin = true;

          Get.snackbar(
            'Info',
            'Please verify your account with OTP.',
            snackPosition: SnackPosition.BOTTOM,
          );

          // Navigate to OTP verification
          Get.to(() => VerifyPhoneNumber());
          return;
        }
      }
      
      // Unexpected response format
      Get.snackbar(
        'Error',
        'Unexpected response from server',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      // Handle error responses
      String errorMessage = 'Login failed';
      if (response.data != null && response.data is Map) {
        final responseData = response.data as Map<String, dynamic>;
        
        // Check if we need OTP verification (even with error status)
        if (responseData.containsKey('message') && 
            (responseData['message'].toString().toLowerCase().contains('verify') ||
             responseData['message'].toString().toLowerCase().contains('otp'))) {
          
          tempPhoneNumber = getCompletePhoneNumber();
          tempPassword = passwordController.text;
          isFromLogin = true;

          Get.snackbar(
            'Info',
            'Please verify your account with OTP.',
            snackPosition: SnackPosition.BOTTOM,
          );

          Get.to(() => VerifyPhoneNumber());
          return;
        }
        
        errorMessage = responseData['message'] ?? 
                      responseData['error'] ?? 
                      responseData['detail'] ?? 
                      errorMessage;
      }
      
      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // OTP verification for login
  Future<void> verifyLoginOTP(String otpCode) async {
    if (tempPhoneNumber == null) {
      Get.snackbar('Error', 'Phone number not found. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;

    // Use the same OTP verification endpoint
    final response = await _loginService.verifyOTP(
      otpCode,
      tempPhoneNumber!,
    );

    isLoading.value = false;

    if (response.statusCode == 200 || response.statusCode == 201) {
      clearTempData();

      // Check if response has token
      if (response.data != null && response.data is Map) {
        final responseData = response.data as Map<String, dynamic>;
        
        if (responseData.containsKey('token')) {
          await SharedPreferencesUtil.saveData<String>('authToken', responseData['token']);
        }
      }

      Get.snackbar(
        'Success',
        'Account verified successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Navigate to onboarding (since coming from login)
      Get.offAll(() => CompleteProfile());
    } else {
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

  // Resend OTP for login
  Future<void> resendLoginOTP() async {
    if (tempPhoneNumber == null) {
      Get.snackbar('Error', 'Phone number not found. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;

    final response = await _loginService.resendOTP(tempPhoneNumber!);

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