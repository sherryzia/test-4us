import 'package:betting_app/view/screens/auth/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../generated/assets.dart';
import 'common_image_view_widget.dart';
import 'my_button.dart';
import 'my_text_widget.dart';


class SwiperPaymentPlan extends StatelessWidget {
  final List<Map<String, dynamic>> plans = [
    {
      "title": "Purchase Plan",
      "description": "In-app purchase plan to\n accommodate data",
      "price": "\$05.00",
      "features": ["Ads free", "Data history backup", "Secure payment"],
      "backgroundColor": kBlackColor,
    },
    {
      "title": "Premium Plan",
      "description": "Unlock premium features",
      "price": "\$10.00",
      "features": ["No ads", "Unlimited storage", "Priority support"],
      "backgroundColor": kBlackColor,
    },
    {
      "title": "Family Plan",
      "description": "Share with your family",
      "price": "\$15.00",
      "features": ["Multi-user access", "Parental controls", "Secure backup"],
      "backgroundColor": kBlackColor,
    },
    {
      "title": "Enterprise Plan",
      "description": "For business needs",
      "price": "\$20.00",
      "features": ["Custom solutions", "Dedicated support", "Advanced analytics"],
      "backgroundColor": kBlackColor,
    },
    {
      "title": "Ultimate Plan",
      "description": "All-in-one solution",
      "price": "\$30.00",
      "features": ["Full access", "VIP support", "Unlimited everything"],
      "backgroundColor": kBlackColor,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Swiper(
      itemHeight: 400,
      itemWidth: 280,
      duration: 500,
      loop: true,
      layout: SwiperLayout.STACK,
      scrollDirection: Axis.horizontal,
      axisDirection: AxisDirection.right,
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: plan["backgroundColor"],
          ),
          alignment: Alignment.center,
          child: Padding(
            padding: AppSizes.DEFAULT,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 30),
                MyText(
                  text: plan["title"],
                  size: 17,
                  weight: FontWeight.w500,
                  color: kPrimaryColor,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: plan["description"],
                      size: 12,
                      weight: FontWeight.w400,
                      color: kPrimaryColor,
                      textAlign: TextAlign.start,
                    ),
                    MyText(
                      text: plan["price"],
                      size: 17,
                      weight: FontWeight.w500,
                      color: kQuaternaryColor,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                MyText(
                  text: "Features:",
                  size: 14,
                  weight: FontWeight.w500,
                  color: kTertiaryColor,
                ),
                ...plan["features"].map<Widget>((feature) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    children: [
                      CommonImageView(svgPath: Assets.svgTick),
                      const SizedBox(width: 10),
                      MyText(
                        text: feature,
                        size: 17,
                        weight: FontWeight.w400,
                        color: kPrimaryColor,
                      ),
                    ],
                  ),
                )),
                const SizedBox(height: 50),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 160,
                    child: MyButton(
                      onTap: () {
                        Get.to(() => const SignupScreen());
                      },
                      buttonText: "Purchase",
                      backgroundColor: kQuaternaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
