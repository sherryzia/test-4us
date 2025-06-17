// Updated views/screens/main_navigation_screen.dart
import 'package:expensary/constants/colors.dart';
import 'package:expensary/controllers/bottom_nav_controller.dart';
import 'package:expensary/views/screens/home_content.dart';
import 'package:expensary/views/screens/analytics_screen.dart';
import 'package:expensary/views/screens/statistics_screen.dart';
import 'package:expensary/views/screens/profile_screen.dart'; // Import the new profile screen
import 'package:expensary/views/widgets/custom_bottom_navbar.dart';
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
          const HomeContent(),        // Home screen content
          const AnalyticsScreen(),    // Analytics screen content
          Container(),                // Empty container for center button
          const StatisticsScreen(),   // Statistics screen
          const ProfileScreen(),      // New Profile screen
        ],
      )),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}