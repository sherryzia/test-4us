// lib/controllers/faqs_controller.dart
import 'package:get/get.dart';

class FAQsController extends GetxController {
  // List of FAQ items with questions and answers
  final RxList<FAQItem> faqItems = <FAQItem>[
    FAQItem(
      question: 'How do I add an expense?',
      answer: 'You can add an expense by tapping the + button in the center of the bottom navigation bar. Fill in the details like merchant name, amount, category, and payment method, then tap "Save Expense".'
    ),
    FAQItem(
      question: 'How do I edit or delete an expense?',
      answer: 'Currently, direct editing of expenses is not supported. To modify an expense, you would need to delete it and create a new one. This feature will be available in a future update.'
    ),
    FAQItem(
      question: 'Can I export my expense data?',
      answer: 'Currently, exporting data is not supported in the app. We\'re working on adding this feature in a future update that will allow you to export your data as CSV or PDF.'
    ),
    FAQItem(
      question: 'How do I change the currency?',
      answer: 'You can change your preferred currency in the Profile screen. Go to Profile and look for the Currency section which will show all available currency options.'
    ),
    FAQItem(
      question: 'Is my data secure?',
      answer: 'Yes, your data is securely stored on your device. We do not collect or store your financial information on our servers. In the future, we plan to add cloud backup with end-to-end encryption.'
    ),
    FAQItem(
      question: 'How do I create a budget?',
      answer: 'Budget features are coming soon in a future update. You\'ll be able to set monthly budgets for different categories and track your spending against them.'
    ),
    FAQItem(
      question: 'Can I use this app offline?',
      answer: 'Yes, Expensary works completely offline. All your data is stored locally on your device and doesn\'t require an internet connection to function.'
    ),
    FAQItem(
      question: 'How do I reset my password?',
      answer: 'On the login screen, tap on "Forgot Password?" and follow the instructions. You\'ll receive a password reset link via email.'
    ),
  ].obs;
  
  // Track which FAQs are expanded
  final RxList<bool> expandedStates = <bool>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    // Initialize all FAQs to collapsed state
    expandedStates.value = List.generate(faqItems.length, (_) => false);
  }
  
  // Toggle the expanded state of an FAQ
  void toggleExpanded(int index) {
    final newList = List<bool>.from(expandedStates);
    newList[index] = !newList[index];
    expandedStates.value = newList;
  }
  
  // Search functionality
  final RxString searchQuery = ''.obs;
  
  // Filtered FAQs based on search
  List<FAQItem> get filteredFAQs {
    if (searchQuery.value.isEmpty) {
      return faqItems;
    }
    
    final query = searchQuery.value.toLowerCase();
    return faqItems.where((item) {
      return item.question.toLowerCase().contains(query) || 
             item.answer.toLowerCase().contains(query);
    }).toList();
  }
  
  // Clear search
  void clearSearch() {
    searchQuery.value = '';
  }
}

class FAQItem {
  final String question;
  final String answer;
  
  FAQItem({
    required this.question,
    required this.answer,
  });
}
