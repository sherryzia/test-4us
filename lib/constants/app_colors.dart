// ignore_for_file: use_full_hex_values_for_flutter_colors, constant_identifier_names

import 'package:flutter/material.dart';

const kBackGroundColor = Color(0xFFF3F3F3);
const kPrimaryColor = Color(0xFFFFFFFF);
const kSecondaryColor = Color(0xFFA22722);
const kSecondaryLightColor = Color(0x19A22722);
const kTertiaryColor = Color(0xFF8C8C8C);
const kQuaternaryColor = Color(0xFFFBC20F);
const kQuaternaryLightColor = Color(0x19FBC20F);
const kBlackColor = Color(0xFF262626);
const kHintColor = Color(0xFFBEB8C4);
const kTFBorderColor = Color(0x4C24123A);
const kCBColor = Color(0x1924123A);
const kCBCColor = Color(0x0724123A);
const kGreenColor = Color(0xFF5CDE3C);








const LinearGradient brownwhite = LinearGradient(
    colors: [
      Color(0xffF6EED0),
      kPrimaryColor, // Start color
      Color(0xffF6EED0),
      // End color
    ],
    stops: [
      0.2,
      0.8,
      1,
    ], // Adjust stops to control color portions
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter);

const LinearGradient blacktrans = LinearGradient(
    colors: [
      Color.fromARGB(31, 9, 0, 0),
      Color.fromARGB(231, 0, 0, 0),
      Color.fromARGB(231, 0, 0, 0),
      // End color
    ],
    stops: [
      0.7,
      0.8,
      0.9,
    ], // Adjust stops to control color portions
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter);
LinearGradient whites2(Color color) {
  return LinearGradient(
      colors: [
        color,
        color.withOpacity(0.0),
      ],
      begin: Alignment.centerRight,
      end: Alignment.centerLeft,
      stops: [
        0.0,
        1,
      ]);
}
