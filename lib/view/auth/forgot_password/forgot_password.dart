import 'package:flutter/material.dart';
import 'package:forus_app/controllers/auth/ForgotPasswordController.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/constants/app_fonts.dart';
import 'package:forus_app/constants/app_sizes.dart';
import 'package:forus_app/generated/assets.dart';
import 'package:forus_app/view/widget/common_image_view_widget.dart';
import 'package:forus_app/view/widget/my_button_widget.dart';
import 'package:forus_app/view/widget/my_text_widget.dart';
import 'package:forus_app/view/widget/my_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({super.key});

  final ForgotPasswordController controller = Get.put(ForgotPasswordController());

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CommonImageView(
              imagePath: Assets.imagesForgotpassword,
              height: 86,
            ),
            MyText(
              text: 'Forgot Password?',
              size: 24,
              paddingTop: 38,
              fontFamily: AppFonts.NUNITO_SANS,
              weight: FontWeight.w800,
            ),
            MyText(
              text: 'Enter the registered email address',
              size: 16,
              paddingTop: 5,
              color: kTextGrey,
              fontFamily: AppFonts.NUNITO_SANS,
              weight: FontWeight.w500,
            ),
            Gap(20),
            MyTextField(
              controller: widget.controller.emailController,
              hint: 'Email address',
              hintColor: kTextGrey,
              labelColor: kBlack,
              radius: 8,
              suffix: Padding(
                padding: const EdgeInsets.all(12),
                child: CommonImageView(
                  imagePath: Assets.imagesGreyemail,
                  height: 22,
                ),
              ),
              filledColor: kTransperentColor,
              kBorderColor: kBorderGrey,
              kFocusBorderColor: KColor1,
            ),
            Gap(25),
            MyButton(
                buttonText: "Continue",
                radius: 14,
                textSize: 18,
                weight: FontWeight.w800,
                onTap: widget.controller.isLoading.value
                    ? () => {} // Disable the button when loading
                    : () {
                  widget.controller.sendEmail();
                }),
          ],
        ),
      ),
    );
  }
}
