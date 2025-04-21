import 'dart:convert';

import 'package:ecomanga/utils/utils.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RegisterController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool authSuccessful = false.obs;
  RxString errorMessage = "".obs;
  Map data = {};

  void register(
    String password,
    String firstName,
    String lastName,
    String username,
    String email,
    String phoneNo,
  ) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        (Urls.auth_register),
        body: jsonEncode(<String, String>{
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          "username": username,
          'email': email,
          'phoneNo': phoneNo,
          'role': 'user',
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      data = await json.decode(response.body);
      if (response.statusCode.toString()[0] == "2") {
        print(data);
        authSuccessful.value = true;
      } else {
        for (String message in data['message']) {
          message = message.replaceFirst(
              message.split('')[0], message.split('')[0].toUpperCase());
          print("Message is $message");
          errorMessage.value += "$message \n";
        }
      }
      print(data);
    } catch (e) {
      errorMessage.value = "Unable to create account. Please try again";
    }
    isLoading.value = false;
  }
}
