import 'package:flutter/material.dart';
import 'package:forus_app/controllers/auth/LoginController.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/constants/app_fonts.dart';
import 'package:forus_app/constants/app_sizes.dart';
import 'package:forus_app/generated/assets.dart';
import 'package:forus_app/view/auth/forgot_password/forgot_password.dart';
import 'package:forus_app/view/auth/signup.dart';
import 'package:forus_app/view/widget/common_image_view_widget.dart';
import 'package:forus_app/view/widget/my_button_widget.dart';
import 'package:forus_app/view/widget/my_text_widget.dart';
import 'package:forus_app/view/widget/my_text_field.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});
  final LoginController controller = Get.put(LoginController());

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.imagesBackgroundCp),
            fit: BoxFit.fill,
          ),
        ),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CommonImageView(
                  imagePath: Assets.imagesLogo,
                  width: 91,
                ),
                Gap(20),
                Container(
                  height: Get.height,
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: AppSizes.HORIZONTAL,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        MyText(
                          text: 'Hi, Welcome Back',
                          size: 24,
                          paddingTop: 20,
                          fontFamily: AppFonts.NUNITO_SANS,
                          weight: FontWeight.w800,
                        ),
                        MyText(
                          text: 'Login to continue using our platform',
                          size: 16,
                          paddingTop: 5,
                          color: kTextGrey,
                          fontFamily: AppFonts.NUNITO_SANS,
                          weight: FontWeight.w500,
                        ),
                        Gap(20),
                        MyTextField(
                          controller: widget.controller.emailController,
                          hint: 'Email',
                          labelColor: kBlack,
                          hintColor: kTextGrey,
                          radius: 8,
                          suffix: Padding(
                            padding: const EdgeInsets.all(12),
                            child: CommonImageView(
                              imagePath: Assets.imagesEmailicon,
                              height: 22,
                            ),
                          ),
                          filledColor: kTransperentColor,
                          kBorderColor: kBorderGrey,
                          kFocusBorderColor: KColor1,
                        ),
                        Gap(16),
                        Obx(() => MyTextField(
                              controller: widget.controller.passwordController,
                              hint: 'Password',
                              hintColor: kTextGrey,
                              labelColor: kBlack,
                              radius: 8,
                              isObSecure: widget.controller.isPasswordHidden
                                  .value, // Reacts to changes
                              suffix: IconButton(
                                icon: Icon(
                                  widget.controller.isPasswordHidden.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: kTextGrey,
                                ),
                                onPressed:
                                    widget.controller.togglePasswordVisibility,
                              ),
                              filledColor: kTransperentColor,
                              kBorderColor: kBorderGrey,
                              kFocusBorderColor: KColor1,
                            )),
                        InkWell(
                          onTap: () {
                            Get.to(() => ForgotPasswordScreen());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              MyText(
                                text: 'Forgot Password?',
                                size: 16,
                                paddingTop: 20,
                                color: kTextOrange,
                                paddingBottom: 30,
                                fontFamily: AppFonts.NUNITO_SANS,
                                weight: FontWeight.w800,
                              ),
                            ],
                          ),
                        ),
                        MyButton(
                          buttonText: widget.controller.isLoading.value
                              ? "Logging In..."
                              : "Login",
                          radius: 14,
                          textSize: 18,
                          weight: FontWeight.w800,
                          onTap: widget.controller.isLoading.value
                              ? () => {} // Disable the button when loading
                              : () {
                                  widget.controller.login();
                                },
                        ),
                        Gap(32),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                height: 1.0,
                                color: kBorderGrey,
                              ),
                            ),
                            MyText(
                              text: 'OR',
                              size: 14,
                              weight: FontWeight.w500,
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                height: 1.0,
                                color: kBorderGrey,
                              ),
                            ),
                          ],
                        ),
                        Gap(37),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CommonImageView(
                              imagePath: Assets.imagesApple,
                              height: 48,
                            ),
                            Gap(24),
                            CommonImageView(
                              imagePath: Assets.imagesGoogle,
                              height: 48,
                            ),
                          ],
                        ),
                        Gap(40),
                        InkWell(
                          onTap: () {
                            Get.to(() => SignUpScreen());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MyText(
                                text: 'Don’t have an account?',
                                size: 16,
                                color: kTextGrey,
                                fontFamily: AppFonts.NUNITO_SANS,
                                weight: FontWeight.w600,
                              ),
                              MyText(
                                text: ' Sign Up',
                                size: 16,
                                color: kTextOrange,
                                fontFamily: AppFonts.NUNITO_SANS,
                                weight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
