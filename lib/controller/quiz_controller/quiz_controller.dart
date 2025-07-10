import 'package:get/get.dart';

class QuizController extends GetxController {
  static final QuizController instance = Get.find<QuizController>();

  RxBool isQuiz = false.obs;
  RxBool showGames = false.obs;
  RxBool isStart = false.obs;
  RxBool isCompatibilityCheck = true.obs;
  RxBool showAiMagic = false.obs;
  RxBool isNegative = false.obs;
  RxBool isPositive = false.obs;

  onQuizToggle() {
    isQuiz.value = !isQuiz.value;
    isStart = false.obs;
    isCompatibilityCheck = true.obs;
    showAiMagic = false.obs;
    isNegative = false.obs;
    isPositive = false.obs;
  }

  onGamesToggle() {
    showGames.value = !showGames.value;
  }

  onStartQuiz() {
    isStart.value = true;
    isCompatibilityCheck.value = false;
  }

  onShowAiMagic() {
    showAiMagic.value = true;
    isStart.value = false;
    isCompatibilityCheck.value = false;
  }

  showPositiveResults() {
    isPositive.value = true;
    isNegative.value = false;
    showAiMagic.value = false;
    isStart.value = false;
    isCompatibilityCheck.value = false;
  }

  showNegativeResults() {
    isNegative.value = true;
    isPositive.value = false;
    showAiMagic.value = false;
    isStart.value = false;
    isCompatibilityCheck.value = false;
  }
}
