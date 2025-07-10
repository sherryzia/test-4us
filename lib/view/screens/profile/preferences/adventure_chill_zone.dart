import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:candid/view/widget/preference_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdventureChillZone extends StatelessWidget {
  const AdventureChillZone({super.key});

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
              text: 'Adventure & Chill Zone',
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
                    title: 'Ideal living situation',
                    items: [
                      'City dweller',
                      'Suburban life',
                      'Rural living',
                      'Nomadic/Traveler',
                    ],
                    onSelect: () {},
                    selectedValue: 'City dweller',
                  ),
                  PreferenceCard(
                    title: 'Preferred first date',
                    items: [
                      'Coffee shop chat',
                      'Outdoor adventure',
                      'Cultural event (museum, concert)',
                      'Cooking together',
                      'Virtual date',
                    ],
                    onSelect: () {},
                    selectedValue: 'Coffee shop chat',
                  ),
                  PreferenceCard(
                    title: 'Travel style',
                    items: [
                      'Luxury traveler',
                      'Backpacker',
                      'Road tripper',
                      'Staycationer',
                      'Adventure seeker',
                      'Cultural explorer',
                    ],
                    onSelect: () {},
                    selectedValue: 'Luxury traveler',
                  ),
                  PreferenceCard(
                    title: 'Favorite way to relax',
                    items: [
                      'Reading',
                      'Watching movies/TV',
                      'Gaming',
                      'Outdoor activities',
                      'Meditation/Yoga',
                      'Cooking',
                      'Creative hobbies',
                    ],
                    onSelect: () {},
                    selectedValue: 'Reading',
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
