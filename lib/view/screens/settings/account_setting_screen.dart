import 'package:betting_app/constants/app_sizes.dart';
import 'package:betting_app/view/widgets/common_image_view_widget.dart';
import 'package:betting_app/view/widgets/my_text_widget.dart';
import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../generated/assets.dart';
import '../../widgets/simple_app_bar.dart';


class AccountSettingScreen extends StatelessWidget {
  const AccountSettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: "Account",
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
                children: [
                  Stack(
                    children: [
                      CommonImageView(
                        imagePath: Assets.imagesProfile,
                        height: 100,
                      ),
                      Positioned(
                        bottom: 0,
                          right: 0,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: ShapeDecoration(
                              color: kBlackColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Center(
                              child: CommonImageView(
                                svgPath: Assets.svgEditIcon,
                                height: 16,

                              ),
                            ),
                          ),)
                    ],
                  ),
                  const SizedBox(height: 40,),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: MyText(
                        text: "Username",
                      size: 14,
                      weight: FontWeight.w500,
                    ),
                    subtitle: MyText(
                        text: "David Beckham",
                      size: 17,
                      weight: FontWeight.w400,
                      color: kBlackColor,
                    ),
                    trailing:RichText(
                      text: const TextSpan(
                        text: "Edit",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: kQuaternaryColor, // Text color
                          decoration: TextDecoration.underline,
                          decorationColor: kQuaternaryColor, // Underline color
                        ),
                      ),
                    )
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: MyText(
                        text: "Phone Number",
                      size: 14,
                      weight: FontWeight.w500,
                    ),
                    subtitle: MyText(
                        text: "+1 (000) 000 0000",
                      size: 17,
                      weight: FontWeight.w400,
                      color: kBlackColor,
                    ),
                    trailing: RichText(
                      text: const TextSpan(
                        text: "Edit",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: kQuaternaryColor, // Text color
                          decoration: TextDecoration.underline,
                          decorationColor: kQuaternaryColor, // Underline color
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: MyText(
                        text: "Email",
                      size: 14,
                      weight: FontWeight.w500,
                    ),
                    subtitle: MyText(
                        text: "dav1d@email.com",
                      size: 17,
                      weight: FontWeight.w400,
                      color: kBlackColor,
                    ),
                    trailing: RichText(
                      text: const TextSpan(
                        text: "Edit",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: kQuaternaryColor, // Text color
                          decoration: TextDecoration.underline,
                          decorationColor: kQuaternaryColor, // Underline color
                        ),
                      ),
                    )

                  ),
                ],
              ),
            ),
            const SizedBox(height: 10,),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(
                    text: "Data History",
                    size: 17,
                    weight: FontWeight.w500,
                    color: kBlackColor,
                  ),
                  RichText(
                    text: const TextSpan(
                      text: "Restore",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: kQuaternaryColor, // Text color
                        decoration: TextDecoration.underline,
                        decorationColor: kQuaternaryColor, // Underline color
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 50,),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: ShapeDecoration(
                color: kSecondaryLightColor,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: kSecondaryColor),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(
                    text: "Delete Account",
                    size: 17,
                    weight: FontWeight.w500,
                    color: kSecondaryColor,
                  ),
                  const Icon(Icons.arrow_forward,color: kSecondaryColor,)
                ],
              ),
            ),


          ],
        ),
      ),
    );
  }
}
