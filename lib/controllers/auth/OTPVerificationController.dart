import 'package:forus_app/view/auth/authentication_point.dart';
import 'package:get/get.dart';
import 'package:forus_app/services/auth/otp_verify_service.dart';

class OTPVerificationController extends GetxController {
  RxBool isLoading = false.obs;

  final OTPVerifyService _verifyOTPService = OTPVerifyService();

  Future<void> verifyOTP(String otp) async {
    isLoading.value = true;

    try {

      final response = await _verifyOTPService.verifyOTP(otp);

      // User is registered and OTP is verified, Send him to authenticationPoint.
      if(response.statusCode == 200 && !response.data.containsKey('errors')){
        Get.offAll(() => AuthenticationPoint());
      }
      else{
        Get.snackbar(
          'Error',
          '${response.data["message"]}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }

    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
}