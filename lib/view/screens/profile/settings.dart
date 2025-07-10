import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/controller/AuthenticationPointController.dart';
import 'package:candid/main.dart';
import 'package:candid/view/screens/profile/about_us.dart';
import 'package:candid/view/screens/profile/blocked_users.dart';
import 'package:candid/view/screens/profile/delete_account.dart';
import 'package:candid/view/screens/profile/help.dart';
import 'package:candid/view/screens/profile/profile.dart';
import 'package:candid/view/screens/profile/social_links.dart';
import 'package:candid/view/screens/subscription/subscription.dart';
import 'package:candid/view/widget/common_image_view_widget.dart';
import 'package:candid/view/widget/custom_scaffold_widget.dart';
import 'package:candid/view/widget/my_button_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:candid/view/widget/simple_app_bar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          simpleAppBar(
            title: 'Settings',
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: AppSizes.HORIZONTAL,
              physics: BouncingScrollPhysics(),
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Stack(
                        children: [
                          CommonImageView(
                            height: 103,
                            width: 103,
                            radius: 100.0,
                            url: dummyImg,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 32,
                              width: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: kPrimaryColor,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 4),
                                    blurRadius: 12,
                                    color: kBlackColor.withOpacity(0.05),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Image.asset(
                                  Assets.imagesEditPhoto,
                                  height: 18,
                                  color: kSecondaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Image.asset(
                          Assets.imagesAvatarStars,
                          height: 110,
                        ),
                      ),
                    ],
                  ),
                ),
                MyText(
                  paddingTop: 30,
                  text: 'General',
                  size: 14,
                  color: kDarkGreyColor4,
                  paddingBottom: 8,
                ),
                _SettingsTile(
                  icon: Assets.imagesMyProfile,
                  title: 'My Profile',
                  onTap: () {
                    Get.to(() => Profile());
                  },
                ),
                _SettingsTile(
                  icon: Assets.imagesMySubscription,
                  title: 'Subscription',
                  onTap: () {
                    Get.to(() => Subscription());
                  },
                ),
                _SettingsTile(
                  icon: Assets.imagesBuyExtra,
                  title: 'Buy Extras',
                  onTap: () {
                    // Get.to(() => SocialLinks());
                  },
                ),
                _SettingsTile(
                  icon: Assets.imagesSocialLinks,
                  title: 'Link Socials',
                  onTap: () {
                    Get.to(() => SocialLinks());
                  },
                ),
                _SettingsTile(
                  icon: Assets.imagesActivityFeed,
                  title: 'Activity Feed',
                  onTap: () {
                    // Get.to(() => SocialLinks());
                  },
                ),
                MyText(
                  paddingTop: 10,
                  text: 'Visibility',
                  size: 14,
                  color: kDarkGreyColor4,
                  paddingBottom: 8,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 20,
                        color: kBlackColor.withOpacity(0.1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        Assets.imagesEyeIcon,
                        height: 26,
                      ),
                      Expanded(
                        child: MyText(
                          paddingLeft: 8,
                          text: 'Show when you’re active',
                          size: 14,
                          weight: FontWeight.w500,
                          paddingRight: 8,
                        ),
                      ),
                      SizedBox(
                        height: 24,
                        child: Transform.scale(
                          scale: 0.65,
                          alignment: Alignment.centerRight,
                          child: CupertinoSwitch(
                            value: true,
                            onChanged: (v) {},
                            activeColor: kSecondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 20,
                        color: kBlackColor.withOpacity(0.1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        Assets.imagesIncognito,
                        height: 26,
                      ),
                      MyText(
                        paddingLeft: 8,
                        text: 'Incognito',
                        size: 14,
                        weight: FontWeight.w500,
                        paddingRight: 8,
                      ),
                      Image.asset(
                        Assets.imagesProFeature,
                        height: 20,
                      ),
                      Spacer(),
                      SizedBox(
                        height: 24,
                        child: Transform.scale(
                          scale: 0.65,
                          alignment: Alignment.centerRight,
                          child: CupertinoSwitch(
                            value: true,
                            onChanged: (v) {},
                            activeColor: kSecondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 20,
                        color: kBlackColor.withOpacity(0.1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        Assets.imagesIncognito,
                        height: 26,
                      ),
                      MyText(
                        paddingLeft: 8,
                        text: 'Hide my Age',
                        size: 14,
                        weight: FontWeight.w500,
                        paddingRight: 8,
                      ),
                      Image.asset(
                        Assets.imagesProFeature,
                        height: 20,
                      ),
                      Spacer(),
                      SizedBox(
                        height: 24,
                        child: Transform.scale(
                          scale: 0.65,
                          alignment: Alignment.centerRight,
                          child: CupertinoSwitch(
                            value: true,
                            onChanged: (v) {},
                            activeColor: kSecondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                MyText(
                  paddingTop: 10,
                  text: 'Support',
                  size: 14,
                  color: kDarkGreyColor4,
                  paddingBottom: 8,
                ),
                _SettingsTile(
                  icon: Assets.imagesHelpIcon,
                  title: 'Help',
                  onTap: () {
                    Get.to(() => Help());
                  },
                ),
                _SettingsTile(
                  icon: Assets.imagesAboutUs,
                  title: 'About us',
                  onTap: () {
                    Get.to(() => AboutUs());
                  },
                ),
                _SettingsTile(
                  icon: Assets.imagesDeleteAccount,
                  title: 'Delete Account',
                  onTap: () {
                    Get.to(() => DeleteAccount());
                  },
                ),
                _SettingsTile(
                  icon: Assets.imagesBlockedUsers,
                  title: 'Blocked Users',
                  onTap: () {
                    Get.to(() => BlockedUsers());
                  },
                ),
                MyText(
                  paddingTop: 10,
                  text: 'Logout',
                  size: 14,
                  color: kDarkGreyColor4,
                  paddingBottom: 8,
                ),
                _SettingsTile(
                  icon: Assets.imagesHelpIcon,
                  title: 'Logout',
                  onTap: () {
                    Get.put(AuthenticationPointController())
                        .logoutWithConfirmation();
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: MyButton(
              buttonText: 'Update',
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });
  final String icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 20,
              color: kBlackColor.withOpacity(0.1),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(
              icon,
              height: 26,
            ),
            Expanded(
              child: MyText(
                paddingLeft: 8,
                text: title,
                size: 14,
                weight: FontWeight.w500,
              ),
            ),
            Image.asset(
              Assets.imagesRoundedNext,
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}
