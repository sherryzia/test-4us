import 'package:betting_app/constants/app_sizes.dart';
import 'package:betting_app/view/widgets/common_image_view_widget.dart';
import 'package:betting_app/view/widgets/my_button.dart';
import 'package:betting_app/view/widgets/my_text_widget.dart';
import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../generated/assets.dart';
import '../../widgets/simple_app_bar.dart';
import '../../widgets/swipper_payment_plan.dart';


class PlanScreen extends StatelessWidget {
  const PlanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: SimpleAppBar(
        showLeading: false,
        title: "Plan",

      ),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: Column(
          children: [
            MyText(
                text: "Get more control over your data by purchasing our plan for you",
              size: 17,
              weight: FontWeight.w500,
              color: kBlackColor,
            ),
            const SizedBox(height: 40,),
            SwiperPaymentPlan(),
          ],
        ),
      ),
    );
  }
}
