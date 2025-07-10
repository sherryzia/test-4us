import 'dart:io';
import 'package:candid/utils/rest_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:candid/utils/dio_util.dart';

class ProfileService {
  final String userProfileUrl = RestConstants.user; // /api/v1/authentication/users/me/
  final Dio _dio = DioUtil.dio;

  // Update user profile with multipart support for image
  Future<Response<dynamic>> updateProfile(
    Map<String, dynamic> profileData,
    File? profileImage,
  ) async {
    
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
      
      // Add other profile data
      profileData.forEach((key, value) {
        if (value is List) {
          // Handle arrays (interests, preferences)
          for (int i = 0; i < value.length; i++) {
            formData.fields.add(MapEntry('$key[$i]', value[i].toString()));
          }
        } else {
          formData.fields.add(MapEntry(key, value.toString()));
        }
      });
      
      final response = await _dio.patch(
        userProfileUrl,
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
      final response = await _dio.patch(
        userProfileUrl,
        data: profileData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      
      return response;
    }
  }

  // Get user profile data
  Future<Response<dynamic>> getUserProfile() async {
    final response = await _dio.get(userProfileUrl);
    return response;
  }

  // Update specific profile field
  Future<Response<dynamic>> updateProfileField(String field, dynamic value) async {
    final response = await _dio.patch(
      userProfileUrl,
      data: {field: value},
    );
    return response;
  }

  // Upload profile image only
  Future<Response<dynamic>> uploadProfileImage(File imageFile) async {
    String fileName = imageFile.path.split('/').last;
    
    FormData formData = FormData.fromMap({
      'profile_picture': await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
      ),
    });

    final response = await _dio.patch(
      userProfileUrl,
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    return response;
  }
}