import 'dart:convert';

import 'package:ecomanga/controllers/controllers.dart';
import 'package:ecomanga/models/models.dart';
import 'package:ecomanga/utils/utils.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProfileController extends GetxController {
  RxMap<String, bool> isLoading = {
    keys.getUser: false,
    keys.getProfile: false,
  }.obs;
  RxMap<String, String> errorMessage = {
    keys.getUser: "",
    keys.getUser: "",
  }.obs;
  Map<dynamic, dynamic> data = {}.obs;
  User? user, profile;

  Future<void> getUser() async {
    isLoading[keys.getUser] = false;
    user = null;

    try {
      final uid = Controllers.prefController.uId;
      final response = await http.get(
        Uri.parse("${Urls.users}$uid"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Controllers.prefController.aTk}',
        },
      );
      data = await json.decode(response.body);

      if (response.statusCode == 200) {
        user = User.fromJson(data);
      } else {
        errorMessage[keys.getUser] = data['message'];
        throw Exception("Unauthorized");
      }
    } catch (e) {
      errorMessage[keys.getUser] = e.toString();
      throw Exception("Error");
    } finally {
      isLoading[keys.getUser] = false;
    }
  }

  void getProfile() async {
    isLoading[keys.getProfile] = true;

    try {
      final response = await http.get(
        Urls.profile,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Controllers.prefController.aTk}',
        },
      );
      print(response.statusCode);
      data = await json.decode(response.body);

      if (response.statusCode == 200) {
        print("Profile data: ${data['data']}");
        profile = User.fromJson(data['data']);
      } else {
        errorMessage[keys.getProfile] = data['message'];
        throw Exception("Unauthorized");
      }
    } catch (e) {
      errorMessage[keys.getProfile] = e.toString();
    } finally {
      isLoading[keys.getProfile] = false;
    }
  }
}
