import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/constants/app_styling.dart';
import 'package:candid/controller/LoginController.dart';
import 'package:candid/controller/signup_controller.dart';
import 'package:candid/view/widget/custom_background.dart';
import 'package:candid/view/widget/heading.dart';
import 'package:candid/view/widget/my_button_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class VerifyPhoneNumber extends StatefulWidget {
  const VerifyPhoneNumber({super.key});

  @override
  State<VerifyPhoneNumber> createState() => _VerifyPhoneNumberState();
}

class _VerifyPhoneNumberState extends State<VerifyPhoneNumber> {
  final TextEditingController otpController = TextEditingController();
  
  // Determine which controller to use based on what's available
  late final dynamic controller;
  late final bool isFromSignup;

  @override
  void initState() {
    super.initState();
    
    // Check which controller is available
    try {
      controller = Get.find<SignUpController>(tag: 'signup');
      isFromSignup = true;
    } catch (e) {
      try {
        controller = Get.find<LoginController>(tag: 'login');
        isFromSignup = false;
      } catch (e) {
        // Fallback - try without tags
        try {
          controller = Get.find<SignUpController>();
          isFromSignup = true;
        } catch (e) {
          controller = Get.find<LoginController>();
          isFromSignup = false;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: AppSizes.DEFAULT,
              child: AuthHeading(
                title: 'Verify your number',
                subTitle:
                    'We\'ve sent an SMS with an activation code to your phone ${controller.getTempPhoneNumber ?? ""}',
              ),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: BouncingScrollPhysics(),
                children: [
                  Pinput(
                    controller: otpController,
                    defaultPinTheme: AppStyling.defaultPinTheme,
                    focusedPinTheme: AppStyling.focusPinTheme,
                    length: 6,
                    mainAxisAlignment: MainAxisAlignment.center,
                    autofocus: true,
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                    onCompleted: (pin) {
                      // Auto-verify when all digits are entered
                      _verifyOTP(pin);
                    },
                  ),
                  MyText(
                    paddingTop: 32,
                    text: 'The code will arrive within 30s.',
                    size: 12,
                    color: kPrimaryColor.withOpacity(0.7),
                    weight: FontWeight.w500,
                    textAlign: TextAlign.center,
                  ),
                  MyText(
                    paddingTop: 16,
                    onTap: () {
                      _resendOTP();
                    },
                    text: 'Didn\'t receive the code? Resend',
                    size: 14,
                    color: kSecondaryColor,
                    weight: FontWeight.w600,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Padding(
              padding: AppSizes.DEFAULT,
              child: Obx(() => MyButton(
                buttonText: controller.isLoading.value ? 'Verifying...' : 'Continue',
                // isLoading: controller.isLoading.value,
                onTap: () {
                  if (otpController.text.length == 6) {
                    _verifyOTP(otpController.text);
                  } else {
                    Get.snackbar(
                      'Error',
                      'Please enter the complete OTP code.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
              )),
            ),
          ],
        ),
      ),
    );
  }

  void _verifyOTP(String pin) {
    if (isFromSignup) {
      controller.verifyOTP(pin);
    } else {
      controller.verifyLoginOTP(pin);
    }
  }

  void _resendOTP() {
    if (isFromSignup) {
      controller.resendOTP();
    } else {
      controller.resendLoginOTP();
    }
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }
}