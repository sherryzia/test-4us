// lib/views/screens/forgot_password_screen.dart
import 'package:expensary/constants/colors.dart';
import 'package:expensary/controllers/forgot_password_controller.dart';
import 'package:expensary/views/widgets/custom_app_bar.dart';
import 'package:expensary/views/widgets/my_Button.dart';
import 'package:expensary/views/widgets/my_text.dart';
import 'package:expensary/views/widgets/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ForgotPasswordController controller = Get.put(ForgotPasswordController());
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        title: 'Reset Password',
        type: AppBarType.withBackButton,
        hasUnderline: true,
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
              child: Obx(() {
                return controller.currentStep.value == 0
                    ? _buildEmailStep(controller)
                    : _buildResetStep(controller);
              }),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildEmailStep(ForgotPasswordController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        
        // Icon
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
            child: Icon(
              Icons.lock_reset,
              color: kwhite,
              size: 40,
            ),
          ),
        ),
        
        const SizedBox(height: 30),
        
        // Title and Description
        Center(
          child: Column(
            children: [
              MyText(
                text: 'Forgot Password?',
                size: 28,
                weight: FontWeight.bold,
                color: kwhite,
              ),
              const SizedBox(height: 12),
              MyText(
                text: 'Don\'t worry! Enter your email address and we\'ll send you instructions to reset your password.',
                size: 16,
                color: kwhite.withOpacity(0.7),
                textAlign: TextAlign.center,
                lineHeight: 1.5,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 40),
        
        // Email Field
        MyTextField(
          controller: controller.emailController,
          label: 'Email Address',
          hint: 'your.email@example.com',
          prefixIcon: Icon(
            Icons.email_outlined,
            color: kwhite.withOpacity(0.7),
          ),
          keyboardType: TextInputType.emailAddress,
          filledColor: kwhite.withOpacity(0.05),
          bordercolor: kwhite.withOpacity(0.1),
          hintColor: kwhite.withOpacity(0.3),
          marginBottom: 30,
        ),
        
        // Send Reset Email Button
        Obx(() => MyButton(
          onTap: controller.isLoading.value ? null : controller.sendResetEmail,
          buttonText: controller.isLoading.value ? 'Sending...' : 'Send Reset Instructions',
          isLoading: controller.isLoading.value,
          width: double.infinity,
          height: 56,
          fillColor: Color(0xFFAF4BCE),
          fontColor: kwhite,
          fontSize: 18,
          radius: 28,
          fontWeight: FontWeight.w600,
          icon: controller.isLoading.value ? null : Icons.send,
          iconPosition: IconPosition.right,
        )),
        
        const SizedBox(height: 30),
        
        // Back to Login
        Center(
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_back,
                  color: Color(0xFFAF4BCE),
                  size: 18,
                ),
                const SizedBox(width: 8),
                MyText(
                  text: 'Back to Login',
                  size: 16,
                  color: Color(0xFFAF4BCE),
                  weight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 40),
        
        // Help Text
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kwhite.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: kwhite.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                color: kblue,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: 'Need Help?',
                      size: 16,
                      weight: FontWeight.bold,
                      color: kwhite,
                    ),
                    const SizedBox(height: 8),
                    MyText(
                      text: 'If you don\'t receive the email within a few minutes, check your spam folder or contact our support team.',
                      size: 14,
                      color: kwhite.withOpacity(0.7),
                      lineHeight: 1.5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildResetStep(ForgotPasswordController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        
        // Icon
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
            child: Icon(
              Icons.security,
              color: kwhite,
              size: 40,
            ),
          ),
        ),
        
        const SizedBox(height: 30),
        
        // Title and Description
        Center(
          child: Column(
            children: [
              MyText(
                text: 'Reset Your Password',
                size: 28,
                weight: FontWeight.bold,
                color: kwhite,
              ),
              const SizedBox(height: 12),
              MyText(
                text: 'Enter the reset token sent to your email and create a new password.',
                size: 16,
                color: kwhite.withOpacity(0.7),
                textAlign: TextAlign.center,
                lineHeight: 1.5,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 40),
        
        // Reset Token Field
        MyTextField(
          controller: controller.tokenController,
          label: 'Reset Token',
          hint: 'Enter the token from your email',
          prefixIcon: Icon(
            Icons.key,
            color: kwhite.withOpacity(0.7),
          ),
          filledColor: kwhite.withOpacity(0.05),
          bordercolor: kwhite.withOpacity(0.1),
          hintColor: kwhite.withOpacity(0.3),
          marginBottom: 20,
        ),
        
        // New Password Field
        Obx(() => MyTextField(
          controller: controller.newPasswordController,
          label: 'New Password',
          hint: '••••••••',
          prefixIcon: Icon(
            Icons.lock_outline,
            color: kwhite.withOpacity(0.7),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              controller.isNewPasswordVisible.value
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: kwhite.withOpacity(0.7),
            ),
            onPressed: controller.toggleNewPasswordVisibility,
          ),
          isObSecure: !controller.isNewPasswordVisible.value,
          filledColor: kwhite.withOpacity(0.05),
          bordercolor: kwhite.withOpacity(0.1),
          hintColor: kwhite.withOpacity(0.3),
          marginBottom: 20,
        )),
        
        // Confirm Password Field
        Obx(() => MyTextField(
          controller: controller.confirmPasswordController,
          label: 'Confirm New Password',
          hint: '••••••••',
          prefixIcon: Icon(
            Icons.lock_outline,
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
          marginBottom: 30,
        )),
        
        // Reset Password Button
        Obx(() => MyButton(
          onTap: controller.isLoading.value ? null : controller.resetPassword,
          buttonText: controller.isLoading.value ? 'Resetting...' : 'Reset Password',
          isLoading: controller.isLoading.value,
          width: double.infinity,
          height: 56,
          fillColor: Color(0xFFAF4BCE),
          fontColor: kwhite,
          fontSize: 18,
          radius: 28,
          fontWeight: FontWeight.w600,
          icon: controller.isLoading.value ? null : Icons.check,
          iconPosition: IconPosition.right,
        )),
        
        const SizedBox(height: 20),
        
        // Back to Email Step
        Center(
          child: GestureDetector(
            onTap: controller.goBackToEmailStep,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_back,
                  color: Color(0xFFAF4BCE),
                  size: 18,
                ),
                const SizedBox(width: 8),
                MyText(
                  text: 'Back to Email',
                  size: 16,
                  color: Color(0xFFAF4BCE),
                  weight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 30),
        
        // Security Notice
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kwhite.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: kwhite.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.security,
                color: kgreen,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: 'Security Notice',
                      size: 16,
                      weight: FontWeight.bold,
                      color: kwhite,
                    ),
                    const SizedBox(height: 8),
                    MyText(
                      text: 'For your security, the reset token will expire in 15 minutes. Make sure to use a strong password.',
                      size: 14,
                      color: kwhite.withOpacity(0.7),
                      lineHeight: 1.5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}