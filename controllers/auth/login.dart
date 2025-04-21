import 'dart:convert';
import 'package:ecomanga/controllers/controllers.dart';
import 'package:ecomanga/utils/utils.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool authSuccessful = false.obs;
  RxString errorMessage = "".obs;
  Map data = {};

  Future<Map> refreshAuth() async {
    try {

      final response = await http.post(
        Urls.auth_refresh,
        body: {"refreshToken": Controllers.prefController.rTk},
      );
      data = await json.decode(response.body);
      if (response.statusCode == 200) {
        Controllers.prefController.refrsh(data["accessToken"]);
      }
    } catch (e) {
      throw Exception("Unable to refresh");
    }
    return data;
  }

  Future<void> login({required String password, required String email}) async {
    isLoading.value = true;

    try {
      // POST REQUEST
      final response = await http.post(
        Urls.auth_login,
        body: {"email": email, "password": password},
      );
      data = await json.decode(response.body);
      print('data $data');

      if (response.statusCode.toString()[0] == "2") {
        // auth successful
        authSuccessful.value = true;
        Controllers.prefController.login(
          data['accessToken'],
          data['refreshToken'],
          data['userId'],
        );
      } else {
        // response error handling
        errorMessage.value = data['message'];
      }
    } catch (e) {
      // caught error handling
      errorMessage.value = e.toString();
    }

    // turn off loading
    isLoading.value = false;
  }
}
