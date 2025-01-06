import 'package:get/get.dart';
import '../../../services/service_provider/provider_business_service.dart';

class GetServicesController extends GetxController {
  final BusinessService _providerService = BusinessService();

  RxList<dynamic> services = <dynamic>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }

  Future<void> fetchServices() async {
    try {
      isLoading.value = true;

      // Fetch services using the service
      final response = await _providerService.fetchServicesTypes();

      if(response.statusCode == 200 && response.data['data'] is List){
        services.value = response.data['data'] as List<dynamic>;
      }

    } catch (e) {
      Get.snackbar('Error', '$e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
