import 'package:affirmation_app/constants/app_sizes.dart';
import 'package:flutter/material.dart';

import 'my_text_widget.dart';

class AuthHeading extends StatelessWidget {
  final String title, subTitle;
  final double? paddingTop, paddingBottom;
  const AuthHeading({
    super.key,
    required this.title,
    required this.subTitle,
    this.paddingTop = 60,
    this.paddingBottom = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSize.HORIZONTAL,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MyText(
            text: title,
            size: 27,
            weight: FontWeight.w600,
            paddingTop: paddingTop,
            paddingBottom: 12,
          ),
          MyText(
            text: subTitle,
            paddingBottom: paddingBottom,
          ),
        ],
      ),
    );
  }
}
