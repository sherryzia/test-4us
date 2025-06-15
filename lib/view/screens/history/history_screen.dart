import 'package:betting_app/constants/app_sizes.dart';
import 'package:betting_app/view/screens/outcomes/outcome_win_screen.dart';
import 'package:betting_app/view/widgets/common_image_view_widget.dart';
import 'package:betting_app/view/widgets/my_button.dart';
import 'package:betting_app/view/widgets/my_text_widget.dart';
import 'package:betting_app/view/widgets/simple_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../constants/app_colors.dart';
import '../../../generated/assets.dart';



class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: "History",
      ),
      body: Padding(
        padding: AppSizes.HORIZONTAL,
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    CommonImageView(imagePath: Assets.imagesBill,),
                    Positioned(
                      right: 15,
                        top: 15,
                        child: CommonImageView(
                          imagePath: Assets.imagesDelete,
                          height: 32,
                        )),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration:  BoxDecoration(
                          color: kBlackColor,

                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                              text: "UEFA Champions League 2024/25 - League Stage",
                              size: 12,
                              weight: FontWeight.w500,
                              color: kSecondaryColor,
                            ),
                            const SizedBox(height: 6,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MyText(
                                  text: "Bayern Munich",
                                  size: 10,
                                  weight: FontWeight.w400,
                                  color: kQuaternaryColor,
                                ),
                                SizedBox(
                                  width: 87,
                                  height: 22,
                                  child: MyButton(
                                    onTap: (){
                                      Get.to(() => const OutcomeWinScreen());
                                    },
                                    backgroundColor: kQuaternaryLightColor,
                                    buttonText: "Show Results",
                                    fontColor: kQuaternaryColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,

                                  ),
                                ),

                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );

        },),
      ),
    );
  }
}
