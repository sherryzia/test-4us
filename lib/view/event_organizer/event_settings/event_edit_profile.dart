import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/constants/app_sizes.dart';
import 'package:forus_app/generated/assets.dart';
import 'package:forus_app/view/widget/common_image_view_widget.dart';
import 'package:forus_app/view/widget/my_button_widget.dart';
import 'package:forus_app/view/widget/my_text_widget.dart';
import 'package:forus_app/view/widget/my_text_field.dart';

class EventEditProfileScreen extends StatefulWidget {
  const EventEditProfileScreen({super.key});

  @override
  State<EventEditProfileScreen> createState() =>
      _EventEditProfileScreenState();
}

class _EventEditProfileScreenState extends State<EventEditProfileScreen> {
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
              imagePath: Assets.imagesBackbutton,
              height: 24,
            ),
          ),
        ),
        title: MyText(
          text: "Edit Profile",
          size: 18,
          weight: FontWeight.w700,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: AppSizes.DEFAULT2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    child: CommonImageView(
                      imagePath: Assets.imagesImagesSettingAvatar,
                      height: 88,
                    ),
                  ),
                  MyText(
                    text: "Change Profile Photo",
                    size: 14,
                    paddingTop: 10,
                    paddingBottom: 17,
                    weight: FontWeight.w500,
                  ),
                  MyTextField(
                    hint: 'Grant Honey',
                    hintColor: kTextGrey,
                    labelColor: kWhite,
                    radius: 8,
                    suffix: Padding(
                      padding: const EdgeInsets.all(12),
                      child: CommonImageView(
                        imagePath: Assets.imagesPersongrey,
                        height: 22,
                      ),
                    ),
                    filledColor: kTransperentColor,
                    kBorderColor: kBorderGrey,
                    kFocusBorderColor: KColor1,
                  ),
                  MyTextField(
                    hint: 'granthoney@gmail.com',
                    hintColor: kTextGrey,
                    labelColor: kWhite,
                    radius: 8,
                    suffix: Padding(
                      padding: const EdgeInsets.all(12),
                      child: CommonImageView(
                        imagePath: Assets.imagesPersongrey,
                        height: 22,
                      ),
                    ),
                    filledColor: kTransperentColor,
                    kBorderColor: kBorderGrey,
                    kFocusBorderColor: KColor1,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "+1",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        Icon(Icons.arrow_drop_down, color: Colors.black),
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: MyTextField(
                              marginBottom: 0,
                              hint: '000 0000 000',
                              hintColor: kTextGrey,
                              labelColor: kWhite,
                              radius: 8,
                              filledColor: kTransperentColor,
                              kBorderColor: kWhite,
                              kFocusBorderColor: kWhite,
                            ),
                          ),
                        ),
                        CommonImageView(
                          imagePath: Assets.imagesCall,
                          height: 22,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                MyButton(
                    buttonText: "Update & Save",
                    radius: 14,
                    textSize: 18,
                    weight: FontWeight.w800,
                    onTap: () {}),
                Gap(20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
