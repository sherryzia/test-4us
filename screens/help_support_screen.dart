// lib/views/screens/help_support_screen.dart
import 'package:expensary/constants/colors.dart';
import 'package:expensary/controllers/help_support_controller.dart';
import 'package:expensary/views/screens/faqs_screen.dart';
import 'package:expensary/views/widgets/custom_app_bar.dart';
import 'package:expensary/views/widgets/my_Button.dart';
import 'package:expensary/views/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HelpSupportController controller = Get.put(HelpSupportController());
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        title: 'Help & Support',
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
                // Header and description
                MyText(
                  text: 'How can we help you?',
                  size: 24,
                  weight: FontWeight.bold,
                  color: kwhite,
                ),
                SizedBox(height: 8),
                MyText(
                  text: 'Send us your questions or concerns, and our support team will assist you as soon as possible.',
                  size: 14,
                  color: kwhite.withOpacity(0.7),
                  lineHeight: 1.5,
                ),
                
                SizedBox(height: 30),
                
                // Topic Selection
                _buildTopicSection(controller),
                
                SizedBox(height: 24),
                
                // Message Input Section
                _buildMessageSection(controller),
                
                SizedBox(height: 30),
                
                // Send Button
                Obx(() => MyButton(
                  onTap: controller.isLoading.value
                      ? null
                      : controller.sendSupportRequest,
                  buttonText: controller.isLoading.value
                      ? 'Sending...'
                      : 'Send Message',
                  width: double.infinity,
                  height: 56,
                  fillColor: Color(0xFF8E2DE2),
                  fontColor: kwhite,
                  fontSize: 18,
                  radius: 28,
                  hasgrad: true,
                  fontWeight: FontWeight.w600,
                  icon: controller.isLoading.value
                      ? null
                      : Icons.send,
                  iconPosition: IconPosition.right,
                )),
                
                SizedBox(height: 20),
                
                // Additional support options
                _buildSupportOptions(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildTopicSection(HelpSupportController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: 'Topic',
          size: 16,
          weight: FontWeight.w600,
          color: kwhite,
        ),
        SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: kwhite.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: kwhite.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Obx(() => DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: controller.selectedTopic.value,
              dropdownColor: kblack2,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: kwhite.withOpacity(0.7),
              ),
              style: TextStyle(
                color: kwhite,
                fontSize: 16,
              ),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.changeTopic(newValue);
                }
              },
              isExpanded: true,
              items: controller.supportTopics.map<DropdownMenuItem<String>>(
                (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }
              ).toList(),
            ),
          )),
        ),
      ],
    );
  }
  
  Widget _buildMessageSection(HelpSupportController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: 'Your Message',
          size: 16,
          weight: FontWeight.w600,
          color: kwhite,
        ),
        SizedBox(height: 12),
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
            controller: controller.messageController,
            style: TextStyle(
              color: kwhite,
              fontSize: 16,
            ),
            maxLines: 6,
            decoration: InputDecoration(
              hintText: 'Please describe your issue or question in detail...',
              hintStyle: TextStyle(
                color: kwhite.withOpacity(0.5),
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildSupportOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: 'Other ways to get help',
          size: 16,
          weight: FontWeight.w600,
          color: kwhite,
        ),
        SizedBox(height: 16),
        
        // FAQ option
        GestureDetector(
          onTap: () => Get.to(() => FAQsScreen()),
          child: _buildSupportOption(
            icon: Icons.help_outline,
            title: 'Frequently Asked Questions',
            description: 'Browse our FAQ for quick answers to common questions.',
            iconColor: korange,
          ),
        ),
        
        SizedBox(height: 12),
        
        // Email option
        GestureDetector(
          onTap: () {
            // Open email client
            Get.snackbar(
              'Support Email',
              'Opening email client with support@expensary.com',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
          child: _buildSupportOption(
            icon: Icons.email_outlined,
            title: 'Email Support',
            description: 'Email us directly at support@expensary.com',
            iconColor: kblue,
          ),
        ),
      ],
    );
  }
  
  Widget _buildSupportOption({
    required IconData icon,
    required String title,
    required String description,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kblack2.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: kwhite.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  text: title,
                  size: 16,
                  weight: FontWeight.w600,
                  color: kwhite,
                ),
                SizedBox(height: 4),
                MyText(
                  text: description,
                  size: 14,
                  color: kwhite.withOpacity(0.7),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: kwhite.withOpacity(0.5),
            size: 16,
          ),
        ],
      ),
    );
  }
}
