// controllers/bottom_nav_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  
  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }
  
  // Navigation item data
  final List<BottomNavItem> navItems = [
    BottomNavItem(icon: Icons.home, label: 'Home'),
    BottomNavItem(icon: Icons.bar_chart, label: 'Analytics'),
    BottomNavItem(icon: Icons.account_balance_wallet, label: 'Wallet'),
    BottomNavItem(icon: Icons.person, label: 'Profile'),
  ];
}

class BottomNavItem {
  final IconData icon;
  final String label;
  
  BottomNavItem({
    required this.icon,
    required this.label,
  });
}