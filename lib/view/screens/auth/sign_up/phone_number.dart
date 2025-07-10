import 'package:candid/constants/app_sizes.dart';
import 'package:candid/controller/LoginController.dart';
import 'package:candid/controller/signup_controller.dart';
import 'package:candid/view/screens/auth/sign_up/create_password.dart';
import 'package:candid/view/screens/auth/sign_up/enter_password.dart';
import 'package:candid/view/widget/custom_background.dart';
import 'package:candid/view/widget/heading.dart';
import 'package:candid/view/widget/my_button_widget.dart';
import 'package:candid/view/widget/my_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneNumber extends StatelessWidget {
  final bool? signUp; // true for signup, false/null for login
  const PhoneNumber({super.key, this.signUp});

  @override
  Widget build(BuildContext context) {
    // Initialize the appropriate controller based on signup flag
    late final dynamic controller;
    
    if (signUp == true) {
      controller = Get.put(SignUpController(), tag: 'signup');
    } else {
      controller = Get.put(LoginController(), tag: 'login');
    }

    return CustomBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
                    title: signUp == true 
                        ? 'Can I have your number?' 
                        : 'Welcome back!',
                    subTitle: signUp == true
                        ? 'We keep our community safe by making sure everyone on Candid is 100% real and not a catfish in disguise!'
                        : 'Please enter your phone number to continue.',
                  ),
                  PhoneField(
                    controller: controller.phoneNumberController,
                    selectedCountryCode: controller.selectedCountryCode,
                    onCountryChanged: controller.onCountryChanged,
                    onChanged: (value) {
                      // Optional: Handle phone number changes
                      print('Phone number: ${controller.getCompletePhoneNumber()}');
                    },
                  ),
                  // Debug info (remove in production)
                  Obx(() => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Complete number: ${controller.getCompletePhoneNumber()}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  )),
                ],
              ),
            ),
            Padding(
              padding: AppSizes.DEFAULT,
              child: MyButton(
                buttonText: 'Continue',
                onTap: () {
                  if (controller.phoneNumberController.text.trim().isNotEmpty) {
                    if (signUp == true) {
                      // Signup flow - go to create password
                      Get.to(() => CreatePassword());
                    } else {
                      // Login flow - go to enter password
                      Get.to(() => EnterPassword());
                    }
                  } else {
                    Get.snackbar(
                      'Error', 
                      'Please enter your phone number.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}