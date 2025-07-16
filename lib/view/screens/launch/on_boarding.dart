import 'package:affirmation_app/constants/app_colors.dart';
import 'package:affirmation_app/constants/app_fonts.dart';
import 'package:affirmation_app/constants/app_images.dart';
import 'package:affirmation_app/constants/app_sizes.dart';
import 'package:affirmation_app/view/screens/auth/login/login.dart';
import 'package:affirmation_app/view/widget/my_button_widget.dart';
import 'package:affirmation_app/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int _currentIndex = 0;
  final _pageController = PageController();

  List<String> onBoarding = [
    'Welcome to Money Magnet App powered by Ocular Vision',
    'Premier AI Powered Money Affirmations App',
    'AI will help you generate your desired income by repeating affirmations that will open your mind up to receiving',
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onNext() async {
    if (_currentIndex == onBoarding.length - 1) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("onboarding", true);
      Get.offAll(() => LoginView());
    } else {
      setState(() {
        _currentIndex++;
        _pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      });
    }
  }

  void _onBack() {
    setState(() {
      if (_currentIndex == 0) {
        Get.back();
      } else {
        _currentIndex--;
        _pageController.previousPage(
          duration: Duration(
            milliseconds: 300,
          ),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _onBack();
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              Assets.imagesBgImage,
              height: Get.height,
              width: Get.width,
              fit: BoxFit.cover,
            ),
            Positioned.fill(
              child: Container(
                color: kBlackColor.withOpacity(0.62),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: PageView.builder(
                physics: BouncingScrollPhysics(),
                controller: _pageController,
                itemCount: onBoarding.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  return Center(
                    child: MyText(
                      text: onBoarding[index],
                      size: 30,
                      weight: FontWeight.w400,
                      lineHeight: 1.3,
                      textAlign: TextAlign.center,
                      fontFamily: AppFonts.GEORGIA,
                      paddingLeft: 10,
                      paddingRight: 10,
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: Image.asset(
                Assets.imagesAppLogo,
                height: 104,
              ),
            ),
            _currentIndex == 2
                ? Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SizedBox(
                        width: Get.width * 0.6,
                        child: MyButton(
                          buttonText: 'I AM READY',
                          onTap: _onNext,
                        ),
                      ),
                    ),
                  )
                : Positioned(
                    bottom: 40,
                    width: Get.width,
                    child: Padding(
                      padding: AppSize.HORIZONTAL,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SmoothPageIndicator(
                                controller: _pageController,
                                count: onBoarding.length,
                                effect: ExpandingDotsEffect(
                                  dotWidth: 8,
                                  dotHeight: 8,
                                  expansionFactor: 3,
                                  activeDotColor: kPrimaryColor,
                                  dotColor: kPrimaryColor.withOpacity(0.4),
                                ),
                                onDotClicked: (index) {},
                              ),
                              MyText(
  text: 'Skip',
  size: 18,
  color: kPrimaryColor.withOpacity(0.4),
  paddingTop: 16,
  onTap: () async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("onboarding", true);  // Set the flag to indicate onboarding is completed
    Get.offAll(() => LoginView());  // Navigate to the LoginView
  },
),

                            ],
                          ),
                          CircularStepProgressIndicator(
                            height: 58,
                            width: 58,
                            totalSteps: onBoarding.length,
                            currentStep: _currentIndex + 1,
                            selectedStepSize: 3,
                            unselectedStepSize: 3,
                            selectedColor: kPrimaryColor,
                            unselectedColor: kPrimaryColor.withOpacity(0.4),
                            padding: 0,
                            child: Center(
                              child: GestureDetector(
                                onTap: _onNext,
                                child: Image.asset(
                                  Assets.imagesArrowRightRounded,
                                  height: 42,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
