// Updated views/screens/analytics_screen.dart
import 'package:expensary/constants/colors.dart';
import 'package:expensary/controllers/home_controller.dart';
import 'package:expensary/models/expense_item_model.dart';
import 'package:expensary/views/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    
    return SafeArea(
      child: Column(
        children: [
          // Header Section
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                  text: 'Analytics',
                  size: 36,
                  weight: FontWeight.bold,
                  color: kwhite,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [korange, Color(0xFFFF6B35)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: korange.withOpacity(0.3),
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      Icons.person,
                      color: kwhite,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Content area
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Monthly Summary Card
                    _buildSummaryCard(controller),
                    
                    const SizedBox(height: 30),
                    
                    // Implemented Category Pie Chart
                    _buildCategoryPieChart(controller),
                    
                    const SizedBox(height: 30),
                    
                    // Expense Breakdown by Category
                    _buildExpenseBreakdown(controller),
                    
                    const SizedBox(height: 100), // Space for bottom navigation
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSummaryCard(HomeController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4A00E0),
            Color(0xFF8E2DE2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF8E2DE2).withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            text: 'Monthly Summary',
            size: 18,
            weight: FontWeight.w500,
            color: kwhite.withOpacity(0.8),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem(
                title: 'Income',
                amount: '₹0',
                color: kgreen,
                icon: Icons.arrow_upward,
              ),
              _buildSummaryItem(
                title: 'Expenses',
                amount: '₹${_formatCurrency(controller.spentAmount.value)}',
                color: kred,
                icon: Icons.arrow_downward,
              ),
              _buildSummaryItem(
                title: 'Balance',
                amount: '₹${_formatCurrency(controller.availableBalance.value)}',
                color: kblue,
                icon: Icons.account_balance_wallet,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildSummaryItem({
    required String title,
    required String amount,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        MyText(
          text: title,
          size: 14,
          color: kwhite.withOpacity(0.7),
        ),
        const SizedBox(height: 4),
        MyText(
          text: amount,
          size: 18,
          weight: FontWeight.bold,
          color: kwhite,
        ),
      ],
    );
  }
  
  // New implementation of category pie chart
  Widget _buildCategoryPieChart(HomeController controller) {
    // Group expenses by category
    Map<String, double> categoryTotals = {};
    double totalSpent = 0;
    
    for (var expense in controller.expenses) {
      // Only count expenses (negative amounts)
      if (expense.amount < 0) {
        String category = _getCategoryForExpense(expense);
        double absAmount = expense.amount.abs();
        totalSpent += absAmount;
        
        if (categoryTotals.containsKey(category)) {
          categoryTotals[category] = categoryTotals[category]! + absAmount;
        } else {
          categoryTotals[category] = absAmount;
        }
      }
    }
    
    // Prepare data for pie chart
    List<PieChartSegment> segments = [];
    
    // Define category colors
    Map<String, Color> categoryColors = {
      'Food & Dining': Colors.orange,
      'Electronics': Colors.blue,
      'Shopping': Colors.purple,
      'Bills & Utilities': Colors.red,
      'Other': Colors.green,
    };
    
    // Create segments
    categoryTotals.forEach((category, amount) {
      double percentage = amount / totalSpent;
      segments.add(PieChartSegment(
        category: category,
        amount: amount,
        percentage: percentage,
        color: categoryColors[category] ?? Colors.green,
      ));
    });
    
    // Sort segments by amount (descending)
    segments.sort((a, b) => b.amount.compareTo(a.amount));
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF232538),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            text: 'Expense by Category',
            size: 18,
            weight: FontWeight.w600,
            color: kwhite,
          ),
          // const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              // height: 200,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: segments.map((segment) => _buildLegendItem(
                    category: segment.category,
                    percentage: segment.percentage,
                    color: segment.color,
                  )).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLegendItem({
    required String category,
    required double percentage,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: MyText(
              text: category,
              size: 14,
              color: kwhite,
            ),
          ),
          MyText(
            text: '${(percentage * 100).toStringAsFixed(1)}%',
            size: 14,
            weight: FontWeight.bold,
            color: kwhite,
          ),
        ],
      ),
    );
  }
  
  Widget _buildExpenseBreakdown(HomeController controller) {
    // Group expenses by category
    Map<String, double> categoryTotals = {};
    double totalSpent = 0;
    
    for (var expense in controller.expenses) {
      if (expense.amount < 0) {
        String category = _getCategoryForExpense(expense);
        double absAmount = expense.amount.abs();
        totalSpent += absAmount;
        
        if (categoryTotals.containsKey(category)) {
          categoryTotals[category] = categoryTotals[category]! + absAmount;
        } else {
          categoryTotals[category] = absAmount;
        }
      }
    }
    
    // Sort categories by amount
    var sortedEntries = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: 'Expense Breakdown',
          size: 20,
          weight: FontWeight.bold,
          color: kwhite,
        ),
        const SizedBox(height: 16),
        ...sortedEntries.map((entry) => _buildCategoryItem(
          category: entry.key,
          amount: entry.value,
          percentage: totalSpent > 0 ? entry.value / totalSpent : 0,
        )).toList(),
      ],
    );
  }
  
  Widget _buildCategoryItem({
    required String category,
    required double amount,
    required double percentage,
  }) {
    Color categoryColor;
    IconData categoryIcon;
    
    // Assign colors and icons based on category
    switch (category) {
      case 'Food & Dining':
        categoryColor = Colors.orange;
        categoryIcon = Icons.restaurant;
        break;
      case 'Electronics':
        categoryColor = Colors.blue;
        categoryIcon = Icons.devices;
        break;
      case 'Shopping':
        categoryColor = Colors.purple;
        categoryIcon = Icons.shopping_bag;
        break;
      case 'Bills & Utilities':
        categoryColor = Colors.red;
        categoryIcon = Icons.receipt;
        break;
      default:
        categoryColor = Colors.green;
        categoryIcon = Icons.category;
    }
    
    // Cap percentage at 1.0 to prevent overflow
    double safePercentage = percentage > 1.0 ? 1.0 : percentage;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF232538),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  categoryIcon,
                  color: categoryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MyText(
                  text: category,
                  size: 16,
                  weight: FontWeight.w600,
                  color: kwhite,
                ),
              ),
              MyText(
                text: '₹${_formatCurrency(amount)}',
                size: 16,
                weight: FontWeight.bold,
                color: kwhite,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              widthFactor: safePercentage, // Using safe value to prevent overflow
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      categoryColor,
                      categoryColor.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: MyText(
              text: '${(percentage * 100).toStringAsFixed(1)}%',
              size: 14,
              color: kwhite.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
  
  String _getCategoryForExpense(ExpenseItem expense) {
    // Map expense to category based on merchant
    switch (expense.title) {
      case 'Amazon':
      case 'Nike Air Max 2090':
        return 'Shopping';
      case 'McDonalds':
      case 'Starbucks':
        return 'Food & Dining';
      case 'iPad Pro':
      case 'iPhone':
        return 'Electronics';
      case 'Mastercard':
      case 'Visa':
        return 'Bills & Utilities';
      default:
        return 'Other';
    }
  }
  
  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2)
        .replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), 
      (Match m) => '${m[1]},'
    );
  }
}

// Data class for pie chart segments
class PieChartSegment {
  final String category;
  final double amount;
  final double percentage;
  final Color color;
  
  PieChartSegment({
    required this.category,
    required this.amount,
    required this.percentage,
    required this.color,
  });
}