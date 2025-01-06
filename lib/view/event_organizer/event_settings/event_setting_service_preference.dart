
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/constants/app_fonts.dart';
import 'package:forus_app/constants/app_sizes.dart';
import 'package:forus_app/generated/assets.dart';
import 'package:forus_app/view/widget/common_image_view_widget.dart';
import 'package:forus_app/view/widget/my_button_widget.dart';
import 'package:forus_app/view/widget/my_text_widget.dart';

class EventSettingServicePreferenceScreen extends StatefulWidget {
  const EventSettingServicePreferenceScreen({super.key});

  @override
  State<EventSettingServicePreferenceScreen> createState() =>
      _EventSettingServicePreferenceScreenState();
}

class _EventSettingServicePreferenceScreenState
    extends State<EventSettingServicePreferenceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemeColors.getTertiary(context),
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: CommonImageView(
              imagePath: Assets.imagesArrowLeft,
              height: 24,
            ),
          ),
        ),
      ),
      backgroundColor: AppThemeColors.getTertiary(context),
      body: Padding(
        padding: AppSizes.DEFAULT2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView(
                children: [
                  MyText(
                    text: 'Choose Events Type',
                    size: 24,
                    textAlign: TextAlign.center,
                    fontFamily: AppFonts.NUNITO_SANS,
                    weight: FontWeight.w800,
                  ),
                  MyText(
                    text: 'Please choose your event type.',
                    size: 16,
                    paddingTop: 5,
                    paddingBottom: 22,
                    textAlign: TextAlign.center,
                    color: kTextGrey,
                    fontFamily: AppFonts.NUNITO_SANS,
                    weight: FontWeight.w500,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    spacing: 26,
                    children: [
                      ImageTextWidget(
                        imagePath: Assets.imagesBusiness,
                        text: "Business",
                      ),
                      ImageTextWidget(
                        imagePath: Assets.imagesSocail,
                        text: "Social",
                      ),
                      ImageTextWidget(
                        imagePath: Assets.imagesCultuural,
                        text: "Cultural",
                      ),
                    ],
                  ),
                  Gap(24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    spacing: 26,
                    children: [
                      ImageTextWidget(
                        imagePath: Assets.imagesEntertainment,
                        text: "Entertainment",
                      ),
                      ImageTextWidget(
                        imagePath: Assets.imagesSports,
                        text: "Sports",
                      ),
                      ImageTextWidget(
                        imagePath: Assets.imagesEducational,
                        text: "Educational",
                      ),
                    ],
                  ),
                  Gap(24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    spacing: 26,
                    children: [
                      ImageTextWidget(
                        imagePath: Assets.imagesCharity,
                        text: "Charity",
                      ),
                      ImageTextWidget(
                        imagePath: Assets.imagesPublicevents,
                        text: "Public Events",
                      ),
                      ImageTextWidget(
                        imagePath: Assets.imagesPrivateevnets,
                        text: "Private Events",
                      ),
                    ],
                  ),
                  Gap(24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    spacing: 26,
                    children: [
                      ImageTextWidget(
                        imagePath: Assets.imagesVirtualevnets,
                        text: "Virtual Events",
                      ),
                      ImageTextWidget(
                        imagePath: Assets.imagesNightclubs,
                        text: "Night Club",
                      ),
                     SizedBox(width: 100,)
                    ],
                  ),
                  Gap(24),
                ],
              ),
            ),
            MyButton(
                buttonText: "Update & Save",
                radius: 14,
                textSize: 18,
                weight: FontWeight.w800,
                onTap: () {
                }),
          ],
        ),
      ),
    );
  }
}

class ImageTextWidget extends StatelessWidget {
  final String imagePath;
  final String text;

  const ImageTextWidget({
    super.key,
    required this.imagePath,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Image.asset(imagePath, height: 66 ,),
 
        MyText(
          text: text,
          size: 12,
          paddingTop: 8,
          fontFamily: AppFonts.NUNITO_SANS,
          weight: FontWeight.w800,
        ),
      ],
    );
  }
}
