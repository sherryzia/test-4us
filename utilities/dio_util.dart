import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'shared_preferences_util.dart';
import 'package:quran_app/utilities/rest_endpoints.dart';
import 'dart:convert';

class DioUtil {
  // Create a single Dio instance with global configurations
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: RestConstants.baseUrl, // Set the base URL if needed
      headers: {
        'Accept': 'application/json', // Default to application/json for all requests
      },
      validateStatus: (status) {
        return status! < 500; // Accept all status codes below 500 as valid
      },
    ),
  );

  // Initialize Dio with interceptors
  static void init() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Check if the auth token is stored in SharedPreferences
        final authToken = await SharedPreferencesUtil.getData<String>('authToken');
        if (authToken != null && authToken.isNotEmpty) {
          // Add Bearer token to Authorization header
          options.headers['Authorization'] = 'Bearer $authToken';
        }

        if (kDebugMode) {
          print("========= REQUEST - START ===========");
          print("Request URL: ${options.uri}");
          print("Request Method: ${options.method}");
          print("Request Headers: ${options.headers}");
          print("Request Data: ${options.data}");
          print("========= REQUEST - END ===========");
        }

        // You can modify the request here if necessary (e.g., add common params)
        return handler.next(options); // Continue with the request
      },
      onResponse: (response, handler) {
        if (kDebugMode) {
          print("========= RESPONSE - START ===========");
          print('Response Status Code: [${response.statusCode}]');
          print(response.data);
          print("========= RESPONSE - END ===========");
        }

        // Split concatenated JSON objects - Rectify DIO error of sending request body with the response body.
        String rawResponse = response.data.toString();
        List<String> jsonParts = rawResponse.split('}{');
        if (jsonParts.length > 1) {
          jsonParts[0] += '}'; // Fix the first JSON object
          jsonParts[1] = '{' + jsonParts[1]; // Fix the second JSON object
          // Parse the second JSON object containing version info
          response.data = json.decode(jsonParts[1]) as Map<String, dynamic>;
        }

        if (response.statusCode == 200) {
          // Handle responses if needed
          return handler.next(response); // Continue with the response
        } else {
          // Create a Snack
          if (response.statusCode == 422) {
            Get.snackbar('Error', response.data['message'] ?? 'An error occurred while handling your request.', snackPosition: SnackPosition.BOTTOM);
            return handler.next(response); // Continue with the response
          } else {
            throw DioException(
              requestOptions: response.requestOptions,
              response: response,
              error: response.data,
            );
          }
        }
      },
      onError: (DioException exception, handler) {
        if (kDebugMode) {
          print("========= EXCEPTION - START ===========");
          print(exception);
          print("========= EXCEPTION - END ===========");
        }

        // Handle errors globally, e.g., logging, error alerts
        return handler.next(exception); // Continue with the error
      },
    ));
  }
}
