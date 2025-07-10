import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_styling.dart';
import 'package:candid/controller/GlobalController.dart';
import 'package:candid/main.dart';
import 'package:candid/view/screens/subscription/pop_corns.dart';
import 'package:candid/view/widget/common_image_view_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final globalController = Get.find<GlobalController>();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CommonImageView(
              height: 90.0,
              width: 90.0,
              radius: 100.0,
              url: globalController.profilePicture.value.isNotEmpty
                  ? globalController.profilePicture.value
                  : dummyImg,
            ),
            Positioned(
              bottom: -15,
              right: 0,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kPrimaryColor,
                      boxShadow: [
                        AppStyling.DEFAULT_SHADOW,
                      ],
                    ),
                    child: CircularPercentIndicator(
                      radius: 15.0,
                      lineWidth: 2,
                      percent: 0.8,
                      circularStrokeCap: CircularStrokeCap.round,
                      backgroundColor: kSecondaryColor.withOpacity(0.1),
                      linearGradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          kSecondaryColor,
                          kPurpleColor,
                        ],
                      ),
                      center: MyText(
                        text: '${globalController.profileCompletion()}%',
                        size: 8,
                        weight: FontWeight.w600,
                        color: kSecondaryColor,
                      ),
                    ),
                  ),
                  MyText(
                    text: 'Complete',
                    size: 8,
                    weight: FontWeight.w600,
                    color: kSecondaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  MyText(
                    text: globalController.name.value,
                    size: 16,
                    weight: FontWeight.w700,
                    paddingRight: 4,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  globalController.isPremium.value == false
                      ? SizedBox(
                          width: 0,
                        )
                      : Image.asset(
                          Assets.imagesCandidPro,
                          height: 28,
                        ),
                  SizedBox(
                    width: 4,
                  ),
                  globalController.isPremium.value == false
                      ? SizedBox(
                          width: 0,
                        )
                      : Image.asset(
                          Assets.imagesCandidElite,
                          height: 28,
                        ),
                ],
              ),
              MyText(
                paddingTop: 4,
                text:
                   globalController.tagline.value.isNotEmpty ? '"${globalController.tagline.value}"' : '"Travel junkie, foodie, bookworm ready for fun and adventure!"',
                size: 14,
                lineHeight: 1.5,
                color: kHintColor,
                paddingBottom: 6,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
