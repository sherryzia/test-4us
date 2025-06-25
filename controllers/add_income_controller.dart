// lib/controllers/add_income_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expensary/controllers/home_controller.dart';
import 'package:expensary/controllers/global_controller.dart';
import 'package:expensary/models/expense_item_model.dart';
import 'package:expensary/services/supabase_service.dart';
import 'package:intl/intl.dart';

class AddIncomeController extends GetxController {
  // Form controllers
  final timeController = TextEditingController();
  final dateController = TextEditingController();
  final amountController = TextEditingController();
  final titleController = TextEditingController();
  final notesController = TextEditingController();
  
  // Observable variables
  final RxString selectedIncomeType = 'Salary'.obs;
  final RxString selectedCurrency = 'PKR (₨)'.obs;
  final RxString selectedPaymentMethod = 'Bank Transfer'.obs;
  final Rx<DateTime> selectedDateTime = DateTime.now().obs;
  final RxBool isLoading = false.obs;
  
  // For Supabase data
  String? selectedIncomeTypeId;
  String? selectedPaymentMethodId;
  
  // Dropdown options
  final RxList<String> incomeTypes = <String>[
    'Salary',
    'Freelance',
    'Business',
    'Investment',
    'Rental',
    'Bonus',
    'Commission',
    'Side Hustle',
    'Passive Income',
    'Other Income'
  ].obs;
  
  final RxList<String> currencies = <String>[
    'PKR (₨)',
    'USD (\$)',
    'EUR (€)',
    'GBP (£)',
    'JPY (¥)'
  ].obs;
  
  final RxList<String> paymentMethods = <String>[
    'Bank Transfer',
    'Cash',
    'Check',
    'Digital Wallet',
    'Direct Deposit',
    'Online Payment',
    'Wire Transfer',
    'Other'
  ].obs;
  
  // Map of income sources with their icons and colors
  final Map<String, Map<String, dynamic>> knownIncomeSources = {
    'Salary': {
      'icon': 'work',
      'color': 'blue',
    },
    'Freelance': {
      'icon': 'laptop',
      'color': 'purple',
    },
    'Business': {
      'icon': 'business',
      'color': 'orange',
    },
    'Investment': {
      'icon': 'trending_up',
      'color': 'green',
    },
    'Rental': {
      'icon': 'home',
      'color': 'teal',
    },
    'Bonus': {
      'icon': 'card_giftcard',
      'color': 'pink',
    },
    'Commission': {
      'icon': 'percent',
      'color': 'indigo',
    },
    'Side Hustle': {
      'icon': 'work_outline',
      'color': 'amber',
    },
    'Passive Income': {
      'icon': 'savings',
      'color': 'cyan',
    },
    'Other Income': {
      'icon': 'attach_money',
      'color': 'grey',
    },
  };
  
  @override
  void onInit() {
    super.onInit();
    loadPaymentMethods();
    initializeDateTime();
  }
  
  @override
  void onClose() {
    timeController.dispose();
    dateController.dispose();
    amountController.dispose();
    titleController.dispose();
    notesController.dispose();
    super.onClose();
  }
  
  // Load payment methods from global controller
  void loadPaymentMethods() {
    try {
      final globalController = Get.find<GlobalController>();
      
      // Only update if authenticated
      if (globalController.isAuthenticated.value) {
        // Get payment method names
        final paymentMethodNames = globalController.paymentMethodNames;
        if (paymentMethodNames.isNotEmpty) {
          // Add income-specific payment methods
          final incomePaymentMethods = [
            'Bank Transfer',
            'Direct Deposit',
            'Cash',
            'Check',
            'Digital Wallet',
            'Wire Transfer',
            'Online Payment',
            'Other'
          ];
          paymentMethods.value = incomePaymentMethods;
          selectedPaymentMethod.value = incomePaymentMethods.first;
          
          // Get payment method ID for the selected payment method
          selectedPaymentMethodId = globalController.getPaymentMethodId(selectedPaymentMethod.value);
        }
      }
    } catch (e) {
      debugPrint('Error loading payment methods: $e');
    }
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
  
  void changeIncomeType(String incomeType) {
    selectedIncomeType.value = incomeType;
  }
  
  void changeCurrency(String currency) {
    selectedCurrency.value = currency;
  }
  
  void changePaymentMethod(String method) {
    selectedPaymentMethod.value = method;
    
    // Update the payment method ID
    final globalController = Get.find<GlobalController>();
    selectedPaymentMethodId = globalController.getPaymentMethodId(method);
  }
  
  bool isFormValid() {
    return amountController.text.isNotEmpty && 
           double.tryParse(amountController.text) != null &&
           double.parse(amountController.text) > 0 &&
           titleController.text.isNotEmpty;
  }
  
  Future<void> saveIncome() async {
    if (!isFormValid()) {
      Get.snackbar(
        'Invalid Input',
        'Please enter a valid amount and income source',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }
    
    isLoading.value = true;
    
    try {
      // Get formatted date for display
      final DateFormat formatter = DateFormat('MMM dd, yyyy');
      final String formattedDate = formatter.format(selectedDateTime.value);
      
      // Format title/income source name
      final String sourceName = titleController.text.trim();
      
      // Determine icon and background
      String iconData = 'attach_money'; // Default icon
      String iconBg = 'green';          // Default background for income
      
      // Check if this is a known income source
      if (knownIncomeSources.containsKey(selectedIncomeType.value)) {
        iconData = knownIncomeSources[selectedIncomeType.value]!['icon']!;
        iconBg = knownIncomeSources[selectedIncomeType.value]!['color']!;
      } else {
        // Set icon based on income type
        switch (selectedIncomeType.value) {
          case 'Salary':
            iconData = 'work';
            iconBg = 'blue';
            break;
          case 'Freelance':
            iconData = 'laptop';
            iconBg = 'purple';
            break;
          case 'Business':
            iconData = 'business';
            iconBg = 'orange';
            break;
          case 'Investment':
            iconData = 'trending_up';
            iconBg = 'green';
            break;
          case 'Rental':
            iconData = 'home';
            iconBg = 'teal';
            break;
          case 'Bonus':
            iconData = 'card_giftcard';
            iconBg = 'pink';
            break;
          default:
            iconData = 'attach_money';
            iconBg = 'green';
        }
      }
      
      // Parse amount (positive for income)
      double amount = double.parse(amountController.text);
      
      // Create category string for income
      String category = 'Income: ${selectedIncomeType.value}';
      
      // Create income object as ExpenseItem (but with positive amount and income category)
      final ExpenseItem incomeItem = ExpenseItem(
        title: sourceName,
        date: formattedDate,
        amount: amount, // Positive for income
        iconData: iconData,
        iconBg: iconBg,
        category: category, // Add income category
      );
      
      // Save to database using SupabaseService
      final globalController = Get.find<GlobalController>();
      if (globalController.isAuthenticated.value) {
        await SupabaseService.createExpense(
          title: sourceName,
          amount: amount, // Positive amount for income
          expenseDate: selectedDateTime.value,
          userId: globalController.userId,
          iconData: iconData,
          iconBg: iconBg,
          category: category, // Save category
          notes: 'Income: ${selectedIncomeType.value}',
        );
        
        // Add to HomeController
        final HomeController homeController = Get.find<HomeController>();
        await homeController.loadData(); // Reload data to include new income
        
        // Reset form
        resetForm();
        
        // Show success message
        Get.snackbar(
          'Success',
          'Income added successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );
        
        // Navigate back to home
        Get.back();
      }
    } catch (e) {
      debugPrint('Error saving income: $e');
      Get.snackbar(
        'Error',
        'Failed to save income. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  void resetForm() {
    titleController.clear();
    amountController.clear();
    notesController.clear();
    selectedIncomeType.value = incomeTypes.isNotEmpty ? incomeTypes.first : 'Salary';
    selectedCurrency.value = currencies.isNotEmpty ? currencies.first : 'PKR (₨)';
    selectedPaymentMethod.value = paymentMethods.isNotEmpty ? paymentMethods.first : 'Bank Transfer';
    initializeDateTime();
  }
}