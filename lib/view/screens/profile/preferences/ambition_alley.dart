import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:candid/view/widget/preference_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AmbitionAlley extends StatelessWidget {
  const AmbitionAlley({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: Get.height * 0.9,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                height: 5,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: kSecondaryColor,
                ),
              ),
            ),
            MyText(
              textAlign: TextAlign.center,
              paddingBottom: 12,
              text: 'Ambition Alley',
              size: 16,
              weight: FontWeight.w600,
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: AppSizes.DEFAULT,
                physics: BouncingScrollPhysics(),
                children: [
                  PreferenceCard(
                    title: 'Education level',
                    items: [
                      'High school',
                      'Some college',
                      'Bachelor\'s degree',
                      'Master\'s degree',
                      'Doctorate',
                      'Trade school',
                    ],
                    onSelect: () {},
                    selectedValue: 'High school',
                  ),
                  PreferenceCard(
                    title: 'Career field',
                    items: [
                      'Technology',
                      'Healthcare',
                      'Education',
                      'Finance',
                      'Arts and entertainment',
                      'Service industry',
                      'Entrepreneur',
                      'Student',
                      'Other (with text input)',
                    ],
                    onSelect: () {},
                    selectedValue: 'Technology',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
