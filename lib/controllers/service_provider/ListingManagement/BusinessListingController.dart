import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forus_app/view/service_provider/ProviderBottomBarNav.dart';
import 'package:get/get.dart';
import '../../../services/service_provider/provider_listing_service.dart';

class BusinessListingController extends GetxController {
  final ProviderListingService _businessListingService = ProviderListingService();

  // Form fields
  RxBool isLoading = false.obs;

  String convertTo24HourFormat(String time) {
    // Parse the input string (expected format: "hh:mm AM/PM")
    final timeOfDay = TimeOfDay(
      hour: int.parse(time.split(":")[0]),
      minute: int.parse(time.split(":")[1].split(" ")[0]),
    );

    // Convert to 24-hour format
    final int hour = timeOfDay.hourOfPeriod + (time.contains("PM") ? 12 : 0);
    final String minute = timeOfDay.minute.toString().padLeft(2, '0');
    return "${hour.toString().padLeft(2, '0')}:$minute";
  }

  Future<void> createBusinessListing({
    required String name,
    required String countryCode,
    required String phoneNumber,
    required String about,
    required List<String> includes,
    required String address,
    required double latitude,
    required double longitude,
    required List<File> photos,
    required Map<String, Map<String, dynamic>> availability,
  }) async {
    isLoading.value = true;

    try {
      // Convert availability to the required format
      final List<Map<String, String>> formattedAvailabilities = [];
      availability.forEach((day, data) {
        if (data['isToggled'] == true) {
          formattedAvailabilities.add({
            'day': day,
            'start_time': convertTo24HourFormat(data['startTime'] ?? ''),
            'end_time': convertTo24HourFormat(data['endTime'] ?? ''),
          });
        }
      });

      // Call the service
      final response = await _businessListingService.createBusinessListing(
        name: name,
        countryCode: countryCode,
        phoneNumber: phoneNumber,
        about: about,
        includes: includes,
        address: address,
        latitude: latitude,
        longitude: longitude,
        photos: photos,
        availabilities: formattedAvailabilities,
      );

      if (response.statusCode == 200 && response.data != null) {
        Get.snackbar(
          'Success',
          'Business listing created successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAll(() => ProviderBottomBarNav());
      } else {
        Get.snackbar(
          'Error',
          response.data?['message'] ?? 'Failed to create business listing.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      if (kDebugMode) {
        print('Error: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteBusinessListing(String serviceId) async {
    isLoading.value = true;

    try {
      final response = await _businessListingService.deleteBusinessListing(serviceId);

      if (response.statusCode == 200) {
        // Handle success response in the UI
      } else {
        // Handle error response in the UI
        Get.snackbar('Error', response.data['message'] ?? 'Failed to delete service.');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> editBusinessListing({
    required String serviceId,
    required String name,
    required String countryCode,
    required String phoneNumber,
    required String about,
    required List<String> includes,
    required String address,
    required double latitude,
    required double longitude,
    List<File>? photos, // Make photos nullable
    required Map<String, Map<String, dynamic>> availability,
  }) async {
    isLoading.value = true;

    try {
      final List<Map<String, String>> formattedAvailabilities = [];
      availability.forEach((day, data) {
        if (data['isToggled'] == true) {
          formattedAvailabilities.add({
            'day': day,
            'start_time': convertTo24HourFormat(data['startTime'] ?? ''),
            'end_time': convertTo24HourFormat(data['endTime'] ?? ''),
          });
        }
      });

      final response = await _businessListingService.editBusinessListing(
        serviceId: serviceId, // Pass the serviceId dynamically
        name: name,
        countryCode: countryCode,
        phoneNumber: phoneNumber,
        about: about,
        includes: includes,
        address: address,
        latitude: latitude,
        longitude: longitude,
        photos: photos,
        availabilities: formattedAvailabilities,
      );

      if (response.statusCode == 200 && response.data != null) {
        Get.snackbar(
          'Success',
          'Business listing updated successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );

        print("Response Data: ${response.data}");
      } else {
        Get.snackbar(
          'Error',
          response.data?['message'] ?? 'Failed to update business listing.',
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
