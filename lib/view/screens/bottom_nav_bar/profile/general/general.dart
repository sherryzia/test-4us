import 'package:affirmation_app/constants/app_sizes.dart';
import 'package:affirmation_app/view/screens/auth/sign_up/complete_profile.dart';
import 'package:affirmation_app/view/screens/bottom_nav_bar/profile/general/chat_view.dart';
import 'package:affirmation_app/view/screens/bottom_nav_bar/profile/general/contact_us.dart';
import 'package:affirmation_app/view/screens/bottom_nav_bar/profile/general/faq_screen.dart';
import 'package:affirmation_app/view/screens/bottom_nav_bar/profile/profile.dart';
import 'package:affirmation_app/view/screens/profile_settings/subscription.dart';
import 'package:affirmation_app/view/widget/my_text_widget.dart';
import 'package:affirmation_app/view/widget/simple_app_bar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class General extends StatelessWidget {
  const General({super.key});

  Future<String> _fetchPrivacyPolicy() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('settings')
        .doc('privacyPolicy')
        .get();

    if (snapshot.exists) {
      return (snapshot.data() as Map<String, dynamic>)?['content'] ??
          'Privacy Policy not found.';
    } else {
      return 'Privacy Policy not found.';
    }
  }

  Future<String> _fetchTermsandConditions() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('settings')
        .doc('termsConditions')
        .get();

    if (snapshot.exists) {
      return (snapshot.data() as Map<String, dynamic>)?['content'] ??
          'Terms and Conditions not found.';
    } else {
      return 'Terms and Conditions not found.';
    }
  }

  void _showPrivacyPolicyDialog(BuildContext context) async {
    String privacyPolicy = await _fetchPrivacyPolicy();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 63, 63, 63).withOpacity(0.4),
          contentTextStyle: TextStyle(color: Colors.white),
          title: Text('Privacy Policy', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Html(
              data: privacyPolicy,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showTermsandConditionsDialog(BuildContext context) async {
    String termsConditions = await _fetchTermsandConditions();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 63, 63, 63).withOpacity(0.4),
          contentTextStyle: TextStyle(color: Colors.white),
          title: Text('Terms and Conditions',
              style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Html(
              data: termsConditions,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: CustomBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SimpleAppBar(
              title: 'General',
              haveLeading: true,
            ),
            Expanded(
              child: ListView(
                padding: AppSize.DEFAULT,
                physics: BouncingScrollPhysics(),
                children: [
                  MyText(
                    text: 'Premium',
                    size: 21,
                    weight: FontWeight.w600,
                    paddingTop: 16,
                    paddingBottom: 26,
                  ),
                  SettingTile(
                    title: 'Manage Subscription',
                    onTap: () {
                      Get.to(
                        () => Subscription(),
                      );
                    },
                  ),
                  MyText(
                    text: 'Customer Support',
                    size: 21,
                    weight: FontWeight.w600,
                    paddingTop: 21,
                    paddingBottom: 8,
                  ),
                  SettingTile(
                    title: 'FAQ’s',
                    onTap: () {
                      Get.to(
                        () => FAQScreen(),
                      );
                    },
                  ),
                  SettingTile(
                    title: 'Contact Us',
                    onTap: () => Get.to(
                      () => contactUsScreen(),
                    ),
                  ),
                  SettingTile(
                    title: 'Chatbot ',
                    onTap: () {
                      Get.to(
                        () => ChatScreen(),
                      );
                    },
                  ),
                  MyText(
                    text: 'Other',
                    size: 21,
                    weight: FontWeight.w600,
                    paddingTop: 21,
                    paddingBottom: 8,
                  ),
                  SettingTile(
                    title: 'Privacy Policy',
                    onTap: () {
                      _showPrivacyPolicyDialog(context);
                    },
                  ),
                  SettingTile(
                    title: 'Terms and Conditions',
                    onTap: () {
                      _showTermsandConditionsDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
