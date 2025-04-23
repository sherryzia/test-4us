import 'package:flutter/material.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_sizes.dart';
import 'package:restaurant_finder/main.dart';
import 'package:restaurant_finder/view/widget/common_image_view_widget.dart';
import 'package:restaurant_finder/view/widget/custom_app_bar_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';

class TopProfiles extends StatelessWidget {
  const TopProfiles({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Top profiles',
      ),
      body: ListView.builder(
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(10),
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
                  height: 40,
                  width: 40,
                  radius: 100.0,
                  url: dummyImg,
                ),
                Expanded(
                  child: MyText(
                    paddingLeft: 12,
                    text: 'Alexa Trait',
                    size: 16,
                    weight: FontWeight.w600,
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
