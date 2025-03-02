import 'package:get/get.dart';
import 'package:quran_app/config/theme/dark_theme.dart';
import 'package:quran_app/config/theme/light_theme.dart';
import 'package:quran_app/config/theme/user_prefences.dart';
class ThemeConfig extends GetxController {
  static ThemeConfig instance = Get.find<ThemeConfig>();
  RxBool isDarkTheme = false.obs;
  onToggle() {
    isDarkTheme.value = !isDarkTheme.value;
    isDarkTheme.value
        ? Get.changeTheme(darkTheme)
        : Get.changeTheme(lightTheme);
    UserPreferences.setTheme(
      isDarkTheme.value ? 'DARK_MODE' : 'LIGHT_MODE',
    );
  }
}
