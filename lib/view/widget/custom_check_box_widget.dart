import 'package:candid/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

// ignore: must_be_immutable
class CustomCheckBox extends StatelessWidget {
  CustomCheckBox({
    Key? key,
    required this.isActive,
    required this.onTap,
    this.radius = 4,
    this.size = 18,
    this.iconSize = 12,
    this.activeColor = kSecondaryColor,
    this.iconColor = kPrimaryColor,
  }) : super(key: key);

  final bool isActive;
  final VoidCallback onTap;
  final double? radius, size, iconSize;
  final Color? activeColor, iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(
          milliseconds: 230,
        ),
        curve: Curves.easeInOut,
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: isActive ? activeColor : kPrimaryColor,
          borderRadius: BorderRadius.circular(radius!),
          border: isActive
              ? null
              : Border.all(
                  width: 1.0,
                  color: kInputBorderColor,
                ),
        ),
        child: !isActive
            ? SizedBox()
            : Icon(
                Icons.check,
                size: iconSize,
                color: iconColor,
              ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomCheckBox2 extends StatelessWidget {
  CustomCheckBox2({
    Key? key,
    required this.isActive,
    required this.onTap,
    this.unSelectedColor,
    this.isRadio = false,
  }) : super(key: key);

  final bool isActive;
  final bool? isRadio;
  final VoidCallback onTap;
  final Color? unSelectedColor;

  @override
  Widget build(BuildContext context) {
    if (isRadio!) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          height: 18,
          width: 18,
          decoration: BoxDecoration(
            border: GradientBoxBorder(
              gradient: !isActive
                  ? LinearGradient(
                      colors: [
                        kBorderColor,
                        kBorderColor,
                      ],
                    )
                  : LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        kSecondaryColor,
                        kPurpleColor,
                      ],
                    ),
              width: 1.0,
            ),
            shape: BoxShape.circle,
          ),
          child: !isActive
              ? SizedBox()
              : Center(
                  child: AnimatedContainer(
                    margin: EdgeInsets.all(3),
                    duration: Duration(
                      milliseconds: 230,
                    ),
                    curve: Curves.easeInOut,
                    height: Get.height,
                    width: Get.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          kSecondaryColor,
                          kPurpleColor,
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: Duration(
            milliseconds: 230,
          ),
          curve: Curves.easeInOut,
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.0,
              color: isActive ? kSecondaryColor : kPrimaryColor,
            ),
            color: isActive ? kSecondaryColor : kPrimaryColor,
            borderRadius: BorderRadius.circular(3.3),
          ),
          child: !isActive
              ? SizedBox()
              : Icon(
                  Icons.check,
                  size: 16,
                  color: kPrimaryColor,
                ),
        ),
      );
    }
  }
}
