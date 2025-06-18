// lib/views/screens/profile_screen.dart - Updated
import 'package:expensary/constants/colors.dart';
import 'package:expensary/controllers/profile_controller.dart';
import 'package:expensary/views/screens/about_screen.dart';
import 'package:expensary/views/screens/faqs_screen.dart';
import 'package:expensary/views/screens/help_support_screen.dart';
import 'package:expensary/views/widgets/custom_app_bar.dart';
import 'package:expensary/views/widgets/my_Button.dart';
import 'package:expensary/views/widgets/my_text.dart';
import 'package:expensary/views/widgets/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        title: 'Profile',
        type: AppBarType.withTitle,
        actionButton: GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => _buildOptionsMenu(controller),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kwhite.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.more_vert,
              color: kwhite,
              size: 24,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // Profile Image
              _buildProfileImage(context),
              
              const SizedBox(height: 30),
              
              // Personal Information Section
              _buildPersonalInfoSection(controller),
              
              const SizedBox(height: 20),
              
              // Financial Settings Section
              _buildFinancialSection(controller),
              
              const SizedBox(height: 20),
              
              // Password Section
              _buildPasswordSection(controller),
              
              const SizedBox(height: 20),
              
              // Currency Section
              _buildCurrencySection(controller),
              
              const SizedBox(height: 20),
              
              // Danger Zone Section
              _buildDangerZoneSection(controller),
              
              const SizedBox(height: 40),
              
              // Logout Button
              Obx(() => MyButton(
                onTap: controller.isLoading.value ? null : controller.logout,
                buttonText: 'Log Out',
                width: double.infinity,
                height: 56,
                fillColor: Color(0xFF2A2D40),
                fontColor: kwhite,
                fontSize: 18,
                radius: 28,
                fontWeight: FontWeight.w600,
                icon: Icons.logout,
                iconPosition: IconPosition.left,
                isLoading: controller.isLoading.value,
              )),
              
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildProfileImage(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 120,
              height: 120,
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
                child: Icon(
                  Icons.person,
                  color: kwhite,
                  size: 60,
                ),
              ),
            ),
            
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => _buildImageSelectionMenu(),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFFAF4BCE),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: kblack.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: kwhite,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        GetX<ProfileController>(
          builder: (controller) => MyText(
            text: controller.name.value.isNotEmpty ? controller.name.value : 'User',
            size: 24,
            weight: FontWeight.bold,
            color: kwhite,
          ),
        ),
        
        const SizedBox(height: 4),
        
        GetX<ProfileController>(
          builder: (controller) => MyText(
            text: controller.email.value.isNotEmpty ? controller.email.value : 'No email',
            size: 16,
            color: kwhite.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
  
  Widget _buildPersonalInfoSection(ProfileController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF2A2D40),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            text: 'Personal Information',
            size: 18,
            weight: FontWeight.bold,
            color: kwhite,
          ),
          
          const SizedBox(height: 20),
          
          MyTextField(
            label: 'Full Name',
            controller: controller.nameController,
            prefixIcon: Icon(Icons.person, color: kwhite.withOpacity(0.7)),
            bordercolor: kpurple.withOpacity(0.3),
            filledColor: kwhite.withOpacity(0.05),
            hintColor: kwhite.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFinancialSection(ProfileController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF2A2D40),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            text: 'Financial Settings',
            size: 18,
            weight: FontWeight.bold,
            color: kwhite,
          ),
          
          const SizedBox(height: 20),
          
          // Monthly Income Field
          MyTextField(
            label: 'Monthly Income',
            controller: controller.incomeController,
            prefixIcon: Icon(Icons.trending_up, color: kgreen),
            keyboardType: TextInputType.number,
            bordercolor: kgreen.withOpacity(0.3),
            filledColor: kwhite.withOpacity(0.05),
            hintColor: kwhite.withOpacity(0.5),
            hint: 'Enter your monthly income',
          ),
          
          // Monthly Budget Field
          MyTextField(
            label: 'Monthly Budget',
            controller: controller.budgetController,
            prefixIcon: Icon(Icons.account_balance_wallet, color: kblue),
            keyboardType: TextInputType.number,
            bordercolor: kblue.withOpacity(0.3),
            filledColor: kwhite.withOpacity(0.05),
            hintColor: kwhite.withOpacity(0.5),
            hint: 'Enter your monthly budget',
          ),
          
          const SizedBox(height: 20),
          
          Center(
            child: Obx(() => MyButton(
              onTap: controller.isLoading.value ? null : controller.updateProfile,
              buttonText: controller.isLoading.value ? 'Updating...' : 'Update Profile',
              width: 200,
              height: 46,
              fillColor: Color(0xFFAF4BCE),
              fontColor: kwhite,
              fontSize: 16,
              radius: 23,
              fontWeight: FontWeight.w600,
              isLoading: controller.isLoading.value,
            )),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPasswordSection(ProfileController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2D40),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            text: 'Change Password',
            size: 18,
            weight: FontWeight.bold,
            color: kwhite,
          ),

          const SizedBox(height: 20),

          Obx(() => MyTextField(
            label: 'Current Password',
            hint: '••••••••',
            isObSecure: !controller.isCurrentPasswordVisible.value,
            suffixIcon: IconButton(
              icon: Icon(
                controller.isCurrentPasswordVisible.value
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: kwhite.withOpacity(0.7),
              ),
              onPressed: () => controller.isCurrentPasswordVisible.toggle(),
            ),
            bordercolor: kpurple.withOpacity(0.3),
            filledColor: kwhite.withOpacity(0.05),
            controller: controller.currentPasswordController,
          )),

          Obx(() => MyTextField(
            label: 'New Password',
            hint: '••••••••',
            isObSecure: !controller.isNewPasswordVisible.value,
            suffixIcon: IconButton(
              icon: Icon(
                controller.isNewPasswordVisible.value
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: kwhite.withOpacity(0.7),
              ),
              onPressed: () => controller.isNewPasswordVisible.toggle(),
            ),
            bordercolor: kpurple.withOpacity(0.3),
            filledColor: kwhite.withOpacity(0.05),
            controller: controller.newPasswordController,
          )),

          Obx(() => MyTextField(
            label: 'Confirm New Password',
            hint: '••••••••',
            isObSecure: !controller.isConfirmPasswordVisible.value,
            suffixIcon: IconButton(
              icon: Icon(
                controller.isConfirmPasswordVisible.value
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: kwhite.withOpacity(0.7),
              ),
              onPressed: () => controller.isConfirmPasswordVisible.toggle(),
            ),
            bordercolor: kpurple.withOpacity(0.3),
            filledColor: kwhite.withOpacity(0.05),
            controller: controller.confirmPasswordController,
          )),

          const SizedBox(height: 20),

          Center(
            child: Obx(() => MyButton(
              onTap: controller.isLoading.value ? null : controller.updatePassword,
              buttonText: controller.isLoading.value ? 'Updating...' : 'Update Password',
              width: 200,
              height: 46,
              fillColor: const Color(0xFFAF4BCE),
              fontColor: kwhite,
              fontSize: 16,
              radius: 23,
              fontWeight: FontWeight.w600,
              isLoading: controller.isLoading.value,
            )),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCurrencySection(ProfileController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF2A2D40),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            text: 'Currency',
            size: 18,
            weight: FontWeight.bold,
            color: kwhite,
          ),
          
          const SizedBox(height: 20),
          
          GetX<ProfileController>(
            builder: (controller) => Column(
              children: controller.currencies.map((currency) => 
                GestureDetector(
                  onTap: () => controller.changeCurrency(currency),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: controller.currency.value == currency
                          ? Color(0xFFAF4BCE).withOpacity(0.2)
                          : kwhite.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: controller.currency.value == currency
                            ? Color(0xFFAF4BCE)
                            : kwhite.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(
                          text: currency,
                          size: 16,
                          weight: controller.currency.value == currency
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: kwhite,
                        ),
                        if (controller.currency.value == currency)
                          Icon(
                            Icons.check_circle,
                            color: Color(0xFFAF4BCE),
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                ),
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDangerZoneSection(ProfileController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF2A2D40),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: kred.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning,
                color: kred,
                size: 24,
              ),
              const SizedBox(width: 12),
              MyText(
                text: 'Danger Zone',
                size: 18,
                weight: FontWeight.bold,
                color: kred,
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          MyText(
            text: 'These actions are irreversible. Please be careful.',
            size: 14,
            color: kwhite.withOpacity(0.7),
          ),
          
          const SizedBox(height: 20),
          
          Obx(() => MyButton(
            onTap: controller.isLoading.value ? null : controller.resetAllExpenses,
            buttonText: controller.isLoading.value ? 'Resetting...' : 'Reset All Expenses',
            width: double.infinity,
            height: 46,
            fillColor: Colors.transparent,
            outlineColor: kred,
            fontColor: kred,
            fontSize: 16,
            radius: 23,
            fontWeight: FontWeight.w600,
            icon: Icons.delete_forever,
            iconPosition: IconPosition.left,
            isLoading: controller.isLoading.value,
          )),
        ],
      ),
    );
  }
  
  Widget _buildImageSelectionMenu() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF2A2D40),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyText(
            text: 'Change Profile Picture',
            size: 18,
            weight: FontWeight.bold,
            color: kwhite,
          ),
          
          const SizedBox(height: 20),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildImageOptionButton(
                icon: Icons.camera_alt,
                label: 'Camera',
                onTap: () {
                  Get.back();
                  Get.snackbar('Camera', 'Opening camera...');
                },
              ),
              _buildImageOptionButton(
                icon: Icons.photo_library,
                label: 'Gallery',
                onTap: () {
                  Get.back();
                  Get.snackbar('Gallery', 'Opening gallery...');
                },
              ),
              _buildImageOptionButton(
                icon: Icons.delete,
                label: 'Remove',
                onTap: () {
                  Get.back();
                  Get.snackbar('Remove', 'Profile picture removed');
                },
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          MyButton(
            onTap: () => Get.back(),
            buttonText: 'Cancel',
            width: double.infinity,
            height: 46,
            fillColor: Colors.transparent,
            outlineColor: kwhite.withOpacity(0.2),
            fontColor: kwhite,
            fontSize: 16,
            radius: 23,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
  
  Widget _buildImageOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: kwhite.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: kwhite, size: 30),
          ),
          const SizedBox(height: 8),
          MyText(text: label, size: 14, color: kwhite),
        ],
      ),
    );
  }
  
  Widget _buildOptionsMenu(ProfileController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF2A2D40),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyText(
            text: 'Options',
            size: 18,
            weight: FontWeight.bold,
            color: kwhite,
          ),
          
          const SizedBox(height: 20),
          
          _buildOptionItem(
            icon: Icons.help_outline,
            label: 'FAQs',
            onTap: () {
              Get.back();
              Get.to(() => FAQsScreen());
            },
          ),
          
          _buildOptionItem(
            icon: Icons.support_agent,
            label: 'Help & Support',
            onTap: () {
              Get.back();
              Get.to(() => HelpSupportScreen());
            },
          ),
          
          _buildOptionItem(
            icon: Icons.info_outline,
            label: 'About',
            onTap: () {
              Get.back();
              Get.to(() => AboutScreen());
            },
          ),
          
          const SizedBox(height: 10),
          
          MyButton(
            onTap: () => Get.back(),
            buttonText: 'Cancel',
            width: double.infinity,
            height: 46,
            fillColor: Colors.transparent,
            outlineColor: kwhite.withOpacity(0.2),
            fontColor: kwhite,
            fontSize: 16,
            radius: 23,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
  
  Widget _buildOptionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: kwhite.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kwhite.withOpacity(0.1), width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: kwhite, size: 24),
            const SizedBox(width: 20),
            MyText(text: label, size: 16, weight: FontWeight.w500, color: kwhite),
            Spacer(),
            Icon(Icons.arrow_forward_ios, color: kwhite.withOpacity(0.5), size: 16),
          ],
        ),
      ),
    );
  }
}