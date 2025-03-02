import 'package:flutter/material.dart';
import 'package:quran_app/constants/app_colors.dart';
import 'package:quran_app/view/widgets/my_text_widget.dart';

// General Button
class MyButton extends StatelessWidget {
  MyButton({
    required this.buttonText,
    required this.onTap,
    this.height = 48,
    this.textSize,
    this.weight,
    this.radius = 50.0,
    this.customChild,
    this.bgColor,
    this.textColor,
    this.mBottom,
    this.mTop,
  });

  final String buttonText;
  final VoidCallback onTap;
  double? height, textSize, radius;
  FontWeight? weight;
  Widget? customChild;
  Color? bgColor, textColor;
  double? mTop, mBottom;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: mTop ?? 0, bottom: mBottom ?? 0),
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius!),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [kPurpleColor, kTextPurple], // ✅ Updated gradient
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 10,
            color: kBlack.withOpacity(0.2), // ✅ Consistent shadow effect
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: kWhite.withOpacity(0.2),
          highlightColor: kWhite.withOpacity(0.2),
          borderRadius: BorderRadius.circular(radius!),
          child: customChild ??
              Center(
                child: MyText(
                  text: buttonText,
                  size: textSize ?? 15,
                  weight: weight ?? FontWeight.w500,
                  color: textColor ?? kWhite, // ✅ Ensured white text for contrast
                ),
              ),
        ),
      ),
    );
  }
}

// Toggle Button
class MyToggleButton extends StatelessWidget {
  MyToggleButton({
    required this.title,
    required this.onTap,
    required this.isSelected,
  });

  final String title;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: isSelected ? kLightPurpleColor : kBorderColor.withOpacity(0.1),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                  color: kPurpleColor.withOpacity(0.2),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: kWhite.withOpacity(0.2),
          highlightColor: kWhite.withOpacity(0.2),
          borderRadius: BorderRadius.circular(50),
          child: Center(
            child: MyText(
              text: title,
              textAlign: TextAlign.center,
              size: 14,
              weight: FontWeight.w500,
              color: isSelected ? kPurpleColor : kLightGray,
            ),
          ),
        ),
      ),
    );
  }
}

// Outlined Border Button
class MyBorderButton extends StatelessWidget {
  MyBorderButton({
    required this.buttonText,
    required this.onTap,
    this.height = 48,
    this.textSize,
    this.weight,
    this.child,
    this.radius = 50.0,
    this.borderColor,
    this.mBottom,
    this.mTop,
  });

  final String buttonText;
  final VoidCallback onTap;
  double? height, textSize, radius;
  FontWeight? weight;
  Widget? child;
  Color? borderColor;
  double? mTop, mBottom;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: mTop ?? 0, bottom: mBottom ?? 0),
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius!),
        color: kWhite, // ✅ Ensure white background
        border: Border.all(
          width: 1.5,
          color: borderColor ?? kPurpleColor, // ✅ Purple border
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 8,
            color: kBlack.withOpacity(0.1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: kPurpleColor.withOpacity(0.2),
          highlightColor: kPurpleColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(radius!),
          child: child ??
              Center(
                child: MyText(
                  text: buttonText,
                  size: textSize ?? 15,
                  weight: weight ?? FontWeight.w500,
                  color: borderColor ?? kPurpleColor, // ✅ Keep consistent with border
                ),
              ),
        ),
      ),
    );
  }
}
