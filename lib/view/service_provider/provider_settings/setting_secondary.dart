// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:forus_app/view/auth/verification_otp.dart';
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

class ProviderSettingSecondaryScreen extends StatefulWidget {
  const ProviderSettingSecondaryScreen({super.key});

  @override
  State<ProviderSettingSecondaryScreen> createState() =>
      _ProviderSettingSecondaryScreenState();
}

class _ProviderSettingSecondaryScreenState
    extends State<ProviderSettingSecondaryScreen> {
  bool _isNotificationEnabled = true;

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
        title: MyText(
          text: "Setting",
          size: 18,
          weight: FontWeight.w700,
        ),
        centerTitle: true,
      ),
      backgroundColor: AppThemeColors.getTertiary(context),
      body: ListView(
        padding: AppSizes.DEFAULT2,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(10),
              border: const Border(
                bottom: BorderSide(
                  color: kborderGrey2,
                  width: 0.5,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        CommonImageView(
                          imagePath: Assets.imagesNotificationorange,
                          height: 25,
                        ),
                        const SizedBox(width: 10),
                        MyText(
                          text: "Get Notification Settings",
                          size: 16,
                          color: KColor13,
                          fontFamily: AppFonts.NUNITO_SANS,
                          weight: FontWeight.w700,
                        ),
                      ],
                    ),
                    Spacer(),
                    Switch(
                      value: _isNotificationEnabled,
                      thumbColor: MaterialStateProperty.all(Color(0xFF8D520D)),
                      trackColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return kswtich2; // Active track color
                        }
                        return kswtich2; // Inactive track color
                      }),
                      onChanged: (bool value) {
                        setState(() {
                          _isNotificationEnabled = value;
                        });
                      },
                    ),
                  ],
                ),
                Divider(
                  thickness: 0.5,
                  color: kborderGrey2,
                ),
                CustomContainer(
                    img: Assets.imagesSmsEdit,
                    text: 'Change Email ID',
                    onTap: () {
                      ChangeEmailBottomSheet();
                    }),
                CustomContainer(
                    img: Assets.imagesPasswordCheck,
                    text: 'Change Password',
                    onTap: () {
                      Get.to(() => VerificationOtpScreen());
                    }),
                CustomContainer(
                    img: Assets.imagesMessageQuestion,
                    text: 'Support & Feedbacks ',
                    onTap: () {
                      SupportFeedbacksBottomSheet();
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Container CustomContainer({
  required String img,
  required String text,
  required VoidCallback onTap,
}) {
  return Container(
    padding: const EdgeInsets.all(10),
    margin: const EdgeInsets.symmetric(vertical: 6),
    decoration: BoxDecoration(
      color: kWhite,
      border: const Border(
        bottom: BorderSide(
          color: kborderGrey2,
          width: 0.5,
        ),
      ),
    ),
    child: InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment:
            CrossAxisAlignment.center, // Aligns content at the top
        children: [
          Row(
            children: [
              CommonImageView(
                imagePath: img,
                height: 25,
              ),
              const SizedBox(width: 10),
              MyText(
                text: text,
                size: 16,
                color: KColor13,
                fontFamily: AppFonts.NUNITO_SANS,
                weight: FontWeight.w700,
              ),
            ],
          ),
          CommonImageView(
            imagePath: Assets.imagesNext,
            height: 20,
          ),
        ],
      ),
    ),
  );
}

void ChangeEmailBottomSheet() {
  Get.bottomSheet(
    isScrollControlled: false,
    Container(
      height: 300,
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        children: [
          Padding(
            padding: AppSizes.DEFAULT,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 5,
                  margin: const EdgeInsets.symmetric(horizontal: 160),
                  decoration: BoxDecoration(
                    color: kDividerGrey3,
                    borderRadius: BorderRadius.circular(90),
                  ),
                ),
                Gap(24),
                MyText(
                  text: "Change Email ID",
                  size: 18,
                  weight: FontWeight.w600,
                  fontFamily: AppFonts.NUNITO_SANS,
                ),
                MyText(
                  text: "Please enter your email ID which need to be change",
                  size: 13,
                  color: kTextGrey,
                  paddingTop: 8,
                  weight: FontWeight.w500,
                  fontFamily: AppFonts.NUNITO_SANS,
                ),
                Gap(15),
                MyTextField(
                  hint: 'Email address',
                  labelColor: kBlack,
                  hintColor: kTextGrey,
                  radius: 8,
                  suffix: Padding(
                    padding: const EdgeInsets.all(12),
                    child: CommonImageView(
                      imagePath: Assets.imagesEmailicon,
                      height: 22,
                    ),
                  ),
                  filledColor: kTransperentColor,
                  kBorderColor: kBorderGrey,
                  kFocusBorderColor: KColor1,
                ),
                Gap(18),
                MyButton(
                  buttonText: "Continue",
                  radius: 14,
                  textSize: 20,
                  weight: FontWeight.w800,
                  onTap: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

void SupportFeedbacksBottomSheet() {
  Get.bottomSheet(
    isScrollControlled: true,
    Container(
      height: 500,
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        children: [
          Padding(
            padding: AppSizes.DEFAULT,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 5,
                  margin: const EdgeInsets.symmetric(horizontal: 160),
                  decoration: BoxDecoration(
                    color: kDividerGrey3,
                    borderRadius: BorderRadius.circular(90),
                  ),
                ),
                Gap(24),
                MyText(
                  text: "Support & Feedbacks ",
                  size: 18,
                  weight: FontWeight.w600,
                  fontFamily: AppFonts.NUNITO_SANS,
                ),
                MyText(
                  text: "Please enter your feedback with subject and details ",
                  size: 13,
                  color: kTextGrey,
                  paddingTop: 8,
                  weight: FontWeight.w500,
                  fontFamily: AppFonts.NUNITO_SANS,
                ),
                Gap(15),
                MyTextField(
                  hint: 'Subject',
                  labelColor: kBlack,
                  hintColor: kTextGrey,
                  radius: 8,
                  filledColor: kTransperentColor,
                  kBorderColor: kBorderGrey,
                  kFocusBorderColor: KColor1,
                ),
                Gap(15),
                MyTextField(
                  hint: 'Support feedback',
                  labelColor: kBlack,
                  hintColor: kTextGrey,
                  radius: 8,
                  maxLines: 10,
                  filledColor: kTransperentColor,
                  kBorderColor: kBorderGrey,
                  kFocusBorderColor: KColor1,
                ),
                Gap(18),
                MyButton(
                  buttonText: "Continue",
                  radius: 14,
                  textSize: 20,
                  weight: FontWeight.w800,
                  onTap: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
