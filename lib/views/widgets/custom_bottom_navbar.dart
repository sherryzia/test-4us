// Updated views/widgets/custom_bottom_navbar.dart
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
        clipBehavior: Clip.none, // This prevents clipping of children
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
                // First two items
                _buildNavItem(controller, 0),
                _buildNavItem(controller, 1),
                
                // Center placeholder for FAB
                Container(width: 60),
                
                // Last two items
                _buildNavItem(controller, 2), // These are indices 2 and 3 in navItems
                _buildNavItem(controller, 3), // But will map to 3 and 4 in the IndexedStack
              ],
            ),
          ),
          
          // Add Expense FAB - positioned outside of the clipping boundary
          Positioned(
            top: -25, // Position it to overlap the navbar without getting clipped
            child: Obx(() {
              // Check if we're on the Add Expense screen (index 2)
              final bool isOnAddExpense = controller.currentIndex.value == 2;
              
              return GestureDetector(
                onTap: () => controller.navigateToAddExpense(),
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
                    // Change color or size when active
                    color: isOnAddExpense ? Colors.yellow : kwhite,
                    size: isOnAddExpense ? 38 : 35,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNavItem(BottomNavController controller, int index) {
    BottomNavItem item = controller.navItems[index == 3 ? 4 : (index == 2 ? 3 : index)];
    
    // Skip middle item (index 2 in navItems)
    if (item.icon == null) return Container(width: 0);
    
    return Obx(() {
      // Check if this tab is selected and we're not on the Add Expense screen
      bool isActive = controller.selectedTabIndex.value == index && controller.currentIndex.value != 2;
      
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