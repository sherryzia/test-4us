import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

// ignore: must_be_immutable
class CustomCheckBox extends StatelessWidget {
  CustomCheckBox(
      {Key? key,
      required this.isActive,
      required this.onTap,
      this.unSelectedColor,
      this.selectedColor,
      this.iscircle})
      : super(key: key);

  final bool isActive;
  final VoidCallback onTap;
  Color? unSelectedColor, selectedColor;
  bool? iscircle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 20,
        width: 20,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(width: 2.0, color: kSecondaryColor),
          borderRadius: BorderRadius.circular(iscircle == true ? 50 : 5),
        ),
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 230,
          ),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isActive
                ? selectedColor ?? kSecondaryColor
                : Colors.transparent,
            border: Border.all(
              width: 1.0,
              color: isActive
                  ? unSelectedColor ?? kSecondaryColor
                  : unSelectedColor ?? Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(iscircle == true ? 50 : 5),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomRadioButton extends StatelessWidget {
  CustomRadioButton({
    Key? key,
    required this.groupValue,
    required this.value,
    required this.onChanged,
    this.unSelectedColor,
    this.selectedColor,
    this.isCircle = true,
  }) : super(key: key);

  final dynamic groupValue; // Current selected value of the radio button group
  final dynamic value; // Value of this radio button
  final ValueChanged<dynamic> onChanged;
  final Color? unSelectedColor, selectedColor;
  final bool isCircle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 230),
        curve: Curves.easeInOut,
        height: 19,
        width: 19,
        decoration: BoxDecoration(
          color: groupValue == value
              ? selectedColor ?? kSecondaryColor
              : Colors.transparent,
          border: Border.all(
            width: 1.0,
            color: groupValue == value
                ? selectedColor ?? kSecondaryColor
                : unSelectedColor ?? kSecondaryColor,
          ),
          borderRadius: BorderRadius.circular(isCircle ? 50 : 5),
        ),
        child: groupValue == value
            ? Center(
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    color: selectedColor ?? kSecondaryColor,
                    shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
