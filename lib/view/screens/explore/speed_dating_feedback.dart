import 'dart:async';

import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/main.dart';
import 'package:candid/view/screens/explore/end_of_event.dart';
import 'package:candid/view/screens/explore/speed_date_calling.dart';
import 'package:candid/view/widget/common_image_view_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SpeedDatingFeedback extends StatefulWidget {
  const SpeedDatingFeedback({super.key});

  @override
  State<SpeedDatingFeedback> createState() => _SpeedDatingFeedbackState();
}

class _SpeedDatingFeedbackState extends State<SpeedDatingFeedback> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        Timer(1.seconds, () {
          Get.bottomSheet(
            _FindingMatch(),
            barrierColor: Colors.transparent,
            isDismissible: false,
            isScrollControlled: true,
            enableDrag: false,
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              Assets.imagesFeedbackBg,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    padding: AppSizes.VERTICAL,
                    physics: BouncingScrollPhysics(),
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Center(
                            child: Lottie.asset(
                              Assets.imagesLoadingCircleHeart,
                              height: 300,
                            ),
                          ),
                          Positioned(
                            bottom: -12,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: MyText(
                                textAlign: TextAlign.center,
                                lineHeight: 1.5,
                                color: kPrimaryColor,
                                text:
                                    'We’re finding another\ngreat match for you...',
                                size: 22,
                                weight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 50,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                      Get.back();
                    },
                    child: Image.asset(
                      Assets.imagesClose,
                      color: kPrimaryColor,
                      height: 18,
                    ),
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

class _FindingMatch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: Get.height * 0.46,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
            gradient: LinearGradient(
              stops: [0, 1],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [
                Color(0xff7B2BFF),
                Color(0xffFF007F),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 100,
              ),
              Column(
                children: [
                  MyText(
                    paddingBottom: 10,
                    text: 'How’s Your Call with David?',
                    size: 23,
                    weight: FontWeight.w800,
                    color: kPrimaryColor,
                    textAlign: TextAlign.center,
                  ),
                  MyText(
                    paddingBottom: 30,
                    text: 'Your feedback makes your\nnext match even better!',
                    size: 16,
                    lineHeight: 1.5,
                    weight: FontWeight.w500,
                    color: kPrimaryColor,
                    textAlign: TextAlign.center,
                  ),
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 270,
                          height: 80,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(5, 14),
                                blurRadius: 39,
                                color: kBlackColor.withOpacity(0.3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => EndOfEvent());
                                },
                                child: Image.asset(
                                  Assets.imagesBad,
                                  height: 52,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => EndOfEvent());
                                },
                                child: Image.asset(
                                  Assets.imagesGood,
                                  height: 52,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 3),
                          child: Image.asset(
                            Assets.imagesVGood,
                            height: 70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(),
            ],
          ),
        ),
        Positioned(
          top: -70,
          left: 0,
          right: 0,
          child: Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: 120,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 7.28,
                                color: Color(0xff861777),
                              ),
                            ),
                            child: CommonImageView(
                              height: 118,
                              width: 118,
                              radius: 100.0,
                              url: dummyImg,
                            ),
                          ),
                          Image.asset(
                            Assets.imagesImageRing,
                            height: 130,
                            width: 130,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 120, top: 50),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 7.28,
                                color: Color(0xff861777),
                              ),
                            ),
                            child: CommonImageView(
                              height: 118,
                              width: 118,
                              radius: 100.0,
                              url: dummyImg,
                            ),
                          ),
                          Image.asset(
                            Assets.imagesImageRing,
                            height: 130,
                            width: 130,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 20,
                        // top: -70,
                      ),
                      child: Center(
                        child: Image.asset(
                          Assets.imagesHbk,
                          height: 120.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
