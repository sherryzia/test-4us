
// Updated controllers/bottom_nav_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expensary/views/screens/add_expense_screen.dart';

class BottomNavController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  
  void changeTabIndex(int index) {
    // Adjust index to account for center FAB
    if (index >= 2) {
      selectedIndex.value = index + 1;
    } else {
      selectedIndex.value = index;
    }
  }
  
  void navigateToAddExpense() {
    Get.to(() => AddExpenseScreen());
  }
  
  // Navigation item data
  final List<BottomNavItem> navItems = [
    BottomNavItem(icon: Icons.home, label: 'Home'),
    BottomNavItem(icon: Icons.bar_chart, label: 'Analytics'),
    BottomNavItem(icon: null, label: ''), // Center item for FAB
    BottomNavItem(icon: Icons.auto_graph_sharp, label: 'Statistics'), // Changed from wallet to statistics
    BottomNavItem(icon: Icons.person, label: 'Profile'),
  ];
}

class BottomNavItem {
  final IconData? icon;
  final String label;
  
  BottomNavItem({
    required this.icon,
    required this.label,
  });
}