
import 'package:forus_app/utils/shared_preferences_util.dart';
import 'package:forus_app/view/auth/authentication_point.dart';
import 'package:forus_app/view/auth/login_screen.dart';
import 'package:get/get.dart';
import 'package:forus_app/services/general/version_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'GlobalController.dart';

class SplashController extends GetxController {
  var isLoading = true.obs;
  var updateMessage = ''.obs;
  var forceUpdate = false.obs;

  final VersionService _versionService = VersionService();

  @override
  void onInit() {
    super.onInit();
    checkAppVersion();
  }

  Future<void> checkAppVersion() async {
    try {
      final response = await _versionService.checkAppVersion();

      final latestVersion = response['latest_version'];
      final forceUpdateFlag = response['force_update'] == 1;

      if (await _isNewVersion(latestVersion)) {
        _forceUpdate(forceUpdateFlag);
      } else {
        updateMessage.value = 'Your app is up to date';
      }

      // Import from existing shared preferences
      final globalController = Get.find<GlobalController>();
      globalController.loadFromSharedPreferences();

      // Temporary Logout Code.
      // SharedPreferencesUtil.removeData("authToken");

      SharedPreferencesUtil.getData<String>("authToken").then((result) {
        if (result == null){
          // Navigate to Login Screen.
          Get.offAll(() => LoginScreen());
        }
        else{
          Get.offAll(() => AuthenticationPoint());
        }
      });

    } catch (e) {
      updateMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> _isNewVersion(String latestVersion) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;  // Your current version
    return currentVersion.compareTo(latestVersion) < 0;
  }

  void _forceUpdate(bool flag) {
    forceUpdate.value = flag;
    updateMessage.value = flag
        ? 'A new version is available. Please update.'
        : 'A new version is available. Update when you can.';
  }
}
