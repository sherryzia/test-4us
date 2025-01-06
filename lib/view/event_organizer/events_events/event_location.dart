import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/constants/app_fonts.dart';
import 'package:forus_app/constants/app_sizes.dart';
import 'package:forus_app/generated/assets.dart';
import 'package:forus_app/view/event_organizer/events_events/events_previous.dart';
import 'package:forus_app/view/widget/common_image_view_widget.dart';
import 'package:forus_app/view/widget/my_button_widget.dart';
import 'package:forus_app/view/widget/my_text_widget.dart';
import 'package:forus_app/view/widget/my_text_field.dart';

class EventLocationScreen extends StatefulWidget {
  const EventLocationScreen({super.key});

  @override
  State<EventLocationScreen> createState() => _EventLocationScreenState();
}

class _EventLocationScreenState extends State<EventLocationScreen> {
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
          text: "Create Event",
          size: 18,
          weight: FontWeight.w800,
          fontFamily: AppFonts.NUNITO_SANS,
        ),
        centerTitle: true,
      ),
      body: InkWell(
        onTap: () {
          showMapBottomSheet();
        },
        child: Container(
          padding: AppSizes.DEFAULT,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.imagesMap),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              MyTextField(
                hint: 'Search location ',
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
            ],
          ),
        ),
      ),
    );
  }
}

void showMapBottomSheet() {
  Get.bottomSheet(
    isScrollControlled: false,
    Container(
      height: 200,
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        children: [
          Padding(
              padding: AppSizes.DEFAULT,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(24),
                  Row(
                    children: [
                      CommonImageView(
                        imagePath: Assets.imagesLocationPin,
                        height: 21,
                        width: 16,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MyText(
                            text: "Brooklyn Westernmost",
                            size: 16,
                            paddingRight: 8,
                            weight: FontWeight.w600,
                            fontFamily: AppFonts.NUNITO_SANS,
                          ),
                          MyText(
                            text: "Atlantic AveBay Shore, New York",
                            size: 13,
                            paddingLeft: 18,
                            color: kTextGrey,
                            weight: FontWeight.w500,
                            fontFamily: AppFonts.NUNITO_SANS,
                          ),
                        ],
                      )
                    ],
                  ),
                  Gap(20),
                  MyButton(
                      buttonText: "Confirm Address",
                      radius: 14,
                      textSize: 20,
                      weight: FontWeight.w800,
                      onTap: () {
                        Get.to(() => EventPreviewsScreen());
                      }),
                ],
              )),
        ],
      ),
    ),
  );
}
