import 'dart:ui';

import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/utils/global_instances.dart';
import 'package:candid/view/screens/auth/sign_up/complete_profile/steps/disclaimer.dart';
import 'package:candid/view/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:candid/view/widget/my_button_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:video_player/video_player.dart';

class RecordVideo extends StatefulWidget {
  const RecordVideo({super.key});

  @override
  State<RecordVideo> createState() => _RecordVideoState();
}

class _RecordVideoState extends State<RecordVideo> {
  late VideoPlayerController _controller;
  void _loadVideo() async {
    _controller = VideoPlayerController.asset(Assets.imagesDemoRecordVideo)
      ..initialize().then((_) {
        setState(() {
          _controller.play();
          _controller.setLooping(true);
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Transform.scale(
            alignment: Alignment.bottomCenter,
            scaleX: 1.2,
            scaleY: 1.0,
            child: VideoPlayer(_controller),
          ),
          Transform.scale(
            scaleX: 1.2,
            scaleY: 1.0,
            child: ClipRRect(
              borderRadius: BorderRadius.zero,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 4.5,
                  sigmaY: 4.5,
                ),
                child: Container(
                  height: Get.height,
                  width: Get.width,
                  color: kBlackColor.withOpacity(0.16),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Image.asset(
                Assets.imagesPlay,
                height: 100,
                color: kPrimaryColor,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: AppSizes.DEFAULT,
              child: MyButton(
                buttonText: 'Record',
                onTap: () {
                  // Get.dialog(
                  //   CustomDialog(
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(24),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.stretch,
                  //         children: [
                  //           Image.asset(
                  //             Assets.imagesUploadVideoIcon,
                  //             height: 151,
                  //           ),
                  //           MyText(
                  //             text: 'Video Uploaded',
                  //             size: 18,
                  //             weight: FontWeight.w600,
                  //             textAlign: TextAlign.center,
                  //             paddingTop: 16,
                  //             paddingBottom: 8,
                  //           ),
                  //           MyText(
                  //             text: 'Video has been uploaded successfully',
                  //             size: 12,
                  //             color: kQuaternaryColor,
                  //             weight: FontWeight.w500,
                  //             textAlign: TextAlign.center,
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // );
                  Get.to(() => Disclaimer());
                },
              ),
            ),
          ),
          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 60,
                    bottom: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Obx(
                        () => ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: StepProgressIndicator(
                            totalSteps: profileController.items.length,
                            currentStep:
                                profileController.currentStep.value + 1,
                            padding: 0,
                            selectedSize: 9,
                            unselectedSize: 9,
                            roundedEdges: Radius.circular(50),
                            selectedColor: kSecondaryColor,
                            unselectedColor: kPrimaryColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              profileController.onBack();
                            },
                            child: Image.asset(
                              Assets.imagesBack,
                              height: 30,
                            ),
                          ),
                          Expanded(
                            child: MyText(
                              text: 'Record Video',
                              size: 24,
                              color: kPrimaryColor,
                              weight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                              paddingLeft: 16,
                            ),
                          ),
                        ],
                      ),
                      MyText(
                        text:
                            'Ready to get Candid? Record your first video to connect with genuine people. Just remember, it\'s all about being as Candid as you can',
                        size: 16,
                        lineHeight: 1.5,
                        color: kPrimaryColor.withOpacity(0.9),
                        weight: FontWeight.w500,
                        paddingTop: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
