import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_images.dart';
import 'package:restaurant_finder/constants/app_sizes.dart';
import 'package:restaurant_finder/view/screens/subscription/add_new_card.dart';
import 'package:restaurant_finder/view/widget/custom_app_bar_widget.dart';
import 'package:restaurant_finder/view/widget/my_button_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';
import 'package:restaurant_finder/controller/theme_controller.dart';

class PaymentMethods extends StatelessWidget {
  const PaymentMethods({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    return Obx(() {
      final isDark = themeController.isDarkMode;
      return Scaffold(
        backgroundColor: isDark ? kBlackColor : Colors.white,
        appBar: simpleAppBar(title: 'paymentMethods'.tr),
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
                    {'icon': Assets.imagesPaypal, 'title': 'paypal'.tr},
                    {'icon': Assets.imagesMaster, 'title': 'masterCard'.tr},
                    {'icon': Assets.imagesGooglePay, 'title': 'googlePay'.tr},
                    {'icon': Assets.imagesApplePay, 'title': 'applePay'.tr},
                  ];
                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 1.0, color: kBorderColor),
                      color: isDark ? kDialogBlack : Colors.white,
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
                            color: isDark ? kDarkTextColor : null,
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: MyButton(
                            height: 36,
                            textColor:
                                index.isEven
                                    ? kPrimaryColor
                                    : (isDark
                                        ? kDarkTextColor
                                        : kQuaternaryColor),
                            bgColor:
                                index.isEven
                                    ? kSecondaryColor
                                    : (isDark ? kDialogBlack : kLightGreyColor),
                            buttonText:
                                index.isEven ? 'connected'.tr : 'connect'.tr,
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
                    text: 'addNewCard'.tr,
                    size: 14,
                    weight: FontWeight.w600,
                    color: kSecondaryColor,
                    paddingBottom: 20,
                    textAlign: TextAlign.center,
                  ),
                  MyButton(
                    buttonText: 'payNow'.tr,
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
    });
  }
}

class _SuccessDialog extends StatelessWidget {
  const _SuccessDialog();

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode;
    final Color dialogBg = isDark ? kDialogBlack : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          color: dialogBg,
          margin: AppSizes.DEFAULT,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(Assets.imagesCongratsCheck, height: 118),
                MyText(
                  paddingTop: 24,
                  text: 'paymentSuccessful'.tr,
                  size: 20,
                  color: kSecondaryColor,
                  weight: FontWeight.bold,
                  textAlign: TextAlign.center,
                  paddingBottom: 14,
                ),
                MyText(
                  text: 'subscribedToMonthlyPlus'.tr,
                  size: 14,
                  color: isDark ? kDarkTextColor : kQuaternaryColor,
                  lineHeight: 1.5,
                  paddingLeft: 10,
                  paddingRight: 10,
                  textAlign: TextAlign.center,
                  paddingBottom: 20,
                ),
                MyButton(
                  buttonText: 'goToMainPage'.tr,
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
