import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/view/widget/custom_scaffold_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:candid/view/widget/simple_app_bar_widget.dart';
import 'package:flutter/material.dart';

class DeleteAccount extends StatelessWidget {
  const DeleteAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SimpleAppBar(
            title: 'Delete Account',
          ),
          MyText(
            paddingLeft: 16,
            paddingRight: 16,
            lineHeight: 1.5,
            paddingBottom: 8,
            text:
                'Lorem ipsum dolor sit amet consectetur. Mauris dictum risus proin interdum et auctor eleifend. In pulvinar varius amet amet. Pellentesque turpis pulvinar ut fringilla quam. ',
            size: 14,
            color: kDarkGreyColor4,
          ),
          Expanded(
            child: Padding(
              padding: AppSizes.DEFAULT,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MyText(
                    text: 'Delete Account',
                    textAlign: TextAlign.center,
                    paddingBottom: 24,
                  ),
                  Center(
                    child: Container(
                      height: 52,
                      width: 166,
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
                              text: 'Confirm',
                              size: 16,
                              weight: FontWeight.w500,
                              color: kSecondaryColor,
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
