import 'package:forus_app/utils/rest_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:forus_app/utils/dio_util.dart';

class ResetPasswordService {

  final String url = RestConstants.resetPassword;
  final Dio _dio = DioUtil.dio;

  Future<Response<dynamic>> resetPassword(otp, email, password, confirmPassword) async {
    final response = await _dio.post(
      url,
      data: {
        'otp': otp,
        'email': email,
        'password': password,
        'password_confirmation': confirmPassword
      },
    );
    return response;
  }
}
