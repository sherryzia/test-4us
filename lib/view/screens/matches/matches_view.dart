import 'package:candid/view/widget/match_card_widget.dart';
import 'package:flutter/material.dart';

class MatchesView extends StatelessWidget {
  const MatchesView({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.fromLTRB(20, 16, 20, 100),
      physics: BouncingScrollPhysics(),
      itemCount: 10,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 9 / 13,
        // mainAxisExtent: 260,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return MatchCard(
          isCrushed: index == 0,
          isAway: index == 1,
          isOnline: index == 0,
          isLocked: false,
          index: index,
        );
      },
    );
  }
}
