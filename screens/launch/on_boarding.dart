import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_images.dart';
import 'package:restaurant_finder/constants/app_sizes.dart';
import 'package:restaurant_finder/view/screens/auth/sign_up/sign_up.dart';
import 'package:restaurant_finder/view/widget/my_button_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// ignore: must_be_immutable
class OnBoarding extends StatefulWidget {
  OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  List<Map<String, dynamic>> _items = [
    {
      'title': 'discoverNewAndExcitingRestaurants'.tr,
      'subTitle': 'startByCreatingYourBusinessProfileToShowcase'.tr,
      'image': Assets.imagesOn1,
    },
    {
      'title': 'findThePerfectDiningSpot'.tr,
      'subTitle': 'discoverNewAndExcitingRestaurants'.tr,
      'image': Assets.imagesOn2,
    },
    {
      'title': 'startByCreatingYourBusinessProfile'.tr,
      'subTitle': 'discoverNewAndExcitingRestaurants'.tr,
      'image': Assets.imagesOn3,
    },
  ];

  PageController controller = PageController();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          PageView.builder(
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            controller: controller,
            itemCount: _items.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Image.asset(
                    _items[index]['image'],
                    height: Get.height,
                    width: Get.width,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: AppSizes.DEFAULT,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MyText(
                          paddingTop: 25,
                          text: _items[index]['title'],
                          size: 22,
                          lineHeight: 1.3,
                          color: kPrimaryColor,
                          weight: FontWeight.w600,
                          paddingBottom: 16,
                        ),
                        MyText(
                          text: _items[index]['subTitle'],
                          lineHeight: 1.8,
                          color: kTertiaryColor.withOpacity(0.77),
                          paddingBottom: 100,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(
                child: SmoothPageIndicator(
                  controller: controller, // PageController
                  count: _items.length,
                  effect: ScrollingDotsEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    dotColor: kTertiaryColor.withOpacity(0.3),
                    activeDotColor: kSecondaryColor,
                  ), // your preferred effect
                  onDotClicked: (index) {},
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: AppSizes.DEFAULT,
                child:
                    currentIndex == 2
                        ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 70),
                          child: MyButton(
                            height: 40,
                            buttonText: 'getStarted'.tr,
                            onTap: () {
                              Get.to(() => SignUp());
                            },
                          ),
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.nextPage(
                                  duration: Duration(milliseconds: 220),
                                  curve: Curves.easeIn,
                                );
                              },
                              child: Container(
                                height: 40,
                                width: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: kPrimaryColor,
                                ),
                                child: Center(
                                  child: MyText(
                                    text: 'skip'.tr,
                                    size: 12,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.nextPage(
                                  duration: Duration(milliseconds: 220),
                                  curve: Curves.easeIn,
                                );
                              },
                              child: Container(
                                height: 40,
                                width: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: kSecondaryColor,
                                ),
                                child: Center(
                                  child: MyText(
                                    text: 'next'.tr,
                                    size: 12,
                                    color: kPrimaryColor,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
