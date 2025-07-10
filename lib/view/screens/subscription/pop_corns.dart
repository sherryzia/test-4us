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

bool _isCrushes = true;

class PopCorns extends StatefulWidget {
  const PopCorns({super.key});

  @override
  State<PopCorns> createState() => _PopCornsState();
}

class _PopCornsState extends State<PopCorns> {
  int _currentIndex = 0;

  void onToggle(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> _popcorns = [
      'Become the star attraction in your area',
      'Multiply your matches exponentially',
      'Effortlessly attract more messages and connections',
      'Fast-track your way to meaningful matches',
      'Spotlight your authentic self to find genuine connections',
    ];

    final List<String> _crushes = [
      'Skip the waiting game - make an instant connection!',
      'Stand out with a personalized video message',
      'Break through the ice before it even forms',
      'Show your genuine interest and boost match chances',
      'Fast-track from attraction to conversation effortlessly',
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Image.asset(
            Assets.imagesPopcornBg,
            height: Get.height,
            width: Get.width,
            fit: BoxFit.cover,
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
                        text: _isCrushes ? 'Get Popcorn' : 'Get Crushes',
                        size: 16,
                        color: kPrimaryColor,
                        weight: FontWeight.w600,
                        textAlign: TextAlign.center,
                        paddingBottom: 10,
                      ),
                      if (_isCrushes)
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              height: 1.5,
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: kPrimaryColor.withOpacity(.9),
                              fontFamily: AppFonts.URBANIST,
                            ),
                            children: [
                              TextSpan(text: 'Lights, camera, you! '),
                              TextSpan(
                                text: 'Popcorn Mode',
                                style: TextStyle(
                                  color: kSecondaryColor,
                                ),
                              ),
                              TextSpan(
                                  text:
                                      ' makes your profile the must-see attraction. Grab that popcorn and watch the connections roll in as you trend to the top!'),
                            ],
                          ),
                        )
                      else
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              height: 1.5,
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: kPrimaryColor.withOpacity(.9),
                              fontFamily: AppFonts.URBANIST,
                            ),
                            children: [
                              TextSpan(text: 'Ready, set, '),
                              TextSpan(
                                text: 'Crush',
                                style: TextStyle(
                                  color: kSecondaryColor,
                                ),
                              ),
                              TextSpan(
                                  text:
                                      '! Break the ice instantly with a message or video. Show your genuine interest and stand out from the crowd. Turn that spark into a match with a Crush!'),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Image.asset(
                                Assets.imagesCandidCrushes,
                                height: 42,
                              ),
                              MyText(
                                paddingTop: 8,
                                text: 'Crushes',
                                size: 12,
                                color: kPrimaryColor,
                                weight: FontWeight.w500,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Transform.scale(
                            alignment: Alignment.bottomCenter,
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
                                value: _isCrushes,
                                onChanged: (v) {
                                  setState(() {
                                    _isCrushes = v;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Column(
                            children: [
                              Image.asset(
                                Assets.imagesCandidPopcorn,
                                height: 42,
                              ),
                              MyText(
                                paddingTop: 8,
                                text: 'Popcorn Tubs',
                                size: 12,
                                weight: FontWeight.w500,
                                color: kPrimaryColor,
                              ),
                            ],
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
                        itemCount:
                            _isCrushes ? _popcorns.length : _crushes.length,
                        itemBuilder: (context, index) {
                          var _items = _isCrushes ? _popcorns : _crushes;
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
                                  height: 22,
                                ),
                                Expanded(
                                  child: MyText(
                                    paddingLeft: 8,
                                    text: _items[index],
                                    size: 12,
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
                            child: _planCard(
                              haveSale: false,
                              isSelected: _currentIndex == 0,
                              onTap: () {
                                onToggle(0);
                              },
                              title: !_isCrushes ? '1 Crush' : '1 Popcorn Tub',
                              price: '£2.99',
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
                              title:
                                  !_isCrushes ? '5 Crushes' : '5 Popcorn Tubs',
                              price: '£9.99',
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: _planCard(
                              isSelected: _currentIndex == 2,
                              onTap: () {
                                onToggle(2);
                              },
                              title:
                                  !_isCrushes ? '3 Crushes' : '3 Popcorn Tubs',
                              price: '£6.99',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      MyButton(
                        buttonText: 'Buy Extras',
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
    required this.title,
    required this.price,
  });

  final bool isSelected;
  final String title;
  final String price;
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
                      text: title,
                      size: 12,
                      weight: FontWeight.w600,
                      textAlign: TextAlign.center,
                      color: kPrimaryColor,
                    ),
                    MyText(
                      text: price,
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

class _planCard extends StatelessWidget {
  const _planCard({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.title,
    required this.price,
    this.haveSale = true,
  });

  final bool isSelected;
  final bool? haveSale;
  final String title;
  final String price;
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
                  mainAxisAlignment: haveSale!
                      ? MainAxisAlignment.spaceEvenly
                      : MainAxisAlignment.center,
                  children: [
                    MyText(
                      text: title,
                      size: 12,
                      weight: FontWeight.w600,
                      textAlign: TextAlign.center,
                      color: kPrimaryColor,
                    ),
                    MyText(
                      paddingTop: haveSale! ? 0 : 6,
                      text: price,
                      size: 22,
                      textAlign: TextAlign.center,
                      weight: FontWeight.w300,
                      color: kPrimaryColor,
                    ),
                    if (haveSale!)
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
