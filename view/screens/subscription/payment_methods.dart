import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_images.dart';
import 'package:restaurant_finder/constants/app_sizes.dart';
import 'package:restaurant_finder/view/screens/subscription/add_new_card.dart';
import 'package:restaurant_finder/view/widget/custom_app_bar_widget.dart';
import 'package:restaurant_finder/view/widget/my_button_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';

class PaymentMethods extends StatelessWidget {
  const PaymentMethods({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Payment Methods',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 4,
              padding: AppSizes.DEFAULT,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final List<Map<String, dynamic>> _items = [
                  {
                    'icon': Assets.imagesPaypal,
                    'title': 'PayPal',
                  },
                  {
                    'icon': Assets.imagesMaster,
                    'title': 'MasterCard',
                  },
                  {
                    'icon': Assets.imagesGooglePay,
                    'title': 'Google Pay',
                  },
                  {
                    'icon': Assets.imagesApplePay,
                    'title': 'Apple Pay',
                  },
                ];
                return Container(
                  margin: EdgeInsets.only(
                    bottom: 12,
                  ),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      width: 1.0,
                      color: kBorderColor,
                    ),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        _items[index]['icon'],
                        width: 28,
                        height: 28,
                      ),
                      Expanded(
                        child: MyText(
                          text: _items[index]['title'],
                          weight: FontWeight.w600,
                          paddingLeft: 16,
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: MyButton(
                          height: 36,
                          textColor:
                              index.isEven ? kPrimaryColor : kQuaternaryColor,
                          bgColor:
                              index.isEven ? kSecondaryColor : kLightGreyColor,
                          buttonText: index.isEven ? 'Connected' : 'Connect',
                          textSize: 12,
                          weight: FontWeight.w600,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyText(
                  onTap: () {
                    Get.to(() => AddNewCard());
                  },
                  text: 'Add new card',
                  size: 14,
                  weight: FontWeight.w600,
                  color: kSecondaryColor,
                  paddingBottom: 20,
                  textAlign: TextAlign.center,
                ),
                MyButton(
                  buttonText: 'Pay now',
                  onTap: () {
                    Get.dialog(_SuccessDialog());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessDialog extends StatelessWidget {
  const _SuccessDialog();

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
                  height: 118,
                ),
                MyText(
                  paddingTop: 24,
                  text: 'Payment Successful',
                  size: 20,
                  color: kSecondaryColor,
                  weight: FontWeight.bold,
                  textAlign: TextAlign.center,
                  paddingBottom: 14,
                ),
                MyText(
                  text: 'You\'ve been subscribed to\nMonthly Plus Plan.',
                  size: 14,
                  color: kQuaternaryColor,
                  lineHeight: 1.5,
                  paddingLeft: 10,
                  paddingRight: 10,
                  textAlign: TextAlign.center,
                  paddingBottom: 20,
                ),
                MyButton(
                  buttonText: 'Go to main page',
                  onTap: () {
                    Get.back();
                    Get.back();
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
