// lib/utils/auth_util.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:betting_app/utils/dio_util.dart';

class AuthUtil {
  // Login method
  static Future<bool> login() async {
    try {
      var data = json.encode({
        "login": "test@example.com",
        "password": "password"
      });
      
      var response = await DioUtil.dio.request(
        '/api/login',
        options: Options(
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'x-api-key': ''
          },
        ),
        data: data,
      );
      
      if (response.statusCode == 200 && response.data['token'] != null) {
        final token = response.data['token'];
        
        // Update the token in DioUtil
        DioUtil.updateToken(token);
        
        if (kDebugMode) {
          print("Login successful, token updated");
        }
        
        return true;
      }
      
      return false;
    } catch (e) {
      if (kDebugMode) {
        print("Login failed: $e");
      }
      return false;
    }
  }
  
  // Method to initialize authentication
  static Future<void> initialize() async {
    try {
      final success = await login();
      
      if (!success) {
        if (kDebugMode) {
          print("Using default token since login failed");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Auth initialization failed: $e");
        print("Using default token");
      }
    }
  }
}