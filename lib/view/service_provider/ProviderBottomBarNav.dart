import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/constants/app_fonts.dart';
import 'package:forus_app/generated/assets.dart';
import 'package:forus_app/view/service_provider/provider_home.dart';
import 'package:forus_app/view/service_provider/provider_messages/provider_messages.dart';
import 'package:forus_app/view/service_provider/provider_settings/provider_setting_main.dart';

class ProviderBottomBarNav extends StatefulWidget {
  @override
  State<ProviderBottomBarNav> createState() => _ProviderBottomBarNavState();
}

class _ProviderBottomBarNavState extends State<ProviderBottomBarNav> {
  late List<Map<String, dynamic>> items;
  int currentIndex = 0;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Get the argument and set initial index
    if (Get.arguments != null) {
      currentIndex = Get.arguments as int;
    }
    updateItems();
  }

  void updateItems() {
    items = [
      {
        'image': currentIndex == 0 ? Assets.imagesHome2 : Assets.imagesHome,
        'label': 'Home',
      },
      {
        'image':
            currentIndex == 1 ? Assets.imagesMessages2 : Assets.imagesMessages,
        'label': 'Message',
      },
      {
        'image':
            currentIndex == 2 ? Assets.imagesProfile2 : Assets.imagesProfile,
        'label': 'Profile',
      },
    ];
  }

  final List<Widget> screens = [
    ProviderHomeScreen(data: false),
    ProviderMessagesScreen(messages: false),
    ProviderSettingMainScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kWhite,
        onTap: (index) {
          setState(() {
            currentIndex = index;
            log(currentIndex.toString());
            updateItems();
          });
        },
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedLabelStyle: TextStyle(
            color: kTextDarkorange2,
            fontFamily: AppFonts.NUNITO_SANS,
            fontWeight: FontWeight.w500,
            fontSize: 12),
        unselectedLabelStyle: TextStyle(
            color: kTextDarkorange3,
            fontFamily: AppFonts.NUNITO_SANS,
            fontWeight: FontWeight.w500,
            fontSize: 12),
        items: List.generate(
          items.length,
          (index) {
            return BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Image.asset(
                  items[index]['image'],
                  height: 24,
                  width: 24,
                ),
              ),
              label: items[index]['label'],
            );
          },
        ),
      ),
    );
  }
}