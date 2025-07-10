import 'package:candid/view/widget/preference_card_widget.dart';
import 'package:flutter/material.dart';

class HighLightsF extends StatelessWidget {
  const HighLightsF({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: BouncingScrollPhysics(),
      children: [
        PreferenceCard(
          isOnFilter: true,
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
          isOnFilter: true,
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
          isOnFilter: true,
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
          isOnFilter: true,
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
          isOnFilter: true,
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
          isOnFilter: true,
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
          isOnFilter: true,
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
          isOnFilter: true,
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
    );
  }
}
