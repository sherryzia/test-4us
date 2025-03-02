import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  // ✅ Save String, int, bool, double, List<String>, List<Map<String, dynamic>>
  static Future<void> saveData<T>(String key, T value) async {
    final prefs = await SharedPreferences.getInstance();

    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    } else if (value is List<Map<String, dynamic>>) {
      // ✅ Convert List<Map<String, dynamic>> to List<String>
      List<String> jsonList = value.map((map) => jsonEncode(map)).toList();
      await prefs.setStringList(key, jsonList);
    } else {
      throw Exception("Unsupported data type: ${value.runtimeType}");
    }
  }

  // ✅ Get Data: String, int, bool, double, List<String>, List<Map<String, dynamic>>
  static Future<T?> getData<T>(String key) async {
    final prefs = await SharedPreferences.getInstance();

    if (T == String) {
      return prefs.getString(key) as T?;
    } else if (T == int) {
      return prefs.getInt(key) as T?;
    } else if (T == bool) {
      return prefs.getBool(key) as T?;
    } else if (T == double) {
      return prefs.getDouble(key) as T?;
    } else if (T == List<String>) {
      return prefs.getStringList(key) as T?;
    } else if (T == List<Map<String, dynamic>>) {
      List<String>? jsonList = prefs.getStringList(key);
      if (jsonList != null) {
        return jsonList.map((json) => jsonDecode(json) as Map<String, dynamic>).toList() as T;
      }
    }

    return null; // If data is not found or not supported
  }

  // ✅ Check if key exists
  static Future<bool> containsKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  // ✅ Remove Data
  static Future<void> removeData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  // ✅ Clear All Data
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
