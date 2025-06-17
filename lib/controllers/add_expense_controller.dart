// controllers/add_expense_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddExpenseController extends GetxController {
  // Form controllers
  final timeController = TextEditingController();
  final dateController = TextEditingController();
  final amountController = TextEditingController();
  
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
    'Cheque'
  ];
  
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
           double.parse(amountController.text) > 0;
  }
  
  void saveExpense() {
    if (!isFormValid()) {
      Get.snackbar(
        'Invalid Input',
        'Please enter a valid amount',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }
    
    // Create expense object
    final expense = {
      'amount': double.parse(amountController.text),
      'category': selectedCategory.value,
      'currency': selectedCurrency.value,
      'paymentMethod': selectedPaymentMethod.value,
      'dateTime': selectedDateTime.value,
      'timestamp': DateTime.now(),
    };
    
    // Here you would typically save to database or send to API
    print('Saving expense: $expense');
    
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
    amountController.clear();
    selectedCategory.value = 'Electronics';
    selectedCurrency.value = 'INR (₹)';
    selectedPaymentMethod.value = 'Physical Cash';
    initializeDateTime();
  }
}