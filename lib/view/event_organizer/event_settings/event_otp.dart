
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/constants/app_fonts.dart';
import 'package:forus_app/constants/app_sizes.dart';
import 'package:forus_app/generated/assets.dart';
import 'package:forus_app/view/event_organizer/event_settings/event_reset_password.dart';
import 'package:forus_app/view/service_provider/provider_settings/provider_reset_password.dart';
import 'package:forus_app/view/widget/common_image_view_widget.dart';
import 'package:forus_app/view/widget/my_button_widget.dart';
import 'package:forus_app/view/widget/my_text_widget.dart';
import 'package:pinput/pinput.dart';

class EventSettingOtpScreen extends StatefulWidget {
  const EventSettingOtpScreen({super.key});

  @override
  State<EventSettingOtpScreen> createState() => _EventSettingOtpScreenState();
}

class _EventSettingOtpScreenState extends State<EventSettingOtpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemeColors.getTertiary(context),
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: CommonImageView(
              imagePath: Assets.imagesArrowLeft,
              height: 24,
            ),
          ),
        ),
      ),
      backgroundColor: AppThemeColors.getTertiary(context),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CommonImageView(
              imagePath: Assets.imagesOtp,
              height: 86,
            ),
            MyText(
              text: 'OTP Verification',
              size: 24,
              paddingTop: 38,
              fontFamily: AppFonts.NUNITO_SANS,
              weight: FontWeight.w800,
            ),
            MyText(
              text: 'Please enter 6 digit code sent to your \ng****@gmail.com',
              size: 16,
              textAlign: TextAlign.center,
              paddingTop: 5,
              color: kTextGrey,
              fontFamily: AppFonts.NUNITO_SANS,
              weight: FontWeight.w500,
            ),
            Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Pinput(
                  length: 6,
                  defaultPinTheme: PinTheme(
                      width: 45,
                      height: 45,
                      textStyle: TextStyle(
                          fontSize: 16,
                          fontFamily: AppFonts.NUNITO_SANS,
                          fontWeight: FontWeight.w600,
                          color: kBlack),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: kBorderGrey),
                      ),
                      margin: EdgeInsets.only(left: 5)),
                  focusedPinTheme: PinTheme(
                      width: 45,
                      height: 45,
                      textStyle: TextStyle(
                          fontSize: 16,
                          fontFamily: AppFonts.NUNITO_SANS,
                          fontWeight: FontWeight.w600,
                          color: kBlack),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: kBorderGrey),
                      ),
                      margin: EdgeInsets.only(left: 5)),
                  submittedPinTheme: PinTheme(
                      width: 45,
                      height: 45,
                      textStyle: TextStyle(
                          fontSize: 16,
                          fontFamily: AppFonts.NUNITO_SANS,
                          fontWeight: FontWeight.w600,
                          color: kBlack),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: kBorderGrey),
                      ),
                      margin: EdgeInsets.only(left: 5)),
                  onCompleted: (pin) {
                    // Handle OTP completion
                    print("Completed: $pin");
                  },
                ),
              ],
            ),
            Gap(25),
            MyButton(
                buttonText: "Verify",
                radius: 14,
                textSize: 18,
                weight: FontWeight.w800,
                onTap: () {
                  Get.to(() => EventResetPasswordScreen());
                }),
            Gap(21),
            InkWell(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyText(
                    text: "Haven't received a code yet?",
                    size: 16,
                    color: kTextGrey,
                    fontFamily: AppFonts.NUNITO_SANS,
                    weight: FontWeight.w600,
                  ),
                  MyText(
                    text: ' Resend',
                    size: 16,
                    color: kTextOrange,
                    fontFamily: AppFonts.NUNITO_SANS,
                    weight: FontWeight.w600,
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
