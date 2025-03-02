import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/constants/app_colors.dart';
import 'package:quran_app/controllers/navController.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavBar extends StatelessWidget {
  CustomBottomNavBar({super.key});

  final NavController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: kLightGray.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: (index) {
            controller.changeIndex(index);
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: kDarkPurpleColor,
          unselectedItemColor: kTextSecondary,
          items: [
            _buildNavItem('assets/images/b1.svg', "Quran", 0),
            _buildNavItem('assets/images/compass.svg', "Qibla", 1),
            _buildNavItem('assets/images/b3.svg', "Prayer", 2),
            _buildNavItem('assets/images/dua.svg', "Duas", 3),
            _buildNavItem('assets/images/clock.svg', "Namaz", 4),
            _buildNavItem('assets/images/b5.svg', "Bookmark", 5),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(String assetPath, String label, int index) {
    return BottomNavigationBarItem(
      icon: Obx(() => Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SvgPicture.asset(
              assetPath,
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(
                controller.selectedIndex.value == index ? kDarkPurpleColor : kTextSecondary,
                BlendMode.srcIn,
              ),
            ),
          )),
      label: '',
    );
  }
}
