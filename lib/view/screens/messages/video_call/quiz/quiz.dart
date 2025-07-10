import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_fonts.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/main.dart';
import 'package:candid/utils/global_instances.dart';
import 'package:candid/view/widget/common_image_view_widget.dart';
import 'package:candid/view/widget/my_button_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:candid/view/widget/video_player_control_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Quiz extends StatelessWidget {
  const Quiz({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.bottomLeft,
            stops: [0, 1.0],
            colors: [
              Color(0xffFF007F).withOpacity(.3),
              Color(0xff7B2BFF).withOpacity(.3),
            ],
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                        ),
                        child: CommonImageView(
                          height: Get.height,
                          width: Get.width,
                          url: dummyImg,
                          radius: 0.0,
                        ),
                      ),
                      Positioned(
                        right: 20,
                        top: 103,
                        child: CommonImageView(
                          height: 150,
                          width: 112,
                          radius: 12,
                          url: dummyImg,
                        ),
                      ),
                      _quizVideoCallControls(),
                    ],
                  ),
                ),
                // Quiz Section Start
                if (quizController.isCompatibilityCheck.value)
                  _CompatibilityQuiz()
                else if (quizController.isStart.value)
                  _StartQuiz()
                else if (quizController.showAiMagic.value)
                  _WorkingOnCompatibility()
                else if (quizController.isNegative.value)
                  _NegativeOutput()
                else if (quizController.isPositive.value)
                  _PositiveOutput(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 60, 20, 0),
                  child: GestureDetector(
                    onTap: quizController.onQuizToggle,
                    child: Image.asset(
                      Assets.imagesArrowBackIcon,
                      height: 24,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                MyText(
                  paddingTop: 55,
                  text: 'QUIZ',
                  size: 20,
                  weight: FontWeight.w600,
                  color: kPrimaryColor,
                  textAlign: TextAlign.center,
                ),
                MyText(
                  paddingRight: 20,
                  paddingTop: 55,
                  text: '01:04:05',
                  size: 16,
                  color: kPrimaryColor,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class _StartQuiz extends StatelessWidget {
  const _StartQuiz({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSizes.DEFAULT,
      // height: Get.height,
      // width: Get.width,
      // decoration: BoxDecoration(
      //   gradient: LinearGradient(
      //     begin: Alignment.centerRight,
      //     end: Alignment.bottomLeft,
      //     stops: [0, 1.0],
      //     colors: [
      //       Color(0xffFF007F).withOpacity(.3),
      //       Color(0xff7B2BFF).withOpacity(.3),
      //     ],
      //   ),
      // ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.imagesQuizStars),
              ),
            ),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  height: 1.5,
                  fontSize: 24,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w600,
                  color: kPrimaryColor,
                  fontFamily: AppFonts.URBANIST,
                ),
                children: [
                  TextSpan(text: 'Who wrote the play\n'),
                  TextSpan(text: '"'),
                  TextSpan(
                    text: 'Romeo and Juliet',
                    style: TextStyle(
                      foreground: Paint()
                        ..shader = LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: <Color>[
                            kPinkColor2,
                            Color(0xff8428F8),
                          ],
                        ).createShader(
                          Rect.fromLTWH(0.0, 0.0, 320.0, 70.0),
                        ),
                    ),
                  ),
                  TextSpan(text: '"'),
                  TextSpan(text: '?'),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: AppSizes.HORIZONTAL,
            child: Row(
              children: [
                MyText(
                  text: 'Time',
                  size: 12,
                  color: kPrimaryColor,
                  paddingRight: 10,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: GradientBoxBorder(
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            kSecondaryColor,
                            kPurpleColor,
                          ],
                        ),
                        width: 1,
                      ),
                    ),
                    child: LinearPercentIndicator(
                      padding: EdgeInsets.zero,
                      animation: true,
                      animationDuration: 3000,
                      lineHeight: 6.0,
                      percent: 1.0,
                      onAnimationEnd: () {
                        quizController.onShowAiMagic();
                      },
                      barRadius: Radius.circular(50),
                      backgroundColor: Colors.transparent,
                      linearGradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          kSecondaryColor,
                          kPurpleColor,
                        ],
                      ),
                    ),
                  ),
                ),
                MyText(
                  paddingLeft: 10,
                  text: '00:42',
                  size: 12,
                  color: kPrimaryColor,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: BouncingScrollPhysics(),
            itemCount: 4,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisExtent: 42,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final List<String> _items = [
                'William Shakespeare',
                'Charles Dickens',
                'Mark Twain',
                'Jane Austin',
              ];
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  _QuizButton(
                    isSelected: index == 0,
                    title: _items[index],
                    isMe: index == 0,
                    isOtherUser: index == 2,
                    options: index == 0
                        ? 'A'
                        : index == 1
                            ? 'B'
                            : index == 2
                                ? 'C'
                                : 'D',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CompatibilityQuiz extends StatelessWidget {
  const _CompatibilityQuiz({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: AppSizes.DEFAULT,
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.centerRight,
          //   end: Alignment.bottomLeft,
          //   stops: [0, 1.0],
          //   colors: [
          //     Color(0xffFF007F).withOpacity(.3),
          //     Color(0xff7B2BFF).withOpacity(.3),
          //   ],
          // ),
          image: DecorationImage(
            image: AssetImage(
              Assets.imagesComBg,
            ),
            alignment: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.imagesQuizStartsHeats),
                ),
              ),
              child: Center(
                child: MyText(
                  text: 'Compatibility Quiz',
                  size: 24,
                  weight: FontWeight.w600,
                  color: kPrimaryColor,
                ),
              ),
            ),
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        CommonImageView(
                          height: 72.44,
                          width: 72.44,
                          radius: 100.0,
                          url: dummyImg,
                        ),
                        Positioned(
                          bottom: -25,
                          left: -40,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(7, 4, 14, 8),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(Assets.imagesNameBgWithStars),
                              ),
                            ),
                            child: MyText(
                              text: 'Sarah!'.toUpperCase(),
                              size: 22.48,
                              fontFamily:
                                  GoogleFonts.familjenGrotesk().fontFamily,
                              weight: FontWeight.w700,
                              color: kPrimaryColor,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 18),
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          CommonImageView(
                            height: 72.44,
                            width: 72.44,
                            radius: 100.0,
                            url: dummyImg,
                          ),
                          Positioned(
                            bottom: -25,
                            left: 10,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(7, 4, 14, 8),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage(Assets.imagesNameBgWithStars),
                                ),
                              ),
                              child: MyText(
                                text: 'David!'.toUpperCase(),
                                size: 22.48,
                                fontFamily:
                                    GoogleFonts.familjenGrotesk().fontFamily,
                                weight: FontWeight.w700,
                                color: kPrimaryColor,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  top: 20,
                  bottom: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset(
                      Assets.imagesHeartWithSmallStars,
                      height: 38.7,
                    ),
                  ),
                ),
              ],
            ),
            MyText(
              paddingTop: 20,
              text:
                  'Find out your compatibility! Answer 10 questions honestly and let Candid’s AI magic reveal your horoscope. Good luck!',
              textAlign: TextAlign.center,
              size: 15,
              lineHeight: 1.5,
              color: kPrimaryColor.withOpacity(0.8),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyButton(
                  buttonText: 'Start Quiz',
                  onTap: quizController.onStartQuiz,
                ),
                MyText(
                  paddingTop: 16,
                  text: '* Waiting for your partner to start!',
                  size: 10,
                  weight: FontWeight.w700,
                  color: kPinkColor3,
                  textAlign: TextAlign.center,
                  paddingBottom: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkingOnCompatibility extends StatelessWidget {
  const _WorkingOnCompatibility({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: AppSizes.DEFAULT,
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              Assets.imagesMatchingBg,
            ),
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter,
          ),
          // gradient: LinearGradient(
          //   begin: Alignment.centerRight,
          //   end: Alignment.bottomLeft,
          //   stops: [0, 1.0],
          //   colors: [
          //     Color(0xffFF007F).withOpacity(.3),
          //     Color(0xff7B2BFF).withOpacity(.3),
          //   ],
          // ),
        ),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: BouncingScrollPhysics(),
          children: [
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CommonImageView(
                          height: 129,
                          width: 129,
                          radius: 100.0,
                          url: dummyImg,
                        ),
                        Image.asset(
                          Assets.imagesImageRing,
                          height: 140.26,
                          width: 140.26,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 37.44),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CommonImageView(
                            height: 129,
                            width: 129,
                            radius: 100.0,
                            url: dummyImg,
                          ),
                          Image.asset(
                            Assets.imagesImageRing,
                            height: 140.26,
                            width: 140.26,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 10,
                  top: 0,
                  bottom: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset(
                      Assets.imagesMatchingHeart,
                      height: 175.3,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            MyText(
              text:
                  'Working on your Compatibility with Ai Magic and a touch of frivolity!',
              textAlign: TextAlign.center,
              size: 18,
              weight: FontWeight.w600,
              lineHeight: 1.5,
              color: kPrimaryColor.withOpacity(0.8),
            ),
            MyText(
              paddingTop: 16,
              text: '30%',
              size: 20,
              weight: FontWeight.w600,
              color: kSecondaryColor,
              textAlign: TextAlign.center,
              paddingBottom: 16,
            ),
            Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: GradientBoxBorder(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      kSecondaryColor,
                      kPurpleColor,
                    ],
                  ),
                  width: 1,
                ),
              ),
              child: LinearPercentIndicator(
                padding: EdgeInsets.zero,
                animation: true,
                animationDuration: 3000,
                lineHeight: 8.24,
                percent: 1.0,
                onAnimationEnd: () {
                  quizController.showNegativeResults();
                },
                barRadius: Radius.circular(50),
                backgroundColor: Colors.transparent,
                linearGradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    kSecondaryColor,
                    kPurpleColor,
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

class _NegativeOutput extends StatelessWidget {
  const _NegativeOutput({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: AppSizes.DEFAULT,
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              Assets.imagesNegBg,
            ),
            alignment: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          CommonImageView(
                            height: 62.44,
                            width: 62.44,
                            radius: 100.0,
                            url: dummyImg,
                          ),
                          Positioned(
                            bottom: -25,
                            left: -40,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(7, 4, 14, 8),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage(Assets.imagesNameBgWithStars),
                                ),
                              ),
                              child: MyText(
                                text: 'Sarah!'.toUpperCase(),
                                size: 22.48,
                                fontFamily:
                                    GoogleFonts.familjenGrotesk().fontFamily,
                                weight: FontWeight.w700,
                                color: kPrimaryColor,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18),
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            CommonImageView(
                              height: 62.44,
                              width: 62.44,
                              radius: 100.0,
                              url: dummyImg,
                            ),
                            Positioned(
                              bottom: -25,
                              left: 10,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(7, 4, 14, 8),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        Assets.imagesNameBgWithStars),
                                  ),
                                ),
                                child: MyText(
                                  text: 'David!'.toUpperCase(),
                                  size: 22.48,
                                  fontFamily:
                                      GoogleFonts.familjenGrotesk().fontFamily,
                                  weight: FontWeight.w700,
                                  color: kPrimaryColor,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    left: 0,
                    top: 20,
                    bottom: 0,
                    right: 0,
                    child: Center(
                      child: Image.asset(
                        Assets.imagesNegativeOutput,
                        height: 48.16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyText(
                  text: 'Romance is Dead!',
                  size: 23.sp,
                  weight: FontWeight.w700,
                  color: kSecondaryColor,
                  paddingBottom: 12,
                  textAlign: TextAlign.center,
                ),
                MyText(
                  text:
                      'You\'re a hopeless romantic with a dash of pessimism. Your chances of finding long-term love are about 10%, but hey, that\'s still higher than your chances of winning the lottery! Maybe it\'s time to stop pining over your ex and give new love a chance.',
                  textAlign: TextAlign.center,
                  size: 15.sp,
                  weight: FontWeight.w500,
                  lineHeight: 1.6,
                  color: kPrimaryColor.withOpacity(0.8),
                  paddingBottom: 16,
                ),
              ],
            ),
            MyButton(
              buttonText: 'Done',
              onTap: quizController.showPositiveResults,
            ),
          ],
        ),
      ),
    );
  }
}

class _PositiveOutput extends StatelessWidget {
  const _PositiveOutput({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: AppSizes.DEFAULT,
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              Assets.imagesPositiveBg,
            ),
            alignment: Alignment.bottomCenter,
          ),
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.bottomLeft,
            stops: [0, 1.0],
            colors: [
              Color(0xffFF007F).withOpacity(.3),
              Color(0xff7B2BFF).withOpacity(.3),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          CommonImageView(
                            height: 80.44,
                            width: 80.44,
                            radius: 100.0,
                            url: dummyImg,
                          ),
                          Positioned(
                            bottom: -25,
                            left: -40,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(7, 4, 14, 8),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage(Assets.imagesNameBgWithStars),
                                ),
                              ),
                              child: MyText(
                                text: 'Sarah!'.toUpperCase(),
                                size: 22.48,
                                fontFamily:
                                    GoogleFonts.familjenGrotesk().fontFamily,
                                weight: FontWeight.w700,
                                color: kPrimaryColor,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18),
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            CommonImageView(
                              height: 80.44,
                              width: 80.44,
                              radius: 100.0,
                              url: dummyImg,
                            ),
                            Positioned(
                              bottom: -25,
                              left: 10,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(7, 4, 14, 8),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        Assets.imagesNameBgWithStars),
                                  ),
                                ),
                                child: MyText(
                                  text: 'David!'.toUpperCase(),
                                  size: 22.48,
                                  fontFamily:
                                      GoogleFonts.familjenGrotesk().fontFamily,
                                  weight: FontWeight.w700,
                                  color: kPrimaryColor,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    left: 0,
                    top: 20,
                    bottom: 0,
                    right: 0,
                    child: Center(
                      child: Image.asset(
                        Assets.imagesPositiveOutput,
                        height: 68.16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                MyText(
                  text: 'Romance is Alive!',
                  size: 23.sp,
                  weight: FontWeight.w700,
                  color: kSecondaryColor,
                  paddingBottom: 12,
                  textAlign: TextAlign.center,
                ),
                MyText(
                  text:
                      'You\'re a hopeless romantic with a dash of pessimism. Your chances of finding long-term love are about 10%, but hey, that\'s still higher than your chances of winning the lottery! Maybe it\'s time to stop pining over your ex and give new love a chance.',
                  textAlign: TextAlign.center,
                  size: 15.sp,
                  // fontFamily: GoogleFonts.poppins().fontFamily,
                  weight: FontWeight.w500,
                  lineHeight: 1.6,
                  color: kPrimaryColor.withOpacity(0.8),
                  paddingBottom: 16,
                ),
              ],
            ),
            MyButton(
              buttonText: 'Done',
              onTap: quizController.onQuizToggle,
            ),
          ],
        ),
      ),
    );
  }
}

Align _quizVideoCallControls() {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Padding(
      padding: const EdgeInsets.only(
        bottom: 14,
        left: 20,
        right: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          VideoPlayerControlButton(
            icon: Assets.imagesNewGameIcon,
            onTap: quizController.onGamesToggle,
          ),
          VideoPlayerControlButton(
            icon: Assets.imagesNewMicIcon,
            onTap: () {},
          ),
          VideoPlayerControlButton(
            icon: Assets.imagesNewCameraIcon,
            onTap: () {},
          ),
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kSecondaryColor,
            ),
            child: Center(
              child: Image.asset(
                Assets.imagesEndCall,
                height: 24,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _QuizButton extends StatelessWidget {
  final String title;
  final String options;
  final bool isSelected;
  final bool isMe;
  final bool isOtherUser;

  const _QuizButton({
    required this.title,
    required this.options,
    required this.isMe,
    required this.isOtherUser,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: !isSelected
              ? [
                  Color(0xff381064),
                  Color(0xff381064),
                ]
              : [
                  kSecondaryColor,
                  kPurpleColor,
                ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(
            text: options,
            size: 14,
            color: kPrimaryColor,
            paddingRight: 13,
          ),
          MyText(
            text: title,
            size: 16,
            color: kPrimaryColor,
          ),
          if (isSelected)
            _QuizSelectedBy(
              isMe: isMe,
              title: 'C',
            )
          else if (isOtherUser)
            _QuizSelectedBy(
              isMe: false,
              title: 'T',
            )
          else
            SizedBox(
              height: 27,
              width: 27,
            ),
        ],
      ),
    );
  }
}

class _QuizSelectedBy extends StatelessWidget {
  const _QuizSelectedBy({
    super.key,
    required this.isMe,
    required this.title,
  });
  final String title;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 27,
      width: 27,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: !isMe ? kPinkColor2 : kPurpleColor,
      ),
      child: Center(
        child: Container(
          margin: EdgeInsets.all(3),
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: !isMe ? kPurpleColor : kPinkColor2,
          ),
          child: Center(
            child: MyText(
              text: title,
              size: 12,
              weight: FontWeight.w600,
              color: kPrimaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
