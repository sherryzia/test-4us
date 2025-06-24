import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_sizes.dart';
import 'package:restaurant_finder/controller/global_controller.dart';
import 'package:restaurant_finder/controller/language_controller.dart';
import 'package:restaurant_finder/view/screens/favorites/favorites.dart';
import 'package:restaurant_finder/view/screens/launch/on_boarding.dart';
import 'package:restaurant_finder/view/screens/saved_restaurants/saved_restaurants.dart';
import 'package:restaurant_finder/view/screens/settings/edit_profile.dart';
import 'package:restaurant_finder/view/screens/settings/select_colors.dart';
import 'package:restaurant_finder/view/screens/settings/top_profiles.dart';
import 'package:restaurant_finder/view/screens/subscription/subscription.dart';
import 'package:restaurant_finder/view/screens/terms_conditions.dart';
import 'package:restaurant_finder/view/widget/custom_app_bar_widget.dart';
import 'package:restaurant_finder/view/widget/custom_check_box_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';
import 'package:restaurant_finder/controller/theme_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Settings extends StatelessWidget {
  Settings({super.key});

  final ThemeController themeController = Get.find<ThemeController>();
  final LanguageController languageController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    final SupabaseClient supabase = Supabase.instance.client;
    final GlobalController globalController = Get.find<GlobalController>();
    
    return Obx(() {
      final isDark = themeController.isDarkMode;
      
      return Scaffold(
        backgroundColor: isDark ? kBlackColor : Colors.white,
        appBar: simpleAppBar(
          haveLeading: false,
          title: 'settings'.tr,
          actions: [
            Center(
              child: MyText(
                onTap: () {
                  supabase.auth.signOut();
                  globalController.clearUserData();
                  Get.offAll(() => OnBoarding());
                },
                text: 'logout'.tr,
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
              text: 'generalSettings'.tr,
              size: 16,
              weight: FontWeight.w600,
              paddingBottom: 8,
              color: isDark ? kTertiaryColor : null,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 9),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: isDark ? kDialogBlack : kLightGreyColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SettingsTile(
                    title: 'editProfile'.tr,
                    onTap: () {
                      Get.to(() => EditProfile());
                    },
                    isDark: isDark,
                  ),
                  _SettingsTile(
                    title: 'topProfiles'.tr,
                    onTap: () {
                      Get.to(() => TopProfiles());
                    },
                    isDark: isDark,
                  ),
                  _SettingsTile(
                    title: 'favoriteRestaurants'.tr,
                    onTap: () {
                      Get.to(() => SavedRestaurants());
                    },
                    isDark: isDark,
                  ),
                  _SettingsTile(
                    title: 'subscriptions'.tr,
                    onTap: () {
                      Get.to(() => Subscription());
                    },
                    isDark: isDark,
                  ),
                  _SettingsTile(
                    title: 'termsAndConditions'.tr,
                    onTap: () {
                      Get.to(() => TermsConditionsScreen());
                    },
                    isDark: isDark,
                  ),
                  _SettingsTile(
                    title: 'selectAppColor'.tr,
                    onTap: () {
                      Get.to(() => SelectColors());
                    },
                    isDark: isDark,
                  ),
                ],
              ),
            ),
            MyText(
              paddingTop: 16,
              text: 'chooseLanguage'.tr,
              size: 16,
              weight: FontWeight.w600,
              paddingBottom: 8,
              color: isDark ? kTertiaryColor : null,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 9),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: isDark ? kDialogBlack : kLightGreyColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(languageController.locales.length, (index) {
                  final AppLocale locale = languageController.locales.keys.elementAt(index);
                  final String languageName = languageController.languageNames[locale] ?? 'Unknown';

                  return Obx(() {
                    final bool isSelected = languageController.currentLanguageIndex.value == index;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: MyText(
                              text: languageName,
                              size: 14,
                              weight: FontWeight.w600,
                              color: isDark ? kDarkTextColor : null,
                            ),
                          ),
                          CustomCheckBox(
                            isRadio: true,
                            isActive: isSelected,
                            onTap: () {
                              languageController.onLanguageChanged(locale);
                            },
                          ),
                        ],
                      ),
                    );
                  });
                }),
              ),
            ),
            MyText(
              paddingTop: 16,
              text: 'controlCenter'.tr,
              size: 16,
              weight: FontWeight.w600,
              paddingBottom: 8,
              color: isDark ? kTertiaryColor : null,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 9),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: isDark ? kDialogBlack : kLightGreyColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: MyText(
                          text: 'switchToDarkMode'.tr,
                          size: 14,
                          weight: FontWeight.w600,
                          color: isDark ? kLightGreyColor : null,
                        ),
                      ),
                      Obx(
                        () => Transform.scale(
                          scale: 0.65,
                          alignment: Alignment.centerRight,
                          child: CupertinoSwitch(
                            value: themeController.isDarkMode,
                            onChanged: (v) => themeController.toggleTheme(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: MyText(
                          text: 'notifications'.tr,
                          size: 14,
                          weight: FontWeight.w600,
                          color: isDark ? kLightGreyColor : null,
                        ),
                      ),
                      Transform.scale(
                        scale: 0.65,
                        alignment: Alignment.centerRight,
                        child: CupertinoSwitch(
                          value: true,
                          onChanged: (v) {
                            // TODO: Implement notification toggle
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () => Get.to(() => Subscription()),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: isDark ? kDialogBlack : kBlackColor,
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
                              text: 'pro'.tr,
                              color: kPrimaryColor,
                              weight: FontWeight.bold,
                              size: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              MyText(
                                text: 'upgradeToPremium'.tr,
                                size: 16,
                                color: kPrimaryColor,
                                weight: FontWeight.w600,
                                paddingBottom: 10,
                              ),
                              MyText(
                                text: 'subscriptionAutoRenewable'.tr,
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
            SizedBox(height: 16),
          ],
        ),
      );
    });
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.title,
    required this.onTap,
    this.isDark = false,
  });
  final String title;
  final VoidCallback onTap;
  final bool isDark;

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
                color: isDark ? kLightGreyColor : null,
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 18, color: kGreyColor),
          ],
        ),
      ),
    );
  }
}