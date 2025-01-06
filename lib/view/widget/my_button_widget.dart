import 'package:forus_app/constants/app_fonts.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import 'my_text_widget.dart';

// ignore: must_be_immutable
class MyButton extends StatelessWidget {
  MyButton({
    required this.buttonText,
    required this.onTap,
    this.height = 54,
    this.textSize,
    this.weight,
    this.radius,
    this.customChild,
    this.bgColor,
    this.textColor,
    this.fontFamily,
    this.isDisabled = false, // Add the isDisabled parameter with a default value
  });

  final String buttonText;
  final VoidCallback onTap;
  final String? fontFamily;

  double? height, textSize, radius;
  FontWeight? weight;
  Widget? customChild;
  Color? bgColor, textColor;
  final bool isDisabled; // Track whether the button is disabled

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 50),
        color: isDisabled ? kTextGrey : (bgColor ?? KColor2), // Dim color if disabled
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onTap, // Disable tap if isDisabled is true
          splashColor: kWhite.withOpacity(0.1),
          highlightColor: kWhite.withOpacity(0.1),
          borderRadius: BorderRadius.circular(radius ?? 50),
          child: customChild ??
              Center(
                child: MyText(
                  text: buttonText,
                  size: textSize ?? 14,
                  letterSpacing: 0.5,
                  weight: weight ?? FontWeight.w700,
                  color: isDisabled ? kWhite.withOpacity(0.6) : (textColor ?? kWhite), // Dim text color if disabled
                  fontFamily: AppFonts.NUNITO_SANS ?? fontFamily,
                ),
              ),
        ),
      ),
    );
  }
}


class MyButton2 extends StatelessWidget {
  MyButton2({
    required this.buttonText,
    required this.onTap,
    this.height = 54,
    this.width = 54,
    this.textSize,
    this.weight,
    this.radius,
    this.customChild,
    this.bgColor,
    this.textColor,
    this.fontFamily,
  });

  final String buttonText;
  final VoidCallback onTap;
  final String? fontFamily;

  double? height, width, textSize, radius;
  FontWeight? weight;
  Widget? customChild;
  Color? bgColor, textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 50),
        color: bgColor ?? KColor2,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: kWhite.withOpacity(0.1),
          highlightColor: kWhite.withOpacity(0.1),
          borderRadius: BorderRadius.circular(radius ?? 50),
          child: customChild ??
              Center(
                child: MyText(
                  text: buttonText,
                  size: textSize ?? 14,
                  letterSpacing: 0.5,
                  weight: weight ?? FontWeight.w700,
                  color: textColor ?? kWhite,
                  fontFamily: AppFonts.NUNITO_SANS ?? fontFamily,
                ),
              ),
        ),
      ),
    );
  }
}
