import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class AppStyling {
  static final defaultPinTheme = PinTheme(
    height: 66,
    width: 63,
    margin: EdgeInsets.zero,
    padding: EdgeInsets.zero,
    textStyle: TextStyle(
      fontSize: 24,
      color: kTertiaryColor,
      fontWeight: FontWeight.w500,
      fontFamily: AppFonts.URBANIST,
    ),
    decoration: BoxDecoration(
      color: kPrimaryColor,
      shape: BoxShape.circle,
    ),
  );
  static final focusPinTheme = PinTheme(
    height: 66,
    width: 63,
    margin: EdgeInsets.zero,
    padding: EdgeInsets.zero,
    textStyle: TextStyle(
      fontSize: 24,
      color: kSecondaryColor,
      fontWeight: FontWeight.w500,
      fontFamily: AppFonts.URBANIST,
    ),
    decoration: BoxDecoration(
      color: kPrimaryColor,
      shape: BoxShape.circle,
    ),
  );

  // Custom List Tile
  static final LIST_TILE_12 = BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    color: kPrimaryColor,
    boxShadow: [
      BoxShadow(
        offset: Offset(0, 4),
        blurRadius: 20,
        color: Color(0xff515151).withOpacity(0.05),
      ),
    ],
  );
  static final LIST_TILE_16 = BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    color: kPrimaryColor,
    boxShadow: [
      BoxShadow(
        offset: Offset(0, 10),
        blurRadius: 26,
        color: Color(0xff000000).withOpacity(0.05),
      ),
    ],
  );

  static final DEFAULT_SHADOW = BoxShadow(
    offset: Offset(0, 4),
    blurRadius: 10,
    color: kBlackColor.withOpacity(0.05),
  );

}
