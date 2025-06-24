import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/localization/locales/ar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restaurant_finder/localization/locales/en_US.dart';

enum AppLocale { en, ar }

class LanguageController extends GetxController {
  static LanguageController instance = Get.find<LanguageController>();

  Rx<AppLocale> currentLocale = AppLocale.en.obs;
  RxInt currentLanguageIndex = 0.obs;
  RxBool isEnglish = true.obs;

  final Map<AppLocale, String> localeCodes = {
    AppLocale.en: 'en_US',
    AppLocale.ar: 'ar_SA',
  };

  final Map<AppLocale, Locale> locales = {
    AppLocale.en: Locale('en', 'US'),
    AppLocale.ar: Locale('ar', 'SA'),
  };

  final Map<AppLocale, String> languageNames = {
    AppLocale.en: 'English',
    AppLocale.ar: 'العربية',
  };

  static const _languageIndexKey = 'languageKey';
  static const _chooseLanguageFirstTime = 'chooseLanguageFirstTime';
  SharedPreferences? _prefs;

  @override
  void onInit() {
    super.onInit();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final int? savedIndex = _prefs?.getInt(_languageIndexKey);
    if (savedIndex != null && savedIndex < AppLocale.values.length) {
      currentLanguageIndex.value = savedIndex;
      currentLocale.value = AppLocale.values[savedIndex];
      isEnglish.value = savedIndex == AppLocale.en.index;
      Localization().selectedLocale(AppLocale.values[savedIndex]);
    }
  }

  Future<void> onLanguageChanged(AppLocale locale) async {
    currentLocale.value = locale;
    currentLanguageIndex.value = locale.index;
    Localization().selectedLocale(locale);
    await _prefs?.setInt(_languageIndexKey, locale.index);
    isEnglish.value = locale == AppLocale.en;
  }

  String getCurrentLocaleCode() {
    return localeCodes[currentLocale.value] ?? 'en_US';
  }

  Future<void> setFirstLaunch(bool value) async {
    await _prefs?.setBool(_chooseLanguageFirstTime, value);
  }

  bool getIsFirstLaunch() {
    return _prefs?.getBool(_chooseLanguageFirstTime) ?? true;
  }
}

class Localization extends Translations {
  static Locale currentLocale = Locale('en', 'US');
  static Locale fallBackLocale = Locale('en', 'US');

  final Map<AppLocale, Locale> locales = {
    AppLocale.en: Locale('en', 'US'),
    AppLocale.ar: Locale('ar', 'SA'),
  };

  void selectedLocale(AppLocale locale) {
    currentLocale = locales[locale] ?? fallBackLocale;
    Get.updateLocale(currentLocale);
  }

  @override
  Map<String, Map<String, String>> get keys => {'en_US': en_US, 'ar_SA': ar};
}
