// lib/views/screens/about_screen.dart - Cleaned version
import 'package:expensary/constants/colors.dart';
import 'package:expensary/views/screens/privacy_policy_screen.dart';
import 'package:expensary/views/screens/terms_conditions_screen.dart';
import 'package:expensary/views/widgets/custom_app_bar.dart';
import 'package:expensary/views/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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
                    'Income tracking and management',
                    'Visual analytics and statistics',
                    'Multiple currency support',
                    'Budget management',
                    'Secure data storage',
                    'Customizable categories and payment methods',
                  ],
                ),
                
                SizedBox(height: 24),
                
                // Technology section (removed placeholder developer name)
                _buildInfoSection(
                  title: 'Technology',
                  items: [
                    'Built with Flutter & Dart',
                    'Material Design with custom themes',
                    'Supabase backend integration',
                    'Local and cloud data synchronization',
                  ],
                ),
                
                SizedBox(height: 24),
                
                // Action buttons section
                _buildActionButtonsSection(),
                
                SizedBox(height: 24),
                
                // Legal information
                _buildInfoSection(
                  title: 'Legal',
                  items: [
                    '© 2024 Expensary. All rights reserved.',
                    'Privacy Policy',
                    'Terms & Conditions',
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
            child: isClickable && (item.contains('Privacy Policy') || item.contains('Terms & Conditions'))
                ? GestureDetector(
                    onTap: () {
                      // Navigate to the respective page
                      if (item.contains('Privacy Policy')) {
                        Get.to(() => PrivacyPolicyScreen());
                      } else if (item.contains('Terms & Conditions')) {
                        Get.to(() => TermsConditionsScreen());
                      }
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
  
  Widget _buildActionButtonsSection() {
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
            text: 'Support Expensary',
            size: 18,
            weight: FontWeight.w600,
            color: kwhite,
          ),
          SizedBox(height: 20),
          
          // Rate app button
          GestureDetector(
            onTap: _rateApp,
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
            onTap: _shareApp,
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
  
  void _rateApp() async {
    // For Android and iOS app store ratings
    try {
      final Uri playStoreUrl = Uri.parse('market://details?id=com.example.expensary');
      final Uri appStoreUrl = Uri.parse('https://apps.apple.com/app/expensary/id123456789');
      
      // Try to open the platform-specific store
      if (GetPlatform.isAndroid) {
        if (await canLaunchUrl(playStoreUrl)) {
          await launchUrl(playStoreUrl);
        } else {
          // Fallback to web version
          final Uri webUrl = Uri.parse('https://play.google.com/store/apps/details?id=com.example.expensary');
          await launchUrl(webUrl, mode: LaunchMode.externalApplication);
        }
      } else if (GetPlatform.isIOS) {
        if (await canLaunchUrl(appStoreUrl)) {
          await launchUrl(appStoreUrl);
        }
      } else {
        // For other platforms, show a message
        Get.snackbar(
          'Rate App',
          'Please rate us on your device\'s app store',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color(0xFFAF4BCE).withOpacity(0.8),
          colorText: kwhite,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to open app store at this time',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: kred.withOpacity(0.8),
        colorText: kwhite,
      );
    }
  }
  
  void _shareApp() async {
    try {
      const String shareText = '''
Check out Expensary - a simple and powerful expense tracking app!

📱 Track expenses and income
📊 Visual analytics and insights  
💰 Multiple currency support
🔒 Secure data storage

Download now and take control of your finances!

Android: https://play.google.com/store/apps/details?id=com.example.expensary
iOS: https://apps.apple.com/app/expensary/id123456789
      ''';
      
      await Share.share(
        shareText,
        subject: 'Check out Expensary - Personal Finance App',
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to share at this time',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: kred.withOpacity(0.8),
        colorText: kwhite,
      );
    }
  }
}