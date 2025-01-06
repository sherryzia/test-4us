// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:forus_app/view/widget/common_image_view_widget.dart';
import 'package:forus_app/view/widget/my_text_widget.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/constants/app_fonts.dart';
import 'package:forus_app/constants/app_sizes.dart';
import 'package:forus_app/generated/assets.dart';

class EventContactUsScreen extends StatefulWidget {
  const EventContactUsScreen({super.key});

  @override
  State<EventContactUsScreen> createState() =>
      _EventContactUsScreenState();
}

class _EventContactUsScreenState extends State<EventContactUsScreen> {
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
          text: "Contact Us",
          size: 18,
          weight: FontWeight.w700,
        ),
        centerTitle: true,
      ),
      backgroundColor: AppThemeColors.getTertiary(context),
      body: ListView(
        padding: AppSizes.DEFAULT2,
        children: [
          Column(
            children: [
              CommonImageView(
                imagePath: Assets.imagesContactusmain,
                height: 270,
              ),
              MyText(
                text: "Hey we’re here to help !",
                size: 22,
                paddingTop: 19,
                paddingBottom: 6,
                textAlign: TextAlign.center,
                fontFamily: AppFonts.NUNITO_SANS,
                weight: FontWeight.w700,
              ),
              MyText(
                text: "Got a question about our service ? Just ask!",
                size: 16,
                textAlign: TextAlign.center,
                fontFamily: AppFonts.NUNITO_SANS,
                weight: FontWeight.w500,
              ),
              home_container(
                  Text1: 'Call Us',
                  Text2: '+1  000 0000 000',
                  img: Assets.imagesCallus),
              home_container(
                  Text1: 'Email Us',
                  Text2: 'linked4us@gmail.com',
                  img: Assets.imagesEmailus)
            ],
          )
        ],
      ),
    );
  }

  Container home_container({
    required String Text1,
    required String Text2,
    required String img,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: kBorderGrey,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Aligns content at the top
            children: [
              // Space between image and the column
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: Text1,
                      size: 18,
                      fontFamily: AppFonts.NUNITO_SANS,
                      weight: FontWeight.w700,
                    ),

                    MyText(
                      text: Text2,
                      size: 16,
                      color: kTextGrey,
                      fontFamily: AppFonts.NUNITO_SANS,
                      weight: FontWeight.w600,
                    ), // Space between text and Row
                  ],
                ),
              ),

              CommonImageView(
                imagePath: img,
                height: 45,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
