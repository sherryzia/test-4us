// lib/view/screens/saved_restaurants/favorite_collection_list.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_sizes.dart';
import 'package:restaurant_finder/controller/saved_restaurants_controller.dart';
import 'package:restaurant_finder/view/screens/saved_restaurants/saved_restaurants.dart';
import 'package:restaurant_finder/view/screens/saved_restaurants/selected_collection_list.dart';
import 'package:restaurant_finder/view/widget/custom_app_bar_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';
import 'package:restaurant_finder/controller/theme_controller.dart';

class FavoriteCollectionList extends StatelessWidget {
  final SavedRestaurantsController controller = Get.find<SavedRestaurantsController>();

  FavoriteCollectionList({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    return Obx(() {
      final isDark = themeController.isDarkMode;
      return Scaffold(
        backgroundColor: isDark ? kBlackColor : Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.dialog(EnterCollectionNameDialog(controller: controller));
          },
          backgroundColor: kSecondaryColor,
          child: Icon(
            Icons.add,
            color: kPrimaryColor,
          ),
        ),
        appBar: simpleAppBar(
          title: 'favoriteList'.tr,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: kSecondaryColor)
            );
          }
          
          if (!controller.globalController.isAuthenticated.value) {
            return Center(
              child: MyText(
                text: 'pleaseLoginToViewCollections'.tr,
                size: 16,
                weight: FontWeight.w600,
                color: isDark ? kTertiaryColor : null,
                textAlign: TextAlign.center,
              ),
            );
          }
          
          if (controller.collections.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: isDark ? kTertiaryColor.withOpacity(0.5) : kGreyColor,
                  ),
                  SizedBox(height: 16),
                  MyText(
                    text: 'noCollectionsYet'.tr,
                    size: 18,
                    weight: FontWeight.w600,
                    color: isDark ? kTertiaryColor : null,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  MyText(
                    text: 'createYourFirstCollection'.tr,
                    size: 14,
                    color: isDark ? kDarkTextColor : kGreyColor,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            shrinkWrap: true,
            padding: AppSizes.DEFAULT,
            physics: BouncingScrollPhysics(),
            itemCount: controller.collections.length,
            itemBuilder: (context, index) {
              final collection = controller.collections[index];
              return GestureDetector(
                onTap: () {
                  Get.to(() => SelectedCollectionList(
                    collectionId: collection.id,
                    collectionName: collection.name,
                  ));
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      width: 1.0,
                      color: kBorderColor,
                    ),
                    color: isDark ? kDialogBlack : Colors.white,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          color: kSecondaryColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: MyText(
                          text: collection.name,
                          size: 16,
                          weight: FontWeight.w600,
                          color: isDark ? kTertiaryColor : null,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: isDark ? kDarkTextColor : kGreyColor,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      );
    });
  }
}

class EnterCollectionNameDialog extends StatelessWidget {
  final SavedRestaurantsController controller;
  final TextEditingController nameController = TextEditingController();

  EnterCollectionNameDialog({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode;
    
    return Dialog(
      backgroundColor: isDark ? kDialogBlack : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MyText(
              text: 'createNewCollection'.tr,
              size: 18,
              weight: FontWeight.w600,
              textAlign: TextAlign.center,
              paddingBottom: 16,
              color: isDark ? kTertiaryColor : null,
            ),
            TextField(
              controller: nameController,
              style: TextStyle(
                color: isDark ? kTertiaryColor : kBlackColor,
              ),
              decoration: InputDecoration(
                hintText: 'enterCollectionName'.tr,
                hintStyle: TextStyle(
                  color: isDark ? kDarkTextColor : kGreyColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: kBorderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: kBorderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: kSecondaryColor),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: MyText(
                      text: 'cancel'.tr,
                      color: isDark ? kDarkTextColor : kGreyColor,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (nameController.text.trim().isNotEmpty) {
                        controller.createCollection(nameController.text.trim());
                        Get.back();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kSecondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: MyText(
                      text: 'create'.tr,
                      color: kPrimaryColor,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}