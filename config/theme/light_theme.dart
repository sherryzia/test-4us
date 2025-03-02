import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_fonts.dart';

final ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: kWhite,
  fontFamily: AppFonts.NUNITO_SANS,
  appBarTheme: AppBarTheme(
    elevation: 0,
    // backgroundColor: AppThemeColors.getPrimaryColor
  ),
  // splashColor: kPrimaryColor.withOpacity(0.10),
  // highlightColor: kPrimaryColor.withOpacity(0.10),
  colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: kBlack,
      secondary: kSecondaryColor.withOpacity(0.1),
      tertiary: kWhite),
  useMaterial3: false,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: kBlack,
  ),
);
