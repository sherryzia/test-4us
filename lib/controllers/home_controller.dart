// Updated controllers/home_controller.dart
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
  
  // Sample expenses data
  final RxList<ExpenseItem> expenses = <ExpenseItem>[
    ExpenseItem(
      title: 'Nike Air Max 2090',
      date: '09 Oct 2023',
      amount: -16999,
      iconData: 'sports_basketball',
      iconBg: 'white',
    ),
    ExpenseItem(
      title: 'iPad Pro',
      date: '10 Oct 2023',
      amount: -79999,
      iconData: 'apple',
      iconBg: 'black',
    ),
    ExpenseItem(
      title: 'Uber',
      date: '5 Mar 2023',
      amount: 50,
      iconData: 'local_taxi',
      iconBg: 'black',
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

// Keep the ExpenseItem model here for now, but ideally move to models folder
class ExpenseItem {
  final String title;
  final String date;
  final double amount;
  final String iconData;
  final String iconBg;
  
  ExpenseItem({
    required this.title,
    required this.date,
    required this.amount,
    required this.iconData,
    required this.iconBg,
  });
  
  // Convert to JSON (for API calls)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date,
      'amount': amount,
      'iconData': iconData,
      'iconBg': iconBg,
    };
  }
  
  // Create from JSON (for API responses)
  factory ExpenseItem.fromJson(Map<String, dynamic> json) {
    return ExpenseItem(
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      iconData: json['iconData'] ?? 'shopping_bag',
      iconBg: json['iconBg'] ?? 'black',
    );
  }
}