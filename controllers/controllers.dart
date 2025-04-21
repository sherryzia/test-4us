import 'package:ecomanga/controllers/shared_pref/shared_pref.dart';
import 'package:ecomanga/controllers/profile/profile.dart';
import 'package:ecomanga/controllers/post/posts.dart';
import 'package:ecomanga/controllers/auth/auth.dart';
import 'package:get/get.dart';
export 'auth/auth.dart';

class keys {
  static String getUser = "getUsers";
  static String getProfile = "getProfile";
  static String createPost = "createPost";
  static String getPosts = "getPosts";
  static String getPostById = "getPostById";
  static String getCommentById = "getCommentById";
}

Future<void> initControllers() async {
  await Get.put(PrefController()).initPref();

  Get.put(RegisterController());
  Get.put(LoginController());
  Get.put(PostController());
  Get.put(GoogleController());
  Get.put(FacebookController());
  Get.put(ProfileController());
}

class Controllers {
  static PrefController prefController = Get.find();
  static LoginController loginController = Get.find();
  static ProfileController profileController = Get.find();
  static PostController postController = Get.find();
}
