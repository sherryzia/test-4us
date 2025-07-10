import 'dart:ui';
import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/main.dart';
import 'package:candid/view/widget/common_image_view_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class OtherUserProfileDetails extends StatelessWidget {
  const OtherUserProfileDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> _items = [
      {
        "title": "Open to anything",
        "icon": Assets.imagesOpenTo,
      },
      {
        "title": "Wants children",
        "icon": Assets.imagesWantChildren,
      },
      {
        "title": "Introvert",
        "icon": Assets.imagesIntrovert,
      },
      {
        "title": "Homebody",
        "icon": Assets.imagesHomebody,
      },
      {
        "title": "Cat person",
        "icon": Assets.imagesCatPerson,
      },
      {
        "title": "Physical touch",
        "icon": Assets.imagesPhysical,
      },
      {
        "title": "Sports player",
        "icon": Assets.imagesSportsPlayer,
      },
      {
        "title": "Coffee shop chat",
        "icon": Assets.imagesCoffee,
      },
      {
        "title": "Technology",
        "icon": Assets.imagesTechnologu,
      },
      {
        "title": "Gaming",
        "icon": Assets.imagesGamming,
      },
      {
        "title": "Road tripper",
        "icon": Assets.imagesRoad,
      },
      {
        "title": "Rock music",
        "icon": Assets.imagesRock,
      },
      {
        "title": "Non-drinker",
        "icon": Assets.imagesNonDrinker,
      },
      {
        "title": "Non-smoker",
        "icon": Assets.imagesSmoker,
      },
      {
        "title": "Vegan",
        "icon": Assets.imagesVegan,
      },
      {
        "title": "Rural living",
        "icon": Assets.imagesRutal,
      },
      {
        "title": "High school education",
        "icon": Assets.imagesEdu,
      },
      {
        "title": "Hindu (Converted)",
        "icon": Assets.imagesHindu,
      },
      {
        "title": "Height: 5'7''",
        "icon": Assets.imagesHeight,
      },
    ];

    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 10,
            sigmaY: 10,
          ),
          child: Container(
            height: Get.height * 0.9,
            padding: AppSizes.DEFAULT,
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    height: 4,
                    width: 45,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    padding: AppSizes.VERTICAL,
                    physics: BouncingScrollPhysics(),
                    children: [
                      Row(
                        children: [
                          CommonImageView(
                            height: 110,
                            width: 110,
                            radius: 100.0,
                            url: dummyImg,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.fromLTRB(7, 4, 14, 8),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image:
                                              AssetImage(Assets.imagesNameBg),
                                        ),
                                      ),
                                      child: MyText(
                                        text: 'Sarah!'.toUpperCase(),
                                        size: 24,
                                        fontFamily:
                                            GoogleFonts.familjenGrotesk()
                                                .fontFamily,
                                        weight: FontWeight.w700,
                                        color: kPrimaryColor,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Image.asset(
                                      Assets.imagesCandidPro,
                                      height: 28,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Image.asset(
                                      Assets.imagesCandidElite,
                                      height: 28,
                                    ),
                                  ],
                                ),
                                MyText(
                                  text:
                                      '"Travel junkie, foodie, bookworm—ready for fun and adventure!"',
                                  size: 12,
                                  lineHeight: 1.5,
                                  color: kPrimaryColor.withOpacity(0.9),
                                  paddingBottom: 10,
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      Assets.imagesAge,
                                      height: 14,
                                    ),
                                    MyText(
                                      paddingLeft: 4,
                                      text: '21',
                                      size: 12,
                                      color: kPrimaryColor,
                                      paddingRight: 14,
                                    ),
                                    MyText(
                                      text: '🇵🇰 Pakistan',
                                      size: 12,
                                      color: kPrimaryColor,
                                      paddingRight: 14,
                                    ),
                                    CircleAvatar(
                                      radius: 3.5,
                                      backgroundColor: kOnlineColor,
                                    ),
                                    MyText(
                                      text: 'Online',
                                      paddingLeft: 4,
                                      size: 12,
                                      color: kOnlineColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        alignment: WrapAlignment.center,
                        children: List.generate(
                          _items.length,
                          (index) {
                            return _Tag(
                              icon: _items[index]['icon'],
                              title: _items[index]['title'],
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Image.asset(
                          Assets.imagesDivider,
                          color: kSecondaryColor,
                        ),
                      ),
                      MyText(
                        text: 'About Me',
                        size: 14,
                        weight: FontWeight.w600,
                        color: kPrimaryColor,
                        paddingBottom: 4,
                      ),
                      MyText(
                        text:
                            'I\'m a firm believer in making the most out of life and love to surround myself with positivity.',
                        size: 12,
                        lineHeight: 1.5,
                        color: kPrimaryColor.withOpacity(0.8),
                        paddingBottom: 12,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 10,
                            sigmaY: 10,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: kBlackColor.withOpacity(0.16),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                MyText(
                                  paddingTop: 12,
                                  paddingLeft: 15,
                                  paddingBottom: 12,
                                  text: 'Posts',
                                  size: 16,
                                  weight: FontWeight.w600,
                                  color: kPrimaryColor,
                                ),
                                GridView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: 6,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisExtent: 120,
                                    crossAxisSpacing: 1,
                                    mainAxisSpacing: 1,
                                  ),
                                  itemBuilder: (context, index) {
                                    return Stack(
                                      children: [
                                        CommonImageView(
                                          height: Get.height,
                                          width: Get.width,
                                          radius: 0,
                                          url: dummyImg,
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          height: Get.height,
                                          width: Get.width,
                                          decoration: BoxDecoration(
                                            color:
                                                kTertiaryColor.withOpacity(0.4),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    Assets.imagesPlaySmall,
                                                    height: 10.5,
                                                    color: kPrimaryColor,
                                                  ),
                                                  MyText(
                                                    paddingLeft: 4,
                                                    text: '1.3k',
                                                    size: 10,
                                                    color: kPrimaryColor,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({
    required this.icon,
    required this.title,
  });
  final String icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 3.58,
          sigmaY: 3.58,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: kBlackColor.withOpacity(0.16),
            borderRadius: BorderRadius.circular(50),
            border: GradientBoxBorder(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  kPrimaryColor,
                  Color(0xff999999),
                ],
              ),
              width: 1,
            ),
          ),
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Image.asset(
                icon,
                height: 10,
              ),
              MyText(
                paddingLeft: 6,
                paddingRight: 6,
                text: title,
                size: 12,
                color: kPrimaryColor,
                weight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
