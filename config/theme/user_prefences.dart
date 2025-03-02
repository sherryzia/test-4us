import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static SharedPreferences? pref;
  static const _themeKey = 'themeKey';
  static Future init() async {
    pref = await SharedPreferences.getInstance();
  }

  static Future setTheme(String theme) async {
    await init(); // Ensure initialization before usage
    await pref!.setString(_themeKey, theme);
  }

  static Future<String?> getTheme() async {
    await init(); // Ensure initialization before usage
    return pref!.getString(_themeKey);
  }
}
