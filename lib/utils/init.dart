import 'package:candid/controller/GlobalController.dart';
import 'package:candid/controller/profile_controller.dart';
import 'package:candid/controller/quiz_controller/quiz_controller.dart';
import 'package:candid/utils/app_initialization.dart';
import 'package:candid/utils/dio_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
     
    
  AppInitialization.initialize();

  // Initialize DioUtil first (for API configurations)
  DioUtil.init();
  
  // Initialize GlobalController (needed by other controllers)
  Get.put(GlobalController());
  
  // Initialize other controllers
  Get.put(ProfileController());
  Get.put(QuizController());
}