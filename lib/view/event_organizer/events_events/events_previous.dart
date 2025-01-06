import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/constants/app_fonts.dart';
import 'package:forus_app/constants/app_sizes.dart';
import 'package:forus_app/generated/assets.dart';
import 'package:forus_app/view/widget/common_image_view_widget.dart';
import 'package:forus_app/view/widget/my_button_widget.dart';
import 'package:forus_app/view/widget/my_text_widget.dart';
import 'package:forus_app/view/widget/my_text_field.dart';

class EventPreviewsScreen extends StatefulWidget {
  const EventPreviewsScreen({super.key});

  @override
  State<EventPreviewsScreen> createState() => _EventPreviewsScreenState();
}

class _EventPreviewsScreenState extends State<EventPreviewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeColors.getTertiary(context),
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
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: kBlack,
            ),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'share',
                child: Row(
                  children: [
                    CommonImageView(
                      imagePath: Assets.imagesMenuShare,
                      height: 20,
                    ),
                    MyText(
                      paddingLeft: 5,
                      text: "Share Event",
                      size: 12,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    CommonImageView(
                      imagePath: Assets.imagesEditorangemennu,
                      height: 20,
                    ),
                    MyText(
                      paddingLeft: 5,
                      text: "Edit Event ",
                      size: 12,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    CommonImageView(
                      imagePath: Assets.imagesTrashorange,
                      height: 20,
                    ),
                    MyText(
                      paddingLeft: 5,
                      text: "Delete Event",
                      size: 12,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ],
            onSelected: (String value) {
              switch (value) {
                case 'share':
                  print('Share Event');
                  break;
                case 'edit':
                  print('Edit Event');
                  break;
                case 'delete':
                  DeleteBottomSheet();
                  break;
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: AppSizes.DEFAULT,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 10,
                child: CommonImageView(
                  radius: 10,
                  imagePath: Assets.imagesEventhome1,
                  height: 180,
                ),
              ),

              MyText(
                text: "A Self-Improvement Experience",
                size: 22,
                paddingTop: 12,
                paddingBottom: 8,
                weight: FontWeight.bold,
              ),
              Row(
                children: [
                  MyText(
                    text: " Business ",
                    size: 12,
                    color: kTextGrey,
                    weight: FontWeight.w500,
                  ),
                  MyText(
                    text: " •  ",
                    size: 12,
                    color: kTextOrange,
                  ),
                  MyText(
                    text: " Conference ",
                    size: 12,
                    color: kTextGrey,
                    weight: FontWeight.w500,
                  ),
                ],
              ),
              Gap(4),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFF4E6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: MyText(text: "Free", size: 12, color: kTextOrange),
                  ),
                  SizedBox(width: 4),
                  MyText(
                    text: "•",
                    size: 12,
                    color: kTextOrange,
                  ),
                  SizedBox(width: 8),
                  MyText(
                    text: "15 August, 2023 ",
                    size: 12,
                    color: kTextGrey2,
                    weight: FontWeight.w500,
                  ),
                  MyText(
                    text: "• ",
                    size: 12,
                    color: kTextOrange,
                  ),
                  MyText(
                    text: "8:00 AM to 11:30 AM ",
                    size: 12,
                    color: kTextGrey2,
                    weight: FontWeight.w500,
                  ),
                ],
              ),

              Divider(
                thickness: 1,
                color: kBorderGrey,
              ),
              // About Section
              MyText(
                text: "About",
                size: 15,
                paddingTop: 12,
                paddingBottom: 8,
                weight: FontWeight.w900,
              ),
              MyText(
                text:
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s.',
                size: 12,
                paddingBottom: 16,
                color: kTextGrey,
                weight: FontWeight.w500,
              ),

              Divider(
                thickness: 1,
                color: kBorderGrey,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(
                    text: "Location",
                    size: 15,
                    paddingTop: 8,
                    paddingBottom: 5,
                    weight: FontWeight.w900,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MyText(
                        text: "Show in Map",
                        size: 15,
                        paddingRight: 8,
                        color: kTextOrange,
                        weight: FontWeight.w600,
                      ),
                      Icon(
                        Icons.arrow_outward_rounded,
                        color: kTextOrange,
                        size: 16,
                      )
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  CommonImageView(
                    imagePath: Assets.imagesLocationorange,
                    height: 15,
                  ),
                  MyText(
                    text: "AECC Study Abroad Consultants in Mumbai",
                    size: 15,
                    color: kTextGrey2,
                    weight: FontWeight.w700,
                  ),
                ],
              ),
              Gap(8),
              Divider(
                thickness: 1,
                color: kBorderGrey,
              ),
            ],
          ),
          Gap(62),
          MyButton(
              buttonText: "Publish Event",
              radius: 14,
              textSize: 20,
              weight: FontWeight.w800,
              onTap: () {
                Get.to(() => EventPreviewsScreen());
              }),
          Center(
            child: MyText(
              paddingTop: 21,
              text: "Edit Event",
              size: 16,
              color: Color(0xFFBE8131),
              weight: FontWeight.w700,
            ),
          ),
          Gap(30),
        ],
      ),
    );
  }

  void DeleteBottomSheet() {
    Get.bottomSheet(
      isScrollControlled: true,
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 5,
                    margin: const EdgeInsets.symmetric(horizontal: 160),
                    decoration: BoxDecoration(
                      color: kDividerGrey3,
                      borderRadius: BorderRadius.circular(90),
                    ),
                  ),
                  Gap(24),
                  MyText(
                    text: "Are you sure you want to delete this account?",
                    size: 18,
                    textAlign: TextAlign.center,
                    weight: FontWeight.w600,
                    fontFamily: AppFonts.NUNITO_SANS,
                  ),
                  Gap(18),
                  Row(
                    spacing: 17,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyButton2(
                        width: 137,
                        buttonText: "No",
                        radius: 14,
                        textSize: 20,
                        textColor: kTextDarkorange,
                        bgColor: kbuttoncolor,
                        weight: FontWeight.w800,
                        onTap: () {
                          Get.back();
                        },
                      ),
                      MyButton2(
                        width: 137,
                        buttonText: "Yes",
                        radius: 14,
                        textSize: 20,
                        weight: FontWeight.w800,
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
