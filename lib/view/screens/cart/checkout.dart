import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/constants/app_styling.dart';
import 'package:candid/main.dart';
import 'package:candid/view/widget/common_image_view_widget.dart';
import 'package:candid/view/widget/custom_check_box_widget.dart';
import 'package:candid/view/widget/custom_scaffold_widget.dart';
import 'package:candid/view/widget/my_button_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:candid/view/widget/simple_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Checkout extends StatelessWidget {
  const Checkout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScaffold(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SimpleAppBar(
              title: 'Checkout',
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
                  MyText(
                    paddingTop: 16,
                    paddingBottom: 10,
                    text: 'Payment Method',
                    size: 16,
                    weight: FontWeight.w600,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: BouncingScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      final List<Map<String, dynamic>> _items = [
                        {
                          'icon': Assets.imagesVisa,
                          'title': 'Visa xxx 3301',
                        },
                        {
                          'icon': Assets.imagesMaster,
                          'title': 'Credit Card/Debit Card',
                        },
                        {
                          'icon': Assets.imagesApplePay,
                          'title': 'Apple Pay',
                        },
                      ];
                      return Container(
                        height: 48,
                        padding: EdgeInsets.all(8),
                        decoration: AppStyling.LIST_TILE_12,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            CustomCheckBox2(
                              isRadio: true,
                              isActive: index == 1,
                              onTap: () {},
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: Get.height,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color:
                                          Color(0xff1E1B4A).withOpacity(0.04),
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        _items[index]['icon'],
                                        height: 24,
                                        width: 24,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: MyText(
                                      paddingLeft: 14,
                                      text: _items[index]['title'],
                                      size: 14,
                                      weight: FontWeight.w500,
                                    ),
                                  ),
                                  Image.asset(
                                    Assets.imagesMoreVert,
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: AppSizes.DEFAULT,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: MyText(
                          text: 'Total',
                          size: 14,
                        ),
                      ),
                      MyText(
                        text: '\$50',
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
                          text: 'Tax + Delivery Charges',
                          size: 14,
                        ),
                      ),
                      MyText(
                        text: '\$50',
                        size: 14,
                      ),
                    ],
                  ),
                  Container(
                    height: 1,
                    color: kBorderColor,
                    margin: EdgeInsets.symmetric(vertical: 16),
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
                        text: '\$50',
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
                      Get.dialog(_SuccessDialog());
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

class _SuccessDialog extends StatelessWidget {
  const _SuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          margin: AppSizes.DEFAULT,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  Assets.imagesCongratsCheck,
                  height: 150,
                ),
                MyText(
                  paddingTop: 24,
                  text: 'Subscription done',
                  size: 24,
                  weight: FontWeight.bold,
                  textAlign: TextAlign.center,
                  paddingBottom: 8,
                ),
                MyText(
                  text: 'You have successfully subscribed',
                  size: 14,
                  color: kGreyColor,
                  weight: FontWeight.w500,
                  lineHeight: 1.5,
                  paddingLeft: 10,
                  paddingRight: 10,
                  textAlign: TextAlign.center,
                  paddingBottom: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
