import 'package:candid/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final Widget child;
  final double? horizontalMargin, height;
  const CustomDialog({
    super.key,
    required this.child,
    this.horizontalMargin = 32,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: height,
            margin: EdgeInsets.symmetric(horizontal: horizontalMargin!),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
