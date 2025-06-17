// Updated controllers/add_expense_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expensary/controllers/home_controller.dart';
import 'package:expensary/models/expense_item_model.dart';
import 'package:intl/intl.dart';

class AddExpenseController extends GetxController {
  // Form controllers
  final timeController = TextEditingController();
  final dateController = TextEditingController();
  final amountController = TextEditingController();
  final titleController = TextEditingController(); // Added for expense title/merchant
  
  // Observable variables
  final RxString selectedCategory = 'Electronics'.obs;
  final RxString selectedCurrency = 'INR (₹)'.obs;
  final RxString selectedPaymentMethod = 'Physical Cash'.obs;
  final Rx<DateTime> selectedDateTime = DateTime.now().obs;
  
  // Dropdown options
  final List<String> categories = [
    'Electronics',
    'Food & Dining',
    'Transportation',
    'Shopping',
    'Entertainment',
    'Health & Medical',
    'Bills & Utilities',
    'Education',
    'Travel',
    'Other'
  ];
  
  final List<String> currencies = [
    'INR (₹)',
    'USD (\$)',
    'EUR (€)',
    'GBP (£)',
    'JPY (¥)'
  ];
  
  final List<String> paymentMethods = [
    'Physical Cash',
    'Debit Card',
    'Credit Card',
    'UPI',
    'Net Banking',
    'Digital Wallet',
    'Mastercard',
    'Visa'
  ];
  
  // Map of merchants with their brand logos (iconData placeholders)
  final Map<String, Map<String, dynamic>> knownMerchants = {
    'Amazon': {
      'icon': 'amazon',
      'category': 'Shopping',
      'bgColor': 'white',
    },
    'McDonalds': {
      'icon': 'mcdonalds',
      'category': 'Food & Dining',
      'bgColor': 'white',
    },
    'Apple': {
      'icon': 'apple',
      'category': 'Electronics',
      'bgColor': 'white',
    },
    'iPad Pro': {
      'icon': 'apple',
      'category': 'Electronics',
      'bgColor': 'white',
    },
    'iPhone': {
      'icon': 'apple',
      'category': 'Electronics',
      'bgColor': 'white',
    },
    'Starbucks': {
      'icon': 'starbucks',
      'category': 'Food & Dining',
      'bgColor': 'white',
    },
    'Uber': {
      'icon': 'uber',
      'category': 'Transportation',
      'bgColor': 'black',
    },
    'Spotify': {
      'icon': 'spotify',
      'category': 'Entertainment',
      'bgColor': 'black',
    },
    'Netflix': {
      'icon': 'netflix',
      'category': 'Entertainment',
      'bgColor': 'black',
    },
    'Mastercard': {
      'icon': 'mastercard',
      'category': 'Bills & Utilities',
      'bgColor': 'white',
    },
    'Visa': {
      'icon': 'visa',
      'category': 'Bills & Utilities',
      'bgColor': 'white',
    },
  };
  
  @override
  void onInit() {
    super.onInit();
    initializeDateTime();
  }
  
  @override
  void onClose() {
    timeController.dispose();
    dateController.dispose();
    amountController.dispose();
    titleController.dispose();
    super.onClose();
  }
  
  void initializeDateTime() {
    final now = DateTime.now();
    selectedDateTime.value = now;
    updateTimeDisplay();
    updateDateDisplay();
  }
  
  void updateTimeDisplay() {
    final time = selectedDateTime.value;
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final period = time.hour >= 12 ? 'p.m.' : 'a.m.';
    final displayHour = hour == 0 ? 12 : hour;
    timeController.text = '$displayHour:${time.minute.toString().padLeft(2, '0')} $period';
  }
  
  void updateDateDisplay() {
    final date = selectedDateTime.value;
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    dateController.text = '${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
  }
  
  void selectTime() async {
    final TimeOfDay? time = await Get.dialog<TimeOfDay>(
      TimePickerDialog(
        initialTime: TimeOfDay.fromDateTime(selectedDateTime.value),
      ),
    );
    
    if (time != null) {
      selectedDateTime.value = DateTime(
        selectedDateTime.value.year,
        selectedDateTime.value.month,
        selectedDateTime.value.day,
        time.hour,
        time.minute,
      );
      updateTimeDisplay();
    }
  }
  
  void selectDate() async {
    final DateTime? date = await showDatePicker(
      context: Get.context!,
      initialDate: selectedDateTime.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    
    if (date != null) {
      selectedDateTime.value = DateTime(
        date.year,
        date.month,
        date.day,
        selectedDateTime.value.hour,
        selectedDateTime.value.minute,
      );
      updateDateDisplay();
    }
  }
  
  void changeCategory(String category) {
    selectedCategory.value = category;
  }
  
  void changeCurrency(String currency) {
    selectedCurrency.value = currency;
  }
  
  void changePaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }
  
  bool isFormValid() {
    return amountController.text.isNotEmpty && 
           double.tryParse(amountController.text) != null &&
           double.parse(amountController.text) > 0 &&
           titleController.text.isNotEmpty;
  }
  
  void saveExpense() {
    if (!isFormValid()) {
      Get.snackbar(
        'Invalid Input',
        'Please enter a valid amount and merchant name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }
    
    // Get formatted date for display
    final DateFormat formatter = DateFormat('MMM dd, yyyy');
    final String formattedDate = formatter.format(selectedDateTime.value);
    
    // Format title/merchant name
    final String merchantName = titleController.text.trim();
    
    // Determine icon and background
    String iconData = 'shopping_bag'; // Default icon
    String iconBg = 'black';         // Default background
    
    // Check if this is a known merchant
    if (knownMerchants.containsKey(merchantName)) {
      iconData = knownMerchants[merchantName]!['icon']!;
      iconBg = knownMerchants[merchantName]!['bgColor']!;
      
      // Set category if from known merchant
      if (selectedCategory.value == 'Electronics') {
        selectedCategory.value = knownMerchants[merchantName]!['category']!;
      }
    } else {
      // Set icon based on category
      switch (selectedCategory.value) {
        case 'Food & Dining':
          iconData = 'restaurant';
          break;
        case 'Transportation':
          iconData = 'local_taxi';
          break;
        case 'Electronics':
          iconData = 'devices';
          break;
        case 'Shopping':
          iconData = 'shopping_bag';
          break;
        case 'Entertainment':
          iconData = 'movie';
          break;
        case 'Health & Medical':
          iconData = 'medical_services';
          break;
        case 'Bills & Utilities':
          iconData = 'receipt';
          break;
        case 'Education':
          iconData = 'school';
          break;
        case 'Travel':
          iconData = 'flight';
          break;
        default:
          iconData = 'shopping_bag';
      }
    }
    
    // Parse amount (negative for expenses)
    double amount = -double.parse(amountController.text);
    
    // Create expense object
    final ExpenseItem expenseItem = ExpenseItem(
      title: merchantName,
      date: formattedDate,
      amount: amount, // Negative for expenses
      iconData: iconData,
      iconBg: iconBg,
    );
    
    // Add to HomeController
    final HomeController homeController = Get.find<HomeController>();
    homeController.addNewExpense(expenseItem);
    
    Get.snackbar(
      'Success',
      'Expense added successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
    );
    
    // Navigate back to home
    Get.back();
  }
  
  void resetForm() {
    titleController.clear();
    amountController.clear();
    selectedCategory.value = 'Electronics';
    selectedCurrency.value = 'INR (₹)';
    selectedPaymentMethod.value = 'Physical Cash';
    initializeDateTime();
  }
}
