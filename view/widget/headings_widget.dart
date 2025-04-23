import 'package:flutter/material.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';

class AuthHeading extends StatelessWidget {
  const AuthHeading({
    super.key,
    required this.title,
    required this.subTitle,
    this.marginTop,
    this.textAlign,
  });
  final String? title;
  final String? subTitle;
  final double? marginTop;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MyText(
          paddingTop: marginTop ?? 0,
          text: title ?? '',
          size: 24,
          textAlign: textAlign ?? TextAlign.start,
          paddingBottom: 10,
          weight: FontWeight.w600,
        ),
        if (subTitle!.isNotEmpty)
          MyText(
            text: subTitle ?? '',
            size: 15,
            lineHeight: 1.5,
            paddingBottom: 30,
            textAlign: textAlign ?? TextAlign.start,
            weight: FontWeight.w500,
          ),
      ],
    );
  }
}
