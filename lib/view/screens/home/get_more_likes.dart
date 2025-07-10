// import 'dart:ui';

// import 'package:candid/constants/app_colors.dart';
// import 'package:candid/constants/app_images.dart';
// import 'package:candid/constants/app_sizes.dart';
// import 'package:candid/view/widget/my_button_widget.dart';
// import 'package:candid/view/widget/my_text_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class GetMoreLikes extends StatelessWidget {
//   const GetMoreLikes({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, dynamic>> _cc = [
//       {
//         'title': 'Send messages before matching',
//         'icon': Assets.imagesBeforeMessage,
//       },
//       {
//         'title': 'Send videos before matching',
//         'icon': Assets.imagesVideoBeforeMessage,
//       },
//       {
//         'title': 'Stand out from the Crowd',
//         'icon': Assets.imagesStandFromCrowd,
//       },
//     ];
//     final List<Map<String, dynamic>> _pt = [
//       {
//         'title': 'Go Trending for 30 mins',
//         'icon': Assets.imagesGoTrending,
//       },
//       {
//         'title': '10 x more views in your area',
//         'icon': Assets.images10xViews,
//       },
//       {
//         'title': 'Sit back and watch the matches roll in',
//         'icon': Assets.imagesMoreVideos,
//       },
//     ];
//     return ClipRRect(
//       child: BackdropFilter(
//         filter: ImageFilter.blur(
//           sigmaX: 8,
//           sigmaY: 8,
//         ),
//         child: Container(
//           padding: AppSizes.DEFAULT,
//           height: Get.height,
//           width: Get.width,
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage(Assets.imagesOutOfSwipesBg),
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Get.back();
//                     },
//                     child: Image.asset(
//                       Assets.imagesClose,
//                       height: 18,
//                     ),
//                   ),
//                   Image.asset(
//                     Assets.imagesAppLogo,
//                     height: 39,
//                   ),
//                   Image.asset(
//                     Assets.imagesClose,
//                     height: 18,
//                     color: Colors.transparent,
//                   ),
//                 ],
//               ),
//               MyText(
//                 paddingTop: 20,
//                 text: 'Get More Likes!',
//                 size: 18,
//                 color: kPrimaryColor,
//                 weight: FontWeight.w600,
//                 textAlign: TextAlign.center,
//                 paddingBottom: 8,
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 20),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Image.asset(
//                         Assets.imagesDividerNew,
//                         height: 1,
//                         fit: BoxFit.fill,
//                       ),
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     Image.asset(
//                       Assets.imagesCs,
//                       height: 32,
//                     ),
//                     MyText(
//                       paddingLeft: 5,
//                       text: 'Crushes',
//                       size: 16,
//                       weight: FontWeight.w600,
//                       color: kPrimaryColor,
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     Expanded(
//                       child: Image.asset(
//                         Assets.imagesDividerNew,
//                         height: 1,
//                         fit: BoxFit.fill,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               ListView.builder(
//                 shrinkWrap: true,
//                 padding: EdgeInsets.zero,
//                 physics: BouncingScrollPhysics(),
//                 itemCount: _cc.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 10),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Image.asset(
//                           _cc[index]['icon'],
//                           height: 24,
//                         ),
//                         MyText(
//                           paddingLeft: 8,
//                           text: _cc[index]['title'],
//                           size: 16,
//                           weight: FontWeight.w500,
//                           color: kPrimaryColor,
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 20),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Image.asset(
//                         Assets.imagesDividerNew,
//                         height: 1,
//                         fit: BoxFit.fill,
//                       ),
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     Image.asset(
//                       Assets.imagesPt,
//                       height: 32,
//                     ),
//                     MyText(
//                       paddingLeft: 5,
//                       text: 'Popcorn Tubs',
//                       size: 16,
//                       weight: FontWeight.w600,
//                       color: kPrimaryColor,
//                       paddingRight: 5,
//                     ),
//                     Expanded(
//                       child: Image.asset(
//                         Assets.imagesDividerNew,
//                         height: 1,
//                         fit: BoxFit.fill,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               ListView.builder(
//                 shrinkWrap: true,
//                 padding: EdgeInsets.zero,
//                 physics: BouncingScrollPhysics(),
//                 itemCount: _pt.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 10),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Image.asset(
//                           _pt[index]['icon'],
//                           height: 24,
//                         ),
//                         MyText(
//                           paddingLeft: 8,
//                           text: _pt[index]['title'],
//                           size: 16,
//                           weight: FontWeight.w500,
//                           color: kPrimaryColor,
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//               Spacer(),
//               MyButton(
//                 buttonText: 'Buy Extras',
//                 onTap: () {},
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_fonts.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/view/widget/my_button_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GirlPopCornTub extends StatelessWidget {
  const GirlPopCornTub({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            padding: AppSizes.DEFAULT,
            margin: AppSizes.DEFAULT,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(
                  Assets.imagesPopUpBg,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Image.asset(
                    Assets.imagesPopCornTub,
                    height: 240,
                  ),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: kBlackColor,
                      fontFamily: AppFonts.URBANIST,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(
                        text: 'Popcorn Mode has ended! Get',
                      ),
                      TextSpan(
                        text: ' 30 FREE mins ',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          foreground: Paint()
                            ..shader = LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                kSecondaryColor,
                                kPurpleColor,
                              ],
                            ).createShader(
                              Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                            ),
                        ),
                      ),
                      TextSpan(
                        text: 'of Trending',
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 12,
                      color: kBlackColor,
                      fontFamily: AppFonts.URBANIST,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(
                        text: 'Wow, what a success... you had',
                      ),
                      TextSpan(
                        text: ' 20x ',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text:
                            'more views than usual.  Get more trend-time and showcase again!',
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                MyButton(
                  buttonText: '',
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MyText(
                        textAlign: TextAlign.center,
                        color: kPrimaryColor,
                        text: '1 Popcorn Tub for ',
                        size: 16,
                        weight: FontWeight.w500,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyText(
                            textAlign: TextAlign.center,
                            color: kPrimaryColor,
                            text: '60',
                            size: 16,
                            weight: FontWeight.w600,
                            paddingBottom: 2,
                          ),
                          MyText(
                            textAlign: TextAlign.center,
                            color: kPrimaryColor,
                            text: ' mins',
                            size: 16,
                            weight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ],
                  ),
                  onTap: () {
                    Get.back();
                    Get.dialog(BoyPopCornTub());
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                MyBorderButton(
                  buttonText: 'End the Show',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class BoyPopCornTub extends StatelessWidget {
  const BoyPopCornTub({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            padding: AppSizes.DEFAULT,
            margin: AppSizes.DEFAULT,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(
                  Assets.imagesPopUpBg,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Image.asset(
                    Assets.imagesBoyPopCornTub,
                    height: 240,
                  ),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: kBlackColor,
                      fontFamily: AppFonts.URBANIST,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(
                        text: 'Popcorn Mode has ended! Get',
                      ),
                      TextSpan(
                        text: ' 30 FREE mins ',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          foreground: Paint()
                            ..shader = LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                kSecondaryColor,
                                kPurpleColor,
                              ],
                            ).createShader(
                              Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                            ),
                        ),
                      ),
                      TextSpan(
                        text: 'of Trending',
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 12,
                      color: kBlackColor,
                      fontFamily: AppFonts.URBANIST,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(
                        text: 'Wow, what a success... you had',
                      ),
                      TextSpan(
                        text: ' 20x ',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text:
                            'more views than usual.  Get more trend-time and showcase again!',
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                MyButton(
                  buttonText: '',
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MyText(
                        textAlign: TextAlign.center,
                        color: kPrimaryColor,
                        text: '1 Popcorn Tub for ',
                        size: 16,
                        weight: FontWeight.w500,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyText(
                            textAlign: TextAlign.center,
                            color: kPrimaryColor,
                            text: '60',
                            size: 16,
                            weight: FontWeight.w600,
                            paddingBottom: 2,
                          ),
                          MyText(
                            textAlign: TextAlign.center,
                            color: kPrimaryColor,
                            text: ' mins',
                            size: 16,
                            weight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ],
                  ),
                  onTap: () {
                    Get.back();
                    Get.dialog(GirlCountDown());
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                MyBorderButton(
                  buttonText: 'End the Show',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class GirlCountDown extends StatelessWidget {
  const GirlCountDown({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            padding: AppSizes.DEFAULT,
            margin: AppSizes.DEFAULT,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(
                  Assets.imagesPopUpBg,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Stack(
                    children: [
                      Image.asset(
                        Assets.imagesGirlCountDown,
                        height: 240,
                      ),
                      Positioned(
                        right: 63,
                        bottom: 55,
                        child: Material(
                          color: Colors.transparent,
                          child: CircularCountDownTimer(
                            duration: 30,
                            initialDuration: 0,
                            controller: CountDownController(),
                            width: 35,
                            height: 35,
                            ringColor: Color(0xfffafafa),

                            fillColor: Colors.transparent,
                            fillGradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [
                                kSecondaryColor,
                                kPurpleColor,
                              ],
                            ),

                            backgroundColor: kPrimaryColor,
                            backgroundGradient: null,
                            strokeWidth: 4.0,
                            strokeCap: StrokeCap.round,
                            textStyle: TextStyle(
                              fontSize: 10.0,
                              color: kSecondaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            // textAlign: TextAlign.center,
                            textFormat: CountdownTextFormat.MM_SS,
                            isReverse: true,
                            isReverseAnimation: true,
                            isTimerTextShown: true,
                            autoStart: true,
                            onStart: () {
                              debugPrint('Countdown Started');
                            },
                            onComplete: () {
                              debugPrint('Countdown Ended');
                            },
                            onChange: (String timeStamp) {
                              debugPrint('Countdown Changed $timeStamp');
                            },
                            timeFormatterFunction:
                                (defaultFormatterFunction, duration) {
                              if (duration.inSeconds == 0) {
                                return "00:30";
                              } else {
                                return Function.apply(
                                    defaultFormatterFunction, [duration]);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: kBlackColor,
                      fontFamily: AppFonts.URBANIST,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(
                        text: 'Popcorn Mode will have you Trending like an ',
                      ),
                      TextSpan(
                        text: 'Influencer for 30 mins!',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          foreground: Paint()
                            ..shader = LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                kSecondaryColor,
                                kPurpleColor,
                              ],
                            ).createShader(
                              Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                            ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                MyText(
                  lineHeight: 1.5,
                  size: 12,
                  color: kBlackColor,
                  textAlign: TextAlign.center,
                  text:
                      'Grab your Popcorn and watch the show as you trend to the top! Or get involved and start swiping for even more views, likes and connections!',
                ),
                SizedBox(
                  height: 16,
                ),
                MyButton(
                  buttonText: 'Start Popcorn Mode',
                  onTap: () {
                    Get.back();
                    Get.dialog(BoyCountDown());
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                MyBorderButton(
                  buttonText: 'Cancel',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class BoyCountDown extends StatelessWidget {
  const BoyCountDown({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            padding: AppSizes.DEFAULT,
            margin: AppSizes.DEFAULT,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(
                  Assets.imagesPopUpBg,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Stack(
                    children: [
                      Image.asset(
                        Assets.imagesBoyCountDown,
                        height: 240,
                      ),
                      Positioned(
                        right: 63,
                        bottom: 55,
                        child: Material(
                          color: Colors.transparent,
                          child: CircularCountDownTimer(
                            duration: 30,
                            initialDuration: 0,
                            controller: CountDownController(),
                            width: 35,
                            height: 35,
                            ringColor: Color(0xfffafafa),

                            fillColor: Colors.transparent,
                            fillGradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [
                                kSecondaryColor,
                                kPurpleColor,
                              ],
                            ),

                            backgroundColor: kPrimaryColor,
                            backgroundGradient: null,
                            strokeWidth: 4.0,
                            strokeCap: StrokeCap.round,
                            textStyle: TextStyle(
                              fontSize: 10.0,
                              color: kSecondaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            // textAlign: TextAlign.center,
                            textFormat: CountdownTextFormat.MM_SS,
                            isReverse: true,
                            isReverseAnimation: true,
                            isTimerTextShown: true,
                            autoStart: true,
                            onStart: () {
                              debugPrint('Countdown Started');
                            },
                            onComplete: () {
                              debugPrint('Countdown Ended');
                            },
                            onChange: (String timeStamp) {
                              debugPrint('Countdown Changed $timeStamp');
                            },
                            timeFormatterFunction:
                                (defaultFormatterFunction, duration) {
                              if (duration.inSeconds == 0) {
                                return "00:30";
                              } else {
                                return Function.apply(
                                    defaultFormatterFunction, [duration]);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: kBlackColor,
                      fontFamily: AppFonts.URBANIST,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(
                        text: 'Popcorn Mode will have you Trending like an ',
                      ),
                      TextSpan(
                        text: 'Influencer for 30 mins!',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          foreground: Paint()
                            ..shader = LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                kSecondaryColor,
                                kPurpleColor,
                              ],
                            ).createShader(
                              Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                            ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                MyText(
                  lineHeight: 1.5,
                  size: 12,
                  color: kBlackColor,
                  textAlign: TextAlign.center,
                  text:
                      'Grab your Popcorn and watch the show as you trend to the top! Or get involved and start swiping for even more views, likes and connections!',
                ),
                SizedBox(
                  height: 16,
                ),
                MyButton(
                  buttonText: 'Start Popcorn Mode',
                  onTap: () {
                    Get.back();
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                MyBorderButton(
                  buttonText: 'Cancel',
                  onTap: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
