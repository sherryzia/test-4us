import 'dart:io';
import 'package:forus_app/view/auth/authentication_point.dart';
import 'package:forus_app/view/general/congrats.dart';
import 'package:get/get.dart';
import 'package:forus_app/services/service_provider/provider_business_service.dart';

class BusinessController extends GetxController {
  final BusinessService _businessService = BusinessService();

  // Form fields
  RxBool isLoading = false.obs;

  Future<void> registerServiceProviderBusiness({
    required List<String> serviceTypes,
    required String name,
    required String email,
    required String countryCode,
    required String phoneNumber,
    required String about,
    required String website,
    required String address,
    required double latitude,
    required double longitude,
    required List<File> photos,
  }) async {

    isLoading.value = true;

    try {

      // Call service to register business
      final response = await _businessService.registerServiceProviderBusiness(
        serviceTypes: serviceTypes,
        name: name,
        email: email,
        countryCode: countryCode,
        phoneNumber: phoneNumber,
        about: about,
        website: website,
        address: address,
        latitude: latitude,
        longitude: longitude,
        businessPhotos: photos, // Pass the converted list of files
      );

      if (response.statusCode == 200 && response.data != null) {
        Get.snackbar(
          'Success',
          'Business registered successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );

        // Navigate or perform actions after success
        print("Response Data: ${response.data}");

        Get.offAll(() => AuthenticationPoint());
      } else {
        Get.snackbar(
          'Error',
          response.data?['message'] ?? 'Failed to register business.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
