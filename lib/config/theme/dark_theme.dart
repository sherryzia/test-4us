import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_fonts.dart';

final ThemeData darkTheme = ThemeData(

  scaffoldBackgroundColor: kBlack,
  fontFamily: AppFonts.NUNITO_SANS,
  // splashColor: kPrimaryColor.withOpacity(0.10),
  // highlightColor: kPrimaryColor.withOpacity(0.10),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: kWhite,
    secondary: kSecondaryColor.withOpacity(0.1),
    tertiary: kBlack
  ),
  useMaterial3: false,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: kWhite,
  ),
);
