import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_fonts.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/view/screens/matches/date_night_events.dart';
import 'package:candid/view/screens/notifications/notifications.dart';
import 'package:candid/view/widget/match_card_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'matches_view.dart';

class Matches extends StatelessWidget {
  const Matches({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> _items = [
      'Matches',
      'Date Night Events',
      'Liked You',
      'You Liked',
    ];
    return DefaultTabController(
      length: _items.length,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: kBottomSheetHandleColor,
        body: NestedScrollView(
          physics: BouncingScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                titleSpacing: 20.0,
                pinned: true,
                floating: false,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        MyText(
                          text: 'Matches',
                          size: 20,
                          weight: FontWeight.w600,
                        ),
                        Positioned(
                          top: -24,
                          left: -10,
                          child: Image.asset(
                            Assets.imagesTitleHearts,
                            height: 41.68,
                          ),
                        ),
                        Positioned(
                          top: -3,
                          right: -10,
                          child: Image.asset(
                            Assets.imagesTitleHeartsFilled,
                            height: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: [
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => Notifications());
                      },
                      child: Image.asset(
                        Assets.imagesNotifications,
                        height: 32,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: Size(0, 30),
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          offset: Offset(0, 2),
                          color: kTertiaryColor.withOpacity(0.1),
                        ),
                      ],
                    ),
                    child: TabBar(
                      labelPadding: AppSizes.HORIZONTAL,
                      isScrollable: true,
                      labelColor: kSecondaryColor,
                      unselectedLabelColor: kHintColor,
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
                            if (e == 'Liked You')
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Image.asset(
                                  Assets.imagesLikedYouImage,
                                  height: 24,
                                ),
                              ),
                            Tab(
                              text: e == 'Liked You' ? 'Liked You (53)' : e,
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: TabBarView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    MatchesView(),
                    DateNightEvents(),
                    LikedYou(),
                    YouLiked(),
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

class LikedYou extends StatelessWidget {
  const LikedYou({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.fromLTRB(20, 16, 20, 100),
      physics: BouncingScrollPhysics(),
      itemCount: 10,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 9 / 13,
        // mainAxisExtent: 193,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return MatchCard(
          isCrushed: index == 0,
          isAway: index == 1,
          isOnline: index == 0,
          isLocked: index != 0,
          index: index,
        );
      },
    );
  }
}

class YouLiked extends StatelessWidget {
  const YouLiked({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.fromLTRB(20, 16, 20, 100),
      physics: BouncingScrollPhysics(),
      itemCount: 10,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 9 / 13,

        // mainAxisExtent: 193,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return MatchCard(
          isCrushed: index == 0,
          isAway: index == 1,
          isOnline: index == 0,
          isLocked: false,
          index: index,
        );
      },
    );
  }
}
