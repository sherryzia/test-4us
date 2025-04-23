import 'package:flutter/material.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_images.dart';
import 'package:restaurant_finder/constants/app_sizes.dart';
import 'package:restaurant_finder/main.dart';
import 'package:restaurant_finder/view/widget/common_image_view_widget.dart';
import 'package:restaurant_finder/view/widget/custom_app_bar_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Favorites',
      ),
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
              border: Border.all(
                width: 1.0,
                color: kBorderColor,
              ),
            ),
            child: Row(
              children: [
                CommonImageView(
                  height: 75,
                  width: 80,
                  radius: 10,
                  url: dummyImg,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MyText(
                        text: 'Big & Burger Boss',
                        size: 16,
                        weight: FontWeight.w600,
                      ),
                      SizedBox(
                        height: 12,
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
                            text: '0.3 mi',
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
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Color(0xffF5BD4F),
                            size: 17,
                          ),
                          MyText(
                            paddingLeft: 4,
                            text: '4.9 Ratings ',
                            size: 12,
                            weight: FontWeight.w500,
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
  }
}
