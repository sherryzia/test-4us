// Updated Signup Screen with MyTextField
import 'package:expensary/constants/colors.dart';
import 'package:expensary/views/screens/otp_verification_screen.dart';
import 'package:expensary/views/widgets/custom_app_bar.dart';
import 'package:expensary/views/widgets/my_Button.dart';
import 'package:expensary/views/widgets/my_text.dart';
import 'package:expensary/views/widgets/my_textfield.dart'; // Import MyTextField
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final RxBool agreeToTerms = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
  
  void toggleAgreeToTerms() {
    agreeToTerms.value = !agreeToTerms.value;
  }
  
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }
  
  void signup() {
    if (!validateForm()) {
      return;
    }
    
    // Navigate to OTP verification screen
    Get.to(() => OTPVerificationScreen(
      email: emailController.text,
    ));
  }
  
  bool validateForm() {
    // Check if any field is empty
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return false;
    }
    
    // Check if passwords match
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return false;
    }
    
    // Check if user agreed to terms
    if (!agreeToTerms.value) {
      Get.snackbar(
        'Error',
        'Please agree to Terms & Conditions',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return false;
    }
    
    return true;
  }
  
  void viewTerms() {
    Get.snackbar(
      'Terms & Conditions',
      'Terms & Conditions coming soon',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.withOpacity(0.8),
      colorText: Colors.white,
    );
  }
}

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SignupController controller = Get.put(SignupController());
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        title: 'Create Account',
        type: AppBarType.withBackButton,
      ),
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
                  // Subtitle text
                  MyText(
                    text: 'Sign up to start tracking your expenses',
                    size: 16,
                    color: kwhite.withOpacity(0.7),
                  ),
                  
                  const SizedBox(height: 24), // Reduced spacing
                  
                  // Full Name Field - Using MyTextField
                  MyTextField(
                    controller: controller.nameController,
                    label: 'Full Name',
                    hint: 'John Doe',
                    prefixIcon: Icon(
                      Icons.person,
                      color: kwhite.withOpacity(0.7),
                    ),
                    filledColor: kwhite.withOpacity(0.05),
                    bordercolor: kwhite.withOpacity(0.1),
                    hintColor: kwhite.withOpacity(0.3),
                    marginBottom: 16, // Reduced spacing
                  ),
                  
                  // Email Field - Using MyTextField
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
                    hintColor: kwhite.withOpacity(0.3),
                    marginBottom: 16, // Reduced spacing
                  ),
                  
                  // Password Field - Using MyTextField
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
                    hintColor: kwhite.withOpacity(0.3),
                    marginBottom: 16, // Reduced spacing
                  )),
                  
                  // Confirm Password Field - Using MyTextField
                  Obx(() => MyTextField(
                    controller: controller.confirmPasswordController,
                    label: 'Confirm Password',
                    hint: '••••••••',
                    prefixIcon: Icon(
                      Icons.lock,
                      color: kwhite.withOpacity(0.7),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isConfirmPasswordVisible.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: kwhite.withOpacity(0.7),
                      ),
                      onPressed: controller.toggleConfirmPasswordVisibility,
                    ),
                    isObSecure: !controller.isConfirmPasswordVisible.value,
                    filledColor: kwhite.withOpacity(0.05),
                    bordercolor: kwhite.withOpacity(0.1),
                    hintColor: kwhite.withOpacity(0.3),
                    marginBottom: 16, // Reduced spacing
                  )),
                  
                  // Terms & Conditions
                  GestureDetector(
                    onTap: controller.toggleAgreeToTerms,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => Container(
                          margin: EdgeInsets.only(top: 3),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: controller.agreeToTerms.value
                                ? Color(0xFFAF4BCE)
                                : Colors.transparent,
                            border: Border.all(
                              color: controller.agreeToTerms.value
                                  ? Color(0xFFAF4BCE)
                                  : kwhite.withOpacity(0.5),
                              width: 1.5,
                            ),
                          ),
                          child: controller.agreeToTerms.value
                              ? Icon(
                                  Icons.check,
                                  color: kwhite,
                                  size: 14,
                                )
                              : null,
                        )),
                        const SizedBox(width: 10),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: 'I agree to the ',
                              style: TextStyle(
                                color: kwhite.withOpacity(0.7),
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Terms & Conditions',
                                  style: TextStyle(
                                    color: Color(0xFFAF4BCE),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: ' and ',
                                ),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                    color: Color(0xFFAF4BCE),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30), // Reduced spacing
                  
                  // Sign Up Button
                  MyButton(
                    onTap: controller.signup,
                    buttonText: 'Create Account',
                    width: double.infinity,
                    height: 32,
                    fillColor: Color(0xFFAF4BCE),
                    fontColor: kwhite,
                    fontSize: 18,
                    radius: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  
                  const SizedBox(height: 24), // Reduced spacing
                  
                  // Sign In Text
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Get.back(); // Go back to login screen
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(
                            color: kwhite.withOpacity(0.7),
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: 'Sign In',
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