// lib/controllers/bottom_nav_controller.dart - Fixed Indexing
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expensary/constants/colors.dart';
import 'package:expensary/views/widgets/my_text.dart';
import 'package:expensary/views/widgets/my_Button.dart';

class BottomNavController extends GetxController {
  // This is the index that will be used for the IndexedStack
  final RxInt currentIndex = 0.obs;
  
  // This is used to track which tab is selected (ignoring center FAB)
  final RxInt selectedTabIndex = 0.obs;
  
  void changeTabIndex(int index) {
    // If the user taps the same tab they're already on, do nothing
    if (selectedTabIndex.value == index && ![4, 5].contains(currentIndex.value)) return;
    
    // Update selected tab index (this is for highlighting the correct nav item)
    selectedTabIndex.value = index;
    
    // Map the tab index to the actual screen index
    // Tab 0 -> Screen 0 (Home)
    // Tab 1 -> Screen 1 (Analytics)  
    // Tab 2 -> Screen 2 (Statistics)
    // Tab 3 -> Screen 3 (Profile)
    currentIndex.value = index;
  }
  
  void navigateToAddExpense() {
    // Navigate to Add Expense screen (index 4)
    currentIndex.value = 4;
    // Don't update selectedTabIndex as this isn't a main tab
  }
  
  void navigateToAddIncome() {
    // Navigate to Add Income screen (index 5)
    currentIndex.value = 5;
    // Don't update selectedTabIndex as this isn't a main tab
  }
  
  // Show bottom sheet with add options
  void showAddOptionsBottomSheet() {
    Get.bottomSheet(
      _buildAddOptionsBottomSheet(),
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
    );
  }
  
  Widget _buildAddOptionsBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFF2A2D40),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: kblack.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: kwhite.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Title
          MyText(
            text: 'Add Transaction',
            size: 22,
            weight: FontWeight.bold,
            color: kwhite,
          ),
          
          const SizedBox(height: 8),
          
          MyText(
            text: 'Choose the type of transaction you want to add',
            size: 14,
            color: kwhite.withOpacity(0.7),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 18),
          
          // Add Expense Option
          _buildOptionButton(
            title: 'Add Expense',
            subtitle: 'Record money spent',
            icon: Icons.remove_circle_outline,
            color: kred,
            onTap: () {
              Get.back(); // Close bottom sheet
              navigateToAddExpense();
            },
          ),
          
          const SizedBox(height: 18),
          
          // Add Income Option
          _buildOptionButton(
            title: 'Add Income',
            subtitle: 'Record money earned',
            icon: Icons.add_circle_outline,
            color: kgreen,
            onTap: () {
              Get.back(); // Close bottom sheet
              navigateToAddIncome();
            },
          ),
          
          const SizedBox(height: 18),
          
          // Cancel Button
          MyButton(
            onTap: () => Get.back(),
            buttonText: 'Cancel',
            width: double.infinity,
            height: 50,
            fillColor: Colors.transparent,
            outlineColor: kwhite.withOpacity(0.2),
            fontColor: kwhite,
            fontSize: 16,
            radius: 25,
            fontWeight: FontWeight.w600,
          ),
          
          // Add bottom padding for safe area
          const SizedBox(height: 4),
        ],
      ),
    );
  }
  
  Widget _buildOptionButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: title,
                    size: 18,
                    weight: FontWeight.bold,
                    color: kwhite,
                  ),
                  const SizedBox(height: 4),
                  MyText(
                    text: subtitle,
                    size: 14,
                    color: kwhite.withOpacity(0.7),
                  ),
                ],
              ),
            ),
            
            // Arrow
            Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: 18,
            ),
          ],
        ),
      ),
    );
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