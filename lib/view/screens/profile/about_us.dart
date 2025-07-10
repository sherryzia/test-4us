import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/constants/app_styling.dart';
import 'package:candid/view/widget/custom_scaffold_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:candid/view/widget/simple_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SimpleAppBar(
            title: 'About us',
            marginBottom: 0.0,
          ),
          Expanded(
            child: Padding(
              padding: AppSizes.DEFAULT,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: AppStyling.LIST_TILE_16,
                    child: MyText(
                      text:
                          'Lorem ipsum dolor sit amet consectetur. Mauris dictum risus proin interdum et auctor eleifend. In pulvinar varius amet amet. Pellentesque turpis pulvinar ut fringilla quam. Scelerisque nunc in tellus sem quam. Augue nec posuere felis bibendum duis sed.',
                      size: 12,
                      lineHeight: 1.6,
                      color: kDarkGreyColor4,
                    ),
                  ),
                  MyText(
                    paddingTop: 20,
                    text: 'To learn more visit our website:',
                    size: 14,
                    paddingBottom: 43,
                  ),
                  Center(
                    child: Container(
                      height: 52,
                      width: Get.width * 0.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: kSecondaryColor.withOpacity(0.05),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {},
                          splashColor: kSecondaryColor.withOpacity(0.02),
                          highlightColor: kSecondaryColor.withOpacity(0.02),
                          borderRadius: BorderRadius.circular(50),
                          child: Center(
                            child: MyText(
                              text: 'Visit Website',
                              size: 16,
                              weight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
