import 'package:candid/constants/app_colors.dart';
import 'package:flutter/material.dart';

Widget CustomSliderThumb() {
  return Container(
    height: 30,
    width: 30,
    decoration: BoxDecoration(
      color: kSecondaryColor,
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
    ),
  );
}
