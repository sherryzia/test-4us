// Create a new file: views/screens/auth/otp_verification_screen.dart
import 'dart:async';
import 'package:expensary/constants/colors.dart';
import 'package:expensary/views/screens/main_navigation_screen.dart';
import 'package:expensary/views/widgets/my_Button.dart';
import 'package:expensary/views/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OTPVerificationController extends GetxController {
  // OTP input controllers for each digit
  final List<TextEditingController> otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  
  // List of FocusNodes for each OTP input field
  final List<FocusNode> otpFocusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );
  
  // Timer for countdown
  Timer? _timer;
  final RxInt countdown = 60.obs;
  final RxBool canResend = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    startTimer();
  }
  
  @override
  void onClose() {
    // Dispose controllers and focus nodes
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in otpFocusNodes) {
      node.dispose();
    }
    
    // Cancel timer if active
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    
    super.onClose();
  }
  
  void startTimer() {
    countdown.value = 60;
    canResend.value = false;
    
    // Cancel any existing timer
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    
    // Start countdown timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }
  
  void resendOTP() {
    if (canResend.value) {
      // Clear existing OTP
      for (var controller in otpControllers) {
        controller.clear();
      }
      
      // Set focus to first field
      otpFocusNodes[0].requestFocus();
      
      // Restart timer
      startTimer();
      
      // Show message
      Get.snackbar(
        'OTP Resent',
        'A new verification code has been sent',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
  
  // Handle input in OTP fields
  void otpDigitInput(String value, int index) {
    if (value.length == 1) {
      // Move to next field
      if (index < 3) {
        otpFocusNodes[index + 1].requestFocus();
      } else {
        // Last digit entered, check if all filled
        verifyOTP();
      }
    }
  }
  
  // Verify the entered OTP
  void verifyOTP() {
    // Combine all digits
    String otp = '';
    for (var controller in otpControllers) {
      otp += controller.text;
    }
    
    // Check if all digits are entered
    if (otp.length != 4) {
      return;
    }
    
    // For demonstration, any 4-digit code is accepted
    Get.offAll(() => MainNavigationScreen());
  }
}

class OTPVerificationScreen extends StatelessWidget {
  final String email;
  
  const OTPVerificationScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OTPVerificationController controller = Get.put(OTPVerificationController());
    
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              backgroundColor,
              backgroundColor.withOpacity(0.8),
              Color(0xFF1A1A2E).withOpacity(0.9),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: kwhite.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: kwhite,
                        size: 24,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Verification Title
                  MyText(
                    text: 'Verification',
                    size: 32,
                    weight: FontWeight.bold,
                    color: kwhite,
                  ),
                  
                  const SizedBox(height: 10),
                  
                  MyText(
                    text: 'We\'ve sent a verification code to',
                    size: 16,
                    color: kwhite.withOpacity(0.7),
                  ),
                  
                  const SizedBox(height: 5),
                  
                  MyText(
                    text: email,
                    size: 16,
                    weight: FontWeight.bold,
                    color: kwhite,
                  ),
                  
                  const SizedBox(height: 50),
                  
                  // OTP Input Fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      4,
                      (index) => _buildOTPDigitField(
                        controller: controller.otpControllers[index],
                        focusNode: controller.otpFocusNodes[index],
                        onChanged: (value) => controller.otpDigitInput(value, index),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Verify Button
                  MyButton(
                    onTap: controller.verifyOTP,
                    buttonText: 'Verify',
                    width: double.infinity,
                    height: 56,
                    fillColor: Color(0xFFAF4BCE),
                    fontColor: kwhite,
                    fontSize: 18,
                    radius: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Resend Code Section
                  Center(
                    child: Column(
                      children: [
                        MyText(
                          text: 'Didn\'t receive the code?',
                          size: 16,
                          color: kwhite.withOpacity(0.7),
                        ),
                        const SizedBox(height: 10),
                        Obx(() => GestureDetector(
                          onTap: controller.canResend.value
                              ? controller.resendOTP
                              : null,
                          child: MyText(
                            text: controller.canResend.value
                                ? 'Resend Code'
                                : 'Resend Code in ${controller.countdown.value}s',
                            size: 16,
                            weight: FontWeight.bold,
                            color: controller.canResend.value
                                ? Color(0xFFAF4BCE)
                                : kwhite.withOpacity(0.5),
                          ),
                        )),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 50),
                  
                  // Secure Verification Message
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: kwhite.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: kwhite.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.security,
                          color: kgreen,
                          size: 24,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(
                                text: 'Secure Verification',
                                size: 16,
                                weight: FontWeight.bold,
                                color: kwhite,
                              ),
                              const SizedBox(height: 4),
                              MyText(
                                text: 'Your data is protected with end-to-end encryption',
                                size: 14,
                                color: kwhite.withOpacity(0.7),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildOTPDigitField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required Function(String) onChanged,
  }) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: kwhite.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: kwhite.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: TextStyle(
            color: kwhite,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            counterText: '',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }
}
