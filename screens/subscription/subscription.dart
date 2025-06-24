import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_sizes.dart';
import 'package:restaurant_finder/view/screens/subscription/payment_methods.dart';
import 'package:restaurant_finder/view/widget/custom_app_bar_widget.dart';
import 'package:restaurant_finder/view/widget/my_button_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';
import 'package:restaurant_finder/controller/theme_controller.dart';

class Subscription extends StatelessWidget {
  const Subscription({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    return Obx(() {
      final isDark = themeController.isDarkMode;
      return Scaffold(
        backgroundColor: isDark ? kBlackColor : Colors.white,
        appBar: simpleAppBar(title: 'subscription'.tr),
        body: Container(
          height: Get.height,
          width: Get.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  padding: AppSizes.DEFAULT,
                  physics: BouncingScrollPhysics(),
                  children: [
                    MyText(
                      paddingBottom: 16,
                      text: 'searchRestaurantsOutside'.tr,
                      size: 36,
                      lineHeight: 1.3,
                      weight: FontWeight.w600,
                      textAlign: TextAlign.center,
                      color: kSecondaryColor,
                    ),
                    MyText(
                      paddingBottom: 30,
                      text: 'selectOneMonthSubscription'.tr,
                      size: 16,
                      lineHeight: 1.5,
                      textAlign: TextAlign.center,
                      color: isDark ? kDarkTextColor : kSecondaryColor,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.scale(
                          scale: 0.8,
                          alignment: Alignment.center,
                          child: CupertinoSwitch(
                            value: true,
                            activeColor: kSecondaryColor,
                            onChanged: (v) {},
                          ),
                        ),
                        MyText(
                          text: 'annualPricingSave'.tr,
                          size: 16,
                          weight: FontWeight.w500,
                          color: kSecondaryColor,
                          paddingRight: 10,
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark ? kDialogBlack : kPrimaryColor,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            color: kBlackColor.withOpacity(0.16),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          MyText(
                            paddingTop: 16,
                            paddingBottom: 8,
                            text: 'monthlyPlus'.tr,
                            size: 20,
                            weight: FontWeight.w600,
                            textAlign: TextAlign.center,
                            color: kSecondaryColor,
                          ),
                          MyText(
                            paddingBottom: 10,
                            text: '\$30.00',
                            size: 36,
                            weight: FontWeight.w600,
                            textAlign: TextAlign.center,
                            color: isDark ? kTertiaryColor : kBlackColor,
                          ),
                          MyText(
                            paddingBottom: 8,
                            text: 'payMonthlyCancelAnyTime'.tr,
                            size: 15,
                            color: isDark ? kDarkTextColor : kGreyColor,
                            textAlign: TextAlign.center,
                          ),
                          MyText(
                            text: 'nextRenewal'.tr,
                            size: 15,
                            lineHeight: 1.5,
                            color: isDark ? kDarkTextColor : kGreyColor,
                            textAlign: TextAlign.center,
                            paddingBottom: 26,
                          ),
                          ...List.generate(3, (index) {
                            final List<String> _items = [
                              'unlimitedAccess'.tr,
                              'payMonthlyCancelAnyTime'.tr,
                              'fiveDaysFreeTrial'.tr,
                            ];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check,
                                    color: kSecondaryColor,
                                    size: 20,
                                  ),
                                  Expanded(
                                    child: MyText(
                                      paddingLeft: 12,
                                      text: _items[index],
                                      color:
                                          isDark ? kDarkTextColor : kGreyColor,
                                      lineHeight: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: AppSizes.DEFAULT,
                child: MyButton(
                  buttonText: 'continue'.tr,
                  onTap: () {
                    Get.to(() => PaymentMethods());
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
