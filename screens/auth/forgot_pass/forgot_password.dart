import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/constants/app_sizes.dart';
import 'package:restaurant_finder/view/screens/auth/forgot_pass/forgot_pass_verification.dart';
import 'package:restaurant_finder/view/widget/custom_app_bar_widget.dart';
import 'package:restaurant_finder/view/widget/headings_widget.dart';
import 'package:restaurant_finder/view/widget/my_button_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_field_widget.dart';

class ForgotPassword extends StatelessWidget {
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
                  title: 'forgotPasswordTitle'.tr,
                  subTitle: 'forgotPasswordSubTitle'.tr,
                ),
                MyTextField(labelText: 'email'.tr, hintText: 'emailHint'.tr),
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
                    Get.to(() => ForgotEmailVerification());
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
