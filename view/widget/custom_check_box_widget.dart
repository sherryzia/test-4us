import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/constants/app_colors.dart';

// ignore: must_be_immutable
class CustomCheckBox extends StatelessWidget {
  CustomCheckBox({
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
    return isRadio!
        ? GestureDetector(
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
                  width: isActive ? 4 : 2,
                  color: isActive ? kSecondaryColor : kGreyColor,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  height: Get.height,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: isActive ? kPrimaryColor : kLightGreyColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          )
        : GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: Duration(
                milliseconds: 230,
              ),
              curve: Curves.easeInOut,
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: kSecondaryColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: !isActive
                  ? SizedBox()
                  : Icon(
                      Icons.check,
                      size: 14,
                      color: kPrimaryColor,
                    ),
            ),
          );
  }
}
