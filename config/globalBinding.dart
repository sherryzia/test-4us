//Global Binding
import 'package:get/get.dart';
import 'package:quran_app/MainScreen.dart';
import 'package:quran_app/controllers/GlobalController.dart';
import 'package:quran_app/controllers/QuranController.dart';
import 'package:quran_app/controllers/navController.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {

  Get.put(GlobalController());
  Get.put(QuranController());
  Get.put(NavController());    
  }
}