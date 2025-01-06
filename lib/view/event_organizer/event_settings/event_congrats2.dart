import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/constants/app_fonts.dart';
import 'package:forus_app/constants/app_sizes.dart';
import 'package:forus_app/generated/assets.dart';
import 'package:forus_app/view/widget/common_image_view_widget.dart';
import 'package:forus_app/view/widget/my_button_widget.dart';
import 'package:forus_app/view/widget/my_text_widget.dart';

class EventCongratsScreen2 extends StatefulWidget {
  const EventCongratsScreen2({super.key});

  @override
  State<EventCongratsScreen2> createState() => _EventCongratsScreen2State();
}

class _EventCongratsScreen2State extends State<EventCongratsScreen2> {
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
      ),
      backgroundColor: AppThemeColors.getTertiary(context),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CommonImageView(
                imagePath: Assets.imagesCongrats,
                height: 110,
              ),
              MyText(
                text: 'Congratulations!',
                size: 24,
                paddingTop: 16,
                paddingBottom: 10,
                textAlign: TextAlign.center,
                fontFamily: AppFonts.NUNITO_SANS,
                weight: FontWeight.w800,
              ),
              MyText(
                text: 'You’ve successfully withdraw amount',
                size: 16,
                paddingBottom: 22,
                textAlign: TextAlign.center,
                fontFamily: AppFonts.NUNITO_SANS,
                weight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
