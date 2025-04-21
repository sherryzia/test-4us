import 'package:ecomanga/utils/utils.dart';

class Urls {
  static final Uri app = Uri.parse(Constants.BASE_URL);
  static final Uri app_status = Uri.parse("${Constants.BASE_URL}/status/");
  static final Uri activity = Uri.parse("${Constants.BASE_URL}/activity/");
  static final Uri auth_google =
      Uri.parse("${Constants.BASE_URL}/auth/google/");
  static final Uri auth_facebook =
      Uri.parse("${Constants.BASE_URL}/auth/facebook/");

  static final Uri auth_login = Uri.parse("${Constants.BASE_URL}/auth/login");

  static final Uri auth_logout =
      Uri.parse("${Constants.BASE_URL}/auth/logout/");
  static final Uri auth_register =
      Uri.parse("${Constants.BASE_URL}/auth/register/");
  static final Uri auth_refresh =
      Uri.parse("${Constants.BASE_URL}/auth/refresh/");
  static final Uri auth_verify =
      Uri.parse("${Constants.BASE_URL}/auth/verify-email/");
  static final Uri auth_passwordForgot =
      Uri.parse("${Constants.BASE_URL}/auth/password/forgot/");
  static final Uri auth_passwordReset =
      Uri.parse("${Constants.BASE_URL}/auth/password/reset/");

  static final String users = "${Constants.BASE_URL}/users/";

  static final Uri profile = Uri.parse("${Constants.BASE_URL}/profile/");
  static final Uri profile_picture =
      Uri.parse("${Constants.BASE_URL}/profile/picture");
  static final Uri profile_follow =
      Uri.parse("${Constants.BASE_URL}/profile/follow");

  static final Uri post = Uri.parse("${Constants.BASE_URL}/post/");
  static Uri postById(int id) => Uri.parse("${Constants.BASE_URL}/post/$id/");
  static Uri commentsById(int id) => Uri.parse(
        "${Constants.BASE_URL}/post/$id/comments/",
      );
}
