// lib/views/widgets/custom_bottom_navbar.dart - Fixed with correct indexing
import 'package:expensary/constants/colors.dart';
import 'package:expensary/controllers/bottom_nav_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BottomNavController controller = Get.find<BottomNavController>();
    
    return Container(
      height: 80,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // Bottom navigation background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border(
                  top: BorderSide(
                    color: kwhite.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: kblack.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom navigation items
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Home (index 0)
                _buildNavItem(controller, 0),
                // Analytics (index 1)
                _buildNavItem(controller, 1),
                
                // Center placeholder for FAB
                Container(width: 60),
                
                // Statistics (index 2)
                _buildNavItem(controller, 2),
                // Profile (index 3)
                _buildNavItem(controller, 3),
              ],
            ),
          ),
          
          // Add Transaction FAB - positioned outside of the clipping boundary
          Positioned(
            top: -25,
            child: GestureDetector(
              onTap: () => controller.showAddOptionsBottomSheet(),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF8E2DE2),
                      Color(0xFF4A00E0),
                      Color(0xFF6A1B9A),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF8E2DE2).withOpacity(0.4),
                      blurRadius: 25,
                      offset: Offset(0, 5),
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: Color(0xFF4A00E0).withOpacity(0.3),
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add,
                  color: kwhite,
                  size: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNavItem(BottomNavController controller, int index) {
    // Get the correct nav item based on index
    BottomNavItem item;
    switch (index) {
      case 0:
        item = controller.navItems[0]; // Home
        break;
      case 1:
        item = controller.navItems[1]; // Analytics
        break;
      case 2:
        item = controller.navItems[3]; // Statistics (skip the null item at index 2)
        break;
      case 3:
        item = controller.navItems[4]; // Profile
        break;
      default:
        item = controller.navItems[0];
    }
    
    return Obx(() {
      // Check if this tab is selected
      bool isActive = controller.selectedTabIndex.value == index;
      
      return GestureDetector(
        onTap: () => controller.changeTabIndex(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item.icon,
                color: isActive ? kpurple : kwhite.withOpacity(0.5),
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                item.label,
                style: TextStyle(
                  color: isActive ? kpurple : kwhite.withOpacity(0.5),
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}