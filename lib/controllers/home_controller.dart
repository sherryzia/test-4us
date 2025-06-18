// lib/controllers/home_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expensary/models/expense_item_model.dart';
import 'package:expensary/views/screens/add_expense_screen.dart';
import 'package:expensary/services/supabase_service.dart';
import 'package:expensary/controllers/global_controller.dart';

class HomeController extends GetxController {
  // Observable variables
  final RxDouble availableBalance = 0.0.obs;
  final RxDouble monthlyBudget = 0.0.obs;
  final RxDouble spentAmount = 0.0.obs;
  
  // Computed values
  double get spentPercentage => monthlyBudget.value > 0 
      ? (spentAmount.value / monthlyBudget.value).clamp(0.0, 1.0) 
      : 0.0;
  
  double get availablePercentage => monthlyBudget.value > 0 
      ? (availableBalance.value / monthlyBudget.value).clamp(0.0, 1.0) 
      : 0.0;
  
  // Loading state
  final RxBool isLoading = false.obs;
  
  // Tips system
  final RxInt currentTipIndex = 0.obs;
  Timer? _tipTimer;
  final RxList<TipItem> tips = <TipItem>[].obs;
  
  // Expenses list
  final RxList<ExpenseItem> expenses = <ExpenseItem>[].obs;
  
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
      
      // Only load data if user is authenticated
      if (globalController.isAuthenticated.value) {
        // Load profile data
        final userProfile = globalController.userProfile;
        monthlyBudget.value = userProfile['monthly_budget']?.toDouble() ?? 150000.0;
        
        // Load expenses from Supabase
        final expensesData = await SupabaseService.getExpenses(
          userId: globalController.userId,
          limit: 10, // Limit to 10 most recent expenses
        );
        
        // Calculate total spent amount
        double spent = 0.0;
        
        // Convert to ExpenseItem objects
        final List<ExpenseItem> expensesList = [];
        
        for (final expense in expensesData) {
          final amount = (expense['amount'] as num).toDouble();
          
          // Only count negative amounts as expenses
          if (amount < 0) {
            spent += amount.abs();
          }
          
          // Create ExpenseItem
          final item = ExpenseItem(
            title: expense['title'] ?? 'Unknown',
            date: _formatDate(expense['expense_date']),
            amount: amount,
            iconData: expense['icon_data'] ?? 'shopping_bag',
            iconBg: expense['icon_bg'] ?? 'black',
          );
          
          expensesList.add(item);
        }
        
        // Update the state
        expenses.value = expensesList;
        spentAmount.value = spent;
        availableBalance.value = monthlyBudget.value - spentAmount.value;
      } else {
        // Use default values if not authenticated
        monthlyBudget.value = 150000.0;
        spentAmount.value = 37092.0;
        availableBalance.value = monthlyBudget.value - spentAmount.value;
        
        // Use sample expenses
        expenses.value = [
          ExpenseItem(
            title: 'Amazon',
            date: 'Sept 09, 2022',
            amount: -89.54,
            iconData: 'amazon',
            iconBg: 'white',
          ),
          ExpenseItem(
            title: 'McDonalds',
            date: 'Sept 12, 2022',
            amount: -32.67,
            iconData: 'mcdonalds',
            iconBg: 'white',
          ),
          ExpenseItem(
            title: 'iPad Pro',
            date: 'Oct 10, 2023',
            amount: -79999,
            iconData: 'apple',
            iconBg: 'white',
          ),
          ExpenseItem(
            title: 'Starbucks',
            date: 'Sept 04, 2022',
            amount: -199.54,
            iconData: 'starbucks',
            iconBg: 'white',
          ),
          ExpenseItem(
            title: 'Mastercard',
            date: 'Sept 09, 2022',
            amount: -1130.54,
            iconData: 'mastercard',
            iconBg: 'white',
          ),
        ];
      }
    } catch (e) {
      debugPrint('Error loading home data: $e');
      Get.find<GlobalController>().handleError(
        e, 
        customMessage: 'Failed to load data'
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Load financial tips from Supabase
  Future<void> loadTips() async {
    try {
      // Load tips from Supabase
      final tipsData = await SupabaseService.getFinancialTips();
      
      // Convert to TipItem objects
      final List<TipItem> tipsList = [];
      
      for (final tip in tipsData) {
        final item = TipItem(
          title: tip['title'] ?? 'Unknown',
          description: tip['description'] ?? '',
          progress: 0.5, // Default progress
        );
        
        tipsList.add(item);
      }
      
      // If tips were loaded successfully, update the list
      if (tipsList.isNotEmpty) {
        tips.value = tipsList;
      } else {
        // Use default tips if none were loaded
        tips.value = [
          TipItem(
            title: 'Prepare a Budget and Stick to It',
            description: 'Create a monthly budget and track your spending to stay on target.',
            progress: 0.4,
          ),
          TipItem(
            title: 'Track Every Small Expense',
            description: 'Small purchases add up quickly. Track coffee, snacks, and daily expenses.',
            progress: 0.7,
          ),
          TipItem(
            title: 'Use the 50/30/20 Rule',
            description: '50% needs, 30% wants, 20% savings and debt repayment.',
            progress: 0.6,
          ),
          TipItem(
            title: 'Review Your Expenses Weekly',
            description: 'Check your spending patterns every week to stay in control.',
            progress: 0.8,
          ),
          TipItem(
            title: 'Set Up Emergency Fund',
            description: 'Save at least 3-6 months of expenses for unexpected situations.',
            progress: 0.3,
          ),
          TipItem(
            title: 'Avoid Impulse Purchases',
            description: 'Wait 24 hours before buying non-essential items.',
            progress: 0.5,
          ),
          TipItem(
            title: 'Use Cash for Discretionary Spending',
            description: 'Physical cash makes you more aware of your spending.',
            progress: 0.9,
          ),
          TipItem(
            title: 'Cancel Unused Subscriptions',
            description: 'Review and cancel subscriptions you don\'t actively use.',
            progress: 0.2,
          ),
        ];
      }
    } catch (e) {
      debugPrint('Error loading tips: $e');
      // Just use default tips if there's an error - not critical
    }
  }
  
  void startTipRotation() {
    _tipTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      currentTipIndex.value = (currentTipIndex.value + 1) % tips.length;
    });
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
  
  TipItem get currentTip => tips[currentTipIndex.value];
  
  void addExpense() {
    // Navigate to Add Expense screen
    Get.to(() => AddExpenseScreen());
  }
  
  void seeAllExpenses() {
    // Navigate to all expenses screen
    Get.snackbar(
      'Navigation', 
      'See all expenses - Screen coming soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  // Method to add new expense from Add Expense screen
  Future<void> addNewExpense(ExpenseItem expense) async {
    try {
      final globalController = Get.find<GlobalController>();
      
      if (globalController.isAuthenticated.value) {
        // Create expense in Supabase
        final DateTime now = DateTime.now();
        
        await SupabaseService.createExpense(
          title: expense.title,
          amount: expense.amount, // Already negative for expenses
          expenseDate: now,
          userId: globalController.userId,
          iconData: expense.iconData,
          iconBg: expense.iconBg,
        );
        
        // Reload data
        await loadData();
      } else {
        // Just add to local list if not authenticated
        expenses.insert(0, expense);
        
        // Update spent amount
        if (expense.amount < 0) {
          spentAmount.value += expense.amount.abs();
          availableBalance.value -= expense.amount.abs();
        } else {
          // If it's income, add to available balance
          availableBalance.value += expense.amount;
        }
      }
      
      // Show success message
      Get.find<GlobalController>().showSuccess('Expense added successfully!');
      
    } catch (e) {
      debugPrint('Error adding expense: $e');
      Get.find<GlobalController>().handleError(
        e, 
        customMessage: 'Failed to add expense'
      );
    }
  }
  
  // Helper method to format date
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

// Tip item model
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