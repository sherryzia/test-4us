import 'dart:ui';

import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/main.dart';
import 'package:candid/utils/global_instances.dart';
import 'package:candid/view/screens/messages/video_call/quiz/quiz.dart';
import 'package:candid/view/widget/common_image_view_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoCall extends StatelessWidget {
  const VideoCall({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: kTertiaryColor,
        body: quizController.isQuiz.value ? Quiz() : _VideoCall(),
      );
    });
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
          left: 16,
          bottom: 120,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 4),
                  blurRadius: 20,
                  color: kTertiaryColor.withValues(alpha: 0.26),
                ),
              ],
            ),
            child: CommonImageView(
              height: 140,
              width: 121,
              url: dummyImg,
              radius: 12.0,
            ),
          ),
        ),
        _Games(),
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

  Row _videoCallControls() {
    return Row(
      children: [
        // SizedBox(
        //   width: 16,
        // ),
        // CircularPercentIndicator(
        //   radius: 28.0,
        //   lineWidth: 3.5,
        //   percent: 0.8,
        //   center: Container(
        //     height: 45,
        //     width: 45,
        //     decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //       color: kPrimaryColor,
        //     ),
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         MyText(
        //           text: '32',
        //           size: 12,
        //           weight: FontWeight.w600,
        //         ),
        //         MyText(
        //           text: 'Min',
        //           size: 10,
        //           weight: FontWeight.w500,
        //         ),
        //       ],
        //     ),
        //   ),
        //   backgroundColor: kBorderColor,
        //   linearGradient: LinearGradient(
        //     begin: Alignment.bottomLeft,
        //     end: Alignment.topRight,
        //     colors: [
        //       kSecondaryColor,
        //       kPurpleColor,
        //     ],
        //   ),
        // ),

        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: quizController.onGamesToggle,
                child: Container(
                  height: 43,
                  width: 43,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kPrimaryColor,
                  ),
                  child: Center(
                    child: Image.asset(
                      Assets.imagesPlayGame,
                      height: 21,
                    ),
                  ),
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
                  color: kPrimaryColor,
                ),
                child: Center(
                  child: Image.asset(
                    Assets.imagesMuteCall,
                    height: 21,
                    color: kSecondaryColor,
                  ),
                ),
              ),
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kPrimaryColor,
                ),
                child: Center(
                  child: Image.asset(
                    Assets.imagesSwitchCamera,
                    height: 21,
                    color: kSecondaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Games extends StatelessWidget {
  const _Games({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return AnimatedOpacity(
        opacity: quizController.showGames.value ? 1.0 : 0.0,
        duration: 150.milliseconds,
        curve: Curves.easeIn,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(50),
                bottom: Radius.circular(50),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  width: 62,
                  height: 230,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 20,
                        color: kTertiaryColor.withValues(alpha: 0.16),
                      ),
                    ],
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(50),
                      bottom: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Image.asset(
                      //   Assets.imagesXo,
                      //   height: 28,
                      // ),
                      // MyText(
                      //   paddingTop: 10,
                      //   text: 'xo',
                      //   color: kPrimaryColor,
                      //   paddingBottom: 16,
                      //   size: 10,
                      // ),
                      // GestureDetector(
                      //   onTap: quizController.onQuizToggle,
                      //   child: Image.asset(
                      //     Assets.imagesQuiz,
                      //     height: 28,
                      //   ),
                      // ),
                      // MyText(
                      //   onTap: quizController.onQuizToggle,
                      //   paddingTop: 10,
                      //   text: 'Quiz',
                      //   color: kPrimaryColor,
                      //   paddingBottom: 16,
                      //   size: 10,
                      // ),
                      // Image.asset(
                      //   Assets.imagesCards,
                      //   height: 25,
                      //   color: kPrimaryColor,
                      // ),
                      // MyText(
                      //   paddingTop: 10,
                      //   text: 'Cards',
                      //   size: 10,
                      //   color: kPrimaryColor,
                      //   paddingBottom: 16,
                      // ),
                      // Image.asset(
                      //   Assets.imagesDrawing,
                      //   height: 25,
                      //   color: kPrimaryColor,
                      // ),
                      // MyText(
                      //   paddingTop: 10,
                      //   text: 'Drawing',
                      //   size: 10,
                      //   color: kPrimaryColor,
                      // ),
                      // Quiz button
                      ImageTextButton(
                        imagePath: Assets.imagesQuizNew,
                        text: 'Quiz',
                        imageHeight: 28,
                        textSize: 10,
                        onTap: quizController.onQuizToggle,
                        textPadding: const EdgeInsets.only(top: 6, bottom: 16),
                        isSelected: true,
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ImageTextButton(
                            imagePath: Assets.imagesPoker,
                            text: 'Cards',
                            imageHeight: 25,
                            isSelected: false,
                            textSize: 10,
                            isUpcomingFeature: true,
                            textPadding:
                                const EdgeInsets.only(top: 6, bottom: 16),
                          ),
                          Positioned(
                            right: -19,
                            bottom: 1,
                            child: RotatedBox(
                              quarterTurns: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: kSecondaryColor,
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3, vertical: 2),
                                child: Center(
                                  child: MyText(
                                    text: 'Upcoming'.toUpperCase(),
                                    size: 7,
                                    weight: FontWeight.w500,
                                    color: kPrimaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ImageTextButton(
                            isSelected: false,
                            imagePath: Assets.imagesArtBoard,
                            text: 'Drawing',
                            imageHeight: 22,
                            textSize: 10,
                            textPadding: const EdgeInsets.only(
                              top: 6,
                            ),
                            isUpcomingFeature: true,
                          ),
                          Positioned(
                            right: -13.5,
                            bottom: 1,
                            child: RotatedBox(
                              quarterTurns: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: kSecondaryColor,
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3, vertical: 2),
                                child: Center(
                                  child: MyText(
                                    text: 'Upcoming'.toUpperCase(),
                                    size: 7,
                                    weight: FontWeight.w500,
                                    color: kPrimaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class ImageTextButton extends StatelessWidget {
  final String imagePath;
  final String text;
  final double imageHeight;
  final double textSize;
  final EdgeInsetsGeometry? textPadding;
  final VoidCallback? onTap;
  final bool isUpcomingFeature;
  final bool? isSelected;

  const ImageTextButton({
    super.key,
    required this.imagePath,
    required this.text,
    this.imageHeight = 25,
    this.textSize = 10,
    this.textPadding,
    this.onTap,
    this.isSelected,
    this.isUpcomingFeature = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: isUpcomingFeature ? null : onTap,
              child: Image.asset(
                imagePath,
                color: isSelected!
                    ? kPrimaryColor
                    : kPrimaryColor.withValues(alpha: 0.4),
                height: 22,
              ),
            ),
            MyText(
              paddingTop: 4,
              onTap: isUpcomingFeature ? null : onTap,
              text: text,
              weight: FontWeight.w600,
              size: 10,
              color: isSelected!
                  ? kPrimaryColor
                  : kPrimaryColor.withValues(alpha: 0.4),
            ),
          ],
        ),
      ],
    );
  }
}
