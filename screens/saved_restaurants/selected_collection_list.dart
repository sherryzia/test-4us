// lib/view/screens/saved_restaurants/selected_collection_list.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_sizes.dart';
import 'package:restaurant_finder/controller/collection_controller.dart';
import 'package:restaurant_finder/controller/theme_controller.dart';
import 'package:restaurant_finder/view/screens/home/restaurant_details.dart';
import 'package:restaurant_finder/view/widget/custom_app_bar_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';
import 'package:restaurant_finder/view/widget/restaurant_card_widget.dart';

class SelectedCollectionList extends StatelessWidget {
  final String collectionId;
  final String collectionName;
  
  SelectedCollectionList({
    Key? key,
    required this.collectionId,
    required this.collectionName,
  }) : super(key: key);

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    final CollectionController controller = Get.put(
      CollectionController(collectionId),
      tag: collectionId,
    );
    
    return Obx(() {
      final isDark = themeController.isDarkMode;
      
      return Scaffold(
        backgroundColor: isDark ? kBlackColor : Colors.white,
        appBar: simpleAppBar(
          title: collectionName,
          actions: [
            IconButton(
              icon: Icon(
                Icons.delete, 
                color: Colors.red,
              ),
              onPressed: () {
                _showDeleteConfirmationDialog(context, controller);
              },
            ),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator(color: kSecondaryColor));
          }
          
          if (controller.restaurants.isEmpty) {
            return Center(
              child: MyText(
                text: 'noRestaurantsInCollection'.tr,
                size: 16,
                weight: FontWeight.w600,
              ),
            );
          }
          
          return ListView.builder(
            shrinkWrap: true,
            padding: AppSizes.DEFAULT,
            physics: BouncingScrollPhysics(),
            itemCount: controller.restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = controller.restaurants[index];
              return GestureDetector(
                onTap: () => Get.to(() => RestaurantDetails(restaurantId: restaurant.id)),
                child: RestaurantCard(
                  restaurant: restaurant,
                  isSaved: true,
                  onFavoriteToggle: () => controller.removeFromCollection(restaurant.id),
                ),
              );
            },
          );
        }),
      );
    });
  }
  
  void _showDeleteConfirmationDialog(BuildContext context, CollectionController controller) {
    final ThemeController themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? kDialogBlack : Colors.white,
          title: Text(
            'deleteCollection'.tr,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          content: Text(
            'deleteCollectionConfirmation'.tr,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'cancel'.tr,
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'delete'.tr,
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                controller.deleteCollection();
              },
            ),
          ],
        );
      },
    );
  }
}