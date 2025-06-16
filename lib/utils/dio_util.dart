// lib/utils/dio_util.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class DioUtil {
  // Create a single Dio instance with global configurations
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://electric-wrongly-troll.ngrok-free.app',
      contentType: 'application/json',
      headers: {
        'Accept': 'application/json',
        'x-api-key': '',
      },
      validateStatus: (status) {
        return status! < 500;
      },
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ),
  );

  // Initialize Dio with interceptors
  static void init() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (kDebugMode) {
          print("========= REQUEST - START ===========");
          print("Request URL: ${options.uri}");
          print("Request Method: ${options.method}");
          print("Request Headers: ${options.headers}");
          print("Request Data: ${options.data}");
          print("========= REQUEST - END ===========");
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        if (kDebugMode) {
          print("========= RESPONSE - START ===========");
          print('Response Status Code: [${response.statusCode}]');
          print(response.data);
          print("========= RESPONSE - END ===========");
        }
        return handler.next(response);
      },
      onError: (DioException exception, handler) {
        if (kDebugMode) {
          print("========= EXCEPTION - START ===========");
          print(exception);
          print(" ----- Exception Response Data -----");
          print(exception.response);
          print("========= EXCEPTION - END ===========");
        }
        return handler.next(exception);
      },
    ));
  }
  
  // Update token
  static void updateToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
    if (kDebugMode) {
      print("Token updated: $token");
    }
  }
  
  // Clear token
  static void clearToken() {
    dio.options.headers.remove('Authorization');
    if (kDebugMode) {
      print("Token cleared");
    }
  }
}