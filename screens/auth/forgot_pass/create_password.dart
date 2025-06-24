import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_images.dart';
import 'package:restaurant_finder/constants/app_sizes.dart';
import 'package:restaurant_finder/view/screens/auth/login.dart';
import 'package:restaurant_finder/view/widget/custom_app_bar_widget.dart';
import 'package:restaurant_finder/view/widget/headings_widget.dart';
import 'package:restaurant_finder/view/widget/my_button_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_field_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';
import 'package:restaurant_finder/controller/theme_controller.dart';

class CreatePassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(title: ''),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: AppSizes.DEFAULT,
              children: [
                AuthHeading(
                  title: 'createNewPassword'.tr,
                  subTitle: 'enterNewPasswordSubTitle'.tr,
                ),
                MyTextField(
                  labelText: 'password'.tr,
                  hintText: 'passwordHint'.tr,
                  isObSecure: true,
                ),
                MyTextField(
                  labelText: 'repeatPassword'.tr,
                  hintText: 'passwordHint'.tr,
                  isObSecure: true,
                ),
              ],
            ),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyButton(
                  onTap: () {
                    Get.dialog(_SuccessDialog());
                  },
                  buttonText: 'confirm'.tr,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessDialog extends StatelessWidget {
  const _SuccessDialog();

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode;
    final Color dialogBg =
        isDark
            ? const Color(0xFF18191A)
            : Colors.white; // Different black shade

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          color: dialogBg,
          margin: AppSizes.DEFAULT,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(Assets.imagesCongratsCheck, height: 118),
                MyText(
                  paddingTop: 24,
                  text: 'resetPasswordSuccessful'.tr,
                  size: 20,
                  color: kSecondaryColor,
                  weight: FontWeight.bold,
                  textAlign: TextAlign.center,
                  paddingBottom: 14,
                ),
                MyText(
                  text: 'passwordChangedSuccess'.tr,
                  size: 14,
                  color: isDark ? kDarkTextColor : kGreyColor,
                  lineHeight: 1.5,
                  paddingLeft: 10,
                  paddingRight: 10,
                  textAlign: TextAlign.center,
                  paddingBottom: 20,
                ),
                MyButton(
                  buttonText: 'goBackToLogin'.tr,
                  onTap: () {
                    Get.offAll(() => Login());
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
