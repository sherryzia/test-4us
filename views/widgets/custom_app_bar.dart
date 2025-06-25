// lib/views/widgets/custom_app_bar.dart - Updated with Profile Navigation
import 'package:expensary/constants/colors.dart';
import 'package:expensary/views/widgets/my_text.dart';
import 'package:expensary/controllers/bottom_nav_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AppBarType {
  withBackButton,
  withTitle,
  withProfile,
  withBackButtonAndProfile
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final AppBarType type;
  final VoidCallback? onProfileTap;
  final VoidCallback? onBackTap;
  final double height;
  final Widget? actionButton;
  final bool hasUnderline;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.type = AppBarType.withTitle,
    this.onProfileTap,
    this.onBackTap,
    this.height = 80.0,
    this.actionButton,
    this.hasUnderline = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: kblack.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left section (back button or empty)
            _buildLeftSection(),
            
            // Center section (title)
            _buildTitleSection(),
            
            // Right section (profile or action button)
            _buildRightSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftSection() {
    if (type == AppBarType.withBackButton || type == AppBarType.withBackButtonAndProfile) {
      return GestureDetector(
        onTap: onBackTap ?? () => Get.back(),
        child: Container(
          width: 40, // Fixed width
          height: 40, // Fixed height
          decoration: BoxDecoration(
            color: kwhite.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: kwhite.withOpacity(0.2),
              width: 1,
            ),
          ),
          // Center the icon in the container
          child: Center(
            child: Icon(
              Icons.arrow_back_ios_new,
              color: kwhite,
              size: 18, // Slightly smaller icon
            ),
          ),
        ),
      );
    } else {
      // Title only or with profile
      return MyText(
        text: title,
        size: 24, // Reduced text size
        weight: FontWeight.bold,
        color: kwhite,
      );
    }
  }

  Widget _buildTitleSection() {
    if (type == AppBarType.withBackButton || type == AppBarType.withBackButtonAndProfile) {
      return Column(
        mainAxisSize: MainAxisSize.min, // Use minimum space
        children: [
          MyText(
            text: title,
            size: 20, // Reduced text size
            weight: FontWeight.bold,
            color: kwhite,
          ),
          if (hasUnderline) ...[
            const SizedBox(height: 4),
            Container(
              width: 40,
              height: 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [kpurple, Color(0xFF8E2DE2)],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ],
      );
    } else {
      // Don't show actionButton here
      return Container();
    }
  }

  Widget _buildRightSection() {
    if (type == AppBarType.withProfile || type == AppBarType.withBackButtonAndProfile) {
      return GestureDetector(
        onTap: onProfileTap ?? _defaultProfileTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [korange, Color(0xFFFF6B35)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: korange.withOpacity(0.3),
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 20, // Slightly smaller
            backgroundColor: Colors.transparent,
            child: Icon(
              Icons.person,
              color: kwhite,
              size: 22, // Slightly smaller icon
            ),
          ),
        ),
      );
    } else {
      // For AppBarType.withTitle or AppBarType.withBackButton
      return actionButton ?? Container(width: 40); // Empty container with same width as back button
    }
  }

  // Default profile tap handler that navigates to profile tab
  void _defaultProfileTap() {
    try {
      final BottomNavController controller = Get.find<BottomNavController>();
      controller.changeTabIndex(3); // Navigate to profile tab (index 3)
    } catch (e) {
      // If controller is not found, just print debug info
      print('BottomNavController not found: $e');
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}