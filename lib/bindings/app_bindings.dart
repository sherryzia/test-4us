// lib/bindings/app_binding.dart

import 'package:betting_app/controllers/global_controller.dart';
import 'package:get/get.dart';
import 'package:betting_app/controllers/account_controller.dart';
import 'package:betting_app/controllers/auth_controller.dart';
import 'package:betting_app/controllers/ticket_controller.dart';
import 'package:betting_app/services/auth_service.dart';
import 'package:betting_app/utils/dio_util.dart';
// lib/bindings/app_bindings.dart
// lib/bindings/app_bindings.dart
class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize DioUtil
    DioUtil.init();
    
    // Register services
    Get.put(AuthService(), permanent: true);
    
    // Register global user controller - IMPORTANT: After AuthService
    Get.put(UserController(), permanent: true);
    
    // Register other controllers
    Get.put(AuthController(), permanent: true);
    Get.put(TicketController(), permanent: true);
    Get.put(AccountController(), permanent: true);
  }
}