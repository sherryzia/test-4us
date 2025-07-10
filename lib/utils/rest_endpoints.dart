class RestConstants {
  static const String baseUrl = 'http://ec2-13-42-45-154.eu-west-2.compute.amazonaws.com';

  static const String login = '/api/v1/authentication/login/';
  static const String register = '/api/v1/authentication/users/';
  static const String logout = '/api/v1/authentication/logout/';
  static const String user = '/api/v1/authentication/users/me/';
  static const String signupOtp = '/api/v1/authentication/users/signup-otp-verify/';

  static const String resendOtp = '/api/v1/authentication/users/signup-otp/'; // Added resend OTP endpoint



}
