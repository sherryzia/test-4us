import 'package:betting_app/constants/app_sizes.dart';
import 'package:betting_app/view/widgets/common_image_view_widget.dart';
import 'package:betting_app/view/widgets/my_text_widget.dart';
import 'package:betting_app/view/widgets/simple_app_bar.dart';
import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../generated/assets.dart';



class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: "Favourite",
      ),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 10,
          itemBuilder: (context, index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(

                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          text: "UEFA Champions League 2024/25 - League Stage - Winner",
                          size: 14,
                          weight: FontWeight.w400,
                          color: kBlackColor,
                        ),
                        const SizedBox(height: 6,),
                        MyText(
                          text: "Championship Outright",
                          size: 14,
                          weight: FontWeight.w400,
                          color: kTertiaryColor,
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyText(
                              text: "Bayern Munich",
                              size: 14,
                              weight: FontWeight.w500,
                              color: kSecondaryColor,
                            ),
                            MyText(
                              text: "500.00",
                              size: 14,
                              weight: FontWeight.w500,
                              color: kQuaternaryColor,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 20,),
                  CommonImageView(svgPath: Assets.svgHeartRed,),
                ],
              ),
              const SizedBox(height: 15,),
              const Divider(color: kTertiaryColor,),
              const SizedBox(height: 15,),
            ],
          );
        },),
      ),
    );
  }
}
