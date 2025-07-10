import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/constants/app_styling.dart';
import 'package:candid/main.dart';
import 'package:candid/view/screens/cart/checkout.dart';
import 'package:candid/view/widget/common_image_view_widget.dart';
import 'package:candid/view/widget/custom_scaffold_widget.dart';
import 'package:candid/view/widget/my_button_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:candid/view/widget/simple_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScaffold(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SimpleAppBar(
              title: 'Cart',
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: AppSizes.DEFAULT,
                physics: BouncingScrollPhysics(),
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: AppStyling.LIST_TILE_16,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              MyText(
                                text: 'Candid Elite',
                                size: 16,
                                weight: FontWeight.w600,
                              ),
                              MyText(
                                paddingTop: 6,
                                text:
                                    'Lorem ipsum dolor sit amet consectetur. Faucibus id quisque dolor massa ornare risus.',
                                size: 12,
                                color: kHintColor,
                                lineHeight: 1.5,
                              ),
                              MyText(
                                paddingTop: 16,
                                text: '\$50.00',
                                size: 16,
                                weight: FontWeight.w700,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Image.asset(
                          Assets.imagesTrash,
                          color: Colors.red,
                          height: 24,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: AppSizes.DEFAULT,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: TextFormField(
                      style: TextStyle(
                        fontSize: 14,
                        color: kTertiaryColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter sponsoring amount',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: kHintColor,
                        ),
                        fillColor: kPrimaryColor,
                        filled: true,
                        border: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: MyText(
                          text: 'Subscription Total',
                          size: 14,
                        ),
                      ),
                      MyText(
                        text: '\$200',
                        size: 14,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: MyText(
                          text: 'Total Amount',
                          size: 16,
                          weight: FontWeight.bold,
                        ),
                      ),
                      MyText(
                        text: '\$200',
                        size: 16,
                        weight: FontWeight.bold,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  MyButton(
                    buttonText: 'Continue',
                    onTap: () {
                      Get.to(() => Checkout());
                    },
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
