import 'package:flutter/material.dart';
import 'package:forus_app/controllers/auth/ResetPasswordController.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/constants/app_fonts.dart';
import 'package:forus_app/constants/app_sizes.dart';
import 'package:forus_app/generated/assets.dart';
import 'package:forus_app/view/auth/login_screen.dart';
import 'package:forus_app/view/widget/common_image_view_widget.dart';
import 'package:forus_app/view/widget/my_button_widget.dart';
import 'package:forus_app/view/widget/my_text_widget.dart';
import 'package:forus_app/view/widget/my_text_field.dart';
import 'package:pinput/pinput.dart';

class ConfirmPasswordScreen extends StatefulWidget {
  const ConfirmPasswordScreen({super.key});

  @override
  State<ConfirmPasswordScreen> createState() =>
      _ConfirmPasswordScreenState();
}

class _ConfirmPasswordScreenState extends State<ConfirmPasswordScreen> {

  final ResetPasswordController controller = Get.put(ResetPasswordController());
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController confirmPasswordTextController = TextEditingController();
  String otpCode = "";

  @override
  Widget build(BuildContext context) {

    final String email = Get.arguments?['email'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemeColors.getTertiary(context),
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: CommonImageView(
              imagePath: Assets.imagesArrowLeft,
              height: 24,
            ),
          ),
        ),
      ),
      backgroundColor: AppThemeColors.getTertiary(context),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CommonImageView(
              imagePath: Assets.imagesResetpasword,
              height: 86,
            ),
            MyText(
              text: 'Reset Password',
              size: 24,
              paddingTop: 38,
              fontFamily: AppFonts.NUNITO_SANS,
              weight: FontWeight.w800,
            ),
            MyText(
              text: "Create your new password to login your\naccount",
              size: 16,
              textAlign: TextAlign.center,
              paddingTop: 5,
              color: kTextGrey,
              fontFamily: AppFonts.NUNITO_SANS,
              weight: FontWeight.w500,
            ),
            Gap(20),
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
            MyTextField(
              controller: passwordTextController,
              hint: 'Password',
              hintColor: kTextGrey,
              labelColor: kWhite,
              radius: 8,
              suffix: Padding(
                padding: const EdgeInsets.all(12),
                child: CommonImageView(
                  imagePath: Assets.imagesHidegrey,
                  height: 22,
                ),
              ),
              filledColor: kTransperentColor,
              kBorderColor: kBorderGrey,
              kFocusBorderColor: KColor1,
            ),
            Gap(16),
            MyTextField(
              controller: confirmPasswordTextController,
              hint: 'Confirm password',
              hintColor: kTextGrey,
              labelColor: kWhite,
              radius: 8,
              suffix: Padding(
                padding: const EdgeInsets.all(12),
                child: CommonImageView(
                  imagePath: Assets.imagesHidegrey,
                  height: 22,
                ),
              ),
              filledColor: kTransperentColor,
              kBorderColor: kBorderGrey,
              kFocusBorderColor: KColor1,
            ),
            Gap(25),
            MyButton(
                buttonText: controller.isLoading.value ? "Updating..." : "Save & Update",
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
                  else if(passwordTextController.text != confirmPasswordTextController.text){
                    Get.snackbar("Error", "Passwords does not match.");
                    return;
                  }
                  controller.resetPassword(otpCode, email, passwordTextController.text, confirmPasswordTextController.text);
                },
            ),
          ],
        ),
      ),
    );
  }
}
