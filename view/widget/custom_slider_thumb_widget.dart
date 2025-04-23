import 'package:flutter/material.dart';
import 'package:restaurant_finder/constants/app_colors.dart';

Widget CustomSliderThumb() {
  return Container(
    height: 16.67,
    width: 16.67,
    decoration: BoxDecoration(
      color: kPrimaryColor,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 1.91),
          blurRadius: 3.83,
          spreadRadius: -1.91,
          color: kBlackColor.withOpacity(0.06),
        ),
        BoxShadow(
          offset: Offset(0, 3.83),
          blurRadius: 7.65,
          spreadRadius: -1.91,
          color: kBlackColor.withOpacity(0.1),
        ),
      ],
      border: Border.all(
        width: 0.96,
        color: kSecondaryColor,
      ),
    ),
  );
}
