// lib/view/screens/terms_conditions/terms_conditions_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_sizes.dart';
import 'package:restaurant_finder/controller/terms_conditions_controller.dart';
import 'package:restaurant_finder/view/widget/custom_app_bar_widget.dart';
import 'package:restaurant_finder/view/widget/my_button_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';

class TermsConditionsScreen extends StatelessWidget {
  final bool showAcceptButtons;
  final TermsConditionsController controller =
      Get.put(TermsConditionsController());

  TermsConditionsScreen({
    Key? key,
    this.showAcceptButtons = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Terms & Conditions',
        haveLeading: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: kSecondaryColor),
          );
        }

        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 60, color: Colors.red),
                SizedBox(height: 16),
                MyText(
                  text: controller.errorMessage.value,
                  size: 16,
                  weight: FontWeight.w500,
                  color: Colors.red,
                  textAlign: TextAlign.center,
                  paddingLeft: 20,
                  paddingRight: 20,
                ),
                SizedBox(height: 24),
                MyButton(
                  buttonText: 'Try Again',
                  //  width: 150,
                  onTap: () => controller.fetchTermsAndConditions(),
                ),
              ],
            ),
          );
        }

        if (controller.termsConditions.value == null) {
          return Center(
            child: MyText(
              text: 'No terms and conditions available.',
              size: 16,
              weight: FontWeight.w500,
            ),
          );
        }

        return Column(
          children: [
            // HTML content area
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: AppSizes.DEFAULT,
                child: Column(
                  children: [
                    Html(
                      data: controller.termsConditions.value!.content,
                      style: {
                        'body': Style(
                          fontSize: FontSize(15.0),
                          fontFamily: 'Poppins',
                          lineHeight: LineHeight(1.5),
                        ),
                        'h1': Style(
                          fontSize: FontSize(22.0),
                          fontWeight: FontWeight.bold,
                          margin: Margins(top: Margin(16), bottom: Margin(8)),
                        ),
                        'h2': Style(
                          fontSize: FontSize(18.0),
                          fontWeight: FontWeight.w600,
                          margin: Margins(top: Margin(16), bottom: Margin(8)),
                        ),
                        'p': Style(
                          margin: Margins(bottom: Margin(12)),
                        ),
                        'li': Style(
                          margin: Margins(bottom: Margin(8)),
                        ),
                      },
                    ),
                     SizedBox(
              height: 8,
            ),                    Center(
              child: MyText(
                text: 'Version ${controller.termsConditions.value!.version}',
                size: 16,
                weight: FontWeight.w500,
                color: kGreyColor,
              ),
            ),

            SizedBox(
              height: 16,
            )
                  ],
                ),

                
              ),
            ),
            
          ],
        );
      }),
    );
  }
}
