import 'dart:ui';

import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/main.dart';
import 'package:candid/utils/global_instances.dart';
import 'package:candid/view/screens/explore/speed_dating_feedback.dart';
import 'package:candid/view/widget/common_image_view_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class SpeedDateCalling extends StatelessWidget {
  const SpeedDateCalling({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kTertiaryColor,
      body: _VideoCall(),
    );
  }
}

class _VideoCall extends StatelessWidget {
  const _VideoCall({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonImageView(
          height: Get.height,
          width: Get.width,
          url: dummyImg,
          radius: 0.0,
        ),
        Positioned(
          right: 16,
          top: 100,
          child: CommonImageView(
            height: 136,
            width: 121,
            url: dummyImg,
            radius: 12.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MyText(
                paddingTop: 55,
                text: 'Alena Sarah',
                size: 20,
                weight: FontWeight.w600,
                color: kPrimaryColor,
                textAlign: TextAlign.center,
              ),
              MyText(
                paddingTop: 3,
                text: '01:04:05',
                size: 16,
                color: kPrimaryColor,
                textAlign: TextAlign.center,
                paddingBottom: 13,
              ),
              Spacer(),
              _videoCallControls(),
            ],
          ),
        ),
        Positioned(
          left: 16,
          top: 60,
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Image.asset(
              Assets.imagesArrowBackIcon,
              height: 24,
              color: kPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Wrap _videoCallControls() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.spaceEvenly,
      children: [
        CircularPercentIndicator(
          radius: 28.0,
          lineWidth: 3.5,
          animationDuration: 3000,
          percent: 1.0,
          animateFromLastPercent: true,
          circularStrokeCap: CircularStrokeCap.round,
          animation: true,
          onAnimationEnd: () {
            Get.to(() => SpeedDatingFeedback());
          },
          center: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kPrimaryColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyText(
                  text: '3',
                  size: 12,
                  weight: FontWeight.w600,
                ),
                MyText(
                  text: 'Sec',
                  size: 10,
                  weight: FontWeight.w500,
                ),
              ],
            ),
          ),
          backgroundColor: kBorderColor,
          linearGradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              kSecondaryColor,
              kPurpleColor,
            ],
          ),
        ),
        Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kSecondaryColor,
          ),
          child: Center(
            child: Image.asset(
              Assets.imagesEndCall,
              height: 24,
            ),
          ),
        ),
        Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kBorderColor,
          ),
          child: Center(
            child: Image.asset(
              Assets.imagesMuteCall,
              height: 21,
              color: kPrimaryColor,
            ),
          ),
        ),
        Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kBorderColor,
          ),
          child: Center(
            child: Image.asset(
              Assets.imagesSwitchCamera,
              height: 21,
              color: kPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
