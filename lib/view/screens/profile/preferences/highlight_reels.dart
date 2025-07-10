import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/view/widget/custom_check_box_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:candid/view/widget/preference_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class HighlightReels extends StatelessWidget {
  const HighlightReels({super.key});

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
              text: 'Highlight Reel',
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
                    title: 'Relationship goal',
                    items: [
                      'Long-term partnership',
                      'Casual dating',
                      'Friendship first',
                      'Open to anything',
                    ],
                    onSelect: () {},
                    selectedValue: 'Long-term partnership',
                  ),
                  PreferenceCard(
                    title: 'Family Plans',
                    items: [
                      'Want children',
                      'Don’t want children',
                      'Open to children',
                      'Have Children already',
                    ],
                    onSelect: () {},
                    selectedValue: 'Want children',
                  ),
                  PreferenceCard(
                    title: 'Life Style',
                    items: [
                      'Homebody',
                      'Social butterfly',
                      'Work-focused',
                      'Adventurer',
                    ],
                    onSelect: () {},
                    selectedValue: 'Homebody',
                  ),
                  PreferenceCard(
                    title: 'Fitness Level',
                    items: [
                      'Gym enthusiast',
                      'Casual exerciser',
                      'Sports player ',
                      'Yoga/Pilates lover',
                      'Not currently active',
                    ],
                    onSelect: () {},
                    selectedValue: 'Gym enthusiast',
                  ),
                  PreferenceCard(
                    title: 'Communication Style',
                    items: [
                      'Frequent texter',
                      'Phone call enthusiast',
                      'In-person conversations',
                      'Mix of all',
                    ],
                    onSelect: () {},
                    selectedValue: 'Frequent texter',
                  ),
                  PreferenceCard(
                    title: 'Personality type',
                    items: [
                      'Introvert',
                      'Extrovert',
                      'Ambivert',
                    ],
                    onSelect: () {},
                    selectedValue: 'Introvert',
                  ),
                  PreferenceCard(
                    title: 'Height',
                    items: [
                      'Less then 4’0',
                      'Between 4’5’’ and 5’0’’',
                      'Between 5’0’’ and 5’5’’',
                      'Between 5’5’’ and 6’0’’',
                      'More then 6’0’’',
                    ],
                    onSelect: () {},
                    selectedValue: 'Less then 4’0',
                  ),
                  PreferenceCard(
                    title: 'Pet Preferences',
                    items: [
                      'Dog lover',
                      'Cat person',
                      'Small pets (rabbits, hamsters. etc)',
                      'Reptile enthusiast',
                      'No pets',
                    ],
                    onSelect: () {},
                    selectedValue: 'Dog lover',
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
