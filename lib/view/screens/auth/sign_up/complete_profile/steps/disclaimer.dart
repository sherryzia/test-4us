import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_fonts.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/view/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:candid/view/widget/my_button_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Disclaimer extends StatelessWidget {
  const Disclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlackColor,
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.bottomLeft,
            stops: [0, 1.0],
            colors: [
              Color(0xffFF007F).withOpacity(0.3),
              Color(0xff7B2BFF).withOpacity(0.3),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 55,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: kPrimaryColor,
                  fontFamily: AppFonts.URBANIST,
                ),
                children: [
                  TextSpan(
                    text: 'Being ',
                  ),
                  TextSpan(
                    text: 'Candid',
                    style: TextStyle(
                      color: kSecondaryColor,
                    ),
                  ),
                  TextSpan(
                    text: ' also\nmeans being Kind',
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: AppSizes.DEFAULT,
                physics: BouncingScrollPhysics(),
                children: [
                  _CustomText(
                    title: 'Spreading the Love, ',
                  ),
                  _CustomText(
                    title: 'One Candid Swipe at a Time!',
                  ),
                  _CustomText(
                    title:
                        'Hey there, lovebirds! 🕊 We\'re totally stoked to join you on your quest for romance! At Candid, we\'re all about the #GoodVibesOnly and treating everyone with mad respect, no matter who you are or where you come from.',
                  ),
                  _CustomText(
                    title:
                        'We\'re on a mission to keep Candid a safe and lit space for all, and we need your help, boo! Do your part by sticking to our guidelines, and we\'ll have your back.',
                  ),
                  _CustomText(
                    title: 'So let\'s do this, and make some epic connections!',
                  ),
                  _CustomText(
                    title:
                        'Peace, love & remember, it\'s all about being Candid! 💖',
                  ),
                ],
              ),
            ),
            Padding(
              padding: AppSizes.DEFAULT,
              child: MyButton(
                buttonText: 'I agree',
                onTap: () {
                  Get.to(() => BottomNavBar());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomText extends StatelessWidget {
  const _CustomText({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return MyText(
      paddingTop: 16,
      text: title,
      textStyle: TextStyle(
        fontSize: 17 * 1.2,
        color: kPrimaryColor,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
      color: kPrimaryColor,
      size: 17,
      lineHeight: 1.6,
    );
  }
}
