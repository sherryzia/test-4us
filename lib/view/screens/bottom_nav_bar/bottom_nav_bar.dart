import 'dart:developer';
import 'dart:io';

import 'package:betting_app/view/screens/plan/plan_screen.dart';
import 'package:betting_app/view/screens/settings/setting_screen.dart';
import 'package:betting_app/view/widgets/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_fonts.dart';
import '../../../generated/assets.dart';
import '../home/home_screen.dart';

class BottomNavBar extends StatefulWidget {
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late List<Map<String, dynamic>> items;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    updateItems();
  }

  void updateItems() {
    items = [
      {
        'image': Assets.imagesHome,
        'label': 'Home',
      },
      {
        'image': Assets.imagesSetting,
        'label': 'Settings',
      },
      {
        'image': Assets.imagesPlan,
        'label': 'Plans',
      },
    ];
  }

  final List<Widget> screens = [
    const HomeScreen(),
    const SettingScreen(),
    const PlanScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(0),
        //height:  62,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, -4),
              spreadRadius: 0,
            )
          ],
        ),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          onTap: (index) {
            setState(() {
              currentIndex = index;
              log(currentIndex.toString());
              updateItems(); // Update items when index changes
            });
          },
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          selectedLabelStyle: TextStyle(
            fontFamily: AppFonts.POPPINS,
            color: kSecondaryColor,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: AppFonts.POPPINS,
            color: kHintColor,
          ),
          selectedItemColor: kSecondaryColor,
          unselectedItemColor: kHintColor,
          items: List.generate(
            items.length,
                (index) {
              return BottomNavigationBarItem(
                tooltip: 'ss',
                activeIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      items[index]['image'],
                      color: kSecondaryColor,
                      width: 27,
                    ),
                    const SizedBox(height: 2), // Space between icon and dot
                    MyText(text: items[index]['label'])
                  ],
                ),
                icon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      items[index]['image'],
                      color: kHintColor,
                      width: 27,
                    ),
                    const SizedBox(height: 2), // Space between icon and dot
                    MyText(text: items[index]['label'])
                  ],
                ),
                label: '',
              );
            },
          ),
        ),
      ),
    );
  }
}
