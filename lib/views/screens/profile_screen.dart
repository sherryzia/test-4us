// Create a new file: views/screens/profile_screen.dart
import 'package:expensary/constants/colors.dart';
import 'package:expensary/controllers/profile_controller.dart';
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
    
    return SafeArea(
      child: Column(
        children: [
          // Header Section
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                  text: 'Profile',
                  size: 36,
                  weight: FontWeight.bold,
                  color: kwhite,
                ),
                GestureDetector(
                  onTap: () {
                    // Show options menu
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
              ],
            ),
          ),
          
          // Content area
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    // Profile Image
                    _buildProfileImage(context),
                    
                    const SizedBox(height: 30),
                    
                    // Profile Information Sections
                    _buildPersonalInfoSection(controller),
                    
                    const SizedBox(height: 20),
                    
                    _buildPasswordSection(controller),
                    
                    const SizedBox(height: 20),
                    
                    _buildCurrencySection(controller),
                    
                    const SizedBox(height: 40),
                    
                    // Logout Button
                    MyButton(
                      onTap: controller.logout,
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
                    ),
                    
                    const SizedBox(height: 100), // Space for bottom navigation
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProfileImage(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            // Profile Image
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
            
            // Edit Button
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  // Show image selection options
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
        
        // User Name
        GetX<ProfileController>(
          builder: (controller) => MyText(
            text: controller.name.value,
            size: 24,
            weight: FontWeight.bold,
            color: kwhite,
          ),
        ),
        
        const SizedBox(height: 4),
        
        // User Email
        GetX<ProfileController>(
          builder: (controller) => MyText(
            text: controller.email.value,
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
          
          // Name Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                text: 'Full Name',
                size: 14,
                color: kwhite.withOpacity(0.7),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: kwhite.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: kwhite.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: controller.nameController,
                  style: TextStyle(
                    color: kwhite,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    hintStyle: TextStyle(
                      color: kwhite.withOpacity(0.5),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Save Button
          Center(
            child: MyButton(
              onTap: controller.updateName,
              buttonText: 'Save Changes',
              width: 200,
              height: 46,
              fillColor: Color(0xFFAF4BCE),
              fontColor: kwhite,
              fontSize: 16,
              radius: 23,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPasswordSection(ProfileController controller) {
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
            text: 'Change Password',
            size: 18,
            weight: FontWeight.bold,
            color: kwhite,
          ),
          
          const SizedBox(height: 20),
          
          // Current Password Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                text: 'Current Password',
                size: 14,
                color: kwhite.withOpacity(0.7),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: kwhite.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: kwhite.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: controller.currentPasswordController,
                  obscureText: true,
                  style: TextStyle(
                    color: kwhite,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    hintStyle: TextStyle(
                      color: kwhite.withOpacity(0.5),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // New Password Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                text: 'New Password',
                size: 14,
                color: kwhite.withOpacity(0.7),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: kwhite.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: kwhite.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: controller.newPasswordController,
                  obscureText: true,
                  style: TextStyle(
                    color: kwhite,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    hintStyle: TextStyle(
                      color: kwhite.withOpacity(0.5),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Confirm Password Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                text: 'Confirm New Password',
                size: 14,
                color: kwhite.withOpacity(0.7),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: kwhite.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: kwhite.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: controller.confirmPasswordController,
                  obscureText: true,
                  style: TextStyle(
                    color: kwhite,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    hintStyle: TextStyle(
                      color: kwhite.withOpacity(0.5),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Update Button
          Center(
            child: MyButton(
              onTap: controller.updatePassword,
              buttonText: 'Update Password',
              width: 200,
              height: 46,
              fillColor: Color(0xFFAF4BCE),
              fontColor: kwhite,
              fontSize: 16,
              radius: 23,
              fontWeight: FontWeight.w600,
            ),
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
          
          // Currency Selection
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
                  Get.snackbar(
                    'Camera',
                    'Opening camera...',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
              _buildImageOptionButton(
                icon: Icons.photo_library,
                label: 'Gallery',
                onTap: () {
                  Get.back();
                  Get.snackbar(
                    'Gallery',
                    'Opening gallery...',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
              _buildImageOptionButton(
                icon: Icons.delete,
                label: 'Remove',
                onTap: () {
                  Get.back();
                  Get.snackbar(
                    'Remove',
                    'Profile picture removed',
                    snackPosition: SnackPosition.BOTTOM,
                  );
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
            child: Icon(
              icon,
              color: kwhite,
              size: 30,
            ),
          ),
          
          const SizedBox(height: 8),
          
          MyText(
            text: label,
            size: 14,
            color: kwhite,
          ),
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
            icon: Icons.help,
            label: 'FAQs',
            onTap: () {
              Get.back();
              Get.snackbar(
                'FAQs',
                'FAQs coming soon',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
          
          _buildOptionItem(
            icon: Icons.help,
            label: 'Help & Support',
            onTap: () {
              Get.back();
              Get.snackbar(
                'Help & Support',
                'Help & Support coming soon',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
          
          _buildOptionItem(
            icon: Icons.info,
            label: 'About',
            onTap: () {
              Get.back();
              Get.snackbar(
                'About',
                'About page coming soon',
                snackPosition: SnackPosition.BOTTOM,
              );
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
          border: Border.all(
            color: kwhite.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: kwhite,
              size: 24,
            ),
            
            const SizedBox(width: 20),
            
            MyText(
              text: label,
              size: 16,
              weight: FontWeight.w500,
              color: kwhite,
            ),
            
            Spacer(),
            
            Icon(
              Icons.arrow_forward_ios,
              color: kwhite.withOpacity(0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
