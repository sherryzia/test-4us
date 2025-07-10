import 'package:candid/view/widget/preference_card_widget.dart';
import 'package:flutter/material.dart';

class AmbitionF extends StatelessWidget {
  const AmbitionF({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
  padding: EdgeInsets.zero,      physics: BouncingScrollPhysics(),
      children: [
        PreferenceCard(
          isOnFilter: true,
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
          isOnFilter: true,
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
    );
  }
}
