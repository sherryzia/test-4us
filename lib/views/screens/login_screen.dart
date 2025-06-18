// lib/views/screens/login_screen.dart (Updated)
import 'package:expensary/constants/colors.dart';
import 'package:expensary/controllers/login_controller.dart';
import 'package:expensary/views/screens/forgot_password_screen.dart';
import 'package:expensary/views/screens/main_navigation_screen.dart';
import 'package:expensary/views/screens/signup_screen.dart';
import 'package:expensary/views/widgets/my_Button.dart';
import 'package:expensary/views/widgets/my_text.dart';
import 'package:expensary/views/widgets/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());
    
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              backgroundColor,
              backgroundColor.withOpacity(0.8),
              Color(0xFF1A1A2E).withOpacity(0.9),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  
                  // App Logo/Icon
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF8E2DE2),
                            Color(0xFF4A00E0),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF8E2DE2).withOpacity(0.3),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'EX',
                          style: TextStyle(
                            color: kwhite,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Welcome Text
                  Center(
                    child: Column(
                      children: [
                        MyText(
                          text: 'Welcome Back!',
                          size: 28,
                          weight: FontWeight.bold,
                          color: kwhite,
                        ),
                        const SizedBox(height: 8),
                        MyText(
                          text: 'Log in to your Expensary account',
                          size: 16,
                          color: kwhite.withOpacity(0.7),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Email Field - Using MyTextField with focus border color
                  MyTextField(
                    controller: controller.emailController,
                    label: 'Email',
                    hint: 'your.email@example.com',
                    prefixIcon: Icon(
                      Icons.email,
                      color: kwhite.withOpacity(0.7),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    filledColor: kwhite.withOpacity(0.05),
                    bordercolor: kwhite.withOpacity(0.1),
                    focusedBorderColor: Color(0xFFAF4BCE), // Purple focus border
                    hintColor: kwhite.withOpacity(0.3),
                    marginBottom: 16,
                  ),
                  
                  // Password Field - Using MyTextField with focus border color
                  Obx(() => MyTextField(
                    controller: controller.passwordController,
                    label: 'Password',
                    hint: '••••••••',
                    prefixIcon: Icon(
                      Icons.lock,
                      color: kwhite.withOpacity(0.7),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordVisible.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: kwhite.withOpacity(0.7),
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                    isObSecure: !controller.isPasswordVisible.value,
                    filledColor: kwhite.withOpacity(0.05),
                    bordercolor: kwhite.withOpacity(0.1),
                    focusedBorderColor: Color(0xFFAF4BCE), // Purple focus border
                    hintColor: kwhite.withOpacity(0.3),
                    marginBottom: 16,
                  )),
                  
                  // Remember Me & Forgot Password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Remember Me
                      GestureDetector(
                        onTap: controller.toggleRememberMe,
                        child: Row(
                          children: [
                            Obx(() => Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: controller.rememberMe.value
                                    ? Color(0xFFAF4BCE)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: controller.rememberMe.value
                                      ? Color(0xFFAF4BCE)
                                      : kwhite.withOpacity(0.5),
                                  width: 1.5,
                                ),
                              ),
                              child: controller.rememberMe.value
                                  ? Icon(
                                      Icons.check,
                                      color: kwhite,
                                      size: 14,
                                    )
                                  : null,
                            )),
                            const SizedBox(width: 8),
                            MyText(
                              text: 'Remember me',
                              size: 14,
                              color: kwhite.withOpacity(0.7),
                            ),
                          ],
                        ),
                      ),
                      
                      // Forgot Password
                      GestureDetector(
                        onTap: controller.forgotPassword,
                        child: MyText(
                          text: 'Forgot Password?',
                          size: 14,
                          color: Color(0xFFAF4BCE),
                          weight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Login Button
                  MyButton(
                    onTap: controller.login,
                    buttonText: 'Log In',
                    width: double.infinity,
                    height: 45,
                    fillColor: Color(0xFFAF4BCE),
                    fontColor: kwhite,
                    fontSize: 18,
                    radius: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Sign Up Text
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => SignupScreen());
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Don\'t have an account? ',
                          style: TextStyle(
                            color: kwhite.withOpacity(0.7),
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: 'Sign Up',
                              style: TextStyle(
                                color: Color(0xFFAF4BCE),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
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