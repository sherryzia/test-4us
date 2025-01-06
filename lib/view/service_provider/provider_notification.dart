import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/constants/app_sizes.dart';
import 'package:forus_app/generated/assets.dart';
import 'package:forus_app/view/widget/common_image_view_widget.dart';
import 'package:forus_app/view/widget/my_text_widget.dart';

class ProviderNotificationsScreens extends StatefulWidget {
  const ProviderNotificationsScreens({super.key});

  @override
  State<ProviderNotificationsScreens> createState() =>
      _ProviderNotificationsScreensState();
}

class _ProviderNotificationsScreensState
    extends State<ProviderNotificationsScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemeColors.getTertiary(context),
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: CommonImageView(
              imagePath: Assets.imagesArrowLeft,
              height: 24,
            ),
          ),
        ),
        title: MyText(
          text: "Notifications",
          size: 18,
          weight: FontWeight.w700,
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: AppSizes.DEFAULT2,
        children: [
          NotificationContainer(),
          NotificationContainer(),
          NotificationContainer(),
          NotificationContainer(),
          NotificationContainer(),
          NotificationContainer(),
          NotificationContainer(),
          NotificationContainer(),
          NotificationContainer(),
          NotificationContainer(),
          NotificationContainer(),
          NotificationContainer(),
          NotificationContainer(),
        ],
      ),
    );
  }

  Container NotificationContainer() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: kborder.withOpacity(0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonImageView(
            imagePath: Assets.imagesBell,
            height: 50,
          ),
          Gap(10),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: "Lorem ipsum dolor",
                      size: 14,
                      weight: FontWeight.w600,
                    ),
                    MyText(
                      text: "3hr ago",
                      size: 12,
                      color: kTextGrey,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
                Gap(5),
                MyText(
                  text:
                      "Lorem ipsum dolor sit amet consectetur. Urna odio vulputate ut quisque .",
                  size: 12,
                  color: kTextGrey,
                  weight: FontWeight.w400,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
