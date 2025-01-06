import 'package:get/get.dart';
import '../../../services/event_organizer/organizer_business_service.dart';

class GetEventTypesController extends GetxController {
  final OrganizerBusinessService _organizerService = OrganizerBusinessService();

  RxList<dynamic> services = <dynamic>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEventTypes();
  }

  Future<void> fetchEventTypes() async {
    try {
      isLoading.value = true;

      // Fetch services using the service
      final response = await _organizerService.fetchEventTypes();

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
