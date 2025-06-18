// lib/views/screens/about_screen.dart
import 'package:expensary/constants/colors.dart';
import 'package:expensary/views/widgets/custom_app_bar.dart';
import 'package:expensary/views/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // App version
    const String appVersion = '1.0.0';
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        title: 'About',
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
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // App logo
                Container(
                  width: 100,
                  height: 100,
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
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: 20),
                
                // App name
                MyText(
                  text: 'Expensary',
                  size: 28,
                  weight: FontWeight.bold,
                  color: kwhite,
                ),
                
                SizedBox(height: 8),
                
                // App version
                MyText(
                  text: 'Version $appVersion',
                  size: 16,
                  color: kwhite.withOpacity(0.7),
                ),
                
                SizedBox(height: 30),
                
                // App description
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: kblack2.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: kwhite.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: MyText(
                    text: 'Expensary is a personal finance app designed to help you track your expenses, manage your budget, and gain insights into your spending habits. With an intuitive interface and powerful features, Expensary makes it easy to stay on top of your finances.',
                    size: 14,
                    color: kwhite.withOpacity(0.8),
                    lineHeight: 1.6,
                  ),
                ),
                
                SizedBox(height: 30),
                
                // Features section
                _buildInfoSection(
                  title: 'Key Features',
                  items: [
                    'Expense tracking with categories',
                    'Visual analytics and statistics',
                    'Multiple currency support',
                    'Budget management',
                    'Secure local data storage',
                    'Customizable categories and payment methods',
                  ],
                ),
                
                SizedBox(height: 24),
                
                // Developer info
                _buildInfoSection(
                  title: 'Development',
                  items: [
                    'Developed by: Your Name',
                    'Technology: Flutter & Dart',
                    'Design: Material Design with custom themes',
                    'Backend: Firebase',
                  ],
                ),
                
                SizedBox(height: 24),
                
                // Social and links
                _buildLinksSection(),
                
                SizedBox(height: 24),
                
                // Legal information
                _buildInfoSection(
                  title: 'Legal',
                  items: [
                    '© 2023 Expensary. All rights reserved.',
                    'Privacy Policy',
                    'Terms of Service',
                  ],
                  isClickable: true,
                ),
                
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildInfoSection({
    required String title,
    required List<String> items,
    bool isClickable = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kblack2.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: kwhite.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            text: title,
            size: 18,
            weight: FontWeight.w600,
            color: kwhite,
          ),
          SizedBox(height: 16),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: isClickable && (item.contains('Privacy Policy') || item.contains('Terms of Service'))
                ? GestureDetector(
                    onTap: () {
                      // Navigate to the respective page
                      Get.snackbar(
                        'Navigation',
                        'Navigating to $item',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: MyText(
                            text: item,
                            size: 14,
                            color: kblue,
                            weight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Icon(
                          Icons.open_in_new,
                          color: kblue,
                          size: 16,
                        ),
                      ],
                    ),
                  )
                : MyText(
                    text: item,
                    size: 14,
                    color: kwhite.withOpacity(0.8),
                    lineHeight: 1.5,
                  ),
          )).toList(),
        ],
      ),
    );
  }
  
  Widget _buildLinksSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kblack2.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: kwhite.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            text: 'Connect With Us',
            size: 18,
            weight: FontWeight.w600,
            color: kwhite,
          ),
          SizedBox(height: 20),
          
          // Social media links
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialButton(
                icon: Icons.language,
                label: 'Website',
                color: Color(0xFF4A00E0),
                onTap: () {
                  Get.snackbar(
                    'Website',
                    'Opening Expensary website',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
              _buildSocialButton(
                icon: Icons.facebook,
                label: 'Facebook',
                color: Color(0xFF1877F2),
                onTap: () {
                  Get.snackbar(
                    'Facebook',
                    'Opening Facebook page',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
              _buildSocialButton(
                icon: Icons.telegram,
                label: 'Twitter',
                color: Color(0xFF1DA1F2),
                onTap: () {
                  Get.snackbar(
                    'Twitter',
                    'Opening Twitter page',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
              _buildSocialButton(
                icon: Icons.insert_link,
                label: 'LinkedIn',
                color: Color(0xFF0077B5),
                onTap: () {
                  Get.snackbar(
                    'LinkedIn',
                    'Opening LinkedIn page',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
            ],
          ),
          
          SizedBox(height: 20),
          
          // Rate app button
          GestureDetector(
            onTap: () {
              Get.snackbar(
                'Rate App',
                'Opening app store to rate Expensary',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Color(0xFFAF4BCE).withOpacity(0.2),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Color(0xFFAF4BCE),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star,
                    color: Color(0xFFAF4BCE),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  MyText(
                    text: 'Rate This App',
                    size: 16,
                    weight: FontWeight.w600,
                    color: kwhite,
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 12),
          
          // Share app button
          GestureDetector(
            onTap: () {
              Get.snackbar(
                'Share App',
                'Opening share options',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: kwhite.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.share,
                    color: kwhite,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  MyText(
                    text: 'Share With Friends',
                    size: 16,
                    weight: FontWeight.w600,
                    color: kwhite,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          SizedBox(height: 8),
          MyText(
            text: label,
            size: 12,
            color: kwhite.withOpacity(0.8),
          ),
        ],
      ),
    );
  }
}