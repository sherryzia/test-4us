import 'dart:developer';
import 'package:get/get.dart';

import '../../main.dart';
import '../../model/user_model.dart';

class ChooseUserController extends GetxController {
  static final ChooseUserController instance = Get.find<ChooseUserController>();

  RxInt currentIndex = 2.obs;
  // var users = [].obs;
  // var users = <UserModel>[].obs;
  // RxString username = ''.obs;
  // RxString first_name = ''.obs;
  // RxString last_name = ''.obs;
  // RxString image_url = ''.obs;
  var isLoading = false.obs;
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  var users = <UserModel>[].obs;

  void onSelect(int index) {
    currentIndex.value = index;
    log(currentIndex.value.toString());
  }

  @override
  void onInit() {
    super.onInit();
    print("ChooseUserController initialized");
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    isLoading.value = true;
    try {
      final response = await supabase.from('users').select();
      print("Raw response: $response");

      if (response != null && response.isNotEmpty) {
        users.value =
            response.map<UserModel>((item) => UserModel.fromMap(item)).toList();

        // Set the first user as the current user
        currentUser.value = users.first;
        print("Users fetched successfully: $users");
      } else {
        print("No users found.");
      }
    } catch (e) {
      print("Error fetching users: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
