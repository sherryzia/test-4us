import 'package:ecomanga/controllers/auth/firebase_auth_controller.dart';
import 'package:ecomanga/controllers/global_controller.dart';
import 'package:ecomanga/controllers/post/posts.dart';
import 'package:ecomanga/controllers/shared_pref/shared_pref.dart';
import 'package:ecomanga/controllers/profile/profile.dart';// Ensure path is correct
import 'package:get/get.dart';

// Export controllers for easier access
export 'global_controller.dart';
export 'auth/firebase_auth_controller.dart';
export 'post/posts.dart';

Future<void> initControllers() async {
  // Initialize SharedPreferences first
  await Get.put(PrefController()).initPref();
  
  // Initialize GlobalController with initialization
  final globalController = Get.put(GlobalController(), permanent: true);
  globalController.onInit();

  // Initialize other controllers
  Get.put(FirebaseAuthController());
  Get.put(FirebasePostController());
  // Get.put(ProfileController());
}

class Controllers {
  // Use consistent getter pattern for all controllers
  static GlobalController get global => GlobalController.to;
  static PrefController get pref => Get.find<PrefController>();
  static FirebaseAuthController get auth => Get.find<FirebaseAuthController>();
  // static ProfileController get profile => Get.find<ProfileController>();
  static FirebasePostController get posts => Get.find<FirebasePostController>();
}