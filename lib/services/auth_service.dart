// lib/services/auth_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:betting_app/controllers/global_controller.dart';
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
  
  // Helper method to update UserController directly
  void _updateUserController(Map<String, dynamic> userData) {
    try {
      // Check if UserController exists and update it directly
      if (Get.isRegistered<UserController>()) {
        final userController = Get.find<UserController>();
        userController.updateUserData(userData);
        print("🔄 UserController updated directly from AuthService");
      }
    } catch (e) {
      print("⚠️ UserController not found or error updating: $e");
    }
  }
  
  // Load user data and token from storage
  Future<bool> loadFromStorage() async {
    print("🔍 Loading from storage...");
    
    final prefs = await SharedPreferences.getInstance();
    
    // Load token
    final storedToken = prefs.getString(_tokenKey);
    print("📱 Stored token: ${storedToken?.substring(0, 20)}...");
    
    if (storedToken != null && storedToken.isNotEmpty) {
      // Set token first
      token.value = storedToken;
      DioUtil.updateToken(storedToken);
      print("🔑 Token set in DioUtil");
      
      // Add a small delay to ensure token is properly set
      await Future.delayed(Duration(milliseconds: 100));
      
      // Validate token
      try {
        print("🔍 Validating token...");
        final response = await DioUtil.dio.get('/api/user');
        print("✅ Token validation response: ${response.statusCode}");
        
        if (response.statusCode == 200) {
          // Load and update user data from response
          if (response.data != null) {
            user.value = response.data;
            // Also save updated user data to storage
            await prefs.setString(_userKey, json.encode(response.data));
            print("👤 User data loaded: ${user.value['email']}");
            
            // 🔥 DIRECTLY UPDATE USER CONTROLLER
            _updateUserController(response.data);
          }
          
          isLoggedIn.value = true;
          print("🎉 Authentication successful");
          return true;
        }
      } catch (e) {
        print("❌ Token validation failed: $e");
        await clearStorage();
      }
    } else {
      print("❌ No stored token found");
    }
    
    isLoggedIn.value = false;
    print("🚫 User not authenticated");
    return false;
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
    
    // Save user data and trigger reactive update
    if (userData != null) {
      await prefs.setString(_userKey, json.encode(userData));
      
      // Update AuthService user data
      user.value = Map<String, dynamic>.from(userData);
      print("💾 User data saved and updated reactively: ${userData['email']}");
      
      // 🔥 DIRECTLY UPDATE USER CONTROLLER
      _updateUserController(userData);
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
    
    // 🔥 CLEAR USER CONTROLLER DATA
    try {
      if (Get.isRegistered<UserController>()) {
        final userController = Get.find<UserController>();
        userController.clearUserData();
        print("🚫 UserController cleared directly from AuthService");
      }
    } catch (e) {
      print("⚠️ Error clearing UserController: $e");
    }
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
    } on dio.DioException catch (e) {
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

  // Update user profile - THE CRITICAL METHOD
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
        // 🔥 CRITICAL: Update local user data properly
        if (response.data['user'] != null) {
          print("✅ Profile update successful, updating local data");
          
          // Force reactive update by creating new map
          final updatedUserData = Map<String, dynamic>.from(response.data['user']);
          
          // Save to storage and trigger reactive updates
          await saveToStorage(userData: updatedUserData);
          
          // 🔥 DOUBLE CHECK: Force update UserController again
          await Future.delayed(Duration(milliseconds: 100));
          _updateUserController(updatedUserData);
          
          print("🔄 Local user data updated: ${updatedUserData['email']}");
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