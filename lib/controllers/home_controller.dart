
// Updated controllers/home_controller.dart
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
  
  // Tip of the day
  final RxString tipTitle = 'Prepare a Budget and Abide by it'.obs;
  final RxDouble tipProgress = 0.4.obs;
  
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
    // Initialize data or fetch from API
    loadData();
  }
  
  void loadData() {
    // Simulate API call or load from local storage
    // This is where you'd fetch real data
  }
  
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