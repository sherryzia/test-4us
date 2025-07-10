import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_fonts.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/view/screens/auth/choose_login.dart';
import 'package:candid/view/screens/auth/sign_up/phone_number.dart';
import 'package:candid/view/widget/custom_background.dart';
import 'package:candid/view/widget/my_button_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChooseSignUp extends StatelessWidget {
  const ChooseSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      bgImage: Assets.imagesSignUpBg,
      child: Padding(
        padding: AppSizes.DEFAULT,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 40,
            ),
            Image.asset(
              Assets.imagesAppLogo,
              height: 38,
            ),
            MyText(
              paddingTop: 16,
              text: 'Sign up for an account',
              size: 20,
              color: kPrimaryColor,
              weight: FontWeight.w500,
              textAlign: TextAlign.center,
              lineHeight: 1.2,
              paddingBottom: 30,
            ),
            MyButton(
              height: 48,
              bgColor: kPrimaryColor,
              splashColor: kBlackColor.withOpacity(0.1),
              buttonText: '',
              onTap: () {
                Get.to(() => PhoneNumber());
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: 45,
                      child: Image.asset(
                        Assets.imagesPhoneIconNew,
                        height: 26,
                      ),
                    ),
                    Expanded(
                      child: MyText(
                        text: 'Continue With Phone',
                        size: 16,
                        color: kTertiaryColor,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            MyButton(
              height: 48,
              onTap: () {},
              bgColor: kBlackColor,
              buttonText: '',
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: 45,
                      child: Image.asset(
                        Assets.imagesApple,
                        height: 32,
                      ),
                    ),
                    Expanded(
                      child: MyText(
                        text: 'Continue With Apple',
                        size: 16,
                        color: kPrimaryColor,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            MyButton(
              height: 48,
              bgColor: kFacebookColor,
              buttonText: '',
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: 45,
                      child: Image.asset(
                        Assets.imagesFacebook,
                        height: 26,
                      ),
                    ),
                    Expanded(
                      child: MyText(
                        text: 'Continue With Facebook',
                        size: 16,
                        color: kPrimaryColor,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {},
            ),
            SizedBox(
              height: 12,
            ),
            MyButton(
              height: 48,
              bgColor: kPrimaryColor,
              buttonText: '',
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: 45,
                      child: Image.asset(
                        Assets.imagesGoogle,
                        height: 26,
                      ),
                    ),
                    Expanded(
                      child: MyText(
                        text: 'Continue With Google',
                        size: 16,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                MyText(
                  text: 'Already have an account? ',
                  size: 14,
                  color: kPrimaryColor,
                ),
                MyText(
                  onTap: () {
                    Get.offAll(() => ChooseLogin());
                  },
                  text: 'Login',
                  size: 15,
                  decoration: TextDecoration.underline,
                  fontFamily: AppFonts.URBANIST,
                  color: kSecondaryColor,
                  weight: FontWeight.w600,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
