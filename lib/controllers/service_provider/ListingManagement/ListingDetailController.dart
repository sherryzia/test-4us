import 'package:get/get.dart';
import '../../../services/service_provider/provider_listing_service.dart';

class ListingDetailController extends GetxController {
  final ProviderListingService _service = ProviderListingService();

  RxBool isLoading = false.obs;
  RxMap<String, dynamic> businessDetail = <String, dynamic>{}.obs;

  Future<void> fetchBusinessDetail(int serviceId) async {
    isLoading.value = true;

    try {
      final response = await _service.fetchListingDetail(serviceId);
      if (response.statusCode == 200 && response.data != null) {
        businessDetail.value = response.data['data'];
      } else {
        Get.snackbar('Error', response.data?['message'] ?? 'Failed to fetch details.',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
