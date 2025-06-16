// lib/view/screens/auth/login_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:betting_app/constants/app_colors.dart';
import 'package:betting_app/constants/app_sizes.dart';
import 'package:betting_app/controllers/auth_controller.dart';
import 'package:betting_app/view/screens/auth/signup_screen.dart';
import 'package:betting_app/view/widgets/my_button.dart';
import 'package:betting_app/view/widgets/my_text_widget.dart';

class LoginScreen extends StatelessWidget {
  final AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSizes.DEFAULT,
          child: SingleChildScrollView(
            child: Form(
              key: controller.loginFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
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
                  const SizedBox(height: 50),
                  MyText(
                    text: "Sign In",
                    size: 17,
                    weight: FontWeight.w500,
                    color: kBlackColor,
                  ),
                  const SizedBox(height: 20),
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
                        // Email field
                        TextFormField(
                          controller: controller.emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            hintText: "e.g. example@email.com",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: kTertiaryColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: kSecondaryColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: kTertiaryColor),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: kSecondaryColor),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: controller.validateEmail,
                        ),
                        const SizedBox(height: 16),
                        
                        // Password field
                        Obx(() => TextFormField(
                          controller: controller.passwordController,
                          decoration: InputDecoration(
                            labelText: "Password",
                            hintText: "********",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: kTertiaryColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: kSecondaryColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: kTertiaryColor),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: kSecondaryColor),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.obscurePassword.value 
                                  ? Icons.visibility_off 
                                  : Icons.visibility,
                                color: kTertiaryColor,
                              ),
                              onPressed: controller.togglePasswordVisibility,
                            ),
                          ),
                          obscureText: controller.obscurePassword.value,
                          validator: controller.validatePassword,
                        )),
                        
                        // Display validation errors if any
                        Obx(() => controller.validationErrors.isNotEmpty
                          ? Container(
                              margin: const EdgeInsets.only(top: 16),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: kSecondaryLightColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: kSecondaryColor),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: controller.validationErrors.entries.map((entry) => 
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      "• ${entry.value}",
                                      style: const TextStyle(
                                        color: kSecondaryColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  )
                                ).toList(),
                              ),
                            )
                          : const SizedBox.shrink()
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Obx(() => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : MyButton(
                        onTap: controller.login,
                        buttonText: "Sign In",
                      )
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => Get.to(() => SignupScreen()),
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
                                color: kBlackColor,
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
        ),
      ),
    );
  }
}