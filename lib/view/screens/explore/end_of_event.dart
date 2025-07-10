import 'dart:async';
import 'dart:ui';

import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/main.dart';
import 'package:candid/view/widget/common_image_view_widget.dart';
import 'package:candid/view/widget/my_button_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EndOfEvent extends StatefulWidget {
  const EndOfEvent({super.key});

  @override
  State<EndOfEvent> createState() => _EndOfEventState();
}

class _EndOfEventState extends State<EndOfEvent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        Timer(1.seconds, () {
          Get.bottomSheet(
            _ResultBottomSheet(),
            barrierColor: Colors.transparent,
            isDismissible: false,
            enableDrag: false,
            isScrollControlled: true,
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              Assets.imagesEndOfEventBg,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          shrinkWrap: true,
          padding: AppSizes.DEFAULT,
          physics: BouncingScrollPhysics(),
          children: [
            MyText(
              paddingTop: 35,
              textAlign: TextAlign.center,
              lineHeight: 1.5,
              color: kPinkColor2,
              text: 'That\'s a Wrap',
              size: 32,
              weight: FontWeight.w800,
            ),
            MyText(
              paddingTop: 14,
              paddingRight: 30,
              paddingLeft: 30,
              textAlign: TextAlign.center,
              lineHeight: 1.5,
              color: kPrimaryColor,
              text:
                  'Thank you for joining our event! We hope you had a great time!',
              size: 16,
              weight: FontWeight.w500,
              paddingBottom: 25,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: Get.width,
                  height: 240,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 3,
                      color: Color(0xffF44274),
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: CommonImageView(
                      radius: 30,
                      width: Get.width,
                      fit: BoxFit.cover,
                      imagePath: Assets.imagesWrapBg,
                      height: Get.height,
                    ),
                  ),
                ),
                Image.asset(
                  Assets.imagesOverlapingHearts,
                  height: 170,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 55,
                    ),
                    Center(
                      child: Stack(
                        children: [
                          ...List.generate(
                            4,
                            (index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  left: index == 0 ? 0 : 42 * index + 1,
                                ),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 55,
                                      width: 55,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 3.13,
                                          color: kMaroonColor2,
                                        ),
                                      ),
                                      child: Center(
                                        child: CommonImageView(
                                          height: Get.height,
                                          width: Get.width,
                                          radius: 100.0,
                                          url: dummyImg,
                                        ),
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 2,
                                          sigmaY: 2,
                                        ),
                                        child: Container(
                                          height: 55,
                                          width: 55,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                kBlackColor.withOpacity(0.16),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    MyText(
                      paddingTop: 10,
                      paddingBottom: 10,
                      text: 'You have Likes!\nUpgrade to see them now!',
                      size: 16,
                      lineHeight: 1.5,
                      weight: FontWeight.w700,
                      color: kPrimaryColor,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: Get.height * 0.35,
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MyText(
                paddingTop: 25,
                paddingBottom: 30,
                text:
                    'All the results of your Matches, Likes and Crushes will appear in your Matches page shortly!',
                size: 18,
                lineHeight: 1.5,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                weight: FontWeight.w600,
                color: kPrimaryColor,
                textAlign: TextAlign.center,
              ),
              MyButton(
                height: 52,
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
                      text: 'Upgrade Now',
                      color: null,
                      size: 16,
                      weight: FontWeight.w700,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                ),
                onTap: () {},
              ),
              MyText(
                paddingTop: 18,
                text: 'End Event',
                size: 16,
                weight: FontWeight.w600,
                color: kPrimaryColor,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Positioned(
          top: -60,
          left: 0,
          right: 0,
          child: Center(
            child: Image.asset(
              Assets.imagesWrapStackHeart,
              height: 100,
            ),
          ),
        ),
      ],
    );
  }
}
