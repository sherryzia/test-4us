// Fixed views/screens/statistics_screen.dart

import 'package:get/get.dart';

class StatisticsController extends GetxController {
  final RxString selectedTimeFrame = '1W'.obs;
  
  void changeTimeFrame(String timeFrame) {
    selectedTimeFrame.value = timeFrame;
  }
}
