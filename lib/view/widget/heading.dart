import 'package:flutter/widgets.dart';
import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthHeading extends StatelessWidget {
  final String title, subTitle;
  const AuthHeading({
    super.key,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 40,
        bottom: 32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Image.asset(
                  Assets.imagesBack,
                  height: 30,
                ),
              ),
              Expanded(
                child: MyText(
                  text: title,
                  size: 24,
                  color: kPrimaryColor,
                  weight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                  paddingLeft: 16,
                ),
              ),
            ],
          ),
          MyText(
            text: subTitle,
            size: 16,
            lineHeight: 1.5,
            color: kPrimaryColor,
            weight: FontWeight.w500,
            paddingTop: 16,
          ),
        ],
      ),
    );
  }
}

class ProfileHeading extends StatelessWidget {
  final String title;
  const ProfileHeading({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 24,
          width: 16,
          decoration: BoxDecoration(
            color: kSecondaryColor.withOpacity(0.7),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        MyText(
          text: title,
          weight: FontWeight.w500,
          paddingLeft: 16,
        ),
      ],
    );
  }
}
