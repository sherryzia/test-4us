// lib/view/screens/saved_restaurants/saved_restaurants.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_sizes.dart';
import 'package:restaurant_finder/controller/saved_restaurants_controller.dart';
import 'package:restaurant_finder/view/screens/saved_restaurants/favorite_collection_list.dart';
import 'package:restaurant_finder/view/screens/home/restaurant_details.dart';
import 'package:restaurant_finder/view/widget/custom_app_bar_widget.dart';
import 'package:restaurant_finder/view/widget/my_button_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_field_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';
import 'package:restaurant_finder/view/widget/restaurant_card_widget.dart';
import 'package:restaurant_finder/controller/theme_controller.dart';

class SavedRestaurants extends StatelessWidget {
  final SavedRestaurantsController controller = Get.put(SavedRestaurantsController());

  SavedRestaurants({super.key});

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode;
      
      return Scaffold(
        backgroundColor: isDark ? kBlackColor : Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.dialog(EnterCollectionNameDialog(controller: controller));
          },
          backgroundColor: kSecondaryColor,
          child: Icon(Icons.add, color: kPrimaryColor),
        ),
        appBar: simpleAppBar(
          haveLeading: false,
          title: 'saved'.tr,
          actions: [
            Center(
              child: MyText(
                onTap: () {
                  Get.to(() => FavoriteCollectionList());
                },
                paddingRight: 20,
                text: 'favoriteList'.tr,
                size: 14,
                textAlign: TextAlign.center,
                weight: FontWeight.w600,
                color: kSecondaryColor,
              ),
            ),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator(color: kSecondaryColor));
          }
          
          if (!controller.globalController.isAuthenticated.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyText(
                    text: 'Please login to view saved restaurants',
                    size: 16,
                    weight: FontWeight.w600,
                  ),
                  SizedBox(height: 20),
                  MyButton(
                    buttonText: 'Login',
                    onTap: () {
                      // Navigate to login screen
                    },
                  ),
                ],
              ),
            );
          }
          
          if (controller.savedRestaurants.isEmpty) {
            return Center(
              child: MyText(
                text: 'No saved restaurants yet',
                size: 16,
                weight: FontWeight.w600,
              ),
            );
          }
          
          return ListView.builder(
            shrinkWrap: true,
            padding: AppSizes.DEFAULT,
            physics: BouncingScrollPhysics(),
            itemCount: controller.savedRestaurants.length,
            itemBuilder: (context, index) {
              final restaurant = controller.savedRestaurants[index];
              return GestureDetector(
                onTap: () => Get.to(() => RestaurantDetails(restaurantId: restaurant.id)),
                child: RestaurantCard(
                  restaurant: restaurant,
                  isSaved: true,
                  onFavoriteToggle: () => controller.removeFromFavorites(restaurant.id),
                ),
              );
            },
          );
        }),
      );
    });
  }
}

// Modified version of EnterCollectionNameDialog in saved_restaurants.dart
class EnterCollectionNameDialog extends StatelessWidget {
  final SavedRestaurantsController controller;
  final Function(CollectionModel collection)? onCollectionCreated;
  
  const EnterCollectionNameDialog({
    required this.controller, 
    this.onCollectionCreated,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode;
    final Color dialogBg = isDark ? kDialogBlack : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          color: dialogBg,
          margin: AppSizes.DEFAULT,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyTextField(
                  controller: controller.collectionNameTextController.value,
                  labelText: 'enterName'.tr,
                  hintText: '',
                ),
                SizedBox(height: 16),
                MyButton(
                  buttonText: 'save'.tr,
                  onTap: () async {
                    final name = controller.collectionNameTextController.value.text;
                    if (name.isEmpty) {
                      Get.snackbar('Error', 'Please enter a collection name');
                      return;
                    }
                    
                    try {
                      // Insert new collection
                      final response = await controller.supabase
                          .from('collections')
                          .insert({
                            'name': name.trim(),
                            'user_id': controller.globalController.userId.value,
                          })
                          .select()
                          .single();
                      
                      // Create collection model
                      final newCollection = CollectionModel.fromJson(response);
                      
                      // Add to local collections list
                      controller.collections.add(newCollection);
                      
                      // Call callback if provided
                      if (onCollectionCreated != null) {
                        onCollectionCreated!(newCollection);
                      }
                      
                      // Clear text field and close dialog
                      controller.collectionNameTextController.value.clear();
                      Get.back();
                      Get.snackbar('Success', 'Collection created');
                    } catch (e) {
                      print("Error creating collection: $e");
                      Get.snackbar('Error', 'Failed to create collection');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}