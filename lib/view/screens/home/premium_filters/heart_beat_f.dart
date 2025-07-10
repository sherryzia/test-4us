import 'package:candid/view/widget/preference_card_widget.dart';
import 'package:flutter/material.dart';

class HeartBeatF extends StatelessWidget {
  const HeartBeatF({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
  padding: EdgeInsets.zero,      physics: BouncingScrollPhysics(),
      children: [
        PreferenceCard(
          isOnFilter: true,
          title: 'Love language',
          items: [
            'Words of affirmation',
            'Acts of service',
            'Physical touch',
            'Quality time',
            'Receiving gifts',
          ],
          onSelect: () {},
          selectedValue: 'Words of affirmation',
        ),
        PreferenceCard(
          isOnFilter: true,
          title: 'Music taste',
          items: [
            'Pop',
            'Rock',
            'Hip-hop/Rap',
            'Classical',
            'Electronic',
            'Country',
            'Jazz',
            'Eclectic',
          ],
          onSelect: () {},
          selectedValue: 'Pop',
        ),
      ],
    );
  }
}
