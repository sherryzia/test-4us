import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:restaurant_finder/constants/app_colors.dart';

FlutterSliderTooltip CustomSliderToolTip() {
  return FlutterSliderTooltip(
    textStyle: TextStyle(
      fontSize: 10,
      color: kTertiaryColor,
    ),
    boxStyle: FlutterSliderTooltipBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.65),
        color: kSecondaryColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 3.83),
            blurRadius: 5.74,
            spreadRadius: -1.91,
            color: kBlackColor.withOpacity(0.03),
          ),
          BoxShadow(
            offset: Offset(0, 11.48),
            blurRadius: 15.3,
            spreadRadius: -3.83,
            color: kBlackColor.withOpacity(0.08),
          ),
        ],
      ),
    ),
  );
}
