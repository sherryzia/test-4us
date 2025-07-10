import 'dart:io';
import 'package:candid/utils/rest_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:candid/utils/dio_util.dart';

class UserUpdateService {
  final String userEndpoint = RestConstants.user; // /api/v1/authentication/users/me/
  final Dio _dio = DioUtil.dio;

  // Update user profile with proper field handling
  Future<Response<dynamic>> updateUserProfile(
    Map<String, dynamic> profileData,
    File? profileImage,
  ) async {
    try {
      if (profileImage != null) {
        // Use multipart form data when image is provided
        FormData formData = FormData();
        
        // Add profile image
        String fileName = profileImage.path.split('/').last;
        formData.files.add(MapEntry(
          'profile_picture',
          await MultipartFile.fromFile(
            profileImage.path,
            filename: fileName,
          ),
        ));
        
        // Add other profile data to form data
        profileData.forEach((key, value) {
          if (value is List) {
            // Handle arrays properly for multipart
            for (int i = 0; i < value.length; i++) {
              formData.fields.add(MapEntry('$key[$i]', value[i].toString()));
            }
          } else if (value != null) {
            formData.fields.add(MapEntry(key, value.toString()));
          }
        });
        
        print('Sending multipart request with image');
        print('FormData fields: ${formData.fields.map((e) => '${e.key}: ${e.value}').join(', ')}');
        print('FormData files: ${formData.files.map((e) => e.key).join(', ')}');
        
        final response = await _dio.patch(
          userEndpoint,
          data: formData,
          options: Options(
            headers: {
              'Content-Type': 'multipart/form-data',
            },
          ),
        );
        
        return response;
      } else {
        // Use JSON when no image
        print('Sending JSON request without image');
        print('JSON data: $profileData');
        
        final response = await _dio.patch(
          userEndpoint,
          data: profileData,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );
        
        return response;
      }
    } catch (e) {
      print('Error in updateUserProfile: $e');
      if (e is DioException) {
        print('DioException details:');
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
        print('Request data: ${e.requestOptions.data}');
      }
      rethrow;
    }
  }

  // Get current user profile
  Future<Response<dynamic>> getCurrentUserProfile() async {
    try {
      final response = await _dio.get(
        userEndpoint,
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      print('Error getting user profile: $e');
      rethrow;
    }
  }

  // Update specific field only
  Future<Response<dynamic>> updateSingleField(String fieldName, dynamic value) async {
    try {
      final response = await _dio.patch(
        userEndpoint,
        data: {fieldName: value},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      print('Error updating field $fieldName: $e');
      rethrow;
    }
  }

  // Update multiple fields without image
  Future<Response<dynamic>> updateFields(Map<String, dynamic> fields) async {
    try {
      // Remove null values
      final cleanedFields = Map<String, dynamic>.from(fields);
      cleanedFields.removeWhere((key, value) => value == null);
      
      final response = await _dio.patch(
        userEndpoint,
        data: cleanedFields,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      print('Error updating fields: $e');
      rethrow;
    }
  }

  // Upload profile image only
  Future<Response<dynamic>> uploadProfileImageOnly(File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;
      
      FormData formData = FormData.fromMap({
        'profile_picture': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      final response = await _dio.patch(
        userEndpoint,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      return response;
    } catch (e) {
      print('Error uploading profile image: $e');
      rethrow;
    }
  }

  // Helper method to validate required fields based on your API
  bool validateProfileData(Map<String, dynamic> data) {
    // Add validation logic based on your API requirements
    if (data.containsKey('email') && data['email'] != null) {
      final email = data['email'].toString();
      if (!email.contains('@')) {
        throw Exception('Invalid email format');
      }
    }

    if (data.containsKey('name') && data['name'] != null) {
      final name = data['name'].toString().trim();
      if (name.isEmpty) {
        throw Exception('Name cannot be empty');
      }
    }

    return true;
  }
}