import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/view/screens/auth/choose_sign_up.dart';
import 'package:candid/view/widget/my_button_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  late VideoPlayerController _controller;
  void _loadVideo() async {
    _controller = VideoPlayerController.asset(Assets.imagesGetStartedVideo)
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
      body: Stack(
        children: [
          Stack(
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
                child: Container(
                  height: Get.height,
                  width: Get.width,
                  color: Color(0xff4B164C).withOpacity(0.2),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Transform.scale(
                  scaleX: 1.2,
                  scaleY: 1.0,
                  child: Container(
                    height: Get.height * 0.5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          kBlackColor.withOpacity(0.0),
                          kBlackColor2,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: AppSizes.DEFAULT,
            height: Get.height,
            width: Get.width,
            decoration: BoxDecoration(
              color: kMaroonColor.withOpacity(0.26),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Spacer(),
                Image.asset(
                  Assets.imagesAppLogo,
                  height: 60,
                ),
                Spacer(),
                MyText(
                  text:
                      'Find your perfect match and start your love story today.',
                  size: 12,
                  lineHeight: 1.5,
                  color: kPrimaryColor,
                  weight: FontWeight.w500,
                  textAlign: TextAlign.center,
                  paddingTop: 12,
                  paddingBottom: 12,
                ),
                MyButton(
                  buttonText: 'Get Started',
                  onTap: () {
                    Get.to(() => ChooseSignUp());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
