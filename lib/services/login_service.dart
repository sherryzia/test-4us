import 'package:candid/utils/rest_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:candid/utils/dio_util.dart';

class LoginService {
  final String loginUrl = RestConstants.login;
  final String otpVerifyUrl = RestConstants.signupOtp; // Same OTP verification endpoint
  final String resendOtpUrl = RestConstants.resendOtp; // Same resend endpoint
  final String userDataUrl = RestConstants.user; // User data endpoint
  final String logoutUrl = RestConstants.logout; // Add logout endpoint
  final Dio _dio = DioUtil.dio;

  // Login
  Future<Response<dynamic>> login(String password, String phoneNumber) async {
    final response = await _dio.post(
      loginUrl,
      data: {
        'password': password,
        'phone_number': phoneNumber,
        'token': false, // Based on your example
      },
    );
    return response;
  }

  // Verify OTP (reuse signup OTP verification)
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

  // Resend OTP (reuse signup resend OTP)
  Future<Response<dynamic>> resendOTP(String phoneNumber) async {
    final response = await _dio.post(
      resendOtpUrl,
      data: {
        'phone_number': phoneNumber,
      },
    );
    return response;
  }

  // Fetch user data
  Future<Response<dynamic>> fetchUserData() async {
    final response = await _dio.get(userDataUrl);
    return response;
  }

  // Logout
  Future<Response<dynamic>> logout() async {
    try {
      final response = await _dio.post(
        logoutUrl,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            // Authorization header will be automatically added by DioUtil interceptor
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      // Handle Dio-specific errors
      print('Logout DioException: ${e.response?.statusCode} - ${e.message}');
      rethrow;
    } catch (e) {
      // Handle any other errors
      print('Logout error: $e');
      rethrow;
    }
  }

  // Logout with explicit token (in case you need to pass token manually)
  Future<Response<dynamic>> logoutWithToken(String token) async {
    try {
      final response = await _dio.post(
        logoutUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      print('Logout with token DioException: ${e.response?.statusCode} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Logout with token error: $e');
      rethrow;
    }
  }
}