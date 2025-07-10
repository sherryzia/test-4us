import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/controller/GlobalController.dart';
import 'package:candid/view/screens/explore/speed_dating_pre_live/speed_dating_live.dart';
import 'package:candid/view/screens/explore/speed_dating_pre_live/speed_dating_pre_live.dart';
import 'package:candid/view/widget/common_image_view_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalController globalController = Get.find<GlobalController>();
    
    return Scaffold(
      body: NestedScrollView(
        physics: BouncingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              titleSpacing: 20.0,
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      MyText(
                        text: 'Explore',
                        size: 20,
                        weight: FontWeight.w600,
                      ),
                      Positioned(
                        top: -24,
                        left: -10,
                        child: Image.asset(
                          Assets.imagesTitleHearts,
                          height: 41.68,
                        ),
                      ),
                      Positioned(
                        top: -3,
                        right: -10,
                        child: Image.asset(
                          Assets.imagesTitleHeartsFilled,
                          height: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              expandedHeight: 90,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: AppSizes.HORIZONTAL,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MyText(
                        paddingBottom: 10,
                        text:
                            'Explore by interests or trending topics - find your match through shared passions and hot discussions!',
                        color: kGreyColor,
                        lineHeight: 1.5,
                        size: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: ListView(
          shrinkWrap: true,
          padding: AppSizes.DEFAULT,
          physics: BouncingScrollPhysics(),
          children: [
            MyText(
              size: 16,
              weight: FontWeight.w600,
              text: 'Categories',
              paddingBottom: 8,
            ),
            // Trending Section
            GestureDetector(
              onTap: () {
                // Handle trending tap - you can navigate to trending content
                // For example: Get.to(() => TrendingPage());
              },
              child: Stack(
                children: [
                  CommonImageView(
                    imagePath: Assets.imagesTrending,
                    height: 102,
                    width: Get.width,
                    radius: 12,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    padding: AppSizes.HORIZONTAL,
                    height: 102,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: kBlackColor.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                      border: GradientBoxBorder(
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            kSecondaryColor,
                            kPurpleColor,
                          ],
                        ),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              Assets.imagesTrendingIcon,
                              height: 34,
                            ),
                            MyText(
                              paddingLeft: 8,
                              text: 'Trending',
                              size: 18,
                              weight: FontWeight.w600,
                              color: kPrimaryColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // Dynamic Categories Grid
            Obx(() {
              final categories = globalController.getReelCategories;
              
              if (categories.isEmpty) {
                return Container(
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        MyText(
                          text: 'Loading categories...',
                          size: 14,
                          color: kGreyColor,
                        ),
                      ],
                    ),
                  ),
                );
              }
              
              return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: categories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  mainAxisExtent: 97,
                ),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final bool isPremium = category['is_premium'] ?? false;
                  final String categoryName = category['name'] ?? 'Unknown';
                  final String categoryIcon = category['icon'] ?? '';
                  final String categoryImage = category['banner'] ?? '';
                  
                  return GestureDetector(
                    onTap: () {
                      // Handle category tap - navigate to category content
                      // You can pass the category data to the next screen
                      // For example: Get.to(() => CategoryPage(category: category));
                      print('Tapped on category: $categoryName');
                    },
                    child: Stack(
                      children: [
                        CommonImageView(
                          url: categoryImage,
                          height: Get.height,
                          width: Get.width,
                          radius: 10,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 14),
                          width: Get.width,
                          height: Get.width,
                          decoration: BoxDecoration(
                            color: kBlackColor.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(10),
                            border: GradientBoxBorder(
                              gradient: LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                colors: [
                                  kSecondaryColor,
                                  kPurpleColor,
                                ],
                              ),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  CommonImageView(
                                    url: categoryIcon,
                                    height: 32,
                                    width: 32,
                                    fit: BoxFit.contain,
                                  ),
                                  SizedBox(width: 6),
                                  Expanded(
                                    child: MyText(
                                      text: categoryName,
                                      size: 15,
                                      weight: FontWeight.w600,
                                      color: kPrimaryColor,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Show crown for premium categories
                        if (isPremium)
                          Positioned(
                            top: 10,
                            right: 6,
                            child: Image.asset(
                              Assets.imagesCrown,
                              height: 20,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              );
            }),
            SizedBox(
              height: 10,
            ),
            // Virtual Speed Dating Section
            GestureDetector(
              onTap: () {
                Get.to(() => SpeedDatingPreLive());
              },
              child: Stack(
                children: [
                  CommonImageView(
                    imagePath: Assets.imagesVirtualSpeedDating,
                    height: 102,
                    width: Get.width,
                    radius: 12,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    padding: AppSizes.HORIZONTAL,
                    height: 102,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: kBlackColor.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                      border: GradientBoxBorder(
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            kSecondaryColor,
                            kPurpleColor,
                          ],
                        ),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              Assets.imagesTrendingIcon,
                              height: 34,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  MyText(
                                    paddingLeft: 8,
                                    text: 'Virtual Speed Dating',
                                    size: 18,
                                    weight: FontWeight.w600,
                                    color: kPrimaryColor,
                                  ),
                                  MyText(
                                    paddingTop: 6,
                                    paddingLeft: 8,
                                    text: '(Sign up for 8pm - 10pm Saturday)',
                                    size: 12,
                                    color: kPrimaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => SpeedDatingLive());
                      },
                      child: Image.asset(
                        Assets.imagesLiveBadge,
                        height: 17,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}