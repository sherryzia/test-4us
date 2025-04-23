// lib/view/screens/auth/login.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_images.dart';
import 'package:restaurant_finder/constants/app_sizes.dart';
import 'package:restaurant_finder/controller/signin_controller.dart';
import 'package:restaurant_finder/view/screens/auth/forgot_pass/forgot_password.dart';
import 'package:restaurant_finder/view/screens/auth/sign_up/sign_up.dart';
import 'package:restaurant_finder/view/widget/custom_app_bar_widget.dart';
import 'package:restaurant_finder/view/widget/custom_check_box_widget.dart';
import 'package:restaurant_finder/view/widget/headings_widget.dart';
import 'package:restaurant_finder/view/widget/my_button_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_field_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';

class Login extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: '',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: AppSizes.DEFAULT,
              children: [
                AuthHeading(
                  textAlign: TextAlign.center,
                  title: 'Welcome',
                  subTitle: 'Please enter your email and password to sign in.',
                ),
                
                // Error message if any
                Obx(() => controller.errorMessage.value.isNotEmpty
                    ? Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: MyText(
                          text: controller.errorMessage.value,
                          color: Colors.red,
                          size: 12,
                          weight: FontWeight.w500,
                        ),
                      )
                    : SizedBox()),
                
                // Email/Phone field
                MyTextField(
                  controller: controller.emailPhoneController,
                  labelText: 'Email/Phone',
                  hintText: 'Email/Phone',
                ),
                
                // Password field
                Obx(() => MyTextField(
                      controller: controller.passwordController,
                      labelText: 'Password',
                      hintText: '********',
                      isObSecure: controller.isObSecure.value,
                      suffix: GestureDetector(
                        onTap: () => controller.isObSecure.value = !controller.isObSecure.value,
                        child: Icon(
                          controller.isObSecure.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    )),
                
                Row(
                  children: [
                    Obx(() => CustomCheckBox(
                          isActive: controller.rememberMe.value,
                          onTap: () => controller.toggleRememberMe(),
                        )),
                    Expanded(
                      child: MyText(
                        paddingLeft: 12,
                        text: 'Remember me',
                        size: 15,
                        weight: FontWeight.w600,
                      ),
                    ),
                    MyText(
                      onTap: () => Get.to(() => ForgotPassword()),
                      text: 'Forgot password?',
                      size: 15,
                      weight: FontWeight.bold,
                      textAlign: TextAlign.end,
                      color: kSecondaryColor,
                    ),
                  ],
                ),
                
                SizedBox(
                  height: 30,
                ),
                
                // Login button
                Obx(() => MyButton(
                      onTap: controller.isLoading.value
                          ? (){}
                          : () => controller.login(),
                      buttonText: controller.isLoading.value
                          ? 'Please wait...'
                          : 'Login',
                    )),
                
                SizedBox(
                  height: 12,
                ),
                
                // Sign in later button
                MyBorderButton(
                  bgColor: kSecondaryColor,
                  onTap: () => controller.signInLater(),
                  buttonText: 'Sign In later',
                ),
                
                SizedBox(
                  height: 20,
                ),
                
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: kBorderColor,
                      ),
                    ),
                    MyText(
                      text: 'or continue with',
                      size: 15,
                      weight: FontWeight.w500,
                      paddingLeft: 16.05,
                      paddingRight: 16.05,
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: kBorderColor,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(
                  height: 20,
                ),
                
                // Social login options
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => controller.loginWithGoogle(),
                      child: Image.asset(
                        Assets.imagesGoogle,
                        height: 52,
                      ),
                    ),
                    SizedBox(
                      width: 14,
                    ),
                    GestureDetector(
                      onTap: () => controller.loginWithFacebook(),
                      child: Image.asset(
                        Assets.imagesFacebook,
                        height: 52,
                      ),
                    ),
                    SizedBox(
                      width: 14,
                    ),
                    GestureDetector(
                      onTap: () => controller.loginWithApple(),
                      child: Image.asset(
                        Assets.imagesApple,
                        height: 52,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Create account link
          Padding(
            padding: AppSizes.DEFAULT,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  spacing: 5,
                  alignment: WrapAlignment.center,
                  children: [
                    MyText(
                      text: 'Don\'t have an account',
                    ),
                    MyText(
                      onTap: () => Get.to(() => SignUp()),
                      text: 'Create account',
                      color: kSecondaryColor,
                      weight: FontWeight.bold,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}