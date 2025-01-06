import 'dart:io';
import 'package:dio/dio.dart';
import 'package:forus_app/utils/dio_util.dart';
import 'package:forus_app/utils/rest_endpoints.dart';

class OrganizerBusinessService {
  final Dio _dio = DioUtil.dio;

  Future<Response<dynamic>> checkEventOrganizerBusiness() async {
    final response = await _dio.get(RestConstants.checkEventOrganizerBusinessAvailability);
    return response;
  }

  Future<Response<dynamic>> fetchEventTypes() async {
    final response = await _dio.get(RestConstants.eventTypes);
    return response;
  }

  Future<Response<dynamic>> registerEventOrganizerBusiness({
    required String name,
    required String email,
    required String countryCode,
    required String phoneNumber,
    required String about,
    required String website,
    required String address,
    required double latitude,
    required double longitude,
    required List<File> businessPhotos, // List of file objects for images
  }) async {

    // Prepare FormData
    final formData = FormData.fromMap({
      'name': name,
      'email': email,
      'country_code': countryCode,
      'phone_number': phoneNumber,
      'about': about,
      'website': website,
      'address': address,
      'lat': latitude.toString(),
      'lng': longitude.toString(),
      'image': [
        for (File photo in businessPhotos)
          await MultipartFile.fromFile(
            photo.path,
            filename: photo.path.split('/').last,
          ),
      ],

    });

    // Make POST request
    final response = await _dio.post(
      RestConstants.registerEventOrganizerBusiness,
      data: formData,
    );
    return response;

  }
}