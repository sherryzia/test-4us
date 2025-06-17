// Create a new file: views/screens/auth/signup_screen.dart
import 'package:expensary/constants/colors.dart';
import 'package:expensary/views/screens/otp_verification_screen.dart';
import 'package:expensary/views/widgets/my_Button.dart';
import 'package:expensary/views/widgets/my_text.dart';
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
                  // Back Button
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: kwhite.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: kwhite,
                        size: 24,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Create Account Text
                  MyText(
                    text: 'Create Account',
                    size: 32,
                    weight: FontWeight.bold,
                    color: kwhite,
                  ),
                  
                  const SizedBox(height: 10),
                  
                  MyText(
                    text: 'Sign up to start tracking your expenses',
                    size: 16,
                    color: kwhite.withOpacity(0.7),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Full Name Field
                  _buildTextField(
                    controller: controller.nameController,
                    label: 'Full Name',
                    hint: 'John Doe',
                    icon: Icons.person,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Email Field
                  _buildTextField(
                    controller: controller.emailController,
                    label: 'Email',
                    hint: 'your.email@example.com',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Password Field
                  Obx(() => _buildTextField(
                    controller: controller.passwordController,
                    label: 'Password',
                    hint: '••••••••',
                    icon: Icons.lock,
                    isPassword: true,
                    obscureText: !controller.isPasswordVisible.value,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordVisible.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: kwhite.withOpacity(0.7),
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  )),
                  
                  const SizedBox(height: 20),
                  
                  // Confirm Password Field
                  Obx(() => _buildTextField(
                    controller: controller.confirmPasswordController,
                    label: 'Confirm Password',
                    hint: '••••••••',
                    icon: Icons.lock,
                    isPassword: true,
                    obscureText: !controller.isConfirmPasswordVisible.value,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isConfirmPasswordVisible.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: kwhite.withOpacity(0.7),
                      ),
                      onPressed: controller.toggleConfirmPasswordVisibility,
                    ),
                  )),
                  
                  const SizedBox(height: 20),
                  
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
                                  // Note: TextSpan doesn't support onTap directly,
                                  // but we have the row gesture detector above
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
                  
                  const SizedBox(height: 40),
                  
                  // Sign Up Button
                  MyButton(
                    onTap: controller.signup,
                    buttonText: 'Create Account',
                    width: double.infinity,
                    height: 56,
                    fillColor: Color(0xFFAF4BCE),
                    fontColor: kwhite,
                    fontSize: 18,
                    radius: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // OR Divider
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: kwhite.withOpacity(0.2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: MyText(
                          text: 'OR',
                          size: 14,
                          color: kwhite.withOpacity(0.5),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: kwhite.withOpacity(0.2),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Social Login Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(
                        icon: Icons.g_mobiledata,
                        color: Colors.red,
                        onTap: () {
                          Get.snackbar(
                            'Google Login',
                            'Google login coming soon',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                      ),
                      const SizedBox(width: 20),
                      _buildSocialButton(
                        icon: Icons.facebook,
                        color: Colors.blue,
                        onTap: () {
                          Get.snackbar(
                            'Facebook Login',
                            'Facebook login coming soon',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                      ),
                      const SizedBox(width: 20),
                      _buildSocialButton(
                        icon: Icons.apple,
                        color: Colors.white,
                        onTap: () {
                          Get.snackbar(
                            'Apple Login',
                            'Apple login coming soon',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  
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
  
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: label,
          size: 16,
          weight: FontWeight.w600,
          color: kwhite,
          paddingBottom: 10,
        ),
        Container(
          decoration: BoxDecoration(
            color: kwhite.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: kwhite.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: TextStyle(
              color: kwhite,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: kwhite.withOpacity(0.7),
              ),
              suffixIcon: suffixIcon,
              hintText: hint,
              hintStyle: TextStyle(
                color: kwhite.withOpacity(0.3),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: kwhite.withOpacity(0.05),
          shape: BoxShape.circle,
          border: Border.all(
            color: kwhite.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: color,
          size: 30,
        ),
      ),
    );
  }
}
