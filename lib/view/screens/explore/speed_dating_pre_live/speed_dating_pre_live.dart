import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_fonts.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/main.dart';
import 'package:candid/view/widget/common_image_view_widget.dart';
import 'package:candid/view/widget/my_button_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SpeedDatingPreLive extends StatelessWidget {
  const SpeedDatingPreLive({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              Assets.imagesSparkBg,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: AppSizes.DEFAULT,
                physics: BouncingScrollPhysics(),
                children: [
                  MyText(
                    textAlign: TextAlign.center,
                    lineHeight: 1.5,
                    color: kPrimaryColor,
                    text: 'Ready to Spark a Connection?',
                    size: 22,
                    weight: FontWeight.w700,
                  ),
                  MyText(
                    paddingTop: 12,
                    textAlign: TextAlign.center,
                    lineHeight: 1.5,
                    color: kPrimaryColor,
                    text: 'Join Our Virtual Speed Dating! Mark Your Calendar',
                    size: 13,
                    weight: FontWeight.w600,
                    paddingBottom: 22,
                  ),
                  Stack(
                    children: [
                      Center(
                        child: Image.asset(
                          Assets.imagesNewHeart,
                          height: 240,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 45),
                        child: Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.transparent,
                                  fontSize: 18,
                                  height: 1.5,
                                  fontFamily: AppFonts.URBANIST,
                                  fontWeight: FontWeight.w900,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(2.0, 2.0),
                                      blurRadius: 12.0,
                                      color: kBlackColor.withOpacity(0.36),
                                    ),
                                    Shadow(
                                      offset: Offset(2.0, 2.0),
                                      blurRadius: 12.0,
                                      color: kBlackColor.withOpacity(0.36),
                                    ),
                                  ],
                                ),
                                '16 Oct 2024\n11:30 PM'.toUpperCase(),
                              ),
                              ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (bounds) => LinearGradient(
                                  stops: [0, 1.0],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xffFFFFFF),
                                    Color(0xffFF007F),
                                  ],
                                ).createShader(
                                  Rect.fromLTWH(
                                      0, 0, bounds.width, bounds.height),
                                ),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 18,
                                    height: 1.5,
                                    fontFamily: AppFonts.URBANIST,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  '16 Oct 2024\n11:30 PM'.toUpperCase(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Stack(
                      children: List.generate(
                        6,
                        (index) {
                          return Padding(
                            padding: EdgeInsets.only(
                                left: index == 0 ? 0 : 30 * index + 1),
                            child: Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                color: index == 5 ? kPrimaryColor : null,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 3.13,
                                  color: kMaroonColor2,
                                ),
                              ),
                              child: index == 5
                                  ? Center(
                                      child: ShaderMask(
                                        blendMode: BlendMode.srcIn,
                                        shaderCallback: (bounds) =>
                                            LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [0, 1],
                                          colors: [
                                            Color(0xffFF007F),
                                            Color(0xff4A1A99),
                                          ],
                                        ).createShader(
                                          Rect.fromLTWH(
                                            0,
                                            0,
                                            bounds.width,
                                            bounds.height,
                                          ),
                                        ),
                                        child: MyText(
                                          text: '200+',
                                          color: null,
                                          size: 12,
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          weight: FontWeight.w700,
                                        ),
                                      ),
                                    )
                                  : Center(
                                      child: CommonImageView(
                                        height: Get.height,
                                        width: Get.width,
                                        radius: 100.0,
                                        url: dummyImg,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _CountDown(
                        text: '2',
                      ),
                      _CountDown(
                        text: '4',
                      ),
                      MyText(
                        paddingLeft: 8,
                        paddingRight: 8,
                        text: ':',
                        size: 24,
                        weight: FontWeight.w700,
                        color: kPrimaryColor,
                      ),
                      _CountDown(
                        text: '3',
                      ),
                      _CountDown(
                        text: '3',
                      ),
                      MyText(
                        paddingLeft: 8,
                        paddingRight: 8,
                        text: ':',
                        size: 24,
                        weight: FontWeight.w700,
                        color: kPrimaryColor,
                      ),
                      _CountDown(
                        text: '0',
                      ),
                      _CountDown(
                        text: '4',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.81,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryColor,
                        fontFamily: AppFonts.URBANIST,
                        height: 1.5,
                      ),
                      children: [
                        TextSpan(
                          text: 'Meet New People, Make Real Connections.\n',
                        ),
                        TextSpan(
                          text: '300+ have already signed up!',
                          style: TextStyle(
                            color: kPinkColor3,
                          ),
                        ),
                        TextSpan(
                          text: ' Don’t miss your chance, sign up now!',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: AppSizes.DEFAULT,
              child: MyButton(
                buttonText: 'Sign Up',
                onTap: () {
                  Get.dialog(_YouAreAllSet());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountDown extends StatelessWidget {
  const _CountDown({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2),
      height: 37.19,
      width: 37.19,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: kSecondaryColor,
      ),
      child: Center(
        child: MyText(
          text: text,
          size: 24,
          weight: FontWeight.w700,
          color: kPrimaryColor,
        ),
      ),
    );
  }
}

class _YouAreAllSet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          margin: AppSizes.DEFAULT,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  Assets.imagesCongratsCheck,
                  height: 150,
                ),
                MyText(
                  paddingTop: 24,
                  text: 'Signup Successful!',
                  size: 26,
                  weight: FontWeight.bold,
                  textAlign: TextAlign.center,
                  paddingBottom: 8,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: kGreyColor,
                      fontFamily: AppFonts.URBANIST,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(
                        text: 'You’re all set!',
                        style: TextStyle(
                          color: kPinkColor3,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text:
                            ' Please join the event at the given time. Users that Signup get Preferential Matching. Enjoy! ',
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
