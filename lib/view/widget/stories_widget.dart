import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/main.dart';
import 'package:candid/view/widget/common_image_view_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

class Stories extends StatelessWidget {
  const Stories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return SizedBox(
            width: 16,
          );
        },
        shrinkWrap: true,
        padding: AppSizes.HORIZONTAL,
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Image.asset(
                    Assets.imagesStoryBorder,
                    height: 66,
                    width: 66,
                  ),
                  CommonImageView(
                    height: 58,
                    width: 58,
                    url: dummyImg,
                    radius: 100.0,
                  ),
                ],
              ),
              MyText(
                paddingTop: 6,
                text: 'Kaiya Rhiel',
                size: 12,
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
      ),
    );
  }
}
