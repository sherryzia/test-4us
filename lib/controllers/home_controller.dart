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
  final RxDouble totalIncome = 0.0.obs; // Added to track income

  // Calculate percentages for the circle chart
  double get spentPercentage {
    // Calculate as a portion of the total 
    double total = monthlyBudget.value + totalIncome.value;
    return total > 0 ? (spentAmount.value / total).clamp(0.0, 1.0) : 0.0;
  }

  double get availablePercentage {
    // Calculate as a portion of the total
    double total = monthlyBudget.value + totalIncome.value;
    return total > 0 ? (availableBalance.value / total).clamp(0.0, 1.0) : 0.0;
  }
  
  double get incomePercentage {
    // Calculate as a portion of the total
    double total = monthlyBudget.value + totalIncome.value;
    return total > 0 ? (totalIncome.value / total).clamp(0.0, 1.0) : 0.0;
  }

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
        double income = 0.0; // Track income
        final List<ExpenseItem> expensesList = [];

        for (final expense in expensesData) {
          final amount = (expense['amount'] as num).toDouble();
          // Get the category from the database or determine from title
          String category = expense['category'] ?? 
                        getCategoryFromMerchant(expense['title'] ?? 'Unknown');
          
          if (amount < 0) {
            spent += amount.abs(); // Add to spent amount if negative
          } else {
            income += amount; // Add to income if positive
          }

          expensesList.add(ExpenseItem(
            title: expense['title'] ?? 'Unknown',
            date: _formatDate(expense['expense_date']),
            amount: amount,
            iconData: expense['icon_data'] ?? 'shopping_bag',
            iconBg: expense['icon_bg'] ?? 'black',
            category: category, // Include the category
          ));
        }

        expenses.value = expensesList;
        spentAmount.value = spent;
        totalIncome.value = income; // Set the income value
        // Update balance calculation to include income
        availableBalance.value = monthlyBudget.value + totalIncome.value - spentAmount.value;
      }
    } catch (e) {
      Get.find<GlobalController>().handleError(e, customMessage: 'Failed to load data');
    } finally {
      isLoading.value = false;
    }
  }

  // Helper function to determine category from merchant name
  String getCategoryFromMerchant(String merchantName) {
    if (['Amazon', 'Nike Air Max 2090'].contains(merchantName)) {
      return 'Shopping';
    } else if (['McDonalds', 'Starbucks'].contains(merchantName)) {
      return 'Food & Dining';
    } else if (['iPad Pro', 'iPhone', 'Apple'].contains(merchantName)) {
      return 'Electronics';
    } else if (['Mastercard', 'Visa'].contains(merchantName)) {
      return 'Bills & Utilities';
    } else if (['Uber'].contains(merchantName)) {
      return 'Transportation';
    } else if (['Spotify', 'Netflix'].contains(merchantName)) {
      return 'Entertainment';
    }
    return 'Other';
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
          category: expense.category, // Pass the category to the service
        );
        await loadData(); // Reload data to include the new expense
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