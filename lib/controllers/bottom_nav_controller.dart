// Updated controllers/bottom_nav_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavController extends GetxController {
  // This is the index that will be used for the IndexedStack
  final RxInt currentIndex = 0.obs;
  
  // This is used to track which tab is selected (ignoring center FAB)
  final RxInt selectedTabIndex = 0.obs;
  
  void changeTabIndex(int index) {
    // If the user taps the same tab they're already on, do nothing
    if (selectedTabIndex.value == index && currentIndex.value != 2) return;
    
    // Update selected tab index (this is for highlighting the correct nav item)
    selectedTabIndex.value = index;
    
    // Map the tab index to the actual screen index (accounting for center FAB)
    if (index >= 2) {
      // This maps tabs 2 and 3 to screens 3 and 4 (Statistics and Profile)
      currentIndex.value = index + 1;
    } else {
      // This maps tabs 0 and 1 to screens 0 and 1 (Home and Analytics)
      currentIndex.value = index;
    }
  }
  
  void navigateToAddExpense() {
    // Simply set the current index to the Add Expense screen (index 2)
    currentIndex.value = 2;
  }
  
  // Navigation item data
  final List<BottomNavItem> navItems = [
    BottomNavItem(icon: Icons.home, label: 'Home'),
    BottomNavItem(icon: Icons.bar_chart, label: 'Analytics'),
    BottomNavItem(icon: null, label: ''), // Center item for FAB
    BottomNavItem(icon: Icons.auto_graph_sharp, label: 'Statistics'),
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