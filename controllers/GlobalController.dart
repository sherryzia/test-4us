import 'package:get/get.dart';
import 'package:quran_app/utilities/shared_preferences_util.dart';

class GlobalController extends GetxController {
  var userName = "".obs;
  var userCountry = "".obs;
  var userCity = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData(); // ✅ Load saved user data when controller initializes
  }

  void updateUserInfo(String name, String country, String city) {
    userName.value = name;
    userCountry.value = country;
    userCity.value = city;
  }

  // ✅ Load user data from SharedPreferences and update global variables
  Future<void> loadUserData() async {
    String? savedName = await SharedPreferencesUtil.getData<String>("user_name");
    String? savedCountry = await SharedPreferencesUtil.getData<String>("user_country");
    String? savedCity = await SharedPreferencesUtil.getData<String>("user_city");

    // ✅ Update only if data exists
    userName.value = savedName ?? "";
    userCountry.value = savedCountry ?? "";
    userCity.value = savedCity ?? "";

    print("🔄 User Data Loaded: $savedName, $savedCountry, $savedCity");
  }
}
