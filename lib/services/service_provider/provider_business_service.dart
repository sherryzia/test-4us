import 'dart:io';

import 'package:dio/dio.dart';
import 'package:forus_app/utils/dio_util.dart';
import 'package:forus_app/utils/rest_endpoints.dart';

class BusinessService {
  final Dio _dio = DioUtil.dio;

  Future<Response<dynamic>> checkServiceProviderBusiness() async {
    final response = await _dio.get(RestConstants.checkServiceProviderBusinessAvailability);
    return response;
  }

  Future<Response<dynamic>> fetchServicesTypes() async {
    final response = await _dio.get(RestConstants.services);
    return response;
  }

  Future<Response<dynamic>> registerServiceProviderBusiness({
    required List<String> serviceTypes,
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
      for (int i = 0; i < serviceTypes.length; i++)
        'service_type[$i]': serviceTypes[i],
    });

    // Make POST request
    final response = await _dio.post(
      RestConstants.registerServiceProviderBusiness,
      data: formData,
    );
    return response;

  }
}
