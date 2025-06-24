import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_fonts.dart';
import 'package:restaurant_finder/constants/app_sizes.dart';
import 'package:restaurant_finder/view/screens/auth/forgot_pass/create_password.dart';
import 'package:restaurant_finder/view/widget/custom_app_bar_widget.dart';
import 'package:restaurant_finder/view/widget/headings_widget.dart';
import 'package:restaurant_finder/view/widget/my_button_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';
import 'package:restaurant_finder/controller/theme_controller.dart';

class ForgotEmailVerification extends StatelessWidget {
  ForgotEmailVerification({super.key});

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode;
      final DEFAULT_THEME = PinTheme(
        width: 72,
        height: 60,
        margin: EdgeInsets.zero,
        textStyle: TextStyle(
          fontSize: 20,
          height: 0.0,
          fontWeight: FontWeight.bold,
          color: isDark ? kTertiaryColor : kSecondaryColor,
          fontFamily: AppFonts.URBANIST,
        ),
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: kBorderColor),
          color: isDark ? kBlackColor : kPrimaryColor,
          borderRadius: BorderRadius.circular(14),
        ),
      );
      return Scaffold(
        backgroundColor: isDark ? kBlackColor : Colors.white,
        appBar: simpleAppBar(title: ''),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: AppSizes.DEFAULT,
                physics: BouncingScrollPhysics(),
                children: [
                  AuthHeading(
                    title: 'youveGotMail'.tr,
                    subTitle: 'forgotVerificationSubTitle'.tr,
                  ),
                  SizedBox(height: 10),
                  Pinput(
                    length: 4,
                    onChanged: (value) {},
                    pinContentAlignment: Alignment.center,
                    defaultPinTheme: DEFAULT_THEME,
                    focusedPinTheme: DEFAULT_THEME.copyWith(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: kSecondaryColor),
                        borderRadius: BorderRadius.circular(14),
                        color: isDark ? kBlackColor : kPrimaryColor,
                      ),
                    ),
                    submittedPinTheme: DEFAULT_THEME.copyWith(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: kSecondaryColor),
                        borderRadius: BorderRadius.circular(14),
                        color: isDark ? kBlackColor : kPrimaryColor,
                      ),
                    ),
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    separatorBuilder: (index) {
                      return SizedBox(width: 12);
                    },
                    onCompleted: (pin) => print(pin),
                  ),
                  SizedBox(height: 35),
                  MyText(
                    text: 'didNotReceiveEmail'.tr,
                    textAlign: TextAlign.center,
                    color: isDark ? kDarkTextColor : kQuaternaryColor,
                    size: 15,
                    weight: FontWeight.w500,
                    paddingBottom: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(
                        text: 'youCanResendCodeIn'.tr,
                        color: isDark ? kDarkTextColor : kQuaternaryColor,
                        size: 15,
                        weight: FontWeight.w500,
                      ),
                      MyText(
                        text: '55s',
                        size: 15,
                        weight: FontWeight.bold,
                        color: kSecondaryColor,
                      ),
                    ],
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
                      Get.to(() => CreatePassword());
                    },
                    buttonText: 'continue'.tr,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
