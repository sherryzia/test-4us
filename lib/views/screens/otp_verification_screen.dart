// lib/views/screens/otp_verification_screen.dart
import 'package:expensary/constants/colors.dart';
import 'package:expensary/controllers/o_t_p_verification_controller.dart';
import 'package:expensary/views/widgets/my_Button.dart';
import 'package:expensary/views/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OTPVerificationScreen extends StatelessWidget {
  final String email;
  final String userId;
  
  const OTPVerificationScreen({
    Key? key,
    required this.email,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the controller with the required parameters
    final controller = Get.put(
      OTPController(
        userId: userId,
        email: email,
      ),
    );
    
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
                  
                  const SizedBox(height: 10),
                  
                  // OTP display for testing only - remove in production
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.amber),
                        SizedBox(width: 8),
                        Expanded(
                          child: MyText(
                            text: 'For testing: Check the console log for the OTP code',
                            size: 14,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
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
                  Obx(() => MyButton(
                    onTap: controller.isLoading.value ? null : () => controller.verifyOTP(),
                    buttonText: controller.isLoading.value ? 'Verifying...' : 'Verify',
                    width: double.infinity,
                    height: 56,
                    fillColor: Color(0xFFAF4BCE),
                    fontColor: kwhite,
                    fontSize: 18,
                    radius: 28,
                    fontWeight: FontWeight.bold,
                    isLoading: controller.isLoading.value,
                  )),
                  
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
                          onTap: (controller.canResend.value && !controller.isLoading.value)
                              ? controller.resendOTP
                              : null,
                          child: MyText(
                            text: controller.isLoading.value
                                ? 'Please wait...'
                                : (controller.canResend.value
                                    ? 'Resend Code'
                                    : 'Resend Code in ${controller.countdown.value}s'),
                            size: 16,
                            weight: FontWeight.bold,
                            color: (controller.canResend.value && !controller.isLoading.value)
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