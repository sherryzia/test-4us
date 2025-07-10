import 'package:candid/constants/app_colors.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

// ignore: must_be_immutable
class MyButton extends StatelessWidget {
  MyButton({
    required this.buttonText,
    required this.onTap,
    this.bgColor,
    this.textColor = kPrimaryColor,
    this.borderColor = kSecondaryColor,
    this.weight = FontWeight.w600,
    this.height = 52,
    this.textSize = 16,
    this.radius = 50,
    this.borderWidth = 0.0,
    this.splashColor,
    this.child,
  });

  final String buttonText;
  final VoidCallback onTap;
  final double? height, textSize, radius, borderWidth;
  final Color? bgColor, textColor, borderColor, splashColor;
  final FontWeight? weight;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius!),
        border: borderWidth == 0
            ? null
            : Border.all(
                width: borderWidth!,
                color: borderColor!,
              ),
        gradient: bgColor == null
            ? LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  kSecondaryColor,
                  kPurpleColor,
                ],
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: splashColor ?? kPrimaryColor.withOpacity(0.2),
          highlightColor: splashColor ?? kPrimaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(radius!),
          child: child != null
              ? child
              : Center(
                  child: MyText(
                    text: buttonText,
                    size: textSize,
                    weight: weight,
                    color: textColor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class MyBorderButton extends StatelessWidget {
  MyBorderButton({
    required this.buttonText,
    required this.onTap,
    this.weight = FontWeight.w600,
    this.height = 52,
    this.textSize = 16,
    this.radius = 50,
    this.child,
  });

  final String buttonText;
  final VoidCallback onTap;
  final double? height, textSize, radius;
  final FontWeight? weight;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius!),
        border: GradientBoxBorder(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              kSecondaryColor,
              kPurpleColor,
            ],
          ),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: kSecondaryColor.withOpacity(0.05),
          highlightColor: kSecondaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(radius!),
          child: child != null
              ? child
              : Center(
                  child: MyGradientText(
                    text: buttonText,
                    size: textSize,
                    weight: weight,
                  ),
                ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class MyRippleEffect extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  Color? splashColor;
  double? radius;
  MyRippleEffect({
    super.key,
    required this.child,
    required this.onTap,
    this.splashColor,
    this.radius = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: splashColor ?? kBlackColor.withOpacity(0.1),
        highlightColor: splashColor ?? kBlackColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(radius!),
        child: child,
      ),
    );
  }
}
