import 'package:flutter/material.dart';
import 'package:forus_app/generated/assets.dart';
import 'package:forus_app/view/widget/common_image_view_widget.dart';
import 'package:get/get.dart';
import '../../../services/service_provider/provider_listing_service.dart';

class GetBusinessListingController extends GetxController {
  final ProviderListingService _businessListingService = ProviderListingService();

  RxBool isLoading = false.obs;
  RxList<dynamic> businessListings = <dynamic>[].obs;
  RxList<dynamic> filteredServices = <dynamic>[].obs;
  RxString searchQuery = ''.obs;
  var bannerCount=0.obs;

  List<Widget> buildBanners() {
  final banners = [
    Assets.imagesImageHome,
    Assets.imagesImageHome,
    Assets.imagesImageHome,
    Assets.imagesImageHome,
  ]; // Replace with dynamic banner data if needed

bannerCount.value = banners.length;
  return banners.map((banner) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 10, top: 10, bottom: 10, right: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20), // Adjust radius as needed
        child: CommonImageView(
          imagePath: banner,
        ),
      ),
    );
  }).toList();
}

  Future<void> fetchBusinessListings() async {
    isLoading.value = true;
    try {
      final response = await _businessListingService.fetchBusinessListings();
      if (response.statusCode == 200 && response.data != null) {
        businessListings.value = response.data['data'];
        filteredServices.value = businessListings; // Initialize filtered services
      } else {
        Get.snackbar('Error', response.data?['message'] ?? 'Failed to fetch business listings');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }


}
