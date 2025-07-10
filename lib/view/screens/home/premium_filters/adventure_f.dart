import 'package:candid/view/widget/preference_card_widget.dart';
import 'package:flutter/material.dart';

class AdventureF extends StatelessWidget {
  const AdventureF({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
  padding: EdgeInsets.zero,      physics: BouncingScrollPhysics(),
      children: [
        PreferenceCard(
          isOnFilter: true,
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
          isOnFilter: true,
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
          isOnFilter: true,
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
          isOnFilter: true,
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
    );
  }
}
