import 'package:flutter/material.dart';
import 'package:forus_app/config/theme/theme_config.dart';

const KColor1 = Color(0xFFD08531);
const KColor2 = Color(0xFF311E0C);
const KColor3 = Color(0xFFDCA971);
const KColor4 = Color(0xFF663B0B);
const KColor5 = Color(0xFFA66514);
const KColor6 = Color(0xFFEEA94B);
const KColor7 = Color(0xFFB57C32);
const KColor8 = Color(0xFF8D520D);
const KColor9 = Color(0xFFE6C198);
const KColor10 = Color(0xFFEFDEC8);
const KColor11 = Color(0xFFF2EEE8);
const KColor12 = Color(0xFFF0EAD6);
const KColor13 = Color(0xFF212121);
const KColor14 = Color(0xFFF4F4F4);
const KColor15 = Color(0xFFBD864E);
const KColor16GradientColor = LinearGradient(colors: [
  Color(0xFFE7AF74),
  Color(0xFFA76B2C),
], stops: [
  0.0,
  0.1,
]);
const KColor16 = Color(0xFF17152F);
const KColor18 = Color(0xFFCD95EE);

const kSecondaryColor = Color(0xffffffff);
const kQuaternaryColor = Color(0xff000000);
const kTertiaryColor = Color(0xff004aad);
const kTertiaryColor2 = Color(0xff304D6B);

const kColorNew1 = Color(0xFF391929);
const kColorNew2 = Color(0xFF1E8CBA);
const kColorNew3 = Color(0xFFB652EC);
const kColorStock = Color(0xFF353535);
const kWhite = Color(0xFFFFFFFF);
const kBlack = Color(0xFF000000);
const kTransperentColor = Colors.transparent;
const kredColor = Color(0xFFFF4A4A);
const kredlightColor = Color(0xFFF45756);

const kborder = Color(0xFF000000);
const kborderOrange = Color(0xFFE7AF74);
const kborderOrangelight = Color.fromARGB(255, 232, 181, 126);

const kborderOrange2 = Color(0xFFFAB04D);
const kBorderGrey = Color(0xFFE8E9ED);
const kborderGrey2 = Color(0xFFE1EAF6);
const kBorderGreen = Color(0xFF2BB927);

const kContainerColor = Color(0xFFFBF5DF);
const kContainerColorGreen = Color(0xFF2BB927);
const kContainerColorOrange= Color(0xFFFE6E09);
const kContainerColorOrang2= Color(0xFFAE6810);


const kDividerGrey = Color(0xFFCED2D7);
const kDividerGrey2 = Color(0xFFDCDCDC);
const kDividerGrey3 = Color(0xFFD9D9D9);


const kTextGrey = Color(0xFFA6A6A6);
const kTextGrey2 = Color(0xFF5F5F5F);
const kTextGrey3 = Color(0xFF4D4D4D);
const kTextGrey4 = Color(0xFF545454);

const kTextOrange = Color(0xFFDA8A31);
const kTextOrange2 = Color(0xFFAE6810);
const kTextOrange3 = Color(0xFFF0C99E);

const kTextDarkorange = Color(0xFF935508);
const kTextDarkorange2 = Color(0xFF331E0B);
const kTextDarkorange3 = Color(0xFF998E85);
const kTextDarkorange4 = Color(0xFF6A3C08);

const kswtich = Color(0xFFEBEBEB);
const kswtich2 = Color(0xFFC9AA83);

const kbuttoncolor = Color(0xFFFAE8D0);



ThemeConfig themeConfig = ThemeConfig.instance;

class AppThemeColors {
  static Color getPrimaryColor(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }

  static Color getSecondaryColor(BuildContext context) {
    return Theme.of(context).colorScheme.secondary;
  }

  static Color getTertiary(BuildContext context) {
    return Theme.of(context).colorScheme.tertiary;
  }

  static Color getquaternary(BuildContext context) {
    return Theme.of(context).colorScheme.onPrimary;
  }

  static Color getfifth(BuildContext context) {
    return Theme.of(context).colorScheme.onTertiary;
  }

  static Color getsplashcolor(BuildContext context) {
    return Theme.of(context).splashColor;
  }

  static Color getblack(BuildContext context) {
    return Theme.of(context).shadowColor;
  }
}
