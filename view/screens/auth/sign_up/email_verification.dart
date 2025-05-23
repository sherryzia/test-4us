// lib/view/screens/auth/sign_up/email_verification.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_fonts.dart';
import 'package:restaurant_finder/constants/app_images.dart';
import 'package:restaurant_finder/constants/app_sizes.dart';
import 'package:restaurant_finder/controller/otp_verification_controller.dart';
import 'package:restaurant_finder/view/widget/custom_app_bar_widget.dart';
import 'package:restaurant_finder/view/widget/headings_widget.dart';
import 'package:restaurant_finder/view/widget/my_button_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';

class EmailVerification extends StatelessWidget {
  final OtpVerificationController controller = Get.put(OtpVerificationController());

  @override
  Widget build(BuildContext context) {
    final DEFAULT_THEME = PinTheme(
      width: 72,
      height: 60,
      margin: EdgeInsets.zero,
      textStyle: TextStyle(
        fontSize: 20,
        height: 0.0,
        fontWeight: FontWeight.bold,
        color: kSecondaryColor,
        fontFamily: AppFonts.URBANIST,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: kBorderColor,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
    );
    
    return Scaffold(
      appBar: simpleAppBar(
        title: '',
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: AppSizes.DEFAULT,
              physics: BouncingScrollPhysics(),
              children: [
                AuthHeading(
                  title: 'Verification Mail 📩',
                  subTitle:
                      'We have sent the OTP verification code to your email address. Check your email and enter the code below.',
                ),
                
                // Error message if any
                Obx(() => controller.errorMessage.value.isNotEmpty
                    ? Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: MyText(
                          text: controller.errorMessage.value,
                          color: Colors.red,
                          weight: FontWeight.w500,
                          textAlign: TextAlign.center,
                        ),
                      )
                    : SizedBox(height: 10)),
                
                // Pinput widget for OTP
                Pinput(
                  length: 4,
                  controller: controller.pinController,
                  onChanged: (value) {
                    // Controller is already listening to changes
                  },
                  pinContentAlignment: Alignment.center,
                  defaultPinTheme: DEFAULT_THEME,
                  focusedPinTheme: DEFAULT_THEME.copyWith(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.0,
                        color: kSecondaryColor,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  submittedPinTheme: DEFAULT_THEME.copyWith(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.0,
                        color: kSecondaryColor,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  separatorBuilder: (index) {
                    return SizedBox(
                      width: 12,
                    );
                  },
                  onCompleted: (pin) {
                    // Optional: auto-verify when all digits are entered
                    // controller.verifyOtp();
                  },
                ),
                
                SizedBox(
                  height: 35,
                ),
                
                // Resend option
                MyText(
                  text: 'Didn\'t receive email?',
                  textAlign: TextAlign.center,
                  color: kQuaternaryColor,
                  size: 15,
                  weight: FontWeight.w500,
                  paddingBottom: 12,
                ),
                
                GestureDetector(
                  onTap: () => controller.resendOtp(),
                  child: MyText(
                    text: 'Resend Code',
                    size: 15,
                    weight: FontWeight.bold,
                    color: kSecondaryColor,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          
          // Verify button
          Padding(
            padding: AppSizes.DEFAULT,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Obx(() => MyButton(
                      onTap: controller.isLoading.value
                          ? (){}
                          : () => controller.verifyOtp(),
                      buttonText: controller.isLoading.value
                          ? 'Verifying...'
                          : 'Continue',
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}