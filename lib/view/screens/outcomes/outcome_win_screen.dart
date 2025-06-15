import 'package:betting_app/constants/app_sizes.dart';
import 'package:betting_app/view/widgets/my_text_widget.dart';
import 'package:betting_app/view/widgets/simple_app_bar.dart';
import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';


class OutcomeWinScreen extends StatelessWidget {
  const OutcomeWinScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: "Details",
      ),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: ShapeDecoration(
                color: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 20,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: "Ticket Details",
                    size: 17,
                    weight: FontWeight.w500,
                    color: kBlackColor,
                  ),
                  const SizedBox(height: 10,),
                  MyText(
                      text: "UEFA Champions League 2024/25 - League Stage - Winner",
                    size: 14,
                    weight: FontWeight.w400,
                    color: kBlackColor,
                  ),
                  const SizedBox(height: 6,),
                  MyText(
                    text: "Championship Outright",
                    size: 14,
                    weight: FontWeight.w400,
                    color: kTertiaryColor,
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(
                          text: "Bayern Munich",
                          size: 14,
                          weight: FontWeight.w500,
                          color: kSecondaryColor,
                      ),
                      MyText(
                        text: "500.00",
                        size: 14,
                        weight: FontWeight.w500,
                        color: kQuaternaryColor,
                      ),
                    ],),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Divider(color: kTertiaryColor,),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(
                        text: "Total Quotation",
                        size: 14,
                        weight: FontWeight.w500,
                        color: kBlackColor,
                      ),
                      MyText(
                        text: "555.65",
                        size: 14,
                        weight: FontWeight.w500,
                        color: kBlackColor,
                      ),
                    ],),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(
                        text: "Stake",
                        size: 14,
                        weight: FontWeight.w500,
                        color: kBlackColor,),
                      MyText(
                          text: "CHF 5.00",
                        size: 14,
                        weight: FontWeight.w500,
                        color: kBlackColor,
                      ),
                    ],),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Divider(color: kTertiaryColor,),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(
                        text: "Possible Prize",
                        size: 14,
                        weight: FontWeight.w500,
                        color: kSecondaryColor,
                      ),
                      MyText(
                        text: "CHF 2500.00",
                        size: 14,
                        weight: FontWeight.w500,
                        color: kSecondaryColor,
                      ),
                    ],),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: ShapeDecoration(
                color: kGreenColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 20,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(
                    text: "Winner",
                    size: 17,
                    weight: FontWeight.w500,
                    color: kPrimaryColor,
                  ),
                  MyText(
                    text: "CHF 2000.00",
                    size: 17,
                    weight: FontWeight.w500,
                    color: kPrimaryColor,
                  ),
                ],),
            )

          ],
        ),
      ),
    );
  }
}
