import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_sizes.dart';
import 'package:restaurant_finder/view/screens/favorites/favorites.dart';
import 'package:restaurant_finder/view/screens/settings/edit_profile.dart';
import 'package:restaurant_finder/view/screens/settings/select_colors.dart';
import 'package:restaurant_finder/view/screens/settings/top_profiles.dart';
import 'package:restaurant_finder/view/screens/subscription/subscription.dart';
import 'package:restaurant_finder/view/widget/custom_app_bar_widget.dart';
import 'package:restaurant_finder/view/widget/custom_check_box_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        haveLeading: false,
        title: 'Settings',
        actions: [
          Center(
            child: MyText(
              text: 'Logout',
              size: 16,
              color: kSecondaryColor,
              weight: FontWeight.w500,
              paddingRight: 20,
            ),
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        children: [
          MyText(
            text: 'General settings',
            size: 16,
            weight: FontWeight.w600,
            paddingBottom: 8,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: kLightGreyColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SettingsTile(
                  title: 'Edit Profile',
                  onTap: () {
                    Get.to(() => EditProfile());
                  },
                ),
                _SettingsTile(
                  title: 'Top Profiles',
                  onTap: () {
                    Get.to(() => TopProfiles());
                  },
                ),
                _SettingsTile(
                  title: 'Favorite Restaurants',
                  onTap: () {
                    Get.to(() => Favorites());
                  },
                ),
                _SettingsTile(
                  title: 'Subscriptions',
                  onTap: () {},
                ),
                _SettingsTile(
                  title: 'Terms & Conditions',
                  onTap: () {},
                ),
                _SettingsTile(
                  title: 'Select App Color',
                  onTap: () {
                    Get.to(() => SelectColors());
                  },
                ),
              ],
            ),
          ),
          MyText(
            paddingTop: 16,
            text: 'Choose language',
            size: 16,
            weight: FontWeight.w600,
            paddingBottom: 8,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: kLightGreyColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...List.generate(2, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: MyText(
                            text: index == 1 ? 'Arabic' : 'English',
                            size: 14,
                            weight: FontWeight.w600,
                          ),
                        ),
                        CustomCheckBox(
                          isRadio: true,
                          isActive: index == 0,
                          onTap: () {},
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          MyText(
            paddingTop: 16,
            text: 'Control center',
            size: 16,
            weight: FontWeight.w600,
            paddingBottom: 8,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: kLightGreyColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: MyText(
                        text: 'Switch to dark mode',
                        size: 14,
                        weight: FontWeight.w600,
                      ),
                    ),
                    Transform.scale(
                      scale: 0.65,
                      alignment: Alignment.centerRight,
                      child: CupertinoSwitch(
                        value: true,
                        onChanged: (v) {},
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: MyText(
                        text: 'Notifications',
                        size: 14,
                        weight: FontWeight.w600,
                      ),
                    ),
                    Transform.scale(
                      scale: 0.65,
                      alignment: Alignment.centerRight,
                      child: CupertinoSwitch(
                        value: true,
                        onChanged: (v) {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () => Get.to(() => Subscription()),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: kBlackColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: MyText(
                            text: 'PRO',
                            color: kPrimaryColor,
                            weight: FontWeight.bold,
                            size: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            MyText(
                              text: 'Upgrade to Premium',
                              size: 16,
                              color: kPrimaryColor,
                              weight: FontWeight.w600,
                              paddingBottom: 10,
                            ),
                            MyText(
                              text: 'This subscription is auto-renewable',
                              size: 14,
                              color: kPrimaryColor,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: kPrimaryColor,
                        size: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.title,
    required this.onTap,
  });
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: MyText(
                text: title,
                size: 14,
                weight: FontWeight.w600,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: kGreyColor,
            ),
          ],
        ),
      ),
    );
  }
}
