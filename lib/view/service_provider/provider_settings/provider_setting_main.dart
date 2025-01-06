import 'package:flutter/material.dart';
import 'package:forus_app/utils/shared_preferences_util.dart';
import 'package:forus_app/view/auth/login_screen.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/constants/app_fonts.dart';
import 'package:forus_app/constants/app_sizes.dart';
import 'package:forus_app/generated/assets.dart';
import 'package:forus_app/view/service_provider/provider_settings/provider_aboutus.dart';
import 'package:forus_app/view/service_provider/provider_settings/provider_contactus.dart';
import 'package:forus_app/view/service_provider/provider_settings/provider_edit_profile.dart';
import 'package:forus_app/view/service_provider/provider_settings/provider_privacy.dart';
import 'package:forus_app/view/service_provider/provider_settings/provider_terms.dart';
import 'package:forus_app/view/service_provider/provider_settings/setting_secondary.dart';
import 'package:forus_app/view/widget/common_image_view_widget.dart';
import 'package:forus_app/view/widget/dasheddivider.dart';
import 'package:forus_app/view/widget/my_button_widget.dart';
import 'package:forus_app/view/widget/my_text_widget.dart';

class ProviderSettingMainScreen extends StatefulWidget {
  const ProviderSettingMainScreen({super.key});

  @override
  State<ProviderSettingMainScreen> createState() =>
      _ProviderSettingMainScreenState();
}

class _ProviderSettingMainScreenState extends State<ProviderSettingMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemeColors.getTertiary(context),
        title: MyText(
          text: "Profile ",
          size: 18,
          textAlign: TextAlign.center,
          fontFamily: AppFonts.NUNITO_SANS,
          weight: FontWeight.w700,
        ),
        centerTitle: true,
      ),
      backgroundColor: AppThemeColors.getTertiary(context),
      body: ListView(
        padding: AppSizes.DEFAULT2,
        children: [
          home_container(),
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
                CustomContainer(
                    img: Assets.imagesUserEdit,
                    text: 'Edit Profile',
                    onTap: () {
                      Get.to(() => ProviderEditProfileScreen());
                    }),
                CustomContainer(
                    img: Assets.imagesBriefcaseSettings,
                    text: 'Manage Business ',
                    onTap: () {
                      // Get.to(() => ProviderManageBusinessScreen());
                    }),
                CustomContainer(
                    img: Assets.imagesSetting,
                    text: 'Settings',
                    onTap: () {
                      Get.to(() => ProviderSettingSecondaryScreen());
                    }),
                CustomContainer(
                    img: Assets.imagesShieldSecurity,
                    text: 'Privacy Policy',
                    onTap: () {
                      Get.to(() => ProviderPrivacyScreen());
                    }),
                CustomContainer(
                    img: Assets.imagesTerms,
                    text: 'Terms & Conditions ',
                    onTap: () {
                      Get.to(() => ProviderTermsCondtionScreen());
                    }),
                CustomContainer(
                    img: Assets.imagesInfoCircle,
                    text: 'About Us ',
                    onTap: () {
                      Get.to(() => ProviderAboutUsScreen());
                    }),
                CustomContainer(
                    img: Assets.imagesContactus,
                    text: 'Contact Us',
                    onTap: () {
                      Get.to(() => ProviiderContactUsScreen());
                    }),
                CustomContainer(
                    img: Assets.imagesLogout,
                    text: 'Logout ',
                    onTap: () {
                      LogoutBottomSheet();
                    }),
              ],
            ),
          ),
          MyText(
             onTap: () {
              DeleteBottomSheet();
            },
            text: "Delete Account ",
            size: 18,
            color: kredColor,
            paddingTop: 32,
            paddingBottom: 32,
            textAlign: TextAlign.center,
            fontFamily: AppFonts.NUNITO_SANS,
            weight: FontWeight.w700,
          ),
        ],
      ),
    );
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

  Container home_container() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: kBorderGrey,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Aligns content at the top
            children: [
              // Space between image and the column
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: 'Grant Honey',
                      size: 18,
                      fontFamily: AppFonts.NUNITO_SANS,
                      weight: FontWeight.w700,
                    ),

                    MyText(
                      text: 'granthoney@gmail.com',
                      size: 16,
                      color: kTextGrey,
                      fontFamily: AppFonts.NUNITO_SANS,
                      weight: FontWeight.w600,
                    ), // Space between text and Row
                  ],
                ),
              ),

              CommonImageView(
                imagePath: Assets.imagesSettingAvatarMain,
                height: 60,
              ),
            ],
          ),
        ],
      ),
    );
  }


}

void LogoutBottomSheet() {
  Get.bottomSheet(
    isScrollControlled: true,
    Container(
      height: 200,
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
                  text: "Are you sure you want to logout from this account?",
                  size: 18,
                  textAlign: TextAlign.center,
                  weight: FontWeight.w600,
                  fontFamily: AppFonts.NUNITO_SANS,
                ),
                Gap(18),
                Row(
                  spacing: 17,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyButton2(
                      width: 137,
                      buttonText: "No",
                      radius: 14,
                      textSize: 20,
                      bgColor: kbuttoncolor,
                      weight: FontWeight.w800,
                      onTap: () {
                        Get.back();
                      },
                    ),
                    MyButton2(
                      width: 137,
                      buttonText: "Yes",
                      radius: 14,
                      textSize: 20,
                      weight: FontWeight.w800,
                      onTap: () {
                        SharedPreferencesUtil.removeData("authToken");
                        Get.offAll(() => LoginScreen());
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}


void DeleteBottomSheet() {
  Get.bottomSheet(
    isScrollControlled: true,
    Container(
      height: 200,
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
                  text: "Are you sure you want to delete this account?",
                  size: 18,
                  textAlign: TextAlign.center,
                  weight: FontWeight.w600,
                  fontFamily: AppFonts.NUNITO_SANS,
                ),
                Gap(18),
                Row(
                  spacing: 17,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyButton2(
                      width: 137,
                      buttonText: "No",
                      radius: 14,
                      textSize: 20,
                      bgColor: kbuttoncolor,
                      weight: FontWeight.w800,
                      onTap: () {
                        Get.back();
                      },
                    ),
                    MyButton2(
                      width: 137,
                      buttonText: "Yes",
                      radius: 14,
                      textSize: 20,
                      weight: FontWeight.w800,
                      onTap: () {
                        Get.offAll(() => LoginScreen());
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
