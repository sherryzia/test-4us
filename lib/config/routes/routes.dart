
import 'package:get/get.dart';
import '../../view/screens/auth/signin_screen.dart';
import '../../view/screens/auth/signup_screen.dart';
import '../../view/screens/bottom_nav_bar/bottom_nav_bar.dart';
import '../../view/screens/favourite/favourite_screen.dart';
import '../../view/screens/history/history_screen.dart';
import '../../view/screens/home/home_screen.dart';
import '../../view/screens/launch/get_started_screen.dart';
import '../../view/screens/launch/splash_screen.dart';
import '../../view/screens/outcomes/outcome_win_screen.dart';
import '../../view/screens/plan/plan_screen.dart';
import '../../view/screens/settings/account_setting_screen.dart';
import '../../view/screens/settings/setting_screen.dart';
import '../../view/screens/ticket_scanning_screen/instruction_screen.dart';
import '../../view/screens/ticket_scanning_screen/ticket_details_screen.dart';

class AppRoutes {
  static final List<GetPage> pages = [
    GetPage(
      name: AppLinks.splash_screen,
      page: () =>   BottomNavBar(),
    ),
  ];
}

class AppLinks {
  static const splash_screen = '/splash_screen';
}
