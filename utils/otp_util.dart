// lib/utils/otp_util.dart

import 'dart:math';

class OtpUtil {
  // Generate a random 4-digit OTP
  static String generateOtp() {
    final random = Random();
    // Generate a number between 1000 and 9999
    final otp = 1000 + random.nextInt(9000);
    return otp.toString();
  }

  // Validate if a string is a valid 4-digit OTP
  static bool isValidOtp(String otp) {
    if (otp.length != 4) return false;
    
    // Check if all characters are digits
    return RegExp(r'^[0-9]{4}$').hasMatch(otp);
  }
}