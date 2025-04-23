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

class SavedRestaurants extends StatelessWidget {
  final SavedRestaurantsController controller = Get.put(SavedRestaurantsController());

  SavedRestaurants({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        haveLeading: false,
        title: 'Saved',
        actions: [
          Center(
            child: MyText(
              onTap: () {
                Get.to(() => FavoriteCollectionList());
              },
              paddingRight: 20,
              text: 'Favorite List',
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
                  // width: 150,
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
            return  GestureDetector(
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
  }
}

class EnterCollectionNameDialog extends StatelessWidget {
  final SavedRestaurantsController controller;
  
  const EnterCollectionNameDialog({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
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
                  labelText: 'Enter collection name...',
                  hintText: '',
                ),
                SizedBox(height: 16),
                MyButton(
                  buttonText: 'Save',
                  onTap: () {
                    controller.createCollection(
                      controller.collectionNameTextController.value.text
                    );
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