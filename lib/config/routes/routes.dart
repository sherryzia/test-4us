import 'package:forus_app/view/auth/forgot_password/forgot_password.dart';
import 'package:get/get.dart';
import 'package:forus_app/view/general/splash_screen.dart';
import 'package:forus_app/view/auth/login_screen.dart';



class AppRoutes {
  static final List<GetPage> pages = [

    GetPage(name: AppLinks.splashScreen, page: () => SplashScreen()),
    GetPage(name: AppLinks.loginScreen, page: () => LoginScreen()),
    GetPage(name: AppLinks.forgotPassword, page: () => ForgotPasswordScreen()),
    // GetPage(name: AppLinks.register_screen, page: () => MyHomePage(title: "4US - Where culture connects",)),

  ];
}


class AppLinks {

  static const splashScreen = '/splash_screen';
  static const loginScreen = '/login';
  static const registerScreen = '/register';
  static const forgotPassword = '/forgot-password';

}
