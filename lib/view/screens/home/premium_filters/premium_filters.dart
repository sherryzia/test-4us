import 'dart:ui';

import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_fonts.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/view/screens/home/premium_filters/adventure_f.dart';
import 'package:candid/view/screens/home/premium_filters/ambition_f.dart';
import 'package:candid/view/screens/home/premium_filters/heart_beat_f.dart';
import 'package:candid/view/screens/home/premium_filters/high_lights_f.dart';
import 'package:candid/view/screens/home/premium_filters/life_styles_f.dart';
import 'package:candid/view/screens/home/premium_filters/mind_soul_f.dart';
import 'package:candid/view/widget/my_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class PremiumFilters extends StatefulWidget {
  const PremiumFilters({super.key});

  @override
  State<PremiumFilters> createState() => _PremiumFiltersState();
}

class _PremiumFiltersState extends State<PremiumFilters>
    with SingleTickerProviderStateMixin {
  bool showFilters = false;

  late TabController _tabController;
  final List<Map<String, dynamic>> _items = [
    {
      'icon': Assets.imagesHighLightReel,
      'title': 'Highlight Reel',
    },
    {
      'icon': Assets.imagesLifeStyleLowDown,
      'title': 'Lifestyle Lowdown',
    },
    {
      'icon': Assets.imagesAdventureIcon,
      'title': 'Adventure & Chill Zone',
    },
    {
      'icon': Assets.imagesAmbition,
      'title': 'Ambition Alley',
    },
    {
      'icon': Assets.imagesHeartBeats,
      'title': 'Heartbeats & Playlists',
    },
    {
      'icon': Assets.imagesMindIcon,
      'title': 'Mind & Soul Matters',
    },
  ];
  int _currentTab = 0;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _items.length,
      vsync: this,
    );
    _tabController.addListener(() {
      setState(() {
        _currentTab = _tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return !showFilters
        ? _premiumFilterDialog()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 40,
                child: TabBar(
                  controller: _tabController,
                  labelPadding: EdgeInsets.only(right: 20),
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: kPrimaryColor,
                  unselectedLabelColor: kPrimaryColor.withOpacity(0.7),
                  indicatorColor: kSecondaryColor,
                  indicatorWeight: 2,
                  labelStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.URBANIST,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.URBANIST,
                  ),
                  automaticIndicatorColorAdjustment: false,
                  tabs: _items.map((e) {
                    return Stack(
                      children: [
                        Tab(
                          child: Row(
                            children: [
                              Image.asset(
                                e['icon'],
                                height: 20,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                e['title'],
                              ),
                              SizedBox(
                                width: 4,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              IndexedStack(
                index: _currentTab,
                children: [
                  HighLightsF(),
                  LifeStylesF(),
                  AdventureF(),
                  AmbitionF(),
                  HeartBeatF(),
                  MindSoulF(),
                ],
              ),
            ],
          );
  }

  ClipRRect _premiumFilterDialog() {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(12),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 30,
          sigmaY: 30,
        ),
        child: Container(
          padding: AppSizes.DEFAULT,
          decoration: BoxDecoration(
            color: kSecondaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: GradientBoxBorder(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  kSecondaryColor,
                  kPurpleColor,
                ],
              ),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Image.asset(
                Assets.imagesProFilter,
                height: 70,
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          height: 1.5,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: kPrimaryColor,
                          fontFamily: AppFonts.URBANIST,
                        ),
                        children: [
                          TextSpan(
                            text: 'Level up your love game! 💎 Go',
                          ),
                          TextSpan(
                            text: ' Premium ',
                            style: TextStyle(
                              color: kPinkColor2,
                            ),
                          ),
                          TextSpan(text: 'for VIP filter magic ✨,'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: MyButton(
                            height: 35,
                            textSize: 12,
                            buttonText: 'Buy Now',
                            onTap: () {
                              setState(() {
                                showFilters = true;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
