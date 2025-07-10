import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/view/screens/launch/get_started.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  PageController _pageController = PageController();
  VideoPlayerController? _controller;
  int _currentIndex = 0;
  final List<String> _content = [
    'Candid captures genuine moments, reducing the chances of misleading profiles.',
    'Capture spontaneous moments that reflect true personality.',
    'Showcase hobbies, talents, and interests through dynamic content!',
    'Swipe Right to like the profile',
    'Swipe left to pass the profile',
  ];

  final List<String> _videos = [
    Assets.imagesOn1Video,
    Assets.imagesOn2Video,
    Assets.imagesOn3Video,
    Assets.imagesOn4Video,
    Assets.imagesOn5Video,
  ];

  @override
  void initState() {
    super.initState();
    _loadVideo(0);
  }

  void _loadVideo(int index) async {
    _currentIndex = index;

    VideoPlayerController? oldController = _controller;

    _controller = VideoPlayerController.asset(_videos[index])
      ..initialize().then((_) {
        setState(() {
          _controller!.play();
          _controller!.setLooping(true);
        });
      });

    await Future.delayed(Duration(milliseconds: 300));
    oldController?.dispose();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlackColor,
      body: Stack(
        children: [
          Stack(
            children: [
              AnimatedOpacity(
                opacity: _controller != null && _controller!.value.isInitialized
                    ? 1.0
                    : 0.0,
                duration: 220.milliseconds,
                curve: Curves.easeIn,
                child: _controller != null && _controller!.value.isInitialized
                    ? Transform.scale(
                        alignment: Alignment.bottomCenter,
                        scaleX: 1.2,
                        scaleY: 1.0,
                        child: VideoPlayer(_controller!),
                      )
                    : Container(),
              ),
              Transform.scale(
                scaleX: 1.1,
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
                  scaleX: 1.1,
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
              PageView.builder(
                onPageChanged: (index) {
                  _loadVideo(index);
                },
                controller: _pageController,
                itemCount: _content.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MyText(
                        text: _content[index],
                        size: 24,
                        lineHeight: 1.5,
                        color: kPrimaryColor,
                        weight: FontWeight.w600,
                        paddingLeft: 20,
                        paddingRight: 20,
                        paddingBottom: 100,
                      ),
                    ],
                  );
                },
              )
            ],
          ),
          Positioned(
            top: 50,
            right: 20,
            child: MyText(
              text: 'Skip',
              size: 16,
              color: kSecondaryColor,
              onTap: () {
                Get.to(() => GetStarted());
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: AppSizes.DEFAULT,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    axisDirection: Axis.horizontal,
                    count: _content.length,
                    effect: ExpandingDotsEffect(
                      dotHeight: 6,
                      dotWidth: 6,
                      spacing: 4,
                      expansionFactor: 5,
                      radius: 8,
                      activeDotColor: kSecondaryColor,
                      dotColor: kPrimaryColor,
                    ),
                    onDotClicked: (index) {},
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      if (_currentIndex == _content.length - 1)
                        Get.to(() => GetStarted());
                      else {
                        _pageController.nextPage(
                          duration: 320.milliseconds,
                          curve: Curves.easeIn,
                        );
                      }
                    },
                    child: Image.asset(
                      Assets.imagesArrowNextRounded,
                      height: 54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
