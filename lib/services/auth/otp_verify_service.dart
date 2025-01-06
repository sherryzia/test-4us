import 'package:forus_app/utils/rest_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:forus_app/utils/dio_util.dart';

class OTPVerifyService {
  final String url = RestConstants.verifyOTP;
  final Dio _dio = DioUtil.dio;

  Future<Response<dynamic>> verifyOTP(otp) async {
    try {

      final response = await _dio.post(
        url,
        data: {
          'otp': otp,
        },
      );
      return response;

    } catch (e) {
      throw Exception(e);
    }
  }
}
