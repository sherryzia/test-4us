// lib/view/widget/restaurant_card_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_images.dart';
import 'package:restaurant_finder/model/explore_model.dart';
import 'package:restaurant_finder/view/screens/home/restaurant_details.dart';
import 'package:restaurant_finder/view/widget/common_image_view_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantModel restaurant;
  final Function()? onFavoriteToggle;
  final bool? isSaved;

  const RestaurantCard({
    Key? key,
    required this.restaurant,
    this.onFavoriteToggle,
    this.isSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use isFavorite from the model if isSaved is not provided
    final isFavorite = isSaved ?? restaurant.isFavorite;
    
    return GestureDetector(
      onTap: () => Get.to(() => RestaurantDetails(restaurantId: restaurant.id)),
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: kPrimaryColor,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 12,
              color: kBlackColor.withOpacity(0.1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  child: CommonImageView(
                    height: 150,
                    radius: 0.0,
                    width: Get.width,
                    url: restaurant.image.isNotEmpty
                        ? restaurant.image
                        : 'https://via.placeholder.com/400x150',
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: GestureDetector(
                    onTap: onFavoriteToggle,
                    child: Image.asset(
                      isFavorite ? Assets.imagesSaved : Assets.imagesSave,
                      height: 24,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: MyText(
                          text: restaurant.name,
                          size: 16,
                          weight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        Icons.star,
                        color: Color(0xffF5BD4F),
                        size: 17,
                      ),
                      MyText(
                        paddingLeft: 4,
                        text: '${restaurant.rating} Ratings',
                        size: 12,
                        weight: FontWeight.w500,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        Assets.imagesLocationPin,
                        height: 14,
                        color: kGreyColor,
                      ),
                      MyText(
                        paddingLeft: 6,
                        text: restaurant.location,
                        size: 12,
                        weight: FontWeight.w500,
                        color: kGreyColor,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Image.asset(
                        Assets.imagesTime,
                        height: 14,
                        color: kGreyColor,
                      ),
                      MyText(
                        paddingLeft: 6,
                        text: 'Opens at 11:00am',
                        size: 12,
                        weight: FontWeight.w500,
                        color: kGreyColor,
                      ),
                    ],
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