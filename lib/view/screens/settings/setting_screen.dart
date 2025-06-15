import 'package:betting_app/constants/app_sizes.dart';
import 'package:betting_app/view/screens/history/history_screen.dart';
import 'package:betting_app/view/screens/launch/get_started_screen.dart';
import 'package:betting_app/view/screens/outcomes/outcome_win_screen.dart';
import 'package:betting_app/view/screens/settings/account_setting_screen.dart';
import 'package:betting_app/view/screens/ticket_scanning_screen/instruction_screen.dart';
import 'package:betting_app/view/widgets/common_image_view_widget.dart';
import 'package:betting_app/view/widgets/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../constants/app_colors.dart';
import '../../../generated/assets.dart';
import '../../widgets/simple_app_bar.dart';


class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: SimpleAppBar(
        showLeading: false,
        title: "Settings",

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
              child: Row(
                children: [
                  CommonImageView(
                    imagePath: Assets.imagesProfile,
                    height: 55,
                  ),
                  const SizedBox(width: 15,),
                  MyText(
                    text: "David Beckham",
                    size: 17,
                    weight: FontWeight.w500,
                    color: kBlackColor,
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: (){
                      Get.to(() => const AccountSettingScreen());
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 5, left: 6, right: 10, bottom: 5),
                      decoration: ShapeDecoration(
                        color: kQuaternaryLightColor,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1, color: kQuaternaryColor),
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: Row(
                        children: [
                          CommonImageView(svgPath: Assets.svgEdit,),
                          const SizedBox(width: 8,),
                          MyText(
                              text: "Edit",
                              size: 10,
                              weight: FontWeight.w500,
                              color: kQuaternaryColor,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30,),
            Align(
              alignment: Alignment.topLeft,
              child: MyText(
                  text: "Settings",
                size: 15,
                weight: FontWeight.w500,
                color: kTertiaryColor,
              ),
            ),
            const SizedBox(height: 20,),
            buildClearHistoryButton(text: 'Clear History', onTap: () {

            },),
            buildClearHistoryButton(text: 'Purchase', onTap: () {
              Get.to(() => const GetStartedScreen());
            },),
            buildClearHistoryButton(text: 'Remove Ads', onTap: () {
              Get.to(() => const GetStartedScreen());
            },),
            const SizedBox(height: 50,),
            GestureDetector(
              onTap: (){},
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: ShapeDecoration(
                    color: kSecondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 20,
                        offset: Offset(0, 0),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.logout, color: kPrimaryColor),
                      const SizedBox(width: 10,),
                      MyText(
                        text: "Log Out",
                        size: 17,
                        weight: FontWeight.w500,
                        color: kPrimaryColor,
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward, color: kPrimaryColor),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildClearHistoryButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Container(
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
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(
                text: text,
                size: 17,
                weight: FontWeight.w500,
                color: kBlackColor,
              ),
              const Icon(Icons.arrow_forward, color: kSecondaryColor),
            ],
          ),
        ),
      ),
    );
  }

}
