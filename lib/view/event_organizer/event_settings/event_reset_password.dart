import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

class EventResetPasswordScreen extends StatefulWidget {
  const EventResetPasswordScreen({super.key});

  @override
  State<EventResetPasswordScreen> createState() =>
      _EventResetPasswordScreenState();
}

class _EventResetPasswordScreenState
    extends State<EventResetPasswordScreen> {
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
              text: 'Change Password',
              size: 24,
              paddingTop: 38,
              fontFamily: AppFonts.NUNITO_SANS,
              weight: FontWeight.w800,
            ),
            Gap(25),
            MyTextField(
              hint: 'Current Password',
              hintColor: kTextGrey,
              labelColor: kWhite,
              radius: 8,
              suffix: Padding(
                padding: const EdgeInsets.all(12),
                child: CommonImageView(
                  imagePath: Assets.imagesHide1,
                  height: 22,
                ),
              ),
              filledColor: kTransperentColor,
              kBorderColor: kBorderGrey,
              kFocusBorderColor: KColor1,
            ),
            Gap(16),
            MyTextField(
              hint: 'New Password',
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
                buttonText: "Save & Update",
                radius: 14,
                textSize: 18,
                weight: FontWeight.w800,
                onTap: () {
              
                }),
          ],
        ),
      ),
    );
  }
}
