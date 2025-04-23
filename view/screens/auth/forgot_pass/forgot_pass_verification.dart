
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

class ForgotEmailVerification extends StatelessWidget {
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
        color: kPrimaryColor,
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
                  title: 'You’ve Got Mail 📩',
                  subTitle:
                      'We have sent the OTP verification code to your email address. Check your email and enter the code below.',
                ),
                SizedBox(
                  height: 10,
                ),
                Pinput(
                  length: 4,
                  onChanged: (value) {},
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
                  onCompleted: (pin) => print(pin),
                ),
                SizedBox(
                  height: 35,
                ),
                MyText(
                  text: 'Didn\'t receive email?',
                  textAlign: TextAlign.center,
                  color: kQuaternaryColor,
                  size: 15,
                  weight: FontWeight.w500,
                  paddingBottom: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyText(
                      text: 'You can resend code in ',
                      color: kQuaternaryColor,
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
                    Get.to(()=> CreatePassword());
                  },
                  buttonText: 'Continue',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
