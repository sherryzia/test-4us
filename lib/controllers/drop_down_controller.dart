import 'package:get/get.dart';

class DropDownController extends GetxController {
  RxString selectedOccupation = RxString('Occupation');
  RxString selectedDesiredOccupation = RxString('Desired Occupation');
  RxString selectedDebtType = RxString('Debt type');

  void updateSelectedOccupation(String value) {
    selectedOccupation.value = value;
  }

  void updateSelectedDesiredOccupation(String value) {
    selectedDesiredOccupation.value = value;
  }

  void updateSelectedDebtType(String value) {
    selectedDebtType.value = value;
  }
}
