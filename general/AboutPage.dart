import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quran_app/constants/app_colors.dart';
// import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String _appVersion = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  // void _launchURL(String url) async {
  //   final Uri uri = Uri.parse(url);
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri, mode: LaunchMode.externalApplication);
  //   } else {
  //     // Show error if URL can't be launched
  //     Get.snackbar(
  //       'Error',
  //       'Could not launch $url',
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundWhite,
      appBar: AppBar(
        backgroundColor: kWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: kDarkPurpleColor, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'About Quran Companion',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: kTextPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App Logo
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: kBackgroundPurpleLight.withOpacity(0.3),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: kShadowColor.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/appIcon.png', // Replace with your app icon
                  width: 100,
                  height: 100,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // App Name and Version
            Text(
              'Quran Companion',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: kDarkPurpleColor,
              ),
            ),
            Text(
              'Version $_appVersion',
              style: TextStyle(
                fontSize: 16,
                color: kTextSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // App Description
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kBackgroundPurpleLight.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Quran Companion is your dedicated app for Quranic learning, '
                'reflection, and spiritual growth. Our mission is to make the '
                'Quran accessible, understandable, and a part of your daily life.',
                style: TextStyle(
                  fontSize: 16,
                  color: kTextPrimary,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),

            // Features Section
            _buildSectionTitle('Key Features'),
            _buildFeatureItem('Comprehensive Quran Recitation'),
            _buildFeatureItem('Detailed Translations'),
            _buildFeatureItem('Tafsir and Insights'),
            _buildFeatureItem('Personalized Learning Paths'),
            const SizedBox(height: 24),

            // Social and Support Links
            // _buildSectionTitle('Connect With Us'),
            // _buildSocialButton(
            //   icon: Icons.language,
            //   label: 'Official Website',
            //   // onTap: () => _launchURL('https://www.qurancompanion.com'),
            // ),
            // _buildSocialButton(
            //   icon: Icons.email_outlined,
            //   label: 'Contact Support',
            //   // onTap: () => _launchURL('mailto:support@qurancompanion.com'),
            // ),
            // _buildSocialButton(
            //   icon: Icons.privacy_tip_outlined,
            //   label: 'Privacy Policy',
            //   // onTap: () => _launchURL('https://www.qurancompanion.com/privacy'),
            // ),
            // const SizedBox(height: 24),

            // Developer Information
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kPurpleColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: kPurpleColor.withOpacity(0.1),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Developed with ❤️ by Shaheer Zia Qazi',
                    style: TextStyle(
                      fontSize: 14,
                      color: kTextSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '© ${DateTime.now().year} All Rights Reserved',
                    style: TextStyle(
                      fontSize: 12,
                      color: kTextSecondary.withOpacity(0.7),
                    ),
                ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: kDarkPurpleColor,
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: kPurpleColor, size: 20),
          const SizedBox(width: 12),
          Text(
            feature,
            style: TextStyle(
              fontSize: 16,
              color: kTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 20),
        label: Text(label),
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: kPurpleColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}