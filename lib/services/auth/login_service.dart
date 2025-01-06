import 'package:dio/dio.dart';
import 'package:forus_app/utils/rest_endpoints.dart';
import 'package:forus_app/utils/dio_util.dart';

class LoginService {
  final String url = RestConstants.login;
  final Dio _dio = DioUtil.dio;

  Future<Response<dynamic>> login(String email, String password) async {
    final response = await _dio.post(
      url,
      data: {
        'email': email,
        'password': password,
      },
    );

    return response;

  }
}
