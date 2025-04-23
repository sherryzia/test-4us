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

class FavoriteCollectionList extends StatelessWidget {
  final SavedRestaurantsController controller = Get.find<SavedRestaurantsController>();

  FavoriteCollectionList({super.key});

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
        title: 'Favorite List',
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: kSecondaryColor));
        }
        
        if (!controller.globalController.isAuthenticated.value) {
          return Center(
            child: MyText(
              text: 'Please login to view collections',
              size: 16,
              weight: FontWeight.w600,
            ),
          );
        }
        
        if (controller.collections.isEmpty) {
          return Center(
            child: MyText(
              text: 'No collections yet',
              size: 16,
              weight: FontWeight.w600,
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
                ),
                child: MyText(
                  text: collection.name,
                  size: 16,
                  weight: FontWeight.w600,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}