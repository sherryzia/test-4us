import 'package:affirmation_app/constants/app_images.dart';
import 'package:affirmation_app/constants/app_sizes.dart';
import 'package:affirmation_app/constants/app_styling.dart';
import 'package:affirmation_app/view/screens/auth/sign_up/complete_profile.dart';
import 'package:affirmation_app/view/widget/my_button_widget.dart';
import 'package:affirmation_app/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddWidgetToHomeScreen extends StatelessWidget {
  const AddWidgetToHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
      },
      child: Scaffold(
        extendBody: true,
        body: CustomBackground(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: AppSize.DEFAULT,
                physics: BouncingScrollPhysics(),
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Image.asset(
                    Assets.imagesHomeScreenWidget,
                    height: 196,
                  ),
                  MyText(
                    text: 'Add a Widget to your Home screen',
                    size: 25,
                    weight: FontWeight.w600,
                    paddingTop: 19,
                    textAlign: TextAlign.center,
                    paddingBottom: 27,
                  ),
                  Container(
                    padding: EdgeInsets.all(18),
                    decoration: AppStyling.cardDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(
                        2,
                        (index) {
                          final List<String> data = [
                            'From the Home screen Touch & Hold the Empty Area until the Apps jiggle.',
                            'Then Tap the + Button in the Upper Corner tp add Widget.',
                          ];
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: index == 1 ? 0 : 23,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Image.asset(
                                    Assets.imagesDot,
                                    height: 10,
                                  ),
                                ),
                                Expanded(
                                  child: MyText(
                                    text: data[index],
                                    size: 15,
                                    paddingLeft: 12,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: AppSize.DEFAULT,
              child: MyButton(
                buttonText: 'Got it!',
                onTap: () => Get.back(),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
