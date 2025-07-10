import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/constants/app_styling.dart';
import 'package:candid/view/widget/custom_scaffold_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:candid/view/widget/simple_app_bar_widget.dart';
import 'package:flutter/material.dart';


class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SimpleAppBar(
            title: 'Help',
          ),
          MyText(
            paddingLeft: 16,
            paddingRight: 16,
            lineHeight: 1.5,
            paddingBottom: 8,
            text: 'Contact our support team to get solved your problems.',
            size: 14,
          
            color: kBlackColor2,
          ),
          Expanded(
            child: Padding(
              padding: AppSizes.DEFAULT,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: AppStyling.LIST_TILE_16,
                    padding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: MyText(
                            text: 'Chat online',
                            size: 14,
                          ),
                        ),
                        Image.asset(
                          Assets.imagesHelp,
                          height: 24,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    decoration: AppStyling.LIST_TILE_16,
                    padding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: MyText(
                            text: 'What’s app',
                            size: 14,
                          ),
                        ),
                        MyText(
                          text: '+00 535 363 ',
                          size: 14,
                          color: kDarkGreyColor4,
                        ),
                      ],
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
