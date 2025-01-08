import 'package:get/get.dart';
import 'package:swim_strive/controller/user/CompleteProfileController.dart';
import 'package:swim_strive/controller/authentication/AuthController.dart';

class AccInfoController extends GetxController {
  final CompleteProfileController completeProfileController = Get.find<CompleteProfileController>();
  final AuthController authController = Get.find<AuthController>();

  RxBool isRefreshing = false.obs;

  Future<void> refreshProfile() async {
    try {
      isRefreshing.value = true;

      // Bust network image cache
      final currentImageUrl = completeProfileController.dpUrl.value;
      completeProfileController.dpUrl.value = ""; // Temporarily clear the URL
      await Future.delayed(const Duration(milliseconds: 100)); // Allow UI to update
      completeProfileController.dpUrl.value = currentImageUrl;

      // Fetch updated profile details
      await completeProfileController.fetchUserProfile(authController.uid.value);
    } catch (e) {
      print("Error refreshing profile: $e");
    } finally {
      isRefreshing.value = false;
    }
  }
}
