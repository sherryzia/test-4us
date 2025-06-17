import 'package:expensary/constants/colors.dart';
import 'package:expensary/views/screens/home.dart';
import 'package:expensary/views/screens/login_screen.dart';
import 'package:expensary/views/screens/main_navigation_screen.dart';
import 'package:expensary/views/widgets/my_Button.dart';
import 'package:expensary/views/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // Logo Section
                Column(
                  children: [
                    // Expensary Logo Initials
                    Text(
                      'EX',
                      style: TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: kwhite,
                        letterSpacing: -2,
                      ),
                    ),

                    const SizedBox(height: 5),

                    // App Name
                    MyText(
                      text: 'Expensary',
                      size: 32,
                      weight: FontWeight.bold,
                      color: kwhite,
                      letterSpacing: -0.5,
                    ),

                    const SizedBox(height: 10),

                    // Tagline
                    MyText(
                      text:
                          'Effortlessly track your spending, plan budgets, and take control of your finances—all in one place.',
                      textAlign: TextAlign.center,
                      size: 16,
                      color: kwhite.withOpacity(0.7),
                      lineHeight: 1.5,
                    ),
                  ],
                ),

                const Spacer(flex: 2),

                // Get Started Button
                Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: MyButton(
                    buttonText: 'Get Started',
                    width: double.infinity,
                    height: 56,
                    fillColor: buttonColor,
                    fontColor: kwhite,
                    fontSize: 18,
                    radius: 28,
                    fontWeight: FontWeight.w600,
                    onTap: () {
                      // Navigate to next screen

                      Get.to(() => LoginScreen());
                      
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
