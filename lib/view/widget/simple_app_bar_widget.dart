import 'package:get/get.dart';
import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

AppBar simpleAppBar({
  required String title,
  bool? haveLeading = true,
  List<Widget>? actions,
  VoidCallback? onLeading,
}) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    automaticallyImplyLeading: false,
    titleSpacing: haveLeading! ? 0 : 20,
    leading: haveLeading
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onLeading ?? () => Get.back(),
                child: Image.asset(
                  Assets.imagesArrowBackIcon,
                  height: 24,
                ),
              ),
            ],
          )
        : null,
    title: MyText(
      text: title,
      size: 18,
      color: kTertiaryColor,
      weight: FontWeight.w600,
    ),
    actions: actions,
  );
}

class SimpleAppBar extends StatelessWidget {
  SimpleAppBar({
    super.key,
    required this.title,
    this.titleSize,
    this.marginBottom,
    this.onBackTap,
    this.actions, // Add actions parameter
  });

  final String title;
  final double? titleSize, marginBottom;
  final VoidCallback? onBackTap;
  final List<Widget>? actions; // Actions list for right side widgets

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 51.7, 16, marginBottom ?? 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBackTap ??
                () {
                  Navigator.pop(context);
                },
            child: Image.asset(
              Assets.imagesArrowBackIcon,
              height: 24,
            ),
          ),
          Expanded(
            child: MyText(
              paddingLeft: 8,
              text: title,
              size: titleSize ?? 18,
              weight: FontWeight.w600,
            ),
          ),
          // Replace the fixed SizedBox with flexible actions
          if (actions != null && actions!.isNotEmpty)
            ...actions!
          else
            SizedBox(
              width: 24,
              height: 24,
            ),
        ],
      ),
    );
  }
}