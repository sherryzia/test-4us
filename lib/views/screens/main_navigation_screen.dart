// views/screens/main_navigation_screen.dart
import 'package:expensary/constants/colors.dart';
import 'package:expensary/controllers/bottom_nav_controller.dart';
import 'package:expensary/views/screens/home_content.dart';
import 'package:expensary/views/widgets/custom_bottom_navbar.dart';
import 'package:expensary/views/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BottomNavController controller = Get.put(BottomNavController());
    
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Obx(() => IndexedStack(
        index: controller.selectedIndex.value,
        children: [
          const HomeContent(), // Home screen content
          _buildPlaceholderScreen('Analytics', Icons.bar_chart),
          _buildPlaceholderScreen('Wallet', Icons.account_balance_wallet),
          _buildPlaceholderScreen('Profile', Icons.person),
        ],
      )),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
  
  Widget _buildPlaceholderScreen(String title, IconData icon) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 80,
                color: kwhite.withOpacity(0.3),
              ),
              const SizedBox(height: 20),
              MyText(
                text: '$title Screen',
                size: 24,
                weight: FontWeight.bold,
                color: kwhite,
              ),
              const SizedBox(height: 10),
              MyText(
                text: 'Coming Soon...',
                size: 16,
                color: kwhite.withOpacity(0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}