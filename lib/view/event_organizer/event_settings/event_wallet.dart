import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/constants/app_fonts.dart';
import 'package:forus_app/constants/app_sizes.dart';
import 'package:forus_app/generated/assets.dart';
import 'package:forus_app/view/event_organizer/event_settings/event_withdraw.dart';
import 'package:forus_app/view/widget/common_image_view_widget.dart';
import 'package:forus_app/view/widget/my_button_widget.dart';
import 'package:forus_app/view/widget/my_text_widget.dart';

class EventWalletScreen extends StatefulWidget {
  const EventWalletScreen({super.key});

  @override
  State<EventWalletScreen> createState() => _EventWalletScreenState();
}

class _EventWalletScreenState extends State<EventWalletScreen> {
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
        centerTitle: true,
        title: MyText(
          text: "Wallet",
          size: 18,
          textAlign: TextAlign.center,
          fontFamily: AppFonts.NUNITO_SANS,
          weight: FontWeight.w700,
        ),
      ),
      backgroundColor: AppThemeColors.getTertiary(context),
      body: SingleChildScrollView(
        padding: AppSizes.DEFAULT2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Ensures full width
          children: [
            SizedBox(
              width: double.infinity, // Ensures the Container stretches fully
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), // Optional
                  color: Colors.white, // Background for clarity
                ),
                child: Stack(
                  children: [
                    CommonImageView(
                      imagePath: Assets.imagesWalletpic1,
                    ),
                    Positioned(
                      top: 30,
                      left: 30,
                      child: MyText(
                        text: "Available Balance",
                        size: 14,
                        color: kTextOrange3,
                        fontFamily: AppFonts.NUNITO_SANS,
                        weight: FontWeight.w500,
                      ),
                    ),
                    Positioned(
                      top: 50,
                      left: 30,
                      child: MyText(
                        text: "\$958",
                        size: 28,
                        color: kWhite,
                        fontFamily: AppFonts.NUNITO_SANS,
                        weight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: AppSizes.HORIZONTAL,
              child: MyButton(
                height: 54,
                bgColor: kContainerColorOrang2,
                buttonText: "",
                customChild: Row(
                  spacing: 5,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonImageView(
                      imagePath: Assets.imagesMoneySend,
                      height: 24,
                    ),
                    MyText(
                      text: "Withdraw",
                      size: 18,
                      color: kWhite,
                      textAlign: TextAlign.center,
                      fontFamily: AppFonts.NUNITO_SANS,
                      weight: FontWeight.w700,
                    ),
                  ],
                ),
                radius: 14,
                textSize: 18,
                weight: FontWeight.w800,
                onTap: () {
                  Get.to(() => EventWithdrawScreen());
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              margin: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(10),
                border: const Border(
                  bottom: BorderSide(
                    color: kborderGrey2,
                    width: 0.5,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    paddingTop: 15,
                    text: "Available Balance",
                    size: 16,
                    paddingBottom: 25,
                    color: kTextDarkorange4,
                    fontFamily: AppFonts.NUNITO_SANS,
                    weight: FontWeight.w900,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: "Withdrawal completed",
                            size: 14,
                            fontFamily: AppFonts.NUNITO_SANS,
                            weight: FontWeight.w600,
                          ),
                          MyText(
                            text: "25 Jan 2021 4:30 PM",
                            size: 12,
                            color: kTextGrey,
                            fontFamily: AppFonts.NUNITO_SANS,
                            weight: FontWeight.w300,
                          ),
                        ],
                      ),
                      MyText(
                        text: "\$15.32",
                        size: 16,
                        color: kredColor,
                        fontFamily: AppFonts.NUNITO_SANS,
                        weight: FontWeight.w700,
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1,
                    color: kDividerGrey3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: "Withdrawal completed",
                            size: 14,
                            fontFamily: AppFonts.NUNITO_SANS,
                            weight: FontWeight.w600,
                          ),
                          MyText(
                            text: "25 Jan 2021 4:30 PM",
                            size: 12,
                            color: kTextGrey,
                            fontFamily: AppFonts.NUNITO_SANS,
                            weight: FontWeight.w300,
                          ),
                        ],
                      ),
                      MyText(
                        text: "\$15.32",
                        size: 16,
                        color: kTextDarkorange,
                        fontFamily: AppFonts.NUNITO_SANS,
                        weight: FontWeight.w700,
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1,
                    color: kDividerGrey3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: "Withdrawal completed",
                            size: 14,
                            fontFamily: AppFonts.NUNITO_SANS,
                            weight: FontWeight.w600,
                          ),
                          MyText(
                            text: "25 Jan 2021 4:30 PM",
                            size: 12,
                            color: kTextGrey,
                            fontFamily: AppFonts.NUNITO_SANS,
                            weight: FontWeight.w300,
                          ),
                        ],
                      ),
                      MyText(
                        text: "\$15.32",
                        size: 16,
                        color: kBorderGreen,
                        fontFamily: AppFonts.NUNITO_SANS,
                        weight: FontWeight.w700,
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1,
                    color: kDividerGrey3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: "Withdrawal completed",
                            size: 14,
                            fontFamily: AppFonts.NUNITO_SANS,
                            weight: FontWeight.w600,
                          ),
                          MyText(
                            text: "25 Jan 2021 4:30 PM",
                            size: 12,
                            color: kTextGrey,
                            fontFamily: AppFonts.NUNITO_SANS,
                            weight: FontWeight.w300,
                          ),
                        ],
                      ),
                      MyText(
                        text: "\$15.32",
                        size: 16,
                        color: kredColor,
                        fontFamily: AppFonts.NUNITO_SANS,
                        weight: FontWeight.w700,
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1,
                    color: kDividerGrey3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: "Withdrawal completed",
                            size: 14,
                            fontFamily: AppFonts.NUNITO_SANS,
                            weight: FontWeight.w600,
                          ),
                          MyText(
                            text: "25 Jan 2021 4:30 PM",
                            size: 12,
                            color: kTextGrey,
                            fontFamily: AppFonts.NUNITO_SANS,
                            weight: FontWeight.w300,
                          ),
                        ],
                      ),
                      MyText(
                        text: "\$15.32",
                        size: 16,
                        color: kTextDarkorange,
                        fontFamily: AppFonts.NUNITO_SANS,
                        weight: FontWeight.w700,
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1,
                    color: kDividerGrey3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: "Withdrawal completed",
                            size: 14,
                            fontFamily: AppFonts.NUNITO_SANS,
                            weight: FontWeight.w600,
                          ),
                          MyText(
                            text: "25 Jan 2021 4:30 PM",
                            size: 12,
                            color: kTextGrey,
                            fontFamily: AppFonts.NUNITO_SANS,
                            weight: FontWeight.w300,
                          ),
                        ],
                      ),
                      MyText(
                        text: "\$15.32",
                        size: 16,
                        color: kBorderGreen,
                        fontFamily: AppFonts.NUNITO_SANS,
                        weight: FontWeight.w700,
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1,
                    color: kDividerGrey3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: "Withdrawal completed",
                            size: 14,
                            fontFamily: AppFonts.NUNITO_SANS,
                            weight: FontWeight.w600,
                          ),
                          MyText(
                            text: "25 Jan 2021 4:30 PM",
                            size: 12,
                            color: kTextGrey,
                            fontFamily: AppFonts.NUNITO_SANS,
                            weight: FontWeight.w300,
                          ),
                        ],
                      ),
                      MyText(
                        text: "\$15.32",
                        size: 16,
                        color: kredColor,
                        fontFamily: AppFonts.NUNITO_SANS,
                        weight: FontWeight.w700,
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1,
                    color: kDividerGrey3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: "Withdrawal completed",
                            size: 14,
                            fontFamily: AppFonts.NUNITO_SANS,
                            weight: FontWeight.w600,
                          ),
                          MyText(
                            text: "25 Jan 2021 4:30 PM",
                            size: 12,
                            color: kTextGrey,
                            fontFamily: AppFonts.NUNITO_SANS,
                            weight: FontWeight.w300,
                          ),
                        ],
                      ),
                      MyText(
                        text: "\$15.32",
                        size: 16,
                        color: kTextDarkorange,
                        fontFamily: AppFonts.NUNITO_SANS,
                        weight: FontWeight.w700,
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1,
                    color: kDividerGrey3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: "Withdrawal completed",
                            size: 14,
                            fontFamily: AppFonts.NUNITO_SANS,
                            weight: FontWeight.w600,
                          ),
                          MyText(
                            text: "25 Jan 2021 4:30 PM",
                            size: 12,
                            color: kTextGrey,
                            fontFamily: AppFonts.NUNITO_SANS,
                            weight: FontWeight.w300,
                          ),
                        ],
                      ),
                      MyText(
                        text: "\$15.32",
                        size: 16,
                        color: kBorderGreen,
                        fontFamily: AppFonts.NUNITO_SANS,
                        weight: FontWeight.w700,
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1,
                    color: kDividerGrey3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: "Withdrawal completed",
                            size: 14,
                            fontFamily: AppFonts.NUNITO_SANS,
                            weight: FontWeight.w600,
                          ),
                          MyText(
                            text: "25 Jan 2021 4:30 PM",
                            size: 12,
                            color: kTextGrey,
                            fontFamily: AppFonts.NUNITO_SANS,
                            weight: FontWeight.w300,
                          ),
                        ],
                      ),
                      MyText(
                        text: "\$15.32",
                        size: 16,
                        color: kredColor,
                        fontFamily: AppFonts.NUNITO_SANS,
                        weight: FontWeight.w700,
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1,
                    color: kDividerGrey3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: "Withdrawal completed",
                            size: 14,
                            fontFamily: AppFonts.NUNITO_SANS,
                            weight: FontWeight.w600,
                          ),
                          MyText(
                            text: "25 Jan 2021 4:30 PM",
                            size: 12,
                            color: kTextGrey,
                            fontFamily: AppFonts.NUNITO_SANS,
                            weight: FontWeight.w300,
                          ),
                        ],
                      ),
                      MyText(
                        text: "\$15.32",
                        size: 16,
                        color: kTextDarkorange,
                        fontFamily: AppFonts.NUNITO_SANS,
                        weight: FontWeight.w700,
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1,
                    color: kDividerGrey3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: "Withdrawal completed",
                            size: 14,
                            fontFamily: AppFonts.NUNITO_SANS,
                            weight: FontWeight.w600,
                          ),
                          MyText(
                            text: "25 Jan 2021 4:30 PM",
                            size: 12,
                            color: kTextGrey,
                            fontFamily: AppFonts.NUNITO_SANS,
                            weight: FontWeight.w300,
                          ),
                        ],
                      ),
                      MyText(
                        text: "\$15.32",
                        size: 16,
                        color: kBorderGreen,
                        fontFamily: AppFonts.NUNITO_SANS,
                        weight: FontWeight.w700,
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
