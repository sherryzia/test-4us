import 'dart:io';

import 'package:affirmation_app/constants/app_colors.dart';
import 'package:affirmation_app/constants/app_fonts.dart';
import 'package:affirmation_app/constants/app_images.dart';
import 'package:affirmation_app/view/screens/auth/sign_up/complete_profile.dart'
    as auth;
import 'package:affirmation_app/view/screens/bottom_nav_bar/affirmation/affirmations_view.dart';
import 'package:affirmation_app/view/screens/bottom_nav_bar/profile/profile.dart';
import 'package:affirmation_app/view/screens/bottom_nav_bar/progress/progress.dart';
import 'package:affirmation_app/view/screens/homescreen/homescreen.dart'
    as home;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavBar extends StatefulWidget {
  final int initialIndex;

  const BottomNavBar({super.key, this.initialIndex = 0});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  Map<String, dynamic>? _userData;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex; // Set the initial index

    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      DocumentSnapshot snapshot =
          await _firestore.collection('userData').doc(_user!.uid).get();
      if (mounted) {
        setState(() {
          _userData = snapshot.data() as Map<String, dynamic>?;
          if (_userData != null) {
            print(_userData!['premium']); // Debug print
          }
        });
      }
    }
  }

  // int _currentIndex = 0;
  final List<Map<String, dynamic>> _items = [
    {
      'label': 'Home',
      'icon': Assets.imagesHome,
    },
    {
      'label': 'Progress',
      'icon': Assets.imagesProgress,
    },
    {
      'label': 'Affirmations',
      'icon': Assets.imagesAffirmation,
    },
    {
      'label': 'Profile',
      'icon': Assets.imagesProfile,
    },
  ];

  void _getCurrentScreen(int index) async {
    if (index == 2) {
      await _fetchUserData();
    }
    setState(() {
      _currentIndex = index;
    });
  }

  // Widget _affirmation() {
  //   return _userData?['premium'] == true
  //       ? AffirmationPersonalized()
  //       : Affirmation();
  // }

  List<Widget> _buildScreens() {
    bool? premium = _userData?['premium'];

    return [
      home.HomeScreenView(),
      ProgressScreen(),
      Affirmation(isPremium: premium ?? false),
      Profile(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: _currentIndex == 2
          ? Container(
              height: Get.height,
              width: Get.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.imagesBackground2),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: IndexedStack(
                      index: _currentIndex,
                      children: _buildScreens(),
                    ),
                  ),
                  _buildBottomNavBar(),
                ],
              ),
            )
          : auth.CustomBackground(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: IndexedStack(
                      index: _currentIndex,
                      children: _buildScreens(),
                    ),
                  ),
                  _buildBottomNavBar(),
                ],
              ),
            ),
    );
  }

  Container _buildBottomNavBar() {
    return Container(
      height: Platform.isIOS ? null : 70,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kGreyColor4.withOpacity(0.1),
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: kGreyColor5.withOpacity(0.16),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _getCurrentScreen,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: kUnSelectedColor,
        selectedLabelStyle: TextStyle(
          fontSize: 8.19,
          fontFamily: AppFonts.MONTSERRAT,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 8.19,
          fontFamily: AppFonts.MONTSERRAT,
        ),
        items: List.generate(
          _items.length,
          (index) {
            return BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: ImageIcon(
                  AssetImage(
                    _items[index]['icon'],
                  ),
                  size: 24,
                ),
              ),
              label: _items[index]['label'],
            );
          },
        ),
      ),
    );
  }
}
