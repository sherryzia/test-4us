import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/controller/signup_controller.dart';
import 'package:candid/view/widget/custom_background.dart';
import 'package:candid/view/widget/heading.dart';
import 'package:candid/view/widget/my_button_widget.dart';
import 'package:candid/view/widget/my_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatePassword extends StatelessWidget {
  const CreatePassword({super.key});

  @override
  Widget build(BuildContext context) {
    final SignUpController signUpController = Get.find<SignUpController>();

    return CustomBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: AppSizes.DEFAULT,
              child: AuthHeading(
                title: 'Create your password',
                subTitle:
                    'Create a strong password to keep your account secure. Use a mix of letters, numbers, and special characters to ensure your password is unique and hard to guess.',
              ),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                padding: AppSizes.HORIZONTAL,
                children: [
                  Obx(() => MyTextField(
                    controller: signUpController.passwordController,
                    labelText: 'Password',
                    hintText: '********',
                    isObscure: signUpController.isPasswordHidden.value,
                    prefixIcon: Assets.imagesPassword,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        signUpController.isPasswordHidden.value = 
                            !signUpController.isPasswordHidden.value;
                      },
                      child: Image.asset(
                        signUpController.isPasswordHidden.value 
                            ? Assets.imagesVisibilityOff 
                            : Assets.imagesVisibilityOff,
                        height: 24,
                      ),
                    ),
                  )),
                  Obx(() => MyTextField(
                    controller: signUpController.confirmPasswordController,
                    labelText: 'Confirm Password',
                    hintText: '********',
                    isObscure: signUpController.isConfirmPasswordHidden.value,
                    prefixIcon: Assets.imagesPassword,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        signUpController.isConfirmPasswordHidden.value = 
                            !signUpController.isConfirmPasswordHidden.value;
                      },
                      child: Image.asset(
                        signUpController.isConfirmPasswordHidden.value 
                            ? Assets.imagesVisibilityOff 
                            : Assets.imagesVisibilityOff,
                        height: 24,
                      ),
                    ),
                  )),
                ],
              ),
            ),
            Padding(
              padding: AppSizes.DEFAULT,
              child: Obx(() => MyButton(
                buttonText: signUpController.isLoading.value ? 'Creating Account...' : 'Continue',
                // isLoading: signUpController.isLoading.value,
                onTap: () {
                  signUpController.signUp();
                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}