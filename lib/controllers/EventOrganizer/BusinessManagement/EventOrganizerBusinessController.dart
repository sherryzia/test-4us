import 'dart:io';
import 'package:forus_app/view/general/user_under_verification_screen.dart';
import 'package:get/get.dart';
import '../../../services/event_organizer/organizer_business_service.dart';

class EventOrganizerBusinessController extends GetxController {
  final OrganizerBusinessService _organizerService = OrganizerBusinessService();

  RxBool isLoading = true.obs;

  Future<void> registerEventOrganizerBusiness({
    required String name,
    required String email,
    required String countryCode,
    required String phoneNumber,
    required String about,
    required String website,
    required String facebook,
    required String instagram,
    required String twitter,
    required String linkedIn,
    required String address,
    required double latitude,
    required double longitude,
    required List<String> filePaths, // Accept file paths as strings
  }) async {
    isLoading.value = true;

    try {
      // Convert file paths to List<File>
      final List<File> businessPhotos = filePaths.map((path) => File(path)).toList();

      // Call service to register business
      final response = await _organizerService.registerEventOrganizerBusiness(
        name: name,
        email: email,
        countryCode: countryCode,
        phoneNumber: phoneNumber,
        about: about,
        website: website,
        address: address,
        latitude: latitude,
        longitude: longitude,
        businessPhotos: businessPhotos, // Pass the converted list of files
      );

      if (response.statusCode == 200 && response.data != null) {
        Get.snackbar(
          'Success',
          'Business registered successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.offAll(() => UserUnderVerificationScreen());
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
    } finally {
      isLoading.value = false;
    }
  }
}
