import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_images.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';

AppBar simpleAppBar({
  bool haveLeading = true,
  String? title,
  bool? centerTitle = true,
  List<Widget>? actions,
}) {
  return AppBar(
    centerTitle: centerTitle,
    automaticallyImplyLeading: false,
    titleSpacing: 20.0,
    leading: haveLeading
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Image.asset(
                  Assets.imagesArrowBack,
                  height: 16,
                ),
              ),
            ],
          )
        : null,
    title: MyText(
      text: title ?? '',
      size: 18,
      color: kBlackColor,
      weight: FontWeight.w600,
    ),
    actions: actions,
  );
}
