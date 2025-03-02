import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/constants/app_colors.dart';
import 'package:quran_app/controllers/navController.dart';
import 'package:quran_app/view/custom_bottom_nav.dart';
import 'package:quran_app/view/widgets/appBar.dart';
import 'package:quran_app/view/widgets/drawer_menu.dart';
import 'package:quran_app/view/widgets/my_text_widget.dart';
import 'package:quran_app/view/bottombar/QiblaPage.dart';
import 'package:quran_app/view/bottombar/bookmarkPage.dart';
import 'package:quran_app/view/bottombar/NamazTimePage.dart';
import 'package:quran_app/view/bottombar/homeScreen.dart';
import 'package:quran_app/view/bottombar/prayerPage.dart';
import 'package:quran_app/view/DuaPage.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//index from arguments
final index = Get.arguments ?? 0;
  // ✅ FIXED: Bottom Navigation Pages
  final List<Widget> bottomPages = [
    const QuranPage(),
    QiblaPage(),
    PrayerPage(),
    DuaPage(),
    NamazTimePage(),
    BookmarkPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: HomeAppBar(
        context: context,
        title: MyText(
          text: 'Quran App',
          color: kDarkPurpleColor,
          size: 20,
          weight: FontWeight.bold,
        ),
        leadingAction: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      drawer: const DrawerMenu(),
      body: Obx(() => bottomPages[Get.find<NavController>().selectedIndex.value]),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
