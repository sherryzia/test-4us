import 'package:forus_app/utils/rest_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:forus_app/utils/dio_util.dart';

class SignUpService {
  final String url = RestConstants.register;
  final Dio _dio = DioUtil.dio;

  Future<Response<dynamic>> signUp(name, email, password, confirmPassword, terms, userType, countryCode, phoneNumber) async {
    final response = await _dio.post(
      url,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': confirmPassword,
        'terms': terms,
        'user_type': userType,
        'country_code': countryCode,
        'phone_number': phoneNumber
      },
    );
    return response;
  }
}
