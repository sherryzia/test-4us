import 'package:candid/view/widget/preference_card_widget.dart';
import 'package:flutter/material.dart';

class LifeStylesF extends StatelessWidget {
  const LifeStylesF({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
       padding: EdgeInsets.zero,
      physics: BouncingScrollPhysics(),
      children: [
        PreferenceCard(
          isOnFilter: true,
          title: 'Drinking habits',
          items: [
            'Non-drinker',
            'Social drinker',
            'Regular drinker',
            'Prefer not to say',
          ],
          onSelect: () {},
          selectedValue: 'Non-drinker',
        ),
        PreferenceCard(
          isOnFilter: true,
          title: 'Smoking habits',
          items: [
            'Non-smoker',
            'Social smoker',
            'Regular smoker',
            'Vaper',
          ],
          onSelect: () {},
          selectedValue: 'Non-smoker',
        ),
        PreferenceCard(
          isOnFilter: true,
          title: 'Dietary preference',
          items: [
            'Omnivore',
            'Vegetarian',
            'Vegan',
            'Pescatarian',
            'Keto',
            'Gluten-free',
          ],
          onSelect: () {},
          selectedValue: 'Omnivore',
        ),
      ],
    );
  }
}
