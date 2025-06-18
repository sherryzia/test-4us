import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expensary/models/expense_item_model.dart';
import 'package:expensary/views/screens/add_expense_screen.dart';
import 'package:expensary/services/supabase_service.dart';
import 'package:expensary/controllers/global_controller.dart';

class HomeController extends GetxController {
  final RxDouble availableBalance = 0.0.obs;
  final RxDouble monthlyBudget = 0.0.obs;
  final RxDouble spentAmount = 0.0.obs;

  double get spentPercentage => monthlyBudget.value > 0
      ? (spentAmount.value / monthlyBudget.value).clamp(0.0, 1.0)
      : 0.0;

  double get availablePercentage => monthlyBudget.value > 0
      ? (availableBalance.value / monthlyBudget.value).clamp(0.0, 1.0)
      : 0.0;

  final RxBool isLoading = false.obs;
  final RxList<TipItem> tips = <TipItem>[].obs;
  final RxList<ExpenseItem> expenses = <ExpenseItem>[].obs;
  final RxInt currentTipIndex = 0.obs;
  Timer? _tipTimer;

  @override
  void onInit() {
    super.onInit();
    loadTips();
    loadData();
    startTipRotation();
  }

  @override
  void onClose() {
    _tipTimer?.cancel();
    super.onClose();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final globalController = Get.find<GlobalController>();
      if (globalController.isAuthenticated.value) {
        final userProfile = globalController.userProfile;
        monthlyBudget.value = userProfile['monthly_budget']?.toDouble() ?? 0.0;

        final expensesData = await SupabaseService.getExpenses(
          userId: globalController.userId,
          limit: 10,
        );

        double spent = 0.0;
        final List<ExpenseItem> expensesList = [];

        for (final expense in expensesData) {
          final amount = (expense['amount'] as num).toDouble();
          if (amount < 0) spent += amount.abs();

          expensesList.add(ExpenseItem(
            title: expense['title'] ?? 'Unknown',
            date: _formatDate(expense['expense_date']),
            amount: amount,
            iconData: expense['icon_data'] ?? 'shopping_bag',
            iconBg: expense['icon_bg'] ?? 'black',
          ));
        }

        expenses.value = expensesList;
        spentAmount.value = spent;
        availableBalance.value = monthlyBudget.value - spentAmount.value;
      }
    } catch (e) {
      Get.find<GlobalController>().handleError(e, customMessage: 'Failed to load data');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadTips() async {
    try {
      final tipsData = await SupabaseService.getFinancialTips();
      final List<TipItem> tipsList = tipsData.map((tip) => TipItem(
        title: tip['title'] ?? 'Tip',
        description: tip['description'] ?? '',
        progress: 0.5,
      )).toList();

      tips.value = tipsList;
    } catch (_) {
      tips.clear();
    }
  }

  void startTipRotation() {
    _tipTimer = Timer.periodic(Duration(seconds: 5), (_) {
      if (tips.isNotEmpty) {
        currentTipIndex.value = (currentTipIndex.value + 1) % tips.length;
      }
    });
  }

  TipItem? get currentTip =>
      tips.isNotEmpty ? tips[currentTipIndex.value] : null;

  void addExpense() => Get.to(() => AddExpenseScreen());

  Future<void> addNewExpense(ExpenseItem expense) async {
    try {
      final globalController = Get.find<GlobalController>();
      if (globalController.isAuthenticated.value) {
        final DateTime now = DateTime.now();
        await SupabaseService.createExpense(
          title: expense.title,
          amount: expense.amount,
          expenseDate: now,
          userId: globalController.userId,
          iconData: expense.iconData,
          iconBg: expense.iconBg,
        );
        await loadData();
        globalController.showSuccess('Expense added successfully!');
      }
    } catch (e) {
      Get.find<GlobalController>().handleError(e, customMessage: 'Failed to add expense');
    }
  }

  void goToNextTip() {
    currentTipIndex.value = (currentTipIndex.value + 1) % tips.length;
    // Reset timer when user manually swipes
    _tipTimer?.cancel();
    startTipRotation();
  }
  
  void goToPreviousTip() {
    currentTipIndex.value = (currentTipIndex.value - 1 + tips.length) % tips.length;
    // Reset timer when user manually swipes
    _tipTimer?.cancel();
    startTipRotation();
  }
  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'Unknown date';
    try {
      final date = DateTime.parse(dateStr);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
    } catch (e) {
      return dateStr;
    }
  }
}

class TipItem {
  final String title;
  final String description;
  final double progress;

  TipItem({
    required this.title,
    required this.description,
    required this.progress,
  });
}
