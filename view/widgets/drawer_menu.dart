import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/MainScreen.dart';
import 'package:quran_app/constants/app_colors.dart';
import 'package:quran_app/controllers/GlobalController.dart';
import 'package:quran_app/controllers/navController.dart';
// import 'package:quran_app/view/ProfilePage.dart'; // ✅ Added ProfilePage
import 'package:quran_app/view/widgets/my_text_widget.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalController globalController = Get.find<GlobalController>();
    final NavController navController = Get.find<NavController>();

    return Drawer(
      backgroundColor: kWhite,
      child: Column(
        children: [
          _buildUserProfileSection(globalController),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  // _buildDrawerItem(Icons.person, "Profile", () => _navigateToPage(() => ProfilePage())), // ✅ Profile Page
                  // const Divider(),
                  _buildDrawerItem(Icons.menu_book, "Quran", () => _navigateToMainScreen(0, navController)),
                  _buildDrawerItem(Icons.explore, "Qibla Finder", () => _navigateToMainScreen(1, navController)),
                  _buildDrawerItem(Icons.mosque, "Prayer", () => _navigateToMainScreen(2, navController)),
                  _buildDrawerItem(Icons.menu_book, "Duas", () => _navigateToMainScreen(3, navController)),
                  _buildDrawerItem(Icons.access_time, "Namaz Time", () => _navigateToMainScreen(4, navController)),
                  _buildDrawerItem(Icons.bookmark, "Bookmarks", () => _navigateToMainScreen(5, navController)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 User Profile Section in Drawer
  Widget _buildUserProfileSection(GlobalController controller) {
    return Container(
      padding: const EdgeInsets.only(top: 50, bottom: 20),
      decoration: BoxDecoration(
        color: kDarkPurpleColor.withOpacity(0.05),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          MyText(
            text: controller.userName.value,
            size: 20,
            weight: FontWeight.bold,
            color: kDarkPurpleColor,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, size: 16, color: kDarkPurpleColor.withOpacity(0.7)),
              const SizedBox(width: 4),
              MyText(
                text: "${controller.userCity.value}, ${controller.userCountry.value}",
                size: 14,
                color: kDarkPurpleColor.withOpacity(0.7),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🔹 Drawer Item Widget (for both Main Tabs & Get.to() Navigation)
  Widget _buildDrawerItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: kDarkPurpleColor),
      title: MyText(text: label, color: kDarkPurpleColor, size: 16, weight: FontWeight.w600),
      onTap: () {
        Get.back(); // ✅ Close Drawer First
        Future.delayed(const Duration(milliseconds: 150), onTap); // ✅ Small delay to avoid UI glitch
      },
    );
  }

  // 🔹 Navigates to MainScreen & Sets BottomNav Index
  void _navigateToMainScreen(int index, NavController navController) {
    navController.changeIndex(index);
    Get.off(() => MainScreen()); // ✅ Prevents backstack issues
  }

  // 🔹 Navigates to a New Page (like Profile) with Get.to()
  void _navigateToPage(Widget Function() page) {
    Get.back(); // ✅ Close Drawer First
    Future.delayed(const Duration(milliseconds: 250), () => Get.to(page()));
  }
}
