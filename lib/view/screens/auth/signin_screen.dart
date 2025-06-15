import 'package:betting_app/view/screens/auth/signup_screen.dart';
import 'package:betting_app/view/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';
import '../../widgets/my_button.dart';
import '../../widgets/my_text_field.dart';
import '../../widgets/my_text_widget.dart';


class SigninScreen extends StatelessWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSizes.DEFAULT,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Bet',
                          style: TextStyle(
                            color: kQuaternaryColor,
                            fontSize: 27,
                            fontFamily: 'Gotham Rounded',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: 'Vault',
                          style: TextStyle(
                            color: kSecondaryColor,
                            fontSize: 27,
                            fontFamily: 'Gotham Rounded',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50,),
                  MyText(
                    text: "Sign In",
                    size: 17,
                    weight: FontWeight.w500,
                    color: kBlackColor,
                  ),
                  const SizedBox(height: 20,),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: ShapeDecoration(
                      color: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
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
                        MyTextField(
                          label: "Email",
                          hint: "e.g. example@email.com",
                        ),
                        MyTextField(
                          label: "Password",
                          hint: "********",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              MyButton(onTap: (){
                Get.to(() => BottomNavBar());
              }, buttonText: "Sign In"),
              const SizedBox(height: 10,),
              InkWell(
                onTap: (){
                  Get.to(() => const SignupScreen());
                },
                child: const Align(
                  alignment: Alignment.center,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Don't have an account?",
                          style: TextStyle(
                            color: kBlackColor,
                            fontSize: 14,
                            fontFamily: 'Gotham',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: ' ',
                          style: TextStyle(
                            color:kBlackColor,
                            fontSize: 14,
                            fontFamily: 'Gotham',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: 'Sign Up',
                          style: TextStyle(
                            color: kQuaternaryColor,
                            fontSize: 14,
                            fontFamily: 'Gotham',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
