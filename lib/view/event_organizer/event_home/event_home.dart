import 'package:flutter/material.dart';
import 'package:forus_app/view/service_provider/provider_notification.dart';
import 'package:forus_app/view/widget/common_image_view_widget.dart';
import 'package:forus_app/view/widget/eventcard.dart';
import 'package:forus_app/view/widget/my_text_widget.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/constants/app_fonts.dart';
import 'package:forus_app/constants/app_sizes.dart';
import 'package:forus_app/generated/assets.dart';

class EventHomeScreen extends StatefulWidget {
  final bool data;
  const EventHomeScreen({super.key, this.data = true});

  @override
  State<EventHomeScreen> createState() => _EventHomeScreenState();
}

class _EventHomeScreenState extends State<EventHomeScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), _autoScroll);
  }

  void _autoScroll() {
    if (_pageController.hasClients) {
      _currentPage = (_currentPage + 1) % 3;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      Future.delayed(const Duration(seconds: 3), _autoScroll);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemeColors.getTertiary(context),
        title: Row(
          children: [
            CommonImageView(
              imagePath: Assets.imagesAvatar,
              height: 36,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      MyText(
                        text: 'Hello,',
                        size: 18,
                        paddingLeft: 5,
                        textAlign: TextAlign.center,
                        fontFamily: AppFonts.NUNITO_SANS,
                        weight: FontWeight.w300,
                      ),
                      MyText(
                        text: 'Grant',
                        size: 18,
                        paddingLeft: 5,
                        textAlign: TextAlign.center,
                        fontFamily: AppFonts.NUNITO_SANS,
                        weight: FontWeight.w600,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CommonImageView(
                        imagePath: Assets.imagesLocation,
                        height: 16,
                      ),
                      MyText(
                        text: 'Panorama, Riyadh',
                        size: 13,
                        paddingLeft: 5,
                        textAlign: TextAlign.center,
                        fontFamily: AppFonts.NUNITO_SANS,
                        weight: FontWeight.w500,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          InkWell(
            onTap: () {
              Get.to(() => ProviderNotificationsScreens());
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: CommonImageView(
                imagePath: Assets.imagesNotification,
                height: 42,
              ),
            ),
          )
        ],
      ),
      backgroundColor: AppThemeColors.getTertiary(context),
      body: Padding(
        padding: AppSizes.DEFAULT2,
        child: Column(
          children: [
            if (widget.data == true)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonImageView(
                      imagePath: Assets.imagesNodataHome,
                      height: 285,
                    ),
                    MyText(
                      text:
                          "Thank you for showing your interest to be an service provider! Your profile is under verification so we'll notify you once it has been approve.,",
                      size: 18,
                      paddingLeft: 5,
                      paddingRight: 5,
                      textAlign: TextAlign.center,
                      fontFamily: AppFonts.NUNITO_SANS,
                      weight: FontWeight.w300,
                    ),
                  ],
                ),
              )
            else
              Expanded(
                child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 140,
                          child: PageView(
                            padEnds: false,
                            allowImplicitScrolling: true,
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentPage = index;
                              });
                            },
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, top: 10, bottom: 10, right: 10),
                                child: CommonImageView(
                                    imagePath: Assets.imagesImageHome,
                                    fit: BoxFit.cover),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, bottom: 10, right: 10),
                                child: CommonImageView(
                                  imagePath: Assets.imagesImageHome,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, bottom: 10, right: 10),
                                child: CommonImageView(
                                  imagePath: Assets.imagesImageHome,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, bottom: 10, right: 10),
                                child: CommonImageView(
                                  imagePath: Assets.imagesImageHome,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Gap(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            4, // Adjusted to match the PageView count
                            (index) => Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: DotIndicator(
                                isActive: index == _currentPage,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(16),
                    ToggleButtons(),
                    Gap(16),
                    EventCard(),
                    Gap(16),
                    EventCard(),
                    Gap(16),
                    EventCard(),
                    Gap(16),
                    EventCard(),
                    Gap(16),
                    EventCard(),
                    Gap(16),
                    EventCard(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  final bool isActive;
  const DotIndicator({super.key, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      height: 5,
      width: isActive ? 12 : 6,
      decoration: BoxDecoration(
        color: isActive ? kTextDarkorange2 : kborderOrange,
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }
}

class ToggleButtons extends StatefulWidget {
  @override
  _ToggleButtonsState createState() => _ToggleButtonsState();
}

class _ToggleButtonsState extends State<ToggleButtons> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: kDividerGrey),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: _selectedIndex == 0
                      ? LinearGradient(
                          colors: [
                            Color(0xFFE7AF74),
                            Color(0xFFA76B2C),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )
                      : null,
                  color: _selectedIndex == 0 ? null : Colors.transparent,
                ),
                margin: EdgeInsets.all(4),
                child: Center(
                  child: Text(
                    'Upcoming',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedIndex == 0 ? Colors.white : kTextGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: _selectedIndex == 1
                      ? LinearGradient(
                          colors: [
                            Color(0xFFE7AF74),
                            Color(0xFFA76B2C),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )
                      : null,
                  color: _selectedIndex == 1 ? null : Colors.transparent,
                ),
                margin: EdgeInsets.all(4),
                child: Center(
                  child: Text(
                    'Ongoing',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedIndex == 1 ? Colors.white : kTextGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
