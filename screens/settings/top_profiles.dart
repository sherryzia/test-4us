import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_images.dart';
import 'package:restaurant_finder/constants/app_sizes.dart';
import 'package:restaurant_finder/controller/explore_controller.dart';
import 'package:restaurant_finder/main.dart';
import 'package:restaurant_finder/model/explore_model.dart';
import 'package:restaurant_finder/view/widget/common_image_view_widget.dart';
import 'package:restaurant_finder/view/widget/custom_app_bar_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';
import 'package:restaurant_finder/controller/theme_controller.dart';

class TopProfiles extends StatelessWidget {
  final ExploreController exploreController = Get.find<ExploreController>();
  
  TopProfiles({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    
    return Obx(() {
      final isDark = themeController.isDarkMode;
      
      return Scaffold(
        backgroundColor: isDark ? kBlackColor : Colors.white,
        appBar: simpleAppBar(title: 'topProfiles'.tr),
        body: Obx(() {
          if (exploreController.topProfiles.isEmpty) {
            return Center(
              child: CircularProgressIndicator(color: kSecondaryColor),
            );
          }
          
          return ListView.builder(
            shrinkWrap: true,
            padding: AppSizes.DEFAULT,
            physics: BouncingScrollPhysics(),
            itemCount: exploreController.topProfiles.length,
            itemBuilder: (context, index) {
              final profile = exploreController.topProfiles[index];
              
              return Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(width: 1.0, color: kBorderColor),
                  color: isDark ? kDialogBlack : Colors.white,
                ),
                child: Row(
                  children: [
                    CommonImageView(
                      height: 40,
                      width: 40,
                      radius: 100.0,
                      url: profile.profileImage.isNotEmpty 
                        ? profile.profileImage 
                        : dummyImg,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            paddingLeft: 12,
                            text: profile.name,
                            size: 16,
                            weight: FontWeight.w600,
                            color: isDark ? kTertiaryColor : null,
                          ),
                          SizedBox(height: 4),
                          MyText(
                            paddingLeft: 12,
                            text: 'followersCount'.trParams({
                              'count': profile.followersCount.toString()
                            }),
                            size: 12,
                            color: isDark ? kDarkTextColor : kGreyColor,
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Add follow/unfollow functionality here
                        // You can implement the follow logic here
                      },
                      child: MyText(
                        text: 'follow'.tr,
                        size: 14,
                        weight: FontWeight.w500,
                        color: kSecondaryColor,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      );
    });
  }
}