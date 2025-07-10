import 'package:candid/view/widget/preference_card_widget.dart';
import 'package:flutter/material.dart';

class MindSoulF extends StatelessWidget {
  const MindSoulF({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: BouncingScrollPhysics(),
      children: [
        PreferenceCard(
          isOnFilter: true,
          title: 'Religious beliefs',
          items: [
            'Atheist',
            'Agnostic',
            'Christian',
            'Muslim',
            'Jewish',
            'Hindu',
            'Buddhist',
            'Spiritual but not religious',
            'Prefer not to say',
          ],
          onSelect: () {},
          selectedValue: 'Atheist',
        ),
        PreferenceCard(
          isOnFilter: true,
          title: 'Political views',
          items: [
            'Liberal',
            'Conservative',
            'Moderate',
            'Apolitical',
            'Prefer not to say',
          ],
          onSelect: () {},
          selectedValue: 'Liberal',
        ),
      ],
    );
  }
}
