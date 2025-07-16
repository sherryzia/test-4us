import 'package:affirmation_app/constants/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import '../../constants/app_colors.dart';
import 'my_text_widget.dart';

// ignore: must_be_immutable
class MyButton extends StatelessWidget {
  MyButton({
    this.buttonText,
    required this.onTap,
    this.height = 48,
    this.textSize,
    this.weight,
    this.radius,
    this.child,
  });

  final String? buttonText;
  final VoidCallback onTap;
  double? height, textSize, radius;
  FontWeight? weight;
  Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 100),
        border: GradientBoxBorder(
          width: 1.13,
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              kPrimaryColor.withOpacity(0.5),
              kPrimaryColor.withOpacity(0.1),
            ],
          ),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kBlackColor.withOpacity(0.35),
            kPrimaryColor.withOpacity(0.0),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.1),
            blurRadius: 22,
            blurStyle: BlurStyle.inner,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: kPrimaryColor.withOpacity(0.1),
          highlightColor: kPrimaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(radius ?? 100),
          child: child ??
              Center(
                child: MyText(
                  text: buttonText ?? 'Continue',
                  size: textSize ?? 16,
                  weight: weight ?? FontWeight.w600,
                  color: kPrimaryColor,
                  fontFamily: AppFonts.MONTSERRAT,
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
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: splashColor ?? kPrimaryColor.withOpacity(0.1),
        highlightColor: splashColor ?? kPrimaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(radius ?? 100),
        child: child,
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final String buttonText, icon;
  final VoidCallback onTap;
  const SocialButton({
    super.key,
    required this.buttonText,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: Get.width * 0.75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: kPrimaryColor,
          width: 0.85,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kBlackColor.withOpacity(0.35),
            kPrimaryColor.withOpacity(0.0),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.1),
            blurRadius: 16,
            blurStyle: BlurStyle.inner,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          highlightColor: kPrimaryColor.withOpacity(0.1),
          splashColor: kPrimaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                icon,
                height: 18,
              ),
              MyText(
                paddingLeft: 14,
                text: buttonText,
                size: 12.71,
                color: kPrimaryColor,
                weight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
