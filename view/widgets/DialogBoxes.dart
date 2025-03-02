import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/view/widgets/my_button_widget.dart';
import 'package:quran_app/view/widgets/my_text_widget.dart';

import '../../constants/app_colors.dart';

class SuccessDialog {
  static void showSuccessDialog(String title, String message, bool link,
      {VoidCallback? ontap}) {
    Get.dialog(
      AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
        contentPadding: const EdgeInsets.only(bottom: 30, left: 5, right: 5),
        backgroundColor: kBackgroundWhite, // ✅ White Background
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Image.asset(
              'assets/images/splash_image.png',
              width: 171,
              height: 151,
            ),
            const SizedBox(height: 20),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyText(
                text: title,
                color: kTextPurple, // ✅ Updated to match heading color
                size: 20,
                weight: FontWeight.w600,
                paddingTop: 5,
              ),
              MyText(
                text: message,
                color: kTextSecondary, // ✅ Softer secondary text color
                size: 13,
                weight: FontWeight.w400,
                paddingBottom: 20,
                textAlign: TextAlign.center,
              ),
              
              MyButton(
                onTap: () {
                  Get.back();
                },
                buttonText: 'Done',
                radius: 15,
                bgColor: kButtonColor, // ✅ Updated button color
                textColor: kBackgroundWhite, // ✅ White text for contrast
              ),
            ],
          ),
        ),
      ),
    );
  }
}
