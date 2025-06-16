// lib/services/auth_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:betting_app/utils/dio_util.dart';

class AuthService extends GetxService {
  final RxBool isLoggedIn = false.obs;
  final RxString token = ''.obs;
  final RxMap<String, dynamic> user = RxMap<String, dynamic>();
  
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  
  @override
  void onInit() {
    super.onInit();
    loadFromStorage();
  }
  
  // Load user data and token from storage
  Future<void> loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load token
    final storedToken = prefs.getString(_tokenKey);
    if (storedToken != null && storedToken.isNotEmpty) {
      token.value = storedToken;
      isLoggedIn.value = true;
      
      // Update DioUtil with token
      DioUtil.updateToken(storedToken);
    }
    
    // Load user data
    final storedUser = prefs.getString(_userKey);
    if (storedUser != null && storedUser.isNotEmpty) {
      try {
        user.value = json.decode(storedUser) as Map<String, dynamic>;
      } catch (e) {
        print("Error parsing stored user data: $e");
      }
    }
  }
  
  // Save data to storage
  Future<void> saveToStorage({String? newToken, Map<String, dynamic>? userData}) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Save token
    if (newToken != null && newToken.isNotEmpty) {
      await prefs.setString(_tokenKey, newToken);
      token.value = newToken;
      
      // Update DioUtil with token
      DioUtil.updateToken(newToken);
    }
    
    // Save user data
    if (userData != null) {
      await prefs.setString(_userKey, json.encode(userData));
      user.value = userData;
    }
    
    isLoggedIn.value = true;
  }
  
  // Clear storage on logout
  Future<void> clearStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    
    token.value = '';
    user.clear();
    isLoggedIn.value = false;
    
    // Clear token from DioUtil
    DioUtil.clearToken();
  }
  
  // Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      var data = json.encode({
        "login": email,
        "password": password
      });
      
      var response = await DioUtil.dio.request(
        '/api/login',
        options: dio.Options(
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'x-api-key': ''
          },
        ),
        data: data,
      );
      
      if (response.statusCode == 200) {
        final responseData = response.data;
        
        // Save token and user data
        if (responseData['token'] != null) {
          await saveToStorage(
            newToken: responseData['token'],
            userData: responseData['user'],
          );
        }
        
        return {
          'success': true,
          'message': 'Login successful',
          'data': responseData
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Login failed',
          'data': response.data
        };
      }
    } on dio.DioException catch (e) {
      return _handleDioError(e, 'Login failed');
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred: ${e.toString()}',
        'data': null
      };
    }
  }
  
  // Register
  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      var data = json.encode({
        "first_name": firstName,
        "last_name": lastName,
        "phone": phone,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation
      });
      
      var response = await DioUtil.dio.request(
        '/api/register',
        options: dio.Options(
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'x-api-key': ''
          },
        ),
        data: data,
      );
      
      if (response.statusCode == 200) {
        final responseData = response.data;
        
        // Save token and user data if available
        if (responseData['token'] != null) {
          await saveToStorage(
            newToken: responseData['token'],
            userData: responseData['user'],
          );
        }
        
        return {
          'success': true,
          'message': 'Registration successful',
          'data': responseData
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Registration failed',
          'data': response.data
        };
      }
    } on dio. DioException catch (e) {
      return _handleDioError(e, 'Registration failed');
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred: ${e.toString()}',
        'data': null
      };
    }
  }
  
  // Logout
  // lib/services/auth_service.dart

// Update the logout method to call the API
Future<Map<String, dynamic>> logout() async {
  try {
    // Make API call to logout
    var response = await DioUtil.dio.request(
      '/api/user/logout',
      options: dio.Options(
        method: 'POST',
        headers: {
          'Accept': 'application/json',
          'x-api-key': '',
        },
      ),
    );
    
    // Clear local storage regardless of API response
    await clearStorage();
    
    if (response.statusCode == 200) {
      return {
        'success': true,
        'message': 'Logout successful',
        'data': response.data
      };
    } else {
      return {
        'success': false,
        'message': response.data['message'] ?? 'Logout failed',
        'data': response.data
      };
    }
  } catch (e) {
    print("Error during logout: $e");
    // Still clear storage even if API call fails
    await clearStorage();
    
    return {
      'success': true,
      'message': 'Logged out locally',
      'data': null
    };
  }
}

  Future<Map<String, dynamic>> updateUserProfile(Map<String, dynamic> userData) async {
  try {
    var formData = dio.FormData();

    // Add fields if provided
    if (userData['first_name'] != null) {
      formData.fields.add(MapEntry('first_name', userData['first_name']));
    }
    if (userData['last_name'] != null) {
      formData.fields.add(MapEntry('last_name', userData['last_name']));
    }
    if (userData['phone'] != null) {
      formData.fields.add(MapEntry('phone', userData['phone']));
    }
    if (userData['email'] != null) {
      formData.fields.add(MapEntry('email', userData['email']));
    }

    // Add profile image if provided
    if (userData['profile_image'] != null) {
      File imageFile = userData['profile_image'];
      formData.files.add(
        MapEntry(
          'files',
          await dio.MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last
          )
        )
      );
    }

    var response = await DioUtil.dio.request(
      '/api/user',
      options: dio.Options(
        method: 'POST',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        },
      ),
      data: formData,
    );
    
    if (response.statusCode == 200) {
      // Update local user data
      if (response.data['user'] != null) {
        await saveToStorage(userData: response.data['user']);
      }
      
      return {
        'success': true,
        'message': 'Profile updated successfully',
        'data': response.data
      };
    } else {
      return {
        'success': false,
        'message': response.data['message'] ?? 'Failed to update profile',
        'data': response.data
      };
    }
  } on dio.DioException catch (e) {
    return _handleDioError(e, 'Failed to update profile');
  } catch (e) {
    return {
      'success': false,
      'message': 'An unexpected error occurred: ${e.toString()}',
      'data': null
    };
  }
}

// Delete user account
Future<Map<String, dynamic>> deleteAccount(String password) async {
  try {
    var data = json.encode({
      "password": password,
      "confirm_deletion": true
    });
    
    var response = await DioUtil.dio.request(
      '/api/user/delete',
      options: dio.Options(
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
      data: data,
    );
    
    if (response.statusCode == 200) {
      // Clear local storage
      await clearStorage();
      
      return {
        'success': true,
        'message': 'Account deleted successfully',
        'data': response.data
      };
    } else {
      return {
        'success': false,
        'message': response.data['message'] ?? 'Failed to delete account',
        'data': response.data
      };
    }
  } on dio.DioException catch (e) {
    return _handleDioError(e, 'Failed to delete account');
  } catch (e) {
    return {
      'success': false,
      'message': 'An unexpected error occurred: ${e.toString()}',
      'data': null
    };
  }
}

// Get current user data
Map<String, dynamic> getUserData() {
  return user.value;
}
  // Helper method to handle Dio errors
  Map<String, dynamic> _handleDioError(dio.DioException e, String defaultMessage) {
    if (e.response != null) {
      // Server responded with an error
      final statusCode = e.response!.statusCode;
      final responseData = e.response!.data;
      
      String message = defaultMessage;
      if (responseData != null && responseData['message'] != null) {
        message = responseData['message'];
      }
      
      // Handle validation errors
      Map<String, dynamic>? validationErrors;
      if (statusCode == 422 && responseData != null && responseData['errors'] != null) {
        validationErrors = responseData['errors'];
      }
      
      return {
        'success': false,
        'message': message,
        'data': responseData,
        'validation_errors': validationErrors,
      };
    } else {
      // Connection errors, timeouts, etc.
      String message;
      switch (e.type) {
        case dio.DioExceptionType.connectionTimeout:
        case dio.DioExceptionType.sendTimeout:
        case dio.DioExceptionType.receiveTimeout:
          message = 'Connection timed out. Please check your internet connection.';
          break;
        case dio.DioExceptionType.connectionError:
          message = 'No internet connection.';
          break;
        default:
          message = defaultMessage;
      }
      
      return {
        'success': false,
        'message': message,
        'data': null
      };
    }
  }
}