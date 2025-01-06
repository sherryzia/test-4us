import 'package:flutter/material.dart';
import 'package:forus_app/view/auth/authentication_point.dart';
import 'package:forus_app/view/widget/common_image_view_widget.dart';
import 'package:forus_app/view/widget/my_button_widget.dart';
import 'package:forus_app/view/widget/my_text_widget.dart';
import 'package:get/get.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/constants/app_fonts.dart';
import 'package:forus_app/constants/app_sizes.dart';
import 'package:forus_app/generated/assets.dart';

class CongratsScreen extends StatelessWidget {
 
  const CongratsScreen({
    super.key,
 
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeColors.getTertiary(context),
      body: SafeArea(
        child: Padding(
          padding: AppSizes.DEFAULT,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CommonImageView(
                imagePath: Assets.imagesCongrats,
                height: 110,
              ),
              SizedBox(height: 24),
              MyText(
                text: 'Congratulations!',
                size: 26,
                textAlign: TextAlign.center,
                fontFamily: AppFonts.NUNITO_SANS,
                weight: FontWeight.bold,
                color: kTextDarkorange,
              ),
              SizedBox(height: 16),
              MyText(
                text: 'Your profile submission task has been done successfully.',
                size: 16,
                textAlign: TextAlign.center,
                fontFamily: AppFonts.NUNITO_SANS,
                weight: FontWeight.w500,
                color: kTextDarkorange.withOpacity(0.8),
              ),
              SizedBox(height: 32),
              MyButton(
                buttonText: "Finish",
                radius: 14,
                textSize: 18,
                weight: FontWeight.w800,
                onTap: () {
            Get.offAll(() => AuthenticationPoint());
},

              ),
            ],
          ),
        ),
      ),
    );
  }
}
