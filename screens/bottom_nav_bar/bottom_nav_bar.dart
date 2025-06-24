import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_images.dart';
import 'package:restaurant_finder/view/screens/explore/explore.dart';
import 'package:restaurant_finder/view/screens/home/home.dart';
import 'package:restaurant_finder/view/screens/saved_restaurants/saved_restaurants.dart';
import 'package:restaurant_finder/view/screens/settings/settings.dart';
import 'package:restaurant_finder/controller/theme_controller.dart';

// ignore: must_be_immutable
class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  void _getCurrentIndex(int index) => setState(() {
    _currentIndex = index;
  });

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    final bool isDark = themeController.isDarkMode;
    final List<Map<String, dynamic>> _items = [
      {'icon': Assets.imagesHome, 'label': 'Home'},
      {'icon': Assets.imagesSave, 'label': 'Save'},
      {'icon': Assets.imagesExplore, 'label': 'Explore'},
      {'icon': Assets.imagesSettings, 'label': 'Settings'},
    ];

    final List<Widget> _screens = [
      Home(),
      SavedRestaurants(),
      Explore(),
      Settings(),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        height: Platform.isIOS ? null : 65,
        decoration: BoxDecoration(
          color:
              isDark
                  ? kDialogBlack
                  : kPrimaryColor, // Use custom black shade in dark mode
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -4),
              blurRadius: 30,
              spreadRadius: -2,
              color: kBlackColor.withOpacity(0.10),
            ),
          ],
        ),
        child: BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
          selectedFontSize: 11,
          unselectedFontSize: 11,
          backgroundColor: Colors.transparent,
          selectedItemColor: kSecondaryColor,
          unselectedItemColor:
              isDark ? kDarkTextColor : kHintColor, // <-- updated
          currentIndex: _currentIndex,
          onTap: (index) => _getCurrentIndex(index),
          items: List.generate(_items.length, (index) {
            var data = _items[index];
            return BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: ImageIcon(AssetImage(data['icon']), size: 22),
              ),
              label: data['label'].toString().tr,
            );
          }),
        ),
      ),
    );
  }
}
