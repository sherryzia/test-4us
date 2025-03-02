import 'package:get/get.dart';
import 'package:quran_app/MainScreen.dart';
import 'package:quran_app/view/general/splash_screen.dart';
import 'package:quran_app/view/general/onBoarding.dart';

class AppRoutes {
  static final List<GetPage> pages = [
    GetPage(name: AppLinks.splashScreen, page: () => SplashScreen()),
    GetPage(name: AppLinks.generalScreen, page: () => GeneralScreen()),
    GetPage(name: AppLinks.mainScreen, page: () => MainScreen()),
  ];
}

class AppLinks {
  static const splashScreen = '/splash_screen';
  static const generalScreen = '/general_screen';
  static const mainScreen = '/main_screen';
}