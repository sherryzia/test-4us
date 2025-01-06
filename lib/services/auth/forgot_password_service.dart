import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:forus_app/utils/rest_endpoints.dart';
import 'package:forus_app/utils/dio_util.dart';

class ForgotPasswordService {
  final String url = RestConstants.forgotPassword;
  final Dio _dio = DioUtil.dio;

  Future<Response<dynamic>> sendEmail(String email) async {
    final response = await _dio.post(
      url,
      data: {
        'email': email
      },
    );
    return response;
  }
}
