import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:forus_app/view/widget/custom_drop_down_widget.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/constants/app_fonts.dart';
import 'package:forus_app/constants/app_sizes.dart';
import 'package:forus_app/generated/assets.dart';
import 'package:forus_app/view/event_organizer/events_events/event_location.dart';
import 'package:forus_app/view/service_provider/provider_messages/chat_messages.dart';
import 'package:forus_app/view/widget/common_image_view_widget.dart';
import 'package:forus_app/view/widget/my_button_widget.dart';
import 'package:forus_app/view/widget/my_text_widget.dart';
import 'package:forus_app/view/widget/my_text_field.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  String _selectedEventType = 'Paid';
  String _selectedEventType2 = 'Yes';

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
          weight: FontWeight.w700,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    height: 110,
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.symmetric(horizontal: 87, vertical: 13),
                    decoration: BoxDecoration(
                      color: kContainerColor,
                      border: Border.all(color: Color(0xFFFAE8D0)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CommonImageView(
                          imagePath: Assets.imagesGalleryExport,
                          height: 24,
                        ),
                        MyText(
                          text: 'Upload Event Cover Image',
                          size: 10,
                          paddingTop: 6,
                          textAlign: TextAlign.center,
                          fontFamily: AppFonts.NUNITO_SANS,
                          weight: FontWeight.w800,
                        ),
                      ],
                    ),
                  ),
                  Gap(14),
                  MyTextField(
                    hint: 'Event Title here',
                    hintColor: kTextGrey,
                    labelColor: kWhite,
                    radius: 8,
                    filledColor: kTransperentColor,
                    kBorderColor: kBorderGrey,
                    kFocusBorderColor: KColor1,
                  ),
                  Gap(9),
                  CustomDropDown(
                    hint: 'Category1',
                    items: [
                      'Category1',
                      'Category2',
                      'Category3',
                    ],
                    selectedValue: 'Category1',
                    onChanged: (v) {},
                  ),
                  CustomDropDown(
                    hint: 'Sub Category',
                    items: [
                      'Sub Category1',
                      'Sub Category2',
                      'Sub Category3',
                    ],
                    selectedValue: 'Sub Category1',
                    onChanged: (v) {},
                  ),
                  MyTextField(
                    hint: 'Event Description',
                    hintColor: kTextGrey,
                    maxLines: 5,
                    labelColor: kWhite,
                    radius: 8,
                    kBorderColor: kBorderGrey,
                    kFocusBorderColor: KColor1,
                  ),
                  Gap(9),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextField(
                          hint: 'Start Date',
                          hintColor: kTextGrey,
                          labelColor: kWhite,
                          radius: 8,
                          suffix: Padding(
                            padding: const EdgeInsets.all(12),
                            child: CommonImageView(
                              imagePath: Assets.imagesCalendargrey,
                              height: 22,
                            ),
                          ),
                          filledColor: kTransperentColor,
                          kBorderColor: kBorderGrey,
                          kFocusBorderColor: KColor1,
                        ),
                      ),
                      Gap(9),
                      Expanded(
                        child: MyTextField(
                          hint: 'End Date',
                          hintColor: kTextGrey,
                          labelColor: kWhite,
                          radius: 8,
                          suffix: Padding(
                            padding: const EdgeInsets.all(12),
                            child: CommonImageView(
                              imagePath: Assets.imagesClockgrey,
                              height: 22,
                            ),
                          ),
                          filledColor: kTransperentColor,
                          kBorderColor: kBorderGrey,
                          kFocusBorderColor: KColor1,
                        ),
                      ),
                    ],
                  ),
                  Gap(9),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextField(
                          hint: 'Start Date',
                          hintColor: kTextGrey,
                          labelColor: kWhite,
                          radius: 8,
                          suffix: Padding(
                            padding: const EdgeInsets.all(12),
                            child: CommonImageView(
                              imagePath: Assets.imagesCalendargrey,
                              height: 22,
                            ),
                          ),
                          filledColor: kTransperentColor,
                          kBorderColor: kBorderGrey,
                          kFocusBorderColor: KColor1,
                        ),
                      ),
                      Gap(9),
                      Expanded(
                        child: MyTextField(
                          hint: 'End Date',
                          hintColor: kTextGrey,
                          labelColor: kWhite,
                          radius: 8,
                          suffix: Padding(
                            padding: const EdgeInsets.all(12),
                            child: CommonImageView(
                              imagePath: Assets.imagesClockgrey,
                              height: 22,
                            ),
                          ),
                          filledColor: kTransperentColor,
                          kBorderColor: kBorderGrey,
                          kFocusBorderColor: KColor1,
                        ),
                      ),
                    ],
                  ),
                  Gap(9),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MyText(
                        text: 'Event Type',
                        size: 16,
                        color: kBlack,
                        textAlign: TextAlign.center,
                        fontFamily: AppFonts.NUNITO_SANS,
                        weight: FontWeight.w800,
                      ),
                      SizedBox(width: 16),
                      Row(
                        children: [
                          Row(
                            children: [
                              Radio<String>(
                                value: 'Free',
                                groupValue: _selectedEventType,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedEventType = value!;
                                  });
                                },
                                activeColor: kTextDarkorange,
                              ),
                              MyText(
                                text: 'Free Event',
                                size: 15,
                                color: kTextGrey,
                                textAlign: TextAlign.center,
                                fontFamily: AppFonts.NUNITO_SANS,
                                weight: FontWeight.w500,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Radio<String>(
                                value: 'Paid',
                                groupValue: _selectedEventType,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedEventType = value!;
                                  });
                                },
                                activeColor: kTextDarkorange,
                              ),
                              MyText(
                                text: 'Paid Event',
                                size: 15,
                                color: kTextGrey,
                                textAlign: TextAlign.center,
                                fontFamily: AppFonts.NUNITO_SANS,
                                weight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  MyTextField(
                    hint: 'Enter Ticket Charges per person',
                    hintColor: kTextGrey,
                    labelColor: kBlack,
                    radius: 8,
                    suffix: Padding(
                      padding: const EdgeInsets.all(12),
                      child: CommonImageView(
                        imagePath: Assets.imagesDollarCircle,
                        height: 22,
                      ),
                    ),
                    filledColor: kTransperentColor,
                    kBorderColor: kBorderGrey,
                    kFocusBorderColor: KColor1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MyText(
                        text: 'Is limited event?',
                        size: 16,
                        color: kBlack,
                        textAlign: TextAlign.center,
                        fontFamily: AppFonts.NUNITO_SANS,
                        weight: FontWeight.w800,
                      ),
                      SizedBox(width: 16),
                      Row(
                        children: [
                          Row(
                            children: [
                              Radio<String>(
                                value: 'Yes',
                                groupValue: _selectedEventType2,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedEventType2 = value!;
                                  });
                                },
                                activeColor: kTextDarkorange,
                              ),
                              MyText(
                                text: 'Yes',
                                size: 15,
                                color: kTextGrey,
                                textAlign: TextAlign.center,
                                fontFamily: AppFonts.NUNITO_SANS,
                                weight: FontWeight.w500,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Radio<String>(
                                value: 'No',
                                groupValue: _selectedEventType2,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedEventType2 = value!;
                                  });
                                },
                                activeColor: kTextDarkorange,
                              ),
                              MyText(
                                text: 'No',
                                size: 15,
                                color: kTextGrey,
                                textAlign: TextAlign.center,
                                fontFamily: AppFonts.NUNITO_SANS,
                                weight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  MyTextField(
                    hint: 'Enter event person limit',
                    hintColor: kTextGrey,
                    labelColor: kBlack,
                    radius: 8,
                    suffix: Padding(
                      padding: const EdgeInsets.all(12),
                      child: CommonImageView(
                        imagePath: Assets.imagesPeople,
                        height: 22,
                      ),
                    ),
                    filledColor: kTransperentColor,
                    kBorderColor: kBorderGrey,
                    kFocusBorderColor: KColor1,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.symmetric(horizontal: 87, vertical: 13),
                    decoration: BoxDecoration(
                      color: kContainerColor,
                      border: Border.all(color: kborderOrange2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CommonImageView(
                          imagePath: Assets.imagesPin,
                          height: 24,
                        ),
                        MyText(
                          text: 'Add Event Location',
                          size: 15,
                          paddingLeft: 5,
                          color: kTextDarkorange,
                          textAlign: TextAlign.center,
                          fontFamily: AppFonts.NUNITO_SANS,
                          weight: FontWeight.w800,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            MyButton(
                buttonText: "Preview Event",
                radius: 14,
                textSize: 18,
                weight: FontWeight.w800,
                onTap: () {
                  Get.to(() => EventLocationScreen());
                }),
          ],
        ),
      ),
    );
  }
}
