import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_images.dart';
import 'package:restaurant_finder/constants/app_sizes.dart';
import 'package:restaurant_finder/main.dart';
import 'package:restaurant_finder/view/widget/common_image_view_widget.dart';
import 'package:restaurant_finder/view/widget/custom_app_bar_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';
import 'package:restaurant_finder/controller/theme_controller.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    return Obx(() {
      final isDark = themeController.isDarkMode;
      return Scaffold(
        backgroundColor: isDark ? kBlackColor : Colors.white,
        appBar: simpleAppBar(title: 'favorites'.tr),
        body: ListView.builder(
          shrinkWrap: true,
          padding: AppSizes.DEFAULT,
          physics: BouncingScrollPhysics(),
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(width: 1.0, color: kBorderColor),
                color: isDark ? kDialogBlack : Colors.white,
              ),
              child: Row(
                children: [
                  CommonImageView(
                    height: 75,
                    width: 80,
                    radius: 10,
                    url: dummyImg,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MyText(
                          text: 'bigAndBurgerBoss'.tr,
                          size: 16,
                          weight: FontWeight.w600,
                          color: isDark ? kTertiaryColor : null,
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Image.asset(
                              Assets.imagesLocationPin,
                              height: 14,
                              color: kGreyColor,
                            ),
                            MyText(
                              paddingLeft: 6,
                              text: 'distance'.tr,
                              size: 12,
                              weight: FontWeight.w500,
                              color: kGreyColor,
                            ),
                            SizedBox(width: 20),
                            Image.asset(
                              Assets.imagesTime,
                              height: 14,
                              color: kGreyColor,
                            ),
                            MyText(
                              paddingLeft: 6,
                              text: 'opensAt'.tr,
                              size: 12,
                              weight: FontWeight.w500,
                              color: kGreyColor,
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Color(0xffF5BD4F),
                              size: 17,
                            ),
                            MyText(
                              paddingLeft: 4,
                              text: 'ratings'.tr,
                              size: 12,
                              weight: FontWeight.w500,
                              color: isDark ? kDarkTextColor : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
