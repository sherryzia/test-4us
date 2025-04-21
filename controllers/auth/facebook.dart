import 'package:ecomanga/utils/utils.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class FacebookController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool authSuccessful = false.obs;
  RxString errorMessage = "".obs;
  Map data = {};

  Future<List> login() async {
    isLoading.value = true;

    try {
      if (!await canLaunchUrl(Urls.auth_facebook)) {
        throw Exception('Could not launch ${Urls.auth_facebook}');
      }

      //Open in external app
      await launchUrl(
        Urls.auth_facebook,
        mode: LaunchMode.externalApplication,
      );

      // if (response.statusCode.toString()[0] == "2") {
      //   // auth successful
      //   authSuccessful.value = true;
      // } else {
      //   // response error handling
      //   errorMessage.value = data['message'];
      // }
    } catch (e) {
      // caught error handling
      errorMessage.value = e.toString();
    }

    // turn off loading
    isLoading.value = false;
    return [data['accessToken'], data['refreshToken']];
  }
}
