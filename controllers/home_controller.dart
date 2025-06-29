
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
  final RxDouble totalIncome = 0.0.obs;
  
  // Store original amounts in base currency for conversion
  final RxMap<String, double> originalAmounts = <String, double>{
    'monthlyBudget': 0.0,
    'spentAmount': 0.0,
    'totalIncome': 0.0,
  }.obs;
  
  // Store original expense data with their original currency and amounts
  final RxList<Map<String, dynamic>> originalExpenseData = <Map<String, dynamic>>[].obs;
  final RxString currentDisplayCurrency = 'PKR'.obs;
  final RxString originalDataCurrency = 'PKR'.obs; // Track the currency of original data

  // Calculate percentages for the circle chart
  double get spentPercentage {
    double total = monthlyBudget.value + totalIncome.value;
    return total > 0 ? (spentAmount.value / total).clamp(0.0, 1.0) : 0.0;
  }

  double get availablePercentage {
    double total = monthlyBudget.value + totalIncome.value;
    return total > 0 ? (availableBalance.value / total).clamp(0.0, 1.0) : 0.0;
  }
  
  double get incomePercentage {
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
    
    // Listen to global controller currency changes
    ever(Get.find<GlobalController>().currentCurrency, (String newCurrency) {
      if (currentDisplayCurrency.value != newCurrency) {
        _convertAllAmountsToCurrency(currentDisplayCurrency.value, newCurrency);
        currentDisplayCurrency.value = newCurrency;
      }
    });
  }

  @override
  void onClose() {
    _tipTimer?.cancel();
    super.onClose();
  }

  // Enhanced conversion method that properly handles original data
  void _convertAllAmountsToCurrency(String fromCurrency, String toCurrency) {
    if (fromCurrency == toCurrency) return;
    
    final globalController = Get.find<GlobalController>();
    
    // Convert main amounts using original stored values
    if (originalAmounts['monthlyBudget']! > 0) {
      monthlyBudget.value = globalController.convertCurrency(
        originalAmounts['monthlyBudget']!, originalDataCurrency.value, toCurrency
      );
    }
    
    if (originalAmounts['spentAmount']! > 0) {
      spentAmount.value = globalController.convertCurrency(
        originalAmounts['spentAmount']!, originalDataCurrency.value, toCurrency
      );
    }
    
    if (originalAmounts['totalIncome']! > 0) {
      totalIncome.value = globalController.convertCurrency(
        originalAmounts['totalIncome']!, originalDataCurrency.value, toCurrency
      );
    }
    
    // Recalculate available balance
    availableBalance.value = monthlyBudget.value + totalIncome.value - spentAmount.value;
    
    // Convert expense items using original data
    List<ExpenseItem> convertedExpenses = [];
    for (var originalExpense in originalExpenseData) {
      final originalAmount = (originalExpense['amount'] as num).toDouble();
      final convertedAmount = globalController.convertCurrency(
        originalAmount.abs(), originalDataCurrency.value, toCurrency
      );
      
      convertedExpenses.add(ExpenseItem(
        title: originalExpense['title'] ?? 'Unknown',
        date: _formatDate(originalExpense['expense_date']),
        amount: originalAmount < 0 ? -convertedAmount : convertedAmount,
        iconData: originalExpense['icon_data'] ?? 'shopping_bag',
        iconBg: originalExpense['icon_bg'] ?? 'black',
        category: originalExpense['category'] ?? getCategoryFromMerchant(originalExpense['title'] ?? 'Unknown'),
      ));
    }
    
    expenses.value = convertedExpenses;
    
    debugPrint('Converted amounts from $fromCurrency to $toCurrency');
    debugPrint('New spent: ${spentAmount.value}, income: ${totalIncome.value}, budget: ${monthlyBudget.value}');
  }

  // Handle currency change from other controllers
  void onCurrencyChanged(String fromCurrency, String toCurrency) {
    _convertAllAmountsToCurrency(fromCurrency, toCurrency);
    currentDisplayCurrency.value = toCurrency;
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final globalController = Get.find<GlobalController>();
      if (globalController.isAuthenticated.value) {
        final userProfile = globalController.userProfile;
        final originalBudget = userProfile['monthly_budget']?.toDouble() ?? 0.0;
        monthlyBudget.value = originalBudget;
        
        // Store current currency and mark it as the original data currency
        currentDisplayCurrency.value = globalController.currentCurrency.value;
        originalDataCurrency.value = globalController.currentCurrency.value;

        final expensesData = await SupabaseService.getExpenses(
          userId: globalController.userId,
          limit: 10,
        );

        // Store original expense data for future conversions
        originalExpenseData.value = List.from(expensesData);

        double spent = 0.0;
        double income = 0.0;
        final List<ExpenseItem> expensesList = [];

        for (final expense in expensesData) {
          final amount = (expense['amount'] as num).toDouble();
          String category = expense['category'] ?? 
                        getCategoryFromMerchant(expense['title'] ?? 'Unknown');
          
          if (amount < 0) {
            spent += amount.abs();
          } else {
            income += amount;
          }

          expensesList.add(ExpenseItem(
            title: expense['title'] ?? 'Unknown',
            date: _formatDate(expense['expense_date']),
            amount: amount,
            iconData: expense['icon_data'] ?? 'shopping_bag',
            iconBg: expense['icon_bg'] ?? 'black',
            category: category,
          ));
        }

        expenses.value = expensesList;
        spentAmount.value = spent;
        totalIncome.value = income;
        availableBalance.value = monthlyBudget.value + totalIncome.value - spentAmount.value;
        
        // Store original amounts for future conversions (in current user currency)
        originalAmounts['monthlyBudget'] = originalBudget;
        originalAmounts['spentAmount'] = spent;
        originalAmounts['totalIncome'] = income;
        
        debugPrint('Loaded data - Spent: ${spentAmount.value}, Income: ${totalIncome.value}, Budget: ${monthlyBudget.value}');
      }
    } catch (e) {
      Get.find<GlobalController>().handleError(e, customMessage: 'Failed to load data');
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh data and convert to current currency
  Future<void> refreshData() async {
    await loadData();
    
    // Ensure amounts are in the correct currency
    final globalController = Get.find<GlobalController>();
    if (currentDisplayCurrency.value != globalController.currentCurrency.value) {
      _convertAllAmountsToCurrency(
        originalDataCurrency.value, // Convert from original data currency
        globalController.currentCurrency.value
      );
      currentDisplayCurrency.value = globalController.currentCurrency.value;
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
          category: expense.category,
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
    _tipTimer?.cancel();
    startTipRotation();
  }
  
  void goToPreviousTip() {
    currentTipIndex.value = (currentTipIndex.value - 1 + tips.length) % tips.length;
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

  // Get formatted currency string using global controller
  String getFormattedCurrency(double amount) {
    final globalController = Get.find<GlobalController>();
    return globalController.formatCurrency(amount);
  }

  // Get currency symbol from global controller
  String getCurrencySymbol() {
    final globalController = Get.find<GlobalController>();
    return globalController.getCurrencySymbol(null);
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
