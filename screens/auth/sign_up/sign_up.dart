// lib/view/screens/auth/sign_up/signup.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_images.dart';
import 'package:restaurant_finder/constants/app_sizes.dart';
import 'package:restaurant_finder/controller/signup_controller.dart';
import 'package:restaurant_finder/view/screens/auth/login.dart';
import 'package:restaurant_finder/view/screens/auth/sign_up/email_verification.dart';
import 'package:restaurant_finder/view/widget/custom_app_bar_widget.dart';
import 'package:restaurant_finder/view/widget/custom_check_box_widget.dart';
import 'package:restaurant_finder/view/widget/headings_widget.dart';
import 'package:restaurant_finder/view/widget/my_button_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_field_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';
import 'package:restaurant_finder/controller/theme_controller.dart';

class SignUp extends StatelessWidget {
  final SignUpController controller = Get.put(SignUpController());

  SignUp({super.key});

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode;
      return Scaffold(
        backgroundColor: isDark ? kBlackColor : Colors.white,
        appBar: simpleAppBar(title: ''),
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
                    title: 'joinUsToday'.tr,
                    subTitle: 'pleaseEnterYourCredentialsToCreateAccount'.tr,
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
                    labelText: 'name'.tr,
                    hintText: 'nameHint'.tr,
                  ),

                  // Email field
                  MyTextField(
                    controller: controller.emailController,
                    labelText: 'email'.tr,
                    hintText: 'emailHint'.tr,
                  ),

                  // Phone field
                  MyTextField(
                    controller: controller.phoneController,
                    labelText: 'phoneNo'.tr,
                    hintText: 'phoneNoHint'.tr,
                  ),

                  // Password field
                  Obx(() => MyTextField(
                        controller: controller.passwordController,
                        labelText: 'password'.tr,
                        hintText: 'passwordHint'.tr,
                        isObSecure: controller.isObSecure.value,
                        suffix: IconButton(
                          icon: Icon(
                            controller.isObSecure.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 18,
                            color: isDark ? kTertiaryColor : Colors.grey,
                          ),
                          onPressed: () => controller.isObSecure.value =
                              !controller.isObSecure.value,
                        ),
                      )),

                  // Confirm password field
                  Obx(() => MyTextField(
                        controller: controller.confirmPasswordController,
                        labelText: 'confirmPassword'.tr,
                        hintText: 'passwordHint'.tr,
                        isObSecure: controller.isObSecure2.value,
                        suffix: IconButton(
                          icon: Icon(
                            controller.isObSecure2.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 18,
                            color: isDark ? kTertiaryColor : Colors.grey,
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
                          text: 'iAgreeToTermsAndPrivacy'.tr,
                          size: 12,
                          weight: FontWeight.w600,
                          color: isDark ? kDarkTextColor : null,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 30),

                  // Sign up button
                  Obx(() => MyButton(
                        onTap: controller.isLoading.value
                            ? () {}
                            : () => controller.signUp(),
                        buttonText: controller.isLoading.value
                            ? 'pleaseWait'.tr
                            : 'continue'.tr,
                      )),

                  SizedBox(height: 20),

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
                        text: 'orContinueWith'.tr,
                        size: 15,
                        weight: FontWeight.w500,
                        paddingLeft: 16.05,
                        paddingRight: 16.05,
                        color: isDark ? kDarkTextColor : null,
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: kBorderColor,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

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
                      SizedBox(width: 14),
                      GestureDetector(
                        onTap: () => controller.signUpWithFacebook(),
                        child: Image.asset(
                          Assets.imagesFacebook,
                          height: 52,
                        ),
                      ),
                      SizedBox(width: 14),
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
                        text: 'alreadyHaveAnAccount'.tr,
                        color: isDark ? kDarkTextColor : null,
                      ),
                      MyText(
                        onTap: () => Get.offAll(() => Login()),
                        text: 'signIn'.tr,
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
    });
  }
}