import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_fonts.dart';
import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String text;
  final String? fontFamily;
  final TextAlign? textAlign;
  final TextDecoration decoration;
  final FontWeight? weight;
  final TextOverflow? overflow;
  final Color? color;
  final Color? decorationColor;

  final FontStyle? fontStyle;
  final VoidCallback? onTap;

  final int? maxLines;
  final double? size;
  final double? lineHeight;
  final double? paddingTop;
  final double? paddingLeft;
  final double? paddingRight;
  final double? paddingBottom;
  final double? letterSpacing;

  final TextStyle? textStyle;

  MyText({
    Key? key,
    required this.text,
    this.size,
    this.lineHeight,
    this.maxLines = 100,
    this.decoration = TextDecoration.none,
    this.color = kTertiaryColor,
    this.letterSpacing,
    this.weight = FontWeight.w400,
    this.textAlign,
    this.overflow,
    this.fontFamily,
    this.paddingTop = 0,
    this.paddingRight = 0,
    this.paddingLeft = 0,
    this.paddingBottom = 0,
    this.onTap,
    this.fontStyle,
    this.textStyle,
    this.decorationColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: paddingTop!,
        left: paddingLeft!,
        right: paddingRight!,
        bottom: paddingBottom!,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          text,
          style: textStyle ??
              TextStyle(
                fontSize: size,
                color: color,
                fontWeight: weight,
                decoration: decoration,
                fontFamily: fontFamily ?? AppFonts.URBANIST,
                height: lineHeight,
                fontStyle: fontStyle,
                letterSpacing: letterSpacing,
                decorationColor: decorationColor,
              ),
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        ),
      ),
    );
  }
}

class MyGradientText extends StatelessWidget {
  final String? text;
  final String? fontFamily;
  final TextAlign? textAlign;
  final TextDecoration? decoration;
  final FontWeight? weight;
  final TextOverflow? textOverflow;
  final FontStyle? fontStyle;
  final VoidCallback? onTap;

  final int? maxLines;
  final double? size;
  final double? lineHeight;
  final double? paddingTop;
  final double? paddingLeft;
  final double? paddingRight;
  final double? paddingBottom;
  final double? letterSpacing;
  const MyGradientText({
    required this.text,
    this.size,
    this.lineHeight,
    this.maxLines = 100,
    this.decoration = TextDecoration.none,
    this.letterSpacing,
    this.weight = FontWeight.w400,
    this.textAlign,
    this.textOverflow,
    this.fontFamily,
    this.paddingTop = 0,
    this.paddingRight = 0,
    this.paddingLeft = 0,
    this.paddingBottom = 0,
    this.onTap,
    this.fontStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: paddingTop!,
        left: paddingLeft!,
        right: paddingRight!,
        bottom: paddingBottom!,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              kBlueColor,
              kSecondaryColor,
            ],
          ).createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          child: Text(
            "$text",
            style: TextStyle(
              fontSize: size,
              fontWeight: weight,
              decoration: decoration,
              fontFamily: fontFamily ?? AppFonts.URBANIST,
              height: lineHeight,
              fontStyle: fontStyle,
              letterSpacing: letterSpacing,
            ),
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: textOverflow,
          ),
        ),
      ),
    );
  }
}
