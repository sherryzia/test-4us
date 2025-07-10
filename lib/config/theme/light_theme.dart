import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_fonts.dart';
import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: kPrimaryColor,
  fontFamily: AppFonts.URBANIST,
  appBarTheme: AppBarTheme(
    backgroundColor: kPrimaryColor,
    elevation: 0,
  ),
  splashColor: kSecondaryColor.withOpacity(0.10),
  highlightColor: kSecondaryColor.withOpacity(0.10),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: kSecondaryColor.withOpacity(0.1),
  ),
  useMaterial3: false,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: kSecondaryColor,
  ),
);
