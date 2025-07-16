import 'package:affirmation_app/constants/app_colors.dart';
import 'package:affirmation_app/constants/app_images.dart';
import 'package:affirmation_app/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SimpleAppBar extends StatelessWidget {
  final String title;
  final bool? haveLeading;
  const SimpleAppBar({
    super.key,
    required this.title,
    this.haveLeading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.only(
        bottom: 8,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: kGreyColor3,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (haveLeading!)
            Padding(
              padding: const EdgeInsets.only(right: 22),
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Image.asset(
                  Assets.imagesArrowBack,
                  height: 16,
                ),
              ),
            ),
          Expanded(
            child: MyText(
              text: title,
              size: 25,
              weight: FontWeight.w700,
            ),
          ),
          // Image.asset(
          //   Assets.imagesBellIconBg,
          //   height: 50,
          // ),
        ],
      ),
    );
  }
}
