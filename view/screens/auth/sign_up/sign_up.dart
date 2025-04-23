// lib/view/screens/auth/sign_up/signup.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_images.dart';
import 'package:restaurant_finder/constants/app_sizes.dart';
import 'package:restaurant_finder/controller/signup_controller.dart';
import 'package:restaurant_finder/view/screens/auth/login.dart';
import 'package:restaurant_finder/view/widget/custom_app_bar_widget.dart';
import 'package:restaurant_finder/view/widget/custom_check_box_widget.dart';
import 'package:restaurant_finder/view/widget/headings_widget.dart';
import 'package:restaurant_finder/view/widget/my_button_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_field_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';

class SignUp extends StatelessWidget {
  final SignUpController controller = Get.put(SignUpController());

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
                  title: 'Join us Today',
                  subTitle:
                      'Please enter your credentials to begin to create your account',
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

                // Name field
                MyTextField(
                  controller: controller.nameController,
                  labelText: 'Name',
                  hintText: 'Leo',
                ),

                // Email field
                MyTextField(
                  controller: controller.emailController,
                  labelText: 'Email',
                  hintText: 'Andrew.john@yourdomain.com',
                ),

                // Phone field
                MyTextField(
                  controller: controller.phoneController,
                  labelText: 'Phone No',
                  hintText: '+92-38749398454',
                ),

                // Password field
                Obx(() => MyTextField(
                      controller: controller.passwordController,
                      labelText: 'Password',
                      hintText: '********',
                      isObSecure: controller.isObSecure.value,
                      suffix: IconButton(
                        icon: Icon(
                          controller.isObSecure.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 18,
                        ),
                        onPressed: () => controller.isObSecure.value =
                            !controller.isObSecure.value,
                      ),
                    )),

                // Confirm password field
               Obx(() => MyTextField(
                  controller: controller.confirmPasswordController,
                      labelText: 'Password',
                      hintText: '********',
                      isObSecure: controller.isObSecure2.value,
                      suffix: IconButton(
                        icon: Icon(
                          controller.isObSecure2.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 18,
                        ),
                        onPressed: () => controller.isObSecure2.value =
                            !controller.isObSecure2.value,
                      ),
                    )),

                // Terms and conditions checkbox
                Row(
                  children: [
                    Obx(() => CustomCheckBox(
                          isActive: controller.termsAccepted.value,
                          
                          onTap: () => controller.toggleTerms(),
                        )),
                    Expanded(
                      child: MyText(
                        paddingLeft: 10,
                        text:
                            'I agree to the all Terms of Service and Privacy Policy',
                        size: 12,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 30,
                ),

                // Sign up button
                Obx(() => MyButton(
                      onTap: controller.isLoading.value
                          ? () {}
                          : () => controller.signUp(),
                      buttonText: controller.isLoading.value
                          ? 'Please wait...'
                          : 'Continue',
                    )),

                SizedBox(
                  height: 20,
                ),

                // Divider
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

                // Social sign up options
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => controller.signUpWithGoogle(),
                      child: Image.asset(
                        Assets.imagesGoogle,
                        height: 52,
                      ),
                    ),
                    SizedBox(
                      width: 14,
                    ),
                    GestureDetector(
                      onTap: () => controller.signUpWithFacebook(),
                      child: Image.asset(
                        Assets.imagesFacebook,
                        height: 52,
                      ),
                    ),
                    SizedBox(
                      width: 14,
                    ),
                    GestureDetector(
                      onTap: () => controller.signUpWithApple(),
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

          // Sign in link
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
                      text: 'Already have an account?',
                    ),
                    MyText(
                      onTap: () => Get.offAll(() => Login()),
                      text: 'Sign In',
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
