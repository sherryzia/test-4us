import 'dart:ui';

import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/view/screens/home/get_more_likes.dart';
import 'package:candid/view/widget/my_button_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OutOfSwipe extends StatelessWidget {
  const OutOfSwipe({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> _items = [
      {
        'title': 'Get 10 x More Views',
        'icon': Assets.images10xViews,
      },
      {
        'title': 'More Videos = More Matches',
        'icon': Assets.imagesMoreVideos,
      },
      {
        'title': 'Send Messages Before Matching',
        'icon': Assets.imagesBeforeMessage,
      },
      {
        'title': 'Send Videos Before Matching',
        'icon': Assets.imagesVideoBeforeMessage,
      },
    ];
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 8,
          sigmaY: 8,
        ),
        child: Container(
          padding: AppSizes.DEFAULT,
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.imagesOutOfSwipesBg),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
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
              MyText(
                paddingTop: 20,
                text: 'You are out of Swipes!',
                size: 18,
                color: kPrimaryColor,
                weight: FontWeight.w600,
                textAlign: TextAlign.center,
                paddingBottom: 8,
              ),
              MyText(
                text: 'Love is all about patience. But waiting Sucks!',
                size: 14,
                textAlign: TextAlign.center,
                lineHeight: 1.5,
                color: kPrimaryColor.withOpacity(.7),
                weight: FontWeight.w300,
                paddingBottom: 20,
              ),
              MyText(
                text: 'Swipes Reset in',
                size: 12,
                textAlign: TextAlign.center,
                lineHeight: 1.5,
                color: kPrimaryColor.withOpacity(.7),
                weight: FontWeight.w300,
                paddingBottom: 8,
              ),
              MyText(
                text: '11:59:36',
                size: 30,
                color: kSecondaryColor,
                weight: FontWeight.w600,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Image.asset(
                  Assets.imagesDividerNew,
                ),
              ),
              Image.asset(
                Assets.imagesPE,
                height: 48,
              ),
              MyText(
                paddingTop: 10,
                paddingBottom: 4,
                text: 'How about unlimited swipes?',
                size: 20,
                weight: FontWeight.w600,
                textAlign: TextAlign.center,
                color: kPrimaryColor,
              ),
              MyText(
                paddingTop: 8,
                text: 'plus... ',
                size: 16,
                weight: FontWeight.w600,
                textAlign: TextAlign.center,
                color: kPrimaryColor,
                paddingBottom: 20,
              ),
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: BouncingScrollPhysics(),
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          _items[index]['icon'],
                          height: 24,
                        ),
                        MyText(
                          paddingLeft: 8,
                          text: _items[index]['title'],
                          size: 16,
                          weight: FontWeight.w500,
                          color: kPrimaryColor,
                        ),
                      ],
                    ),
                  );
                },
              ),
              MyText(
                paddingTop: 8,
                text: 'and so much more...',
                size: 16,
                weight: FontWeight.w600,
                textAlign: TextAlign.center,
                color: kPrimaryColor,
                paddingBottom: 20,
              ),
              Spacer(),
              MyButton(
                buttonText: 'Upgrade to Premium',
                onTap: () {
                  Get.back();
                  Get.dialog(GirlPopCornTub());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
