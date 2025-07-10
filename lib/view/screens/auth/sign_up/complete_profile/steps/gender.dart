import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/utils/global_instances.dart';
import 'package:candid/view/widget/my_button_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class Gender extends StatefulWidget {
  Gender({super.key});

  @override
  State<Gender> createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  PageController pageController = PageController();
  int currentIndex = 0;
  int delayIndex = 0;

  @override
  void initState() {
    super.initState();
    // Set initial gender selection
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileController.setGenderByIndex(0); // Default to Male
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> images = [
      Assets.imagesMale,
      Assets.imagesFemaleImage,
      Assets.imagesGenderNonBinary,
    ];

    final List<String> gender = [
      'Male',
      'Female',
      'Non-binary',
    ];
    
    return PopScope(
      canPop: false,
      onPopInvoked: (isPop) {
        if (isPop) return;
        profileController.onBack();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            AnimatedSwitcher(
              duration: 280.milliseconds,
              child: Image.asset(
                key: ValueKey<int>(currentIndex),
                images[currentIndex],
                height: Get.height,
                width: Get.width,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                color: kMaroonColor.withOpacity(0.4),
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
                          SizedBox(height: 24),
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
                                  text: 'What\'s your gender?',
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
                                'This helps us match you with people who align with what you\'re looking for in a potential partner.',
                            size: 16,
                            lineHeight: 1.5,
                            color: kPrimaryColor.withOpacity(0.9),
                            weight: FontWeight.w500,
                            paddingTop: 16,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: PageView.builder(
                        physics: BouncingScrollPhysics(),
                        controller: pageController,
                        itemCount: 3,
                        onPageChanged: (v) {
                          setState(() {
                            currentIndex = v;
                            // Update ProfileController when page changes
                            profileController.setGenderByIndex(v);
                            print('Gender selected: ${gender[v]} -> ${profileController.gender.value}');
                            
                            Future.delayed(280.milliseconds, () {
                              setState(() {
                                delayIndex = v;
                              });
                            });
                          });
                        },
                        itemBuilder: (ctx, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              AnimatedSwitcher(
                                duration: 280.milliseconds,
                                child: delayIndex == index
                                    ? MyGradientText(
                                        text: gender[index],
                                        size: 56,
                                        textAlign: TextAlign.center,
                                      )
                                    : MyText(
                                        text: gender[index],
                                        size: 56,
                                        color: kPrimaryColor,
                                        textAlign: TextAlign.center,
                                      ),
                              ),
                              SizedBox(height: 20),
                            ],
                          );
                        },
                      ),
                    ),
                    Center(
                      child: SmoothPageIndicator(
                        controller: pageController,
                        axisDirection: Axis.horizontal,
                        count: gender.length,
                        effect: ExpandingDotsEffect(
                          dotHeight: 6,
                          dotWidth: 6,
                          spacing: 4,
                          expansionFactor: 5,
                          radius: 8,
                          activeDotColor: kSecondaryColor,
                          dotColor: kPrimaryColor,
                        ),
                        onDotClicked: (index) {
                          pageController.animateToPage(
                            index,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 40),
                    // Debug display (remove in production)
                    Obx(() => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Selected: ${profileController.gender.value}',
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    )),
                    Padding(
                      padding: AppSizes.DEFAULT,
                      child: MyButton(
                        buttonText: 'Continue',
                        onTap: () {
                          profileController.onNext();
                        },
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