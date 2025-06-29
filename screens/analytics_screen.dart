
// lib/views/screens/analytics_screen.dart - Complete with Dynamic Currency
import 'package:expensary/constants/colors.dart';
import 'package:expensary/controllers/home_controller.dart';
import 'package:expensary/controllers/global_controller.dart';
import 'package:expensary/models/expense_item_model.dart';
import 'package:expensary/views/widgets/custom_app_bar.dart'; 
import 'package:expensary/views/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final GlobalController globalController = Get.find<GlobalController>();
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        title: 'Analytics',
        type: AppBarType.withProfile,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // Monthly Summary Card with Dynamic Currency
              Obx(() => _buildSummaryCard(controller, globalController)),
              
              const SizedBox(height: 30),
              
              // Category Pie Chart with converted amounts
              Obx(() => _buildCategoryPieChart(controller, globalController)),
              
              const SizedBox(height: 30),
              
              // Expense Breakdown by Category with Dynamic Currency
              Obx(() => _buildExpenseBreakdown(controller, globalController)),
              
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSummaryCard(HomeController controller, GlobalController globalController) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
           Color.fromARGB(255, 103, 0, 193),
              Color.fromARGB(255, 63, 0, 117),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(
                text: 'Monthly Summary',
                size: 18,
                weight: FontWeight.w500,
                color: kwhite.withOpacity(0.8),
              ),
              // Currency indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: kwhite.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Obx(() => MyText(
                  text: globalController.currentCurrency.value,
                  size: 12,
                  weight: FontWeight.bold,
                  color: kwhite,
                )),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem(
                title: 'Income',
                amount: globalController.formatCurrency(controller.totalIncome.value),
                color: kgreen,
                icon: Icons.arrow_upward,
              ),
              _buildSummaryItem(
                title: 'Expenses',
                amount: globalController.formatCurrency(controller.spentAmount.value),
                color: kred,
                icon: Icons.arrow_downward,
              ),
              _buildSummaryItem(
                title: 'Balance',
                amount: globalController.formatCurrency(controller.availableBalance.value),
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
          size: 16,
          weight: FontWeight.bold,
          color: kwhite,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  
  Widget _buildCategoryPieChart(HomeController controller, GlobalController globalController) {
    // Group expenses by category using converted amounts
    Map<String, double> categoryTotals = {};
    double totalSpent = 0;

    for (var expense in controller.expenses) {
      if (expense.amount < 0) {
        String category = expense.category;
        double absAmount = expense.amount.abs();
        totalSpent += absAmount;

        categoryTotals.update(category, (value) => value + absAmount,
            ifAbsent: () => absAmount);
      }
    }

    if (categoryTotals.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF232538),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: MyText(
            text: 'No expenses to show',
            size: 16,
            color: kwhite.withOpacity(0.6),
          ),
        ),
      );
    }

    List<PieChartSegment> segments = [];
    Map<String, Color> categoryColors = {
      'Food & Dining': Colors.orange,
      'Electronics': Colors.blue,
      'Shopping': Colors.purple,
      'Bills & Utilities': Colors.red,
      'Entertainment': Colors.amber,
      'Transportation': Colors.teal,
      'Other': Colors.green,
    };

    categoryTotals.forEach((category, amount) {
      double percentage = amount / totalSpent;
      
      Color color = Colors.grey;
      for (var key in categoryColors.keys) {
        if (category.contains(key)) {
          color = categoryColors[key]!;
          break;
        }
      }
      
      segments.add(PieChartSegment(
        category: category,
        amount: amount,
        percentage: percentage,
        color: color,
      ));
    });

    segments.sort((a, b) => b.amount.compareTo(a.amount));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF232538),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(
                text: 'Expense by Category',
                size: 18,
                weight: FontWeight.w600,
                color: kwhite,
              ),
              Obx(() => MyText(
                text: 'Total: ${globalController.formatCurrency(totalSpent)}',
                size: 14,
                color: kwhite.withOpacity(0.7),
              )),
            ],
          ),
          const SizedBox(height: 12),
          ...segments.map((segment) => _buildLegendItem(
                category: segment.category,
                percentage: segment.percentage,
                amount: segment.amount,
                color: segment.color,
                globalController: globalController,
              )),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required String category,
    required double percentage,
    required double amount,
    required Color color,
    required GlobalController globalController,
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
            text: globalController.formatCurrency(amount),
            size: 13,
            weight: FontWeight.w600,
            color: kwhite.withOpacity(0.8),
          ),
          const SizedBox(width: 8),
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
  
  Widget _buildExpenseBreakdown(HomeController controller, GlobalController globalController) {
    Map<String, double> categoryTotals = {};
    double totalSpent = 0;

    // Process current expenses (already converted to current currency)
    for (var expense in controller.expenses) {
      if (expense.amount < 0) {
        String category = expense.category;
        double absAmount = expense.amount.abs();
        totalSpent += absAmount;

        categoryTotals.update(category, (value) => value + absAmount,
            ifAbsent: () => absAmount);
      }
    }

    if (categoryTotals.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: MyText(
            text: 'Nothing to show',
            size: 16,
            color: kwhite.withOpacity(0.6),
          ),
        ),
      );
    }

    var sortedEntries = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              text: 'Expense Breakdown',
              size: 20,
              weight: FontWeight.bold,
              color: kwhite,
            ),
            Obx(() => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: kwhite.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: MyText(
                text: globalController.currentCurrency.value,
                size: 12,
                weight: FontWeight.bold,
                color: kwhite.withOpacity(0.8),
              ),
            )),
          ],
        ),
        const SizedBox(height: 16),
        ...sortedEntries.map((entry) => _buildCategoryItem(
              category: entry.key,
              amount: entry.value,
              percentage: totalSpent > 0 ? entry.value / totalSpent : 0,
              globalController: globalController,
            )),
      ],
    );
  }
  
  Widget _buildCategoryItem({
    required String category,
    required double amount,
    required double percentage,
    required GlobalController globalController,
  }) {
    Color categoryColor;
    IconData categoryIcon;
    
    // Assign colors and icons based on category
    if (category.contains('Food & Dining')) {
      categoryColor = Colors.orange;
      categoryIcon = Icons.restaurant;
    } else if (category.contains('Electronics')) {
      categoryColor = Colors.blue;
      categoryIcon = Icons.devices;
    } else if (category.contains('Shopping')) {
      categoryColor = Colors.purple;
      categoryIcon = Icons.shopping_bag;
    } else if (category.contains('Bills & Utilities')) {
      categoryColor = Colors.red;
      categoryIcon = Icons.receipt;
    } else if (category.contains('Transportation')) {
      categoryColor = Colors.teal;
      categoryIcon = Icons.local_taxi;
    } else if (category.contains('Entertainment')) {
      categoryColor = Colors.amber;
      categoryIcon = Icons.movie;
    } else {
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
              // Dynamic currency formatting
              MyText(
                text: globalController.formatCurrency(amount),
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
              widthFactor: safePercentage,
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