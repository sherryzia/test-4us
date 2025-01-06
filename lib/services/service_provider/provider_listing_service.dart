import 'dart:io';

import 'package:dio/dio.dart';
import 'package:forus_app/utils/dio_util.dart';
import 'package:forus_app/utils/rest_endpoints.dart';

class ProviderListingService {
  final Dio _dio = DioUtil.dio;


  Future<Response<dynamic>> fetchBusinessListings() async {
    final response = await _dio.get(RestConstants.businessListing);
    return response;
  }

  Future<Response<dynamic>> fetchListingDetail(int serviceId) async {
    final response = await _dio.get('${RestConstants.businessListing}/$serviceId');
    return response;
  }

  Future<Response<dynamic>> editBusinessListing({
    required String serviceId,
    required String name,
    required String countryCode,
    required String phoneNumber,
    required String about,
    required List<String> includes,
    required String address,
    required double latitude,
    required double longitude,
    required List<File>? photos,
    required List<Map<String, String>> availabilities,
  }) async {
    // Prepare FormData
    final formData = FormData.fromMap({
      '_method': "PUT",
      'name': name,
      'country_code': countryCode,
      'phone_number': phoneNumber,
      'about': about,
      'address': address,
      'lat': latitude.toString(),
      'lng': longitude.toString(),
      for (int i = 0; i < includes.length; i++) 'includes[$i]': includes[i],
      for (int i = 0; i < availabilities.length; i++) ...{
        'availabilities[$i][day]': availabilities[i]['day']!,
        'availabilities[$i][start_time]': availabilities[i]['start_time']!,
        'availabilities[$i][end_time]': availabilities[i]['end_time']!,
      },
    });

    if (photos != null && photos.isNotEmpty) {
      formData.files.addAll([
        for (File photo in photos)
          MapEntry(
            'image',
            await MultipartFile.fromFile(
              photo.path,
              filename: photo.path.split('/').last,
            ),
          ),
      ]);
    }

    print("FormData Fields: ${formData.fields}");
    print("FormData Files: ${formData.files}");

    // Send request
    final response = await _dio.post(
      "${RestConstants.businessListing}/$serviceId",
      data: formData,
    );

    return response;
  }


  Future<Response> deleteBusinessListing(String serviceId) async {
    final response = await _dio.request(
      "${RestConstants.businessListing}/$serviceId",
      options: Options(method: 'DELETE'),
    );

    return response; // Return the response to the controller
  }

  Future<Response<dynamic>> createBusinessListing({
    required String name,
    required String countryCode,
    required String phoneNumber,
    required String about,
    required List<String> includes,
    required String address,
    required double latitude,
    required double longitude,
    required List<File> photos,
    required List<Map<String, String>> availabilities,
  }) async {
    // Prepare FormData
    final formData = FormData.fromMap({
      'name': name,
      'country_code': countryCode,
      'phone_number': phoneNumber,
      'about': about,
      'address': address,
      'lat': latitude.toString(),
      'lng': longitude.toString(),
      'image': [
        for (File photo in photos)
          await MultipartFile.fromFile(
            photo.path,
            filename: photo.path.split('/').last,
          ),
      ],
      for (int i = 0; i < includes.length; i++) 'includes[$i]': includes[i],
      for (int i = 0; i < availabilities.length; i++) ...{
        'availabilities[$i][day]': availabilities[i]['day']!,
        'availabilities[$i][start_time]': availabilities[i]['start_time']!,
        'availabilities[$i][end_time]': availabilities[i]['end_time']!,
      },
    });

    // Debugging logs
    print("FormData Fields: ${formData.fields}");
    print("FormData Files: ${formData.files}");

    // Make the POST request
    final response = await _dio.post(
      RestConstants.businessListing, // Define this in RestConstants
      data: formData,
    );
    return response;
  }


}