// lib/views/screens/privacy_policy_screen.dart
import 'package:expensary/constants/colors.dart';
import 'package:expensary/views/widgets/custom_app_bar.dart';
import 'package:expensary/views/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        title: 'Privacy Policy',
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
                    color: kblue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kblue.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.update, color: kblue),
                      const SizedBox(width: 12),
                      MyText(
                        text: 'Last updated: December 2024',
                        size: 14,
                        color: kblue,
                        weight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Introduction
                _buildSection(
                  title: 'Introduction',
                  content: 'Welcome to Expensary. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application. Please read this privacy policy carefully. If you do not agree with the terms of this privacy policy, please do not access the application.',
                ),
                
                // Information We Collect
                _buildSection(
                  title: 'Information We Collect',
                  content: '''We may collect information about you in a variety of ways. The information we may collect via the App includes:

Personal Data:
• Name and email address
• Financial data (expenses, income, budgets)
• Device information and usage statistics
• Location data (if enabled)

Automatically Collected Information:
• App usage data and analytics
• Device type and operating system
• IP address and mobile device identifiers
• Crash reports and performance data''',
                ),
                
                // How We Use Information
                _buildSection(
                  title: 'How We Use Your Information',
                  content: '''We use the information we collect to:

• Provide and maintain our service
• Process your transactions and manage your account
• Send you updates and security alerts
• Improve our app and develop new features
• Analyze usage patterns and trends
• Provide customer support
• Comply with legal obligations''',
                ),
                
                // Data Storage and Security
                _buildSection(
                  title: 'Data Storage and Security',
                  content: '''Your data is stored securely using industry-standard encryption. We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.

Local Storage:
• Financial data is primarily stored locally on your device
• We use secure cloud backup services for data synchronization
• You can delete your local data at any time

Cloud Storage:
• We use Supabase for secure cloud storage
• All data is encrypted in transit and at rest
• Regular security audits are performed''',
                ),
                
                // Data Sharing
                _buildSection(
                  title: 'Disclosure of Your Information',
                  content: '''We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except in the following circumstances:

• With your explicit consent
• To comply with legal obligations
• To protect our rights and safety
• To trusted service providers who assist in app operation
• In case of business transfer or merger

We never share your financial data with advertisers or marketing companies.''',
                ),
                
                // Your Rights
                _buildSection(
                  title: 'Your Privacy Rights',
                  content: '''You have the right to:

• Access your personal data
• Correct inaccurate information
• Delete your account and data
• Export your data
• Withdraw consent at any time
• File a complaint with supervisory authorities

To exercise these rights, contact us through the app's support section.''',
                ),
                
                // Third-Party Services
                _buildSection(
                  title: 'Third-Party Services',
                  content: '''Our app may contain links to third-party websites or services. We are not responsible for the privacy practices of these third parties. We encourage you to read their privacy policies.

Third-party services we use:
• Supabase (Database and Authentication)
• Analytics services for app improvement
• Crash reporting services for stability''',
                ),
                
                // Children's Privacy
                _buildSection(
                  title: 'Children\'s Privacy',
                  content: 'Our app is not intended for children under 13 years of age. We do not knowingly collect personal information from children under 13. If we become aware that we have collected personal information from a child under 13, we will take steps to remove that information.',
                ),
                
                // Changes to Privacy Policy
                _buildSection(
                  title: 'Changes to This Privacy Policy',
                  content: 'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last updated" date. You are advised to review this Privacy Policy periodically for any changes.',
                ),
                
                // Contact Information - Removed placeholder content
                _buildSection(
                  title: 'Contact Us',
                  content: '''If you have any questions about this Privacy Policy, please contact us through the app's support section or help center.

We will respond to your inquiries within a reasonable timeframe.''',
                ),
                
                const SizedBox(height: 40),
                
                // Agreement Notice
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: kgreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: kgreen.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.verified_user, color: kgreen, size: 32),
                      const SizedBox(height: 12),
                      MyText(
                        text: 'Your Privacy Matters',
                        size: 18,
                        weight: FontWeight.bold,
                        color: kwhite,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      MyText(
                        text: 'By using Expensary, you agree to this Privacy Policy. We are committed to protecting your privacy and maintaining the security of your financial data.',
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