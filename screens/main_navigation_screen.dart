// lib/views/screens/main_navigation_screen.dart - Updated with Add Screens
import 'package:expensary/constants/colors.dart';
import 'package:expensary/controllers/bottom_nav_controller.dart';
import 'package:expensary/views/screens/home_content.dart';
import 'package:expensary/views/screens/analytics_screen.dart';
import 'package:expensary/views/screens/statistics_screen.dart';
import 'package:expensary/views/screens/profile_screen.dart';
import 'package:expensary/views/screens/add_expense_screen.dart';
import 'package:expensary/views/screens/add_income_screen.dart';
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
        // Include all 6 screens in the IndexedStack with correct mapping
        return IndexedStack(
          index: controller.currentIndex.value,
          children: [
            
             const HomeContent(),        // index 0 - Home screen content
            const AnalyticsScreen(),    // index 1 - Analytics screen content  
            const StatisticsScreen(),   // index 2 - Statistics screen (was index 3)
            const ProfileScreen(),      // index 3 - Profile screen (was index 4)
            const AddExpenseScreen(),   // index 4 - Add Expense screen
            const AddIncomeScreen(),    // index 5 - Add Income screen
          ],
        );
      }),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}