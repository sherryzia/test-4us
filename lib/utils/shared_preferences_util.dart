import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  // Generic function to save data to SharedPreferences
  static Future<void> saveData<T>(String key, T value) async {
    final prefs = await SharedPreferences.getInstance();

    if (T == String) {
      await prefs.setString(key, value as String);
    } else if (T == int) {
      await prefs.setInt(key, value as int);
    } else if (T == bool) {
      await prefs.setBool(key, value as bool);
    } else if (T == double) {
      await prefs.setDouble(key, value as double);
    } else if (T == List<String>) {
      await prefs.setStringList(key, value as List<String>);
    } else if (T == Map<String, dynamic>) {
      await prefs.setString(key, jsonEncode(value)); // Save as JSON string
    } else {
      throw Exception("Unsupported data type");
    }
  }

  // Generic function to get data from SharedPreferences
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
    } else if (T == Map<String, dynamic>) {
      String? jsonString = prefs.getString(key);
      if (jsonString != null) {
        return jsonDecode(jsonString) as T?;
      }
    }

    return null; // If data is not found or not supported
  }

  static Future<bool> containsKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  // Generic function to remove data from SharedPreferences
  static Future<void> removeData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  // Function to remove all data stored in SharedPreferences
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
