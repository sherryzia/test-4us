import 'package:candid/utils/rest_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:candid/utils/dio_util.dart';

class SignUpService {
  final String signupUrl = RestConstants.register;
  final String otpVerifyUrl = RestConstants.signupOtp;
  final String resendOtpUrl = RestConstants.resendOtp; // Add this to your RestConstants
  final Dio _dio = DioUtil.dio;

  // Initial signup - sends OTP
  Future<Response<dynamic>> signUp(String password, String phoneNumber) async {
    final response = await _dio.post(
      signupUrl,
      data: {
        'password': password,
        'phone_number': phoneNumber,
        'id': false, // Based on your example
      },
    );
    return response;
  }

  // Verify OTP - returns token and user data
  Future<Response<dynamic>> verifyOTP(String otpCode, String phoneNumber) async {
    final response = await _dio.post(
      otpVerifyUrl,
      data: {
        'code': otpCode,
        'phone_number': phoneNumber,
      },
    );
    return response;
  }

  // Resend OTP - only requires phone number
  Future<Response<dynamic>> resendOTP(String phoneNumber) async {
    final response = await _dio.post(
      resendOtpUrl,
      data: {
        'phone_number': phoneNumber,
      },
    );
    return response;
  }
}