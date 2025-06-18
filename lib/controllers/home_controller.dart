// Updated controllers/home_controller.dart
import 'dart:async';
import 'package:expensary/models/expense_item_model.dart';
import 'package:expensary/views/screens/add_expense_screen.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // Observable variables
  final RxDouble availableBalance = 112908.0.obs;
  final RxDouble monthlyBudget = 150000.0.obs;
  final RxDouble spentAmount = 37092.0.obs;
  
  // Computed values
  double get spentPercentage => spentAmount.value / monthlyBudget.value;
  double get availablePercentage => availableBalance.value / monthlyBudget.value;
  
  // Tips system
  final RxInt currentTipIndex = 0.obs;
  Timer? _tipTimer;
  
  final List<TipItem> tips = [
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
  
  // Sample expenses data with brand icons
  final RxList<ExpenseItem> expenses = <ExpenseItem>[
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
  ].obs;
  
  @override
  void onInit() {
    super.onInit();
    loadData();
    startTipRotation();
  }
  
  @override
  void onClose() {
    _tipTimer?.cancel();
    super.onClose();
  }
  
  void loadData() {
    // Simulate API call or load from local storage
    // This is where you'd fetch real data
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
  void addNewExpense(ExpenseItem expense) {
    expenses.insert(0, expense); // Add to beginning of list
    
    // Update spent amount
    if (expense.amount < 0) {
      spentAmount.value += expense.amount.abs();
      availableBalance.value -= expense.amount.abs();
    } else {
      // If it's income, add to available balance
      availableBalance.value += expense.amount;
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