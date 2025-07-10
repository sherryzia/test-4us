import 'dart:ui';

import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_fonts.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/view/screens/cart/cart.dart';

import 'package:candid/view/widget/my_button_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

bool _isWeekly = true;

class Subscription extends StatefulWidget {
  const Subscription({super.key});

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  int _currentIndex = 0;
  final List<String> _images = [
    Assets.imagesP1,
    Assets.imagesP2,
    Assets.imagesP3,
  ];
  void onToggle(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> _spark = [
      'Match, Chat and Date!',
      'Limited Swipes',
      '3 Candid Videos',
      '1 Crush Like ',
      'Explore users by Interests',
    ];

    final List<String> _pro = [
      'Unlimited Likes',
      '6 Candid Videos',
      '3 Crush Likes',
      'See who Likes You',
      'Hide your Age',
    ];
    final List<String> _elite = [
      'Unlimited Likes',
      'Unlimited Candid Videos',
      '5 Crush Likes',
      'See who Likes You',
      'Hide your Age',
      'Send Video Replies before Matching',
      'Unlock Elite Only Content',
    ];
    Widget animatedImage(int index, String image) {
      return Image.asset(
        key: ValueKey(index),
        image,
        height: Get.height,
        width: Get.width,
        fit: BoxFit.cover,
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Column(
            children: [
              AnimatedSwitcher(
                duration: 280.milliseconds,
                reverseDuration: 280.milliseconds,
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeInOut,
                child: Image.asset(
                  key: ValueKey(_currentIndex),
                  _images[_currentIndex],
                  height: Get.height,
                  width: Get.width,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          Container(
            padding: AppSizes.VERTICAL,
            height: Get.height,
            width: Get.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: AppSizes.HORIZONTAL,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Image.asset(
                          Assets.imagesClose,
                          height: 18,
                        ),
                      ),
                      Image.asset(
                        Assets.imagesAppLogo,
                        height: 39,
                      ),
                      Image.asset(
                        Assets.imagesClose,
                        height: 18,
                        color: Colors.transparent,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    padding: AppSizes.DEFAULT,
                    physics: BouncingScrollPhysics(),
                    children: [
                      MyText(
                        text: 'Get Premium Access',
                        size: 16,
                        color: kPrimaryColor,
                        weight: FontWeight.w600,
                        textAlign: TextAlign.center,
                        paddingBottom: 10,
                      ),
                      MyText(
                        text:
                            'Unlock Candid for exclusive perks including access to Exclusive Videos, Unlimited  Swipes, and more. Elevate your dating experience today!',
                        size: 12,
                        textAlign: TextAlign.center,
                        lineHeight: 1.5,
                        color: kPrimaryColor.withOpacity(.9),
                        weight: FontWeight.w300,
                        paddingBottom: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyText(
                            paddingRight: 12,
                            text: 'Pay Weekly',
                            size: 12,
                            color: kPrimaryColor,
                            weight: FontWeight.w500,
                          ),
                          Transform.scale(
                            scale: 1.3,
                            child: SwitchTheme(
                              data: SwitchThemeData(
                                trackColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                  return Color(0xffE0E0E0);
                                }),
                                thumbColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                  return kSecondaryColor;
                                }),
                              ),
                              child: Switch(
                                value: _isWeekly,
                                onChanged: (v) {
                                  setState(() {
                                    _isWeekly = v;
                                  });
                                },
                              ),
                            ),
                          ),
                          MyText(
                            paddingLeft: 12,
                            text: 'Pay Monthly',
                            size: 12,
                            weight: FontWeight.w500,
                            color: kPrimaryColor,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: BouncingScrollPhysics(),
                        itemCount: _currentIndex == 0
                            ? _spark.length
                            : _currentIndex == 1
                                ? _pro.length
                                : _elite.length,
                        itemBuilder: (context, index) {
                          var _items = _currentIndex == 0
                              ? _spark
                              : _currentIndex == 1
                                  ? _pro
                                  : _elite;
                          // final List<Map<String, dynamic>> _items2 = [
                          //   {
                          //     'title': 'Candid Basic',
                          //     'subTitle': 'Free',
                          //   },
                          //   {
                          //     'title': 'Candid Pro',
                          //     'subTitle': !isWeekly ? '£3.99' : '£8.99',
                          //   },
                          //   {
                          //     'title': 'Candid Elite',
                          //     'subTitle': !isWeekly ? '£5.99' : '£12.99',
                          //   },
                          // ];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Image.asset(
                                  Assets.imagesFeatureCheck,
                                  height: 24,
                                ),
                                Expanded(
                                  child: MyText(
                                    paddingLeft: 8,
                                    text: _items[index],
                                    size: 16,
                                    weight: FontWeight.w500,
                                    color: kPrimaryColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _SparkPlan(
                              isSelected: _currentIndex == 0,
                              onTap: () {
                                onToggle(0);
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: _Popular(
                              isSelected: _currentIndex == 1,
                              onTap: () {
                                onToggle(1);
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: _Elite(
                              isSelected: _currentIndex == 2,
                              onTap: () {
                                onToggle(2);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      MyButton(
                        buttonText: 'Subscribe Now',
                        onTap: () {
                          Get.to(() => Cart());
                        },
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 10,
                            height: 1.5,
                            color: kPrimaryColor,
                            fontFamily: AppFonts.URBANIST,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  'By tapping "Subscribe Now", you will be charged. Your subscription will auto-renew for the same price and package length until you cancel via App Store Settings, and you agree to our ',
                            ),
                            TextSpan(
                              text: 'Terms.',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
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

class _SparkPlan extends StatelessWidget {
  const _SparkPlan({
    super.key,
    required this.isSelected,
    required this.onTap,
  });

  final bool isSelected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: AnimatedContainer(
                duration: 220.milliseconds,
                curve: Curves.easeIn,
                height: 115,
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    width: 0.5,
                    color: isSelected ? kSecondaryColor : kPrimaryColor,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MyText(
                      text: 'Candid Spark',
                      size: 12,
                      weight: FontWeight.w600,
                      textAlign: TextAlign.center,
                      color: kPrimaryColor,
                    ),
                    Image.asset(
                      Assets.imagesFree,
                      height: 14,
                    ),
                    MyText(
                      text: '(Active)',
                      size: 12,
                      textAlign: TextAlign.center,
                      weight: FontWeight.w300,
                      color: kPrimaryColor.withOpacity(.42),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isSelected)
            Positioned(
              top: -8,
              right: 2,
              child: Image.asset(
                Assets.imagesSelectedCheck,
                height: 20,
              ),
            ),
        ],
      ),
    );
  }
}

class _Popular extends StatelessWidget {
  const _Popular({
    super.key,
    required this.isSelected,
    required this.onTap,
  });

  final bool isSelected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: AnimatedContainer(
                duration: 220.milliseconds,
                curve: Curves.easeIn,
                height: 152,
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    width: 0.5,
                    color: isSelected ? kSecondaryColor : kPrimaryColor,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      Assets.imagesMostPop,
                      height: 20,
                    ),
                    MyText(
                      text: 'Candid Pro',
                      size: 16,
                      weight: FontWeight.w600,
                      textAlign: TextAlign.center,
                      color: kPrimaryColor,
                    ),
                    MyText(
                      text: !_isWeekly ? ' £3.99' : '£8.99',
                      size: 22,
                      textAlign: TextAlign.center,
                      weight: FontWeight.w300,
                      color: kPrimaryColor,
                    ),
                    Center(
                      child: Container(
                        height: 20,
                        width: 66,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: kPrimaryColor.withOpacity(.2),
                        ),
                        child: Center(
                          child: MyText(
                            text: 'Save 15%',
                            size: 10,
                            color: Color(0xffF4CC2E),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isSelected)
            Positioned(
              top: -8,
              right: 2,
              child: Image.asset(
                Assets.imagesSelectedCheck,
                height: 20,
              ),
            ),
        ],
      ),
    );
  }
}

class _Elite extends StatelessWidget {
  const _Elite({
    super.key,
    required this.isSelected,
    required this.onTap,
  });

  final bool isSelected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: AnimatedContainer(
                duration: 220.milliseconds,
                curve: Curves.easeIn,
                height: 115,
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    width: 0.5,
                    color: isSelected ? kSecondaryColor : kPrimaryColor,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MyText(
                      text: 'Candid Elite',
                      size: 12,
                      weight: FontWeight.w600,
                      textAlign: TextAlign.center,
                      color: kPrimaryColor,
                    ),
                    MyText(
                      text: !_isWeekly ? '£5.99' : '£12.99',
                      size: 22,
                      textAlign: TextAlign.center,
                      weight: FontWeight.w300,
                      color: kPrimaryColor,
                    ),
                    Center(
                      child: Container(
                        height: 20,
                        width: 66,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: kPrimaryColor.withOpacity(.2),
                        ),
                        child: Center(
                          child: MyText(
                            text: 'Save 15%',
                            size: 10,
                            color: Color(0xffF4CC2E),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isSelected)
            Positioned(
              top: -8,
              right: 2,
              child: Image.asset(
                Assets.imagesSelectedCheck,
                height: 20,
              ),
            ),
        ],
      ),
    );
  }
}
