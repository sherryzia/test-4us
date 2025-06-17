// Updated lib/views/screens/main_navigation_screen.dart
import 'package:expensary/constants/colors.dart';
import 'package:expensary/controllers/bottom_nav_controller.dart';
import 'package:expensary/views/screens/home_content.dart';
import 'package:expensary/views/screens/analytics_screen.dart';
import 'package:expensary/views/screens/add_expense_screen.dart'; // Import Add Expense screen
import 'package:expensary/views/screens/statistics_screen.dart';
import 'package:expensary/views/screens/profile_screen.dart';
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
      body: Obx(() {
        // Include Add Expense screen directly in the index stack
        // with a special index (we'll use 2 for Add Expense)
        return IndexedStack(
          index: controller.currentIndex.value,
          children: [
            const HomeContent(),        // index 0 - Home screen content
            const AnalyticsScreen(),    // index 1 - Analytics screen content
            const AddExpenseScreen(),   // index 2 - Add Expense screen
            const StatisticsScreen(),   // index 3 - Statistics screen
            const ProfileScreen(),      // index 4 - Profile screen
          ],
        );
      }),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}