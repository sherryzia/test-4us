import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChooseColorController extends GetxController {
  static final ChooseColorController instance =
      Get.find<ChooseColorController>();
  Rx<Color> currentThemeColor = Color(0xffF35656).obs;

  void onUserSelect(Color color) {
    currentThemeColor.value = color;
  }

  @override
  void onInit() {
    super.onInit();
    currentThemeColor.value = Color(0xffF35656);
  }
}
