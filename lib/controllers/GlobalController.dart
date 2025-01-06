import 'dart:developer';

import 'package:get/get.dart';
import 'package:forus_app/utils/shared_preferences_util.dart';

class GlobalController extends GetxController {
  // Reactive properties for global state
  RxString email = ''.obs;
  RxInt userId = 0.obs;
  RxString name = ''.obs;
  RxString countryCode = ''.obs;
  RxString phoneNumber = ''.obs;
  RxString userType = ''.obs;
  RxString profilePhotoUrl = ''.obs;
  RxString authToken = ''.obs;

  // Method to update global state from the response
  void updateFromResponse(Map<String, dynamic> response) {
    try {
      email.value = response['email'] ?? '';
      final user = response['user'];
      if (user != null) {
        userId.value = user['id'] ?? 0;
        name.value = user['name'] ?? '';
        countryCode.value = user['country_code'] ?? '';
        phoneNumber.value = user['phone_number'] ?? '';
        userType.value = user['user_type'] ?? '';
        profilePhotoUrl.value = user['profile_photo_url'] ?? '';
      }
      authToken.value = response['token'] ?? '';
    } catch (e) {
      Get.snackbar('Error', 'Failed to update global state: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Method to clear all state values
  Future<void> clear() async{
    email.value = '';
    userId.value = 0;
    name.value = '';
    countryCode.value = '';
    phoneNumber.value = '';
    userType.value = '';
    profilePhotoUrl.value = '';
    authToken.value = '';

    await SharedPreferencesUtil.removeData('email');
    await SharedPreferencesUtil.removeData('userId');
    await SharedPreferencesUtil.removeData('name');
    await SharedPreferencesUtil.removeData('countryCode');
    await SharedPreferencesUtil.removeData('phoneNumber');
    await SharedPreferencesUtil.removeData('userType');
    await SharedPreferencesUtil.removeData('profilePhotoUrl');
    await SharedPreferencesUtil.removeData("authToken");
  }


  // Method to save global state to SharedPreferences
  Future<void> saveToSharedPreferences() async {
    try {
      await SharedPreferencesUtil.saveData<String>('email', email.value);
      await SharedPreferencesUtil.saveData<int>('userId', userId.value);
      await SharedPreferencesUtil.saveData<String>('name', name.value);
      await SharedPreferencesUtil.saveData<String>('countryCode', countryCode.value);
      await SharedPreferencesUtil.saveData<String>('phoneNumber', phoneNumber.value);
      await SharedPreferencesUtil.saveData<String>('userType', userType.value);
      await SharedPreferencesUtil.saveData<String>('profilePhotoUrl', profilePhotoUrl.value);
      await SharedPreferencesUtil.saveData<String>("authToken", authToken.value);
    } catch (e) {
      Get.snackbar('Error', 'Failed to save data to SharedPreferences: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Method to load data from SharedPreferences into global state
  Future<void> loadFromSharedPreferences() async {
    try {
      email.value = await SharedPreferencesUtil.getData<String>('email') ?? '';
      userId.value = await SharedPreferencesUtil.getData<int>('userId') ?? 0;
      name.value = await SharedPreferencesUtil.getData<String>('name') ?? '';
      countryCode.value = await SharedPreferencesUtil.getData<String>('countryCode') ?? '';
      phoneNumber.value = await SharedPreferencesUtil.getData<String>('phoneNumber') ?? '';
      userType.value = await SharedPreferencesUtil.getData<String>('userType') ?? '';
      profilePhotoUrl.value = await SharedPreferencesUtil.getData<String>('profilePhotoUrl') ?? '';
      authToken.value = await SharedPreferencesUtil.getData<String>("authToken") ?? '';
    } catch (e) {
      Get.snackbar('Error', 'Failed to load data from SharedPreferences: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Method to log all values for debugging
  void logValues() {
    log('GlobalController Values:');
    log('Email: ${email.value}');
    log('User ID: ${userId.value}');
    log('Name: ${name.value}');
    log('Country Code: ${countryCode.value}');
    log('Phone Number: ${phoneNumber.value}');
    log('User Type: ${userType.value}');
    log('Profile Photo URL: ${profilePhotoUrl.value}');
    log('Token: ${authToken.value}');
  }
}
