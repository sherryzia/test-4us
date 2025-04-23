// lib/view/screens/saved_restaurants/selected_collection_list.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_sizes.dart';
import 'package:restaurant_finder/controller/collection_controller.dart';
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

  @override
  Widget build(BuildContext context) {
    final CollectionController controller = Get.put(
      CollectionController(collectionId),
      tag: collectionId,
    );
    
    return Scaffold(
      appBar: simpleAppBar(
        title: collectionName,
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
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
              text: 'No restaurants in this collection',
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
  }
  
  void _showDeleteConfirmationDialog(BuildContext context, CollectionController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Collection'),
          content: Text('Are you sure you want to delete this collection?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete', style: TextStyle(color: Colors.red)),
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