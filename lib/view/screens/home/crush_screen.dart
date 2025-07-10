import 'dart:ui';
import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/view/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:candid/view/widget/my_button_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:stroke_text/stroke_text.dart';

class CrushScreen extends StatefulWidget {
  const CrushScreen({super.key});

  @override
  State<CrushScreen> createState() => _CrushScreenState();
}

class _CrushScreenState extends State<CrushScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (v) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) {
              return BottomNavBar();
            },
          ),
          (route) {
            return route.isFirst;
          },
        ).then((v) {
          setState(() {});
        });
      },
      child: Scaffold(
        body: Stack(
          children: [
            Transform.scale(
              alignment: Alignment.bottomCenter,
              scaleX: 1.23,
              scaleY: 1.0,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Image.asset(
                  Assets.imagesItsAMatchGif, // Change this to your GIF asset path
                  fit: BoxFit.cover,
                  gaplessPlayback: true, // Ensures smooth looping
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: AppSizes.DEFAULT,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 5,
                        sigmaY: 5,
                      ),
                      child: Container(
                        height: 325,
                        padding: AppSizes.DEFAULT,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.5,
                            color: kPrimaryColor,
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              kBlackColor.withOpacity(0.0),
                              kBlackColor.withOpacity(0.47),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Image.asset(
                                  Assets.imagesYouCrush,
                                  height: 97.4,
                                ),
                                Positioned(
                                  top: 83,
                                  left: 0,
                                  right: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        Assets.imagesOn,
                                        height: 35.55,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Stack(
                                        clipBehavior: Clip.none,
                                        alignment: Alignment.center,
                                        children: [
                                          StrokeText(
                                            text: 'Sarah!'.toUpperCase(),
                                            textStyle: TextStyle(
                                              fontSize: 34,
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.italic,
                                              fontFamily:
                                                  GoogleFonts.familjenGrotesk()
                                                      .fontFamily,
                                              color: kPrimaryColor,
                                            ),
                                            strokeColor: kSecondaryColor,
                                            strokeWidth: 5,
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: -20,
                                            child: Image.asset(
                                              Assets.imagesSmallHearts,
                                              height: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 35,
                            ),
                            MyButton(
                              buttonText: '',
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 32,
                                      width: 32,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: kPrimaryColor,
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          Assets.imagesSendMessage,
                                          height: 18,
                                          color: kSecondaryColor,
                                        ),
                                      ),
                                    ),
                                    MyText(
                                      text: 'Send Message',
                                      size: 16,
                                      weight: FontWeight.w600,
                                      color: kPrimaryColor,
                                    ),
                                    Image.asset(
                                      Assets.imagesMultipleArrow,
                                      height: 18,
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {},
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1.0,
                                      color: kPrimaryColor,
                                    ),
                                    color: kPrimaryColor.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          height: 32,
                                          width: 32,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: kPrimaryColor,
                                          ),
                                          child: Center(
                                            child: Image.asset(
                                              Assets.imagesVideoMessage,
                                              height: 18,
                                              color: kSecondaryColor,
                                            ),
                                          ),
                                        ),
                                        MyText(
                                          text: 'Send Video Message',
                                          size: 16,
                                          weight: FontWeight.w600,
                                          color: kPrimaryColor,
                                        ),
                                        Image.asset(
                                          Assets.imagesMultipleArrow,
                                          height: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            MyText(
                              paddingTop: 24,
                              text: 'Keep Swiping',
                              size: 14,
                              color: kPrimaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Lottie.asset(
              Assets.imagesM1,
              repeat: false,
              height: Get.height,
              width: Get.width,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}