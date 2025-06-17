// Create a new file: views/screens/auth/login_screen.dart
import 'package:expensary/constants/colors.dart';
import 'package:expensary/views/screens/main_navigation_screen.dart';
import 'package:expensary/views/screens/signup_screen.dart';
import 'package:expensary/views/widgets/my_Button.dart';
import 'package:expensary/views/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final RxBool rememberMe = false.obs;
  final RxBool isPasswordVisible = false.obs;
  
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
  
  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }
  
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  
  void login() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      // For now, just navigate to the main screen without any actual authentication
      Get.offAll(() => MainNavigationScreen());
    } else {
      Get.snackbar(
        'Error',
        'Please enter both email and password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
  
  void forgotPassword() {
    // Show a snackbar for now, as we're not implementing the actual logic
    Get.snackbar(
      'Reset Password',
      'Password reset functionality coming soon',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.withOpacity(0.8),
      colorText: Colors.white,
    );
  }
}

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
                  const SizedBox(height: 40),
                  
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
                  
                  const SizedBox(height: 40),
                  
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
                        const SizedBox(height: 10),
                        MyText(
                          text: 'Log in to your Expensary account',
                          size: 16,
                          color: kwhite.withOpacity(0.7),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 50),
                  
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
                  
                  const SizedBox(height: 40),
                  
                  // Login Button
                  MyButton(
                    onTap: controller.login,
                    buttonText: 'Log In',
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
