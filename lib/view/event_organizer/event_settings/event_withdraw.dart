import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/constants/app_fonts.dart';
import 'package:forus_app/constants/app_sizes.dart';
import 'package:forus_app/generated/assets.dart';
import 'package:forus_app/view/event_organizer/event_settings/event_congrats2.dart';
import 'package:forus_app/view/widget/common_image_view_widget.dart';
import 'package:forus_app/view/widget/my_button_widget.dart';
import 'package:forus_app/view/widget/my_text_widget.dart';
import 'package:forus_app/view/widget/my_text_field.dart';

class EventWithdrawScreen extends StatefulWidget {
  const EventWithdrawScreen({super.key});

  @override
  State<EventWithdrawScreen> createState() => _EventWithdrawScreenState();
}

class _EventWithdrawScreenState extends State<EventWithdrawScreen> {
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
          text: "Withdraw",
          size: 18,
          textAlign: TextAlign.center,
          fontFamily: AppFonts.NUNITO_SANS,
          weight: FontWeight.w700,
        ),
      ),
      backgroundColor: AppThemeColors.getTertiary(context),
      body: Padding(
        padding: AppSizes.DEFAULT2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  text: "Enter Bank Details ",
                  size: 16,
                  paddingBottom: 5,
                  textAlign: TextAlign.center,
                  fontFamily: AppFonts.NUNITO_SANS,
                  weight: FontWeight.w700,
                ),
                MyTextField(
                  hint: 'Bank Name',
                  hintColor: kTextGrey,
                  labelColor: kBlack,
                  radius: 8,
                  filledColor: kTransperentColor,
                  kBorderColor: kBorderGrey,
                  kFocusBorderColor: KColor1,
                ),
                MyTextField(
                  hint: 'Account Holder Name',
                  hintColor: kTextGrey,
                  labelColor: kBlack,
                  radius: 8,
                  filledColor: kTransperentColor,
                  kBorderColor: kBorderGrey,
                  kFocusBorderColor: KColor1,
                ),
                MyTextField(
                  hint: 'Account Number',
                  hintColor: kTextGrey,
                  labelColor: kBlack,
                  radius: 8,
                  filledColor: kTransperentColor,
                  kBorderColor: kBorderGrey,
                  kFocusBorderColor: KColor1,
                ),
                MyTextField(
                  hint: 'Confirm Account Number',
                  hintColor: kTextGrey,
                  labelColor: kBlack,
                  radius: 8,
                  filledColor: kTransperentColor,
                  kBorderColor: kBorderGrey,
                  kFocusBorderColor: KColor1,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: MyButton(
                buttonText: "Submit",
                radius: 14,
                textSize: 18,
                weight: FontWeight.w800,
                onTap: () {
                  Get.to(() => EventCongratsScreen2());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
