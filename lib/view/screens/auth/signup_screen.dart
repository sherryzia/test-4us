// lib/view/screens/auth/signup_screen.dart

import 'package:betting_app/view/screens/auth/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:betting_app/constants/app_colors.dart';
import 'package:betting_app/constants/app_sizes.dart';
import 'package:betting_app/controllers/auth_controller.dart';
import 'package:betting_app/view/widgets/my_button.dart';
import 'package:betting_app/view/widgets/my_text_widget.dart';

class SignupScreen extends StatelessWidget {
  final AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSizes.DEFAULT,
          child: SingleChildScrollView(
            child: Form(
              key: controller.registerFormKey,
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
                  const SizedBox(height: 30),
                  MyText(
                    text: "Sign Up",
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
                        // First name and last name row
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: controller.firstNameController,
                                decoration: InputDecoration(
                                  labelText: "First Name",
                                  hintText: "e.g. John",
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
                                validator: (value) => controller.validateRequired(value, 'First name'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: controller.lastNameController,
                                decoration: InputDecoration(
                                  labelText: "Last Name",
                                  hintText: "e.g. Doe",
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
                                validator: (value) => controller.validateRequired(value, 'Last name'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Phone number
                        TextFormField(
                          controller: controller.phoneController,
                          decoration: InputDecoration(
                            labelText: "Phone Number",
                            hintText: "e.g. 1234567890",
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
                            prefixIcon: const Icon(Icons.phone, color: kTertiaryColor),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: controller.validatePhone,
                        ),
                        const SizedBox(height: 16),
                        
                        // Email
                        TextFormField(
                          controller: controller.registerEmailController,
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
                            prefixIcon: const Icon(Icons.email, color: kTertiaryColor),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: controller.validateEmail,
                        ),
                        const SizedBox(height: 16),
                        
                        // Password
                        Obx(() => TextFormField(
                          controller: controller.registerPasswordController,
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
                            prefixIcon: const Icon(Icons.lock, color: kTertiaryColor),
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
                        const SizedBox(height: 16),
                        
                        // Confirm Password
                        Obx(() => TextFormField(
                          controller: controller.confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
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
                            prefixIcon: const Icon(Icons.lock, color: kTertiaryColor),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.obscureConfirmPassword.value 
                                  ? Icons.visibility_off 
                                  : Icons.visibility,
                                color: kTertiaryColor,
                              ),
                              onPressed: controller.toggleConfirmPasswordVisibility,
                            ),
                          ),
                          obscureText: controller.obscureConfirmPassword.value,
                          validator: controller.validateConfirmPassword,
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
                  const SizedBox(height: 30),
                  Obx(() => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : MyButton(
                        onTap: controller.register,
                        buttonText: "Sign Up",
                      )
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => Get.to(() => LoginScreen()),
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
                                color: kBlackColor,
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}