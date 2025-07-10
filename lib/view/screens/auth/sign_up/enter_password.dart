import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/controller/LoginController.dart';
import 'package:candid/view/widget/custom_background.dart';
import 'package:candid/view/widget/heading.dart';
import 'package:candid/view/widget/my_button_widget.dart';
import 'package:candid/view/widget/my_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EnterPassword extends StatelessWidget {
  const EnterPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.find<LoginController>(tag: 'login');

    return CustomBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: AppSizes.DEFAULT,
              child: AuthHeading(
                title: 'Enter your password',
                subTitle:
                    'Please enter your password to continue with ${loginController.getCompletePhoneNumber()}',
              ),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                padding: AppSizes.HORIZONTAL,
                children: [
                  Obx(() => MyTextField(
                    controller: loginController.passwordController,
                    labelText: 'Password',
                    hintText: '********',
                    isObscure: loginController.isPasswordHidden.value,
                    prefixIcon: Assets.imagesPassword,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        loginController.isPasswordHidden.value = 
                            !loginController.isPasswordHidden.value;
                      },
                      child: Image.asset(
                        loginController.isPasswordHidden.value 
                            ? Assets.imagesVisibilityOff 
                            : Assets.imagesVisibilityOff,
                        height: 24,
                      ),
                    ),
                  )),
                  // Forgot password option
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: TextButton(
                      onPressed: () {
                        // Handle forgot password
                        Get.snackbar(
                          'Info',
                          'Forgot password functionality will be implemented',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: kSecondaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: AppSizes.DEFAULT,
              child: Obx(() => MyButton(
                buttonText: loginController.isLoading.value ? 'Logging in...' : 'Login',
                // isLoading: loginController.isLoading.value,
                onTap: () {
                  loginController.login();
                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}