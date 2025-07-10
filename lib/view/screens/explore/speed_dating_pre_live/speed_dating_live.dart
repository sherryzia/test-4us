import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_fonts.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/main.dart';
import 'package:candid/view/screens/explore/speed_date_calling.dart';
import 'package:candid/view/widget/common_image_view_widget.dart';
import 'package:candid/view/widget/my_button_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SpeedDatingLive extends StatelessWidget {
  const SpeedDatingLive({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              Assets.imagesLiveEventBg,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    padding: AppSizes.VERTICAL,
                    physics: BouncingScrollPhysics(),
                    children: [
                      MyText(
                        textAlign: TextAlign.center,
                        lineHeight: 1.5,
                        color: kPrimaryColor,
                        text: 'Welcome to Candid Speed Dating',
                        size: 21.5,
                        weight: FontWeight.w800,
                      ),
                      MyText(
                        paddingTop: 12,
                        textAlign: TextAlign.center,
                        lineHeight: 1.5,
                        color: kPrimaryColor,
                        text:
                            'Get ready to meet real people,\nmake genuine connections and find Love!',
                        size: 13,
                        weight: FontWeight.w600,
                        paddingBottom: 22,
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            Assets.imagesLiveFlowers,
                            height: 200,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Image.asset(
                                Assets.imagesLiveClock,
                                height: 58,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Center(
                                child: Stack(
                                  children: [
                                    Text(
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.transparent,
                                        fontSize: 18,
                                        height: 1.5,
                                        fontFamily: AppFonts.URBANIST,
                                        fontWeight: FontWeight.w700,
                                        shadows: <Shadow>[
                                          Shadow(
                                            offset: Offset(2.0, 2.0),
                                            blurRadius: 12.0,
                                            color:
                                                kBlackColor.withOpacity(0.36),
                                          ),
                                          Shadow(
                                            offset: Offset(2.0, 2.0),
                                            blurRadius: 12.0,
                                            color:
                                                kBlackColor.withOpacity(0.36),
                                          ),
                                        ],
                                      ),
                                      '6pm - 8pm'.toUpperCase(),
                                    ),
                                    ShaderMask(
                                      blendMode: BlendMode.srcIn,
                                      shaderCallback: (bounds) =>
                                          LinearGradient(
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
                                          fontWeight: FontWeight.w700,
                                        ),
                                        '6pm - 8pm'.toUpperCase(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              MyText(
                                textAlign: TextAlign.center,
                                paddingTop: 4,
                                text: 'Location: UK',
                                size: 12,
                                weight: FontWeight.w600,
                                color: kPrimaryColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: Get.height * 0.44,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: AppSizes.DEFAULT,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                        gradient: LinearGradient(
                          stops: [0, 1],
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [
                            Color(0xff7B2BFF),
                            Color(0xffFF007F),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 22,
                          ),
                          Image.asset(
                            Assets.imagesLiveHeart,
                            height: 40.35,
                          ),
                          Expanded(
                            child: ListView(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: BouncingScrollPhysics(),
                              children: [
                                MyText(
                                  paddingTop: 15,
                                  paddingBottom: 15,
                                  text: 'Please Remember the Rules:',
                                  size: 20,
                                  weight: FontWeight.w600,
                                  color: kPrimaryColor,
                                  textAlign: TextAlign.center,
                                ),
                                ...List.generate(
                                  3,
                                  (index) {
                                    final List<String> _items = [
                                      'You can Skip a call at any time',
                                      'Give your Feedback at the end of the Call\nBe kind, be genuine, be yourself',
                                      'If you need to take a break, you can\ncontinue while the event is Live',
                                    ];
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            Assets.imagesRuleHeart,
                                            height: 24,
                                          ),
                                          MyText(
                                            paddingLeft: 8,
                                            lineHeight: 1.5,
                                            text: _items[index],
                                            size: 14,
                                            weight: FontWeight.w500,
                                            color: kPrimaryColor,
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                          MyButton(
                            buttonText: '',
                            bgColor: kPrimaryColor,
                            child: Center(
                              child: ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (bounds) => LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  stops: [0, 1],
                                  colors: [
                                    Color(0xff7B2BFF),
                                    Color(0xffFF007F),
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
                                  text: 'Start Event',
                                  color: null,
                                  size: 20,
                                  weight: FontWeight.w700,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                ),
                              ),
                            ),
                            onTap: () {
                              Get.to(() => SpeedDateCalling());
                            },
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: -25,
                      left: 0,
                      right: 0,
                      child: Center(
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
                                      width: 3.74,
                                      color: index == 1 || index == 3
                                          ? Color(0xffAA5668)
                                          : kMaroonColor2,
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
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
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
