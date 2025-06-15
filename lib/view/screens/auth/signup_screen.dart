import 'package:betting_app/view/screens/auth/signin_screen.dart';
import 'package:betting_app/view/widgets/my_button.dart';
import 'package:betting_app/view/widgets/my_text_field.dart';
import 'package:betting_app/view/widgets/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: AppSizes.DEFAULT,
            child: Column(
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
                  text: "Sign Up",
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
                      Row(
                        children: [
                          Expanded(
                            child: MyTextField(
                              label: "First Name",
                              hint: "Lewis",
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Expanded(
                            child: MyTextField(
                              label: "Second Name",
                              hint: "Hamilton",
                            ),
                          ),
                        ],
                      ),
                      MyTextField(
                        label: "Email",
                        hint: "e.g. example@email.com",
                      ),
                      MyTextField(
                        label: "Password",
                        hint: "********",
                      ),
                      MyTextField(
                        label: "Confirm Password",
                        hint: "********",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60,),
                MyButton(onTap: (){}, buttonText: "Sign Up"),
                const SizedBox(height: 10,),
                InkWell(
                  onTap: (){
                    Get.to(() => const SigninScreen());
                  },
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Already have an account?',
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
                            text: 'Login',
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
      ),
    );
  }
}
