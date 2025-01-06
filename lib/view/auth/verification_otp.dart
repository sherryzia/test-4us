import 'package:flutter/material.dart';
import 'package:forus_app/controllers/auth/OTPVerificationController.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/constants/app_fonts.dart';
import 'package:forus_app/constants/app_sizes.dart';
import 'package:forus_app/generated/assets.dart';
import 'package:forus_app/view/widget/common_image_view_widget.dart';
import 'package:forus_app/view/widget/my_button_widget.dart';
import 'package:forus_app/view/widget/my_text_widget.dart';
import 'package:pinput/pinput.dart';

class VerificationOtpScreen extends StatefulWidget {
  const VerificationOtpScreen({super.key});

  @override
  State<VerificationOtpScreen> createState() => _VerificationOtpScreenState();
}

class _VerificationOtpScreenState extends State<VerificationOtpScreen> {
  final OTPVerificationController controller = Get.put(OTPVerificationController());
  String otpCode = "";

  @override
  Widget build(BuildContext context) {
    final String email = Get.arguments?['email'] ?? "your_email@example.com";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemeColors.getTertiary(context),
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: CommonImageView(
              imagePath: Assets.imagesArrowLeft,
              height: 24,
            ),
          ),
        ),
      ),
      backgroundColor: AppThemeColors.getTertiary(context),
      body: Obx(() => Padding(
            padding: AppSizes.DEFAULT,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CommonImageView(
                  imagePath: Assets.imagesOtp,
                  height: 86,
                ),
                MyText(
                  text: 'OTP Verification',
                  size: 24,
                  paddingTop: 38,
                  fontFamily: AppFonts.NUNITO_SANS,
                  weight: FontWeight.w800,
                ),
                MyText(
                  text: 'Please enter the 6-digit code sent to \n$email',
                  size: 16,
                  textAlign: TextAlign.center,
                  paddingTop: 5,
                  color: kTextGrey,
                  fontFamily: AppFonts.NUNITO_SANS,
                  weight: FontWeight.w500,
                ),
                Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Pinput(
                      length: 6,
                      onChanged: (value) => otpCode = value,
                      defaultPinTheme: PinTheme(
                        width: 45,
                        height: 45,
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontFamily: AppFonts.NUNITO_SANS,
                          fontWeight: FontWeight.w600,
                          color: kBlack,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: kBorderGrey),
                        ),
                      ),
                      focusedPinTheme: PinTheme(
                        width: 45,
                        height: 45,
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontFamily: AppFonts.NUNITO_SANS,
                          fontWeight: FontWeight.w600,
                          color: kBlack,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: kBorderGrey),
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(25),
                MyButton(
                  buttonText: controller.isLoading.value ? "Verifying..." : "Verify",
                  radius: 14,
                  textSize: 18,
                  weight: FontWeight.w800,
                  onTap: controller.isLoading.value
                      ? () {} // No-op function when loading
                      : () {
                          if (otpCode.isEmpty || otpCode.length != 6) {
                            Get.snackbar("Error", "Please enter a valid 6-digit OTP.");
                            return;
                          }
                          controller.verifyOTP(otpCode);
                        },
                ),

                Gap(21),
                InkWell(
                  onTap: () {
                    // Implement resend OTP logic here
                    Get.snackbar("Info", "OTP resent successfully!");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(
                        text: "Haven't received a code yet?",
                        size: 16,
                        color: kTextGrey,
                        fontFamily: AppFonts.NUNITO_SANS,
                        weight: FontWeight.w600,
                      ),
                      MyText(
                        text: ' Resend',
                        size: 16,
                        color: kTextOrange,
                        fontFamily: AppFonts.NUNITO_SANS,
                        weight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
