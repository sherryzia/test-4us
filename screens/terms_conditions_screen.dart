// lib/views/screens/terms_conditions_screen.dart
import 'package:expensary/constants/colors.dart';
import 'package:expensary/views/widgets/custom_app_bar.dart';
import 'package:expensary/views/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        title: 'Terms & Conditions',
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Last updated info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kpurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kpurple.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.gavel, color: kpurple),
                      const SizedBox(width: 12),
                      MyText(
                        text: 'Effective Date: December 2024',
                        size: 14,
                        color: kpurple,
                        weight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Introduction
                _buildSection(
                  title: 'Agreement to Terms',
                  content: '''By downloading, installing, or using the Expensary mobile application, you agree to be bound by these Terms and Conditions. If you do not agree to these terms, please do not use our app.

These terms constitute a legally binding agreement between you and Expensary regarding your use of the app and related services.''',
                ),
                
                // App Description
                _buildSection(
                  title: 'Description of Service',
                  content: '''Expensary is a personal finance management application that helps users:

• Track daily expenses and income
• Categorize financial transactions  
• Create and manage budgets
• Generate financial reports and analytics
• Sync data across devices

The app is designed for personal use only and is not intended for commercial financial management.''',
                ),
                
                // User Account
                _buildSection(
                  title: 'User Accounts and Registration',
                  content: '''To use certain features of the app, you must create an account by providing:

• Valid email address
• Secure password
• Personal information as required

You are responsible for:
• Maintaining the confidentiality of your account
• All activities that occur under your account
• Ensuring your information is accurate and up-to-date
• Notifying us immediately of any unauthorized use''',
                ),
                
                // Acceptable Use
                _buildSection(
                  title: 'Acceptable Use Policy',
                  content: '''You agree to use Expensary only for lawful purposes. You must not:

• Use the app for any illegal activities
• Attempt to gain unauthorized access to our systems
• Upload malicious code or viruses
• Share your account credentials with others
• Use the app to track finances that are not your own
• Reverse engineer or decompile the application
• Remove or modify any proprietary notices''',
                ),
                
                // Financial Data
                _buildSection(
                  title: 'Financial Data and Accuracy',
                  content: '''Important Disclaimers:

• You are solely responsible for the accuracy of your financial data
• Expensary does not provide financial advice or recommendations
• The app is for tracking purposes only, not financial planning
• We are not liable for any financial decisions based on app data
• Always consult with qualified financial professionals for advice
• Regularly backup your financial data''',
                ),
                
                // Intellectual Property
                _buildSection(
                  title: 'Intellectual Property Rights',
                  content: '''Expensary and all its content are protected by intellectual property laws:

Our Rights:
• App design, code, and functionality
• Trademarks, logos, and branding
• All proprietary algorithms and features

Your Rights:
• You own the financial data you input
• You may use the app according to these terms
• You can export your data at any time

You may not copy, distribute, or create derivative works without permission.''',
                ),
                
                // Data and Privacy
                _buildSection(
                  title: 'Data Handling and Privacy',
                  content: '''Your privacy is important to us:

• We collect minimal personal information
• Financial data is encrypted and secure
• We do not sell your data to third parties
• You can delete your account and data anytime
• Regular security audits are performed

For detailed information, please review our Privacy Policy, which is incorporated into these terms by reference.''',
                ),
                
                // Service Availability
                _buildSection(
                  title: 'Service Availability and Modifications',
                  content: '''We strive to provide reliable service, but:

• The app may experience downtime or interruptions
• We may modify features with or without notice
• Some features may require internet connectivity
• We reserve the right to discontinue features
• Updates may be required for continued use

We will make reasonable efforts to notify users of major changes.''',
                ),
                
                // Limitation of Liability
                _buildSection(
                  title: 'Limitation of Liability',
                  content: '''To the maximum extent permitted by law:

• Expensary is provided "as is" without warranties
• We are not liable for any financial losses
• Our liability is limited to the fees you paid for the app (if any)
• We are not responsible for data loss or corruption
• You use the app at your own risk

Some jurisdictions do not allow liability limitations, so these may not apply to you.''',
                ),
                
                // Termination
                _buildSection(
                  title: 'Termination',
                  content: '''Either party may terminate this agreement:

You may:
• Stop using the app at any time
• Delete your account and data
• Uninstall the application

We may:
• Suspend or terminate accounts for violations
• Discontinue the service with notice
• Remove content that violates these terms

Upon termination, these terms remain in effect for resolved matters.''',
                ),
                
                // Updates to Terms
                _buildSection(
                  title: 'Changes to Terms',
                  content: '''We may update these Terms and Conditions periodically:

• Changes will be posted in the app
• Continued use constitutes acceptance
• Material changes will be highlighted
• You can view the latest version anytime
• If you disagree with changes, discontinue use

We recommend reviewing these terms regularly.''',
                ),
                
                // Governing Law - Removed placeholder content
                _buildSection(
                  title: 'Governing Law and Disputes',
                  content: '''These terms are governed by applicable local law. Any disputes arising from these terms or your use of the app will be resolved according to the laws of your jurisdiction.

This agreement supersedes all previous agreements between you and Expensary regarding the use of this application.''',
                ),
                
                // Contact Information - Removed placeholder content
                _buildSection(
                  title: 'Contact Information',
                  content: '''For questions about these Terms and Conditions, please contact us through the app's support section or help center.

We will respond to inquiries in a timely manner during business days.''',
                ),
                
                const SizedBox(height: 40),
                
                // Acceptance Notice
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: kpurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: kpurple.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.assignment_turned_in, color: kpurple, size: 32),
                      const SizedBox(height: 12),
                      MyText(
                        text: 'Terms Acceptance',
                        size: 18,
                        weight: FontWeight.bold,
                        color: kwhite,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      MyText(
                        text: 'By using Expensary, you acknowledge that you have read, understood, and agree to these Terms and Conditions. Thank you for choosing Expensary for your financial tracking needs.',
                        size: 14,
                        color: kwhite.withOpacity(0.8),
                        textAlign: TextAlign.center,
                        lineHeight: 1.5,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildSection({
    required String title,
    required String content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            text: title,
            size: 20,
            weight: FontWeight.bold,
            color: kwhite,
          ),
          const SizedBox(height: 12),
          Container(
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
            child: MyText(
              text: content,
              size: 14,
              color: kwhite.withOpacity(0.8),
              lineHeight: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}