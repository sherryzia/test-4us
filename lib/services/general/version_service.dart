import 'package:dio/dio.dart';
import 'package:forus_app/utils/dio_util.dart';
import 'package:forus_app/utils/rest_endpoints.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:get/get.dart';

class VersionService {
  final String url = RestConstants.versionChecker;
  final Dio _dio = DioUtil.dio;

  Future<Map<String, dynamic>> checkAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      final response = await _dio.post(
        url,
        data: {
          'platform': GetPlatform.isIOS ? 'ios' : 'android',
          'version': packageInfo.version,
        },
      );

      return response.data;

    } catch (e) {
      throw Exception("Error in checkAppVersion: $e");
    }
  }
}






// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:forus_app/utils/rest_endpoints.dart';
// import 'package:dio/dio.dart';
// import 'package:forus_app/utils/dio_util.dart';
// import 'package:get/get.dart';
// import 'package:package_info_plus/package_info_plus.dart';

// class VersionService {
//   final String url = RestConstants.versionChecker;
//   final Dio _dio = DioUtil.dio;

//   Future<Map<String, dynamic>> checkAppVersion() async {
//     try {
//       PackageInfo packageInfo = await PackageInfo.fromPlatform();

//       final response = await _dio.post(
//         url,
//         data: {
//           'platform': GetPlatform.isIOS ? 'ios' : 'android',
//           'version': packageInfo.version
//         },
//       );
//       return response.data;

//     } catch (e) {
//       throw Exception(e);
//     }
//   }
// }
