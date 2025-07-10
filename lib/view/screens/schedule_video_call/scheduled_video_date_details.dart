import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScheduledVideoDateDetails extends StatelessWidget {
  const ScheduledVideoDateDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: AppSizes.DEFAULT,
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              Assets.imagesVideoDateBg,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    kSecondaryColor.withOpacity(0.2),
                    kPurpleColor.withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: MyText(
                text: 'You\'re going on a Virtual Date!',
                textAlign: TextAlign.center,
                lineHeight: 1.5,
                size: 32,
                weight: FontWeight.w600,
                color: kPrimaryColor,
                paddingBottom: 8,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Image.asset(
              Assets.imagesAppLogo,
              height: 70,
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    kSecondaryColor.withOpacity(0.2),
                    kPurpleColor.withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  MyText(
                    paddingTop: 10,
                    text: 'Virtual Date starts in',
                    textAlign: TextAlign.center,
                    size: 14,
                    color: kPrimaryColor,
                    weight: FontWeight.w600,
                    paddingBottom: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          MyText(
                            text: '02',
                            size: 28,
                            color: kPrimaryColor,
                            weight: FontWeight.w600,
                            paddingBottom: 4,
                          ),
                          MyText(
                            color: kPrimaryColor,
                            text: 'Days',
                            size: 16,
                            weight: FontWeight.w600,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          MyText(
                            text: '12',
                            size: 28,
                            color: kPrimaryColor,
                            weight: FontWeight.w600,
                            paddingBottom: 4,
                          ),
                          MyText(
                            color: kPrimaryColor,
                            text: 'Hours',
                            size: 16,
                            weight: FontWeight.w600,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          MyText(
                            text: '30',
                            size: 28,
                            color: kPrimaryColor,
                            weight: FontWeight.w600,
                            paddingBottom: 4,
                          ),
                          MyText(
                            color: kPrimaryColor,
                            text: 'Minutes',
                            size: 16,
                            weight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
