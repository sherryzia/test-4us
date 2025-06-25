// lib/views/screens/statistics_screen.dart (Improved)
import 'package:expensary/constants/colors.dart';
import 'package:expensary/controllers/home_controller.dart';
import 'package:expensary/controllers/statistics_controller.dart';
import 'package:expensary/models/expense_item_model.dart';
import 'package:expensary/views/widgets/custom_app_bar.dart';
import 'package:expensary/views/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statisticsController = Get.put(StatisticsController());
    final homeController = Get.find<HomeController>();
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        title: 'Statistics',
        type: AppBarType.withProfile,
        // onProfileTap: () {
        //   Get.snackbar(
        //     'Profile',
        //     'Profile button tapped',
        //     snackPosition: SnackPosition.BOTTOM,
        //   );
        // },
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time Frame Dropdown Selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildTimeFrameDropdown(statisticsController),
            ),
            
            const SizedBox(height: 30),
            
            // Spending Insights Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildSpendingInsightsCard(statisticsController, homeController),
            ),
            
            const SizedBox(height: 30),
            
            // Expenses Chart
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                height: 300,
                child: Obx(() => _buildExpenseChart(statisticsController)),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Spending Summary Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildSpendingSummaryCard(homeController, statisticsController),
            ),
            
            const SizedBox(height: 30),
            
            // Recent Transactions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: MyText(
                text: 'Recent Transactions',
                size: 24,
                weight: FontWeight.bold,
                color: kwhite,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Transaction List
            _buildRecentTransactions(homeController),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
  
  // Time frame dropdown selector
  Widget _buildTimeFrameDropdown(StatisticsController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: kwhite.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: kwhite.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Obx(() => DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: controller.selectedTimeFrame.value,
          dropdownColor: Color(0xFF2A2D40),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: kwhite.withOpacity(0.7),
          ),
          style: TextStyle(
            color: kwhite,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          onChanged: (String? newValue) {
            if (newValue != null) {
              controller.changeTimeFrame(newValue);
            }
          },
          isExpanded: true,
          items: controller.timeFrameOptions.map<DropdownMenuItem<String>>(
            (Map<String, String> option) {
              return DropdownMenuItem<String>(
                value: option['value'],
                child: Row(
                  children: [
                    Icon(
                      Icons.timeline,
                      color: Color(0xFFAF4BCE),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      option['label']!,
                      style: TextStyle(
                        color: kwhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }
          ).toList(),
        ),
      )),
    );
  }
  
  // Spending insights card
  Widget _buildSpendingInsightsCard(StatisticsController statisticsController, HomeController homeController) {
    return Obx(() {
      final insights = statisticsController.spendingInsights;
      if (insights.isEmpty) return Container();
      
      final trend = insights['trend'] as String;
      final changePercent = insights['changePercent'] as double;
      final isIncreasing = trend == 'increasing';
      
      return Container(
        padding: const EdgeInsets.all(20),
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
                  text: 'Spending Insights',
                  size: 18,
                  weight: FontWeight.bold,
                  color: kwhite,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isIncreasing ? kred.withOpacity(0.2) : kgreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isIncreasing ? Icons.trending_up : Icons.trending_down,
                        color: isIncreasing ? kred : kgreen,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      MyText(
                        text: '${changePercent.toStringAsFixed(1)}%',
                        size: 14,
                        weight: FontWeight.bold,
                        color: isIncreasing ?kred : kgreen,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            MyText(
              text: 'Your spending is ${trend} compared to the previous period. ${insights['isAboveAverage'] ? 'You\'re spending above your average.' : 'You\'re spending below your average.'}',
              size: 14,
              color: kwhite.withOpacity(0.9),
              lineHeight: 1.5,
            ),
          ],
        ),
      );
    });
  }
  
  // Improved expense chart with dynamic data
  Widget _buildExpenseChart(StatisticsController controller) {
    return CustomPaint(
      painter: ImprovedExpenseChartPainter(
        data: controller.chartData,
        labels: controller.chartLabels,
        yAxisLabels: controller.yAxisLabels,
      ),
      child: Container(),
    );
  }
  
  // Spending summary card (replaces the meaningless "pay early" card)
  Widget _buildSpendingSummaryCard(HomeController homeController, StatisticsController statisticsController) {
    return GetX<HomeController>(
      builder: (homeController) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Color(0xFF2A2D40),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                  text: 'Spending Summary',
                  size: 18,
                  weight: FontWeight.bold,
                  color: kwhite,
                ),
                Obx(() => MyText(
                  text: statisticsController.currentTimeFrameLabel,
                  size: 14,
                  color: kwhite.withOpacity(0.7),
                )),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Summary stats
            Row(
              children: [
                // Total Spent
                Expanded(
                  child: _buildSummaryItem(
                    title: 'Total Spent',
                    amount: '₨${_formatCurrency(homeController.spentAmount.value)}',
                    icon: Icons.trending_up,
                    color: kred,
                  ),
                ),
                const SizedBox(width: 16),
                // Average Daily
                Expanded(
                  child: _buildSummaryItem(
                    title: 'Daily Average',
                    amount: '₨${_formatCurrency(homeController.spentAmount.value / 30)}',
                    icon: Icons.calendar_today,
                    color: kblue,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                // Remaining Budget
                Expanded(
                  child: _buildSummaryItem(
                    title: 'Remaining',
                    amount: '₨${_formatCurrency(homeController.availableBalance.value)}',
                    icon: Icons.account_balance_wallet,
                    color: kgreen,
                  ),
                ),
                const SizedBox(width: 16),
                // Budget Progress
                Expanded(
                  child: _buildSummaryItem(
                    title: 'Budget Used',
                    amount: '${(homeController.spentPercentage * 100).toStringAsFixed(1)}%',
                    icon: Icons.pie_chart,
                    color: korange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSummaryItem({
    required String title,
    required String amount,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: MyText(
                  text: title,
                  size: 12,
                  color: kwhite.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          MyText(
            text: amount,
            size: 16,
            weight: FontWeight.bold,
            color: kwhite,
          ),
        ],
      ),
    );
  }
  
  // Recent transactions (unchanged)
  Widget _buildRecentTransactions(HomeController controller) {
    return GetX<HomeController>(
      builder: (controller) => Column(
        children: controller.expenses
          .take(3)
          .map((expense) => _buildTransactionItem(expense))
          .toList(),
      ),
    );
  }
  
  Widget _buildTransactionItem(ExpenseItem expense) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF232538),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Logo
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: expense.iconBg == 'white' ? kwhite : kblack,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: _getLogo(expense.iconData, expense.iconBg == 'white' ? kblack : kwhite),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Title and Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  text: expense.title,
                  size: 18,
                  weight: FontWeight.w600,
                  color: kwhite,
                ),
                const SizedBox(height: 4),
                MyText(
                  text: _formatDateWithTime(expense.date),
                  size: 14,
                  color: kwhite.withOpacity(0.6),
                ),
              ],
            ),
          ),
          
          // Amount
          MyText(
            text: '₨${_formatCurrency(expense.amount.abs())}',
            size: 18,
            weight: FontWeight.bold,
            color: kwhite,
          ),
        ],
      ),
    );
  }
  
  Widget _getLogo(String iconName, Color color) {
    switch (iconName) {
      case 'amazon':
        return Icon(Icons.shopping_cart, color: color, size: 26);
      case 'apple':
        return Icon(Icons.phone_iphone, color: color, size: 26);
      case 'mcdonalds':
        return Icon(Icons.fastfood, color: Colors.amber, size: 26);
      case 'starbucks':
        return Icon(Icons.coffee, color: Colors.green, size: 26);
      case 'mastercard':
        return Icon(Icons.credit_card, color: Colors.red, size: 26);
      default:
        return Icon(Icons.shopping_bag, color: color, size: 26);
    }
  }
  
  String _formatCurrency(double amount) {
    if (amount - amount.truncate() > 0) {
      return amount.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},'
      );
    }
    return amount.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},'
    );
  }
  
  String _formatDateWithTime(String date) {
    List<String> parts = date.split(' ');
    if (parts.length >= 2) {
      String day = parts[1].replaceAll(',', '');
      String month = parts[0];
      return '$day $month - 13:01';
    }
    return date;
  }
}

// Improved custom painter with dynamic data
class ImprovedExpenseChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> labels;
  final List<String> yAxisLabels;
  
  ImprovedExpenseChartPainter({
    required this.data,
    required this.labels,
    required this.yAxisLabels,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    
    // Grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;
    
    // Horizontal grid lines
    for (int i = 1; i <= 5; i++) {
      final y = i * (height * 0.8) / 5;
      canvas.drawLine(Offset(0, y), Offset(width, y), gridPaint);
    }
    
    // Vertical grid lines
    final stepX = width / labels.length;
    for (int i = 1; i <= labels.length; i++) {
      final x = i * stepX;
      canvas.drawLine(Offset(x, 0), Offset(x, height * 0.8), gridPaint);
    }
    
    // Draw x-axis labels
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 12,
    );
    
    for (int i = 0; i < labels.length; i++) {
      final x = i * stepX + (stepX / 2);
      final textPainter = TextPainter(
        text: TextSpan(text: labels[i], style: textStyle),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, height * 0.85));
    }
    
    // Draw y-axis labels
    for (int i = 0; i < yAxisLabels.length; i++) {
      final y = height * 0.8 - (i + 1) * (height * 0.8) / 5;
      final textPainter = TextPainter(
        text: TextSpan(text: yAxisLabels[i], style: textStyle),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(width - textPainter.width - 10, y - textPainter.height / 2));
    }
    
    // Draw the expense line
    final linePaint = Paint()
      ..color = Color(0xFFAF4BCE)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    final path = Path();
    
    for (int i = 0; i < data.length; i++) {
      final x = i * stepX + (stepX / 2);
      final y = height * 0.8 - data[i] * height * 0.8;
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final prevX = (i - 1) * stepX + (stepX / 2);
        final prevY = height * 0.8 - data[i - 1] * height * 0.8;
        final controlX = (prevX + x) / 2;
        path.quadraticBezierTo(controlX, prevY, x, y);
      }
    }
    
    canvas.drawPath(path, linePaint);
    
    // Create gradient fill under the line
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFAF4BCE).withOpacity(0.5),
          Color(0xFFAF4BCE).withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height * 0.8));
    
    // Clone the path and close it for filling
    final fillPath = Path.from(path);
    fillPath.lineTo((data.length - 1) * stepX + (stepX / 2), height * 0.8);
    fillPath.lineTo(stepX / 2, height * 0.8);
    fillPath.close();
    
    canvas.drawPath(fillPath, fillPaint);
    
    // Draw points on the line
    final pointPaint = Paint()
      ..color = Color(0xFFAF4BCE)
      ..style = PaintingStyle.fill;
    
    final pointBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    for (int i = 0; i < data.length; i++) {
      final x = i * stepX + (stepX / 2);
      final y = height * 0.8 - data[i] * height * 0.8;
      
      canvas.drawCircle(Offset(x, y), 4, pointPaint);
      canvas.drawCircle(Offset(x, y), 4, pointBorderPaint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}