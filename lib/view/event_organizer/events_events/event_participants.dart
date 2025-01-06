import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/constants/app_fonts.dart';
import 'package:forus_app/constants/app_sizes.dart';
import 'package:forus_app/generated/assets.dart';
import 'package:forus_app/view/widget/common_image_view_widget.dart';
import 'package:forus_app/view/widget/my_text_widget.dart';
import 'package:forus_app/view/widget/my_text_field.dart';

class EventparticipantsScreens extends StatefulWidget {
  const EventparticipantsScreens({super.key});

  @override
  State<EventparticipantsScreens> createState() =>
      _EventparticipantsScreensState();
}

class _EventparticipantsScreensState extends State<EventparticipantsScreens> {
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
          text: "Event Participants ",
          size: 18,
          weight: FontWeight.w700,
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: InkWell(
              onTap: () {},
              child: CommonImageView(
                imagePath: Assets.imagesDownloadicon,
                height: 24,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: AppSizes.DEFAULT2,
        children: [
          MyTextField(
            marginBottom: 8,
            hint: 'Search User',
            hintColor: kTextGrey,
            labelColor: kWhite,
            radius: 8,
            prefix: Padding(
              padding: const EdgeInsets.all(12),
              child: CommonImageView(
                imagePath: Assets.imagesSearchNormal,
                height: 20,
              ),
            ),
            filledColor: kTransperentColor,
            kBorderColor: kBorderGrey,
            kFocusBorderColor: KColor1,
          ),
          EventparticipantsContainer(),
          EventparticipantsContainer(),
          EventparticipantsContainer(),
          EventparticipantsContainer(),
          EventparticipantsContainer(),
          EventparticipantsContainer(),
          EventparticipantsContainer(),
          EventparticipantsContainer(),
          EventparticipantsContainer(),
          EventparticipantsContainer(),
          EventparticipantsContainer(),
          EventparticipantsContainer(),
        ],
      ),
    );
  }

  Container EventparticipantsContainer() {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonImageView(
                imagePath: Assets.imagesChat1,
                height: 50,
              ),
              Gap(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: "Michael Smith",
                      size: 16,
                      weight: FontWeight.w600,
                    ),
                    Gap(5),
                    MyText(
                      text: "Joined in event 21/6/2024",
                      size: 12,
                      color: kTextGrey,
                      weight: FontWeight.w400,
                    ),
                  ],
                ),
              )
            ],
          ),
          Divider(
            thickness: 1,
            color: kDividerGrey2,
          )
        ],
      ),
    );
  }
}
