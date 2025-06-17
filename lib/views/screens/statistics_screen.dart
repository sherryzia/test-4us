// Updated lib/views/screens/statistics_screen.dart
import 'package:expensary/constants/colors.dart';
import 'package:expensary/controllers/home_controller.dart';
import 'package:expensary/controllers/statistics_controller.dart';
import 'package:expensary/models/expense_item_model.dart';
import 'package:expensary/views/widgets/custom_app_bar.dart'; // Import the custom app bar
import 'package:expensary/views/widgets/my_Button.dart';
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
      // Using the custom app bar with title and profile
      appBar: CustomAppBar(
        title: 'Statistics',
        type: AppBarType.withProfile,
        onProfileTap: () {
          // Handle profile tap
          Get.snackbar(
            'Profile',
            'Profile button tapped',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        // Optional: Add a filter button if needed
       
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time Frame Selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildTimeFrameSelector(statisticsController),
            ),
            
            const SizedBox(height: 30),
            
            // Expenses Chart
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                height: 300,
                child: _buildExpenseChart(),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Total Spendings & Due Date Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildTotalSpendingsCard(homeController),
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
            
            const SizedBox(height: 100), // Space for bottom navigation
          ],
        ),
      ),
    );
  }
  
  // Time frame selector with proper GetX implementation
  Widget _buildTimeFrameSelector(StatisticsController controller) {
    List<String> timeFrames = ['1W', '1M', '3M', '6M', '1Y', 'ALL'];
    
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: kwhite.withOpacity(0.1), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: timeFrames.map((frame) => 
          GetX<StatisticsController>(
            builder: (controller) => GestureDetector(
              onTap: () => controller.changeTimeFrame(frame),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: controller.selectedTimeFrame.value == frame 
                      ? Color(0xFFAF4BCE)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: MyText(
                  text: frame,
                  size: 16,
                  weight: controller.selectedTimeFrame.value == frame
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: kwhite,
                ),
              ),
            ),
          )
        ).toList(),
      ),
    );
  }
  
  Widget _buildExpenseChart() {
    return CustomPaint(
      painter: ExpenseChartPainter(),
      child: Container(), // Empty container as the chart is drawn by the CustomPainter
    );
  }
  
  Widget _buildTotalSpendingsCard(HomeController controller) {
    return GetX<HomeController>(
      builder: (controller) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Color(0xFF2A2D40),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Total Spendings
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  text: 'Total Spendings',
                  size: 16,
                  color: kwhite.withOpacity(0.8),
                ),
                const SizedBox(height: 8),
                MyText(
                  text: '₨${_formatCurrency(controller.spentAmount.value)}',
                  size: 28,
                  weight: FontWeight.bold,
                  color: kwhite,
                ),
              ],
            ),
            
            // Due Date
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                MyText(
                  text: 'Due Date 10th Oct',
                  size: 16,
                  color: kwhite.withOpacity(0.8),
                ),
                const SizedBox(height: 8),
                MyButton(
                  onTap: () {},
                  buttonText: 'PAY EARLY',
                  width: 150,
                  height: 40,
                  fillColor: Color(0xFFAF4BCE),
                  fontColor: kwhite,
                  fontSize: 16,
                  radius: 25,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  // Recent transactions with proper GetX implementation
  Widget _buildRecentTransactions(HomeController controller) {
    return GetX<HomeController>(
      builder: (controller) => Column(
        children: controller.expenses
          .take(3) // Only show the most recent 3 transactions
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
    // For a real implementation, you would use actual logos
    switch (iconName) {
      case 'netflix':
        return Container(
          padding: EdgeInsets.all(4),
          child: Image.asset(
            'assets/images/netflix_logo.png',
            width: 40,
            height: 40,
            errorBuilder: (ctx, obj, stk) => Icon(Icons.movie, color: Colors.red, size: 26),
          ),
        );
      case 'amazon':
        return Icon(Icons.shopping_cart, color: color, size: 26);
      case 'apple':
        return Icon(Icons.apple, color: color, size: 26);
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
    // For amounts with decimal places
    if (amount - amount.truncate() > 0) {
      return amount.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},'
      );
    }
    // For whole numbers
    return amount.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},'
    );
  }
  
  String _formatDateWithTime(String date) {
    // Sample format: "21 Sept - 13:01"
    // In a real app, you would parse the actual date and format it accordingly
    
    // Extract month and day
    List<String> parts = date.split(' ');
    if (parts.length >= 2) {
      String day = parts[1].replaceAll(',', '');
      String month = parts[0];
      return '$day $month - 13:01'; // Add a placeholder time
    }
    return date;
  }
}

// Custom painter for the expense chart
class ExpenseChartPainter extends CustomPainter {
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
    for (int i = 1; i <= 6; i++) {
      final x = i * width / 6;
      canvas.drawLine(Offset(x, 0), Offset(x, height * 0.8), gridPaint);
    }
    
    // Chart data - simulated spending trend
    final List<double> data = [
      0.1, 0.25, 0.4, 0.65, 0.55, 1.0
    ];
    
    // X-axis labels (days of week)
    final List<String> labels = [
      'MON', 'TUE', 'WED', 'THR', 'FRI', 'SAT'
    ];
    
    // Y-axis labels (amounts)
    final List<String> amountLabels = [
      '1K', '2K', '3K', '4K', '5K'
    ];
    
    // Draw x-axis labels
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 12,
    );
    
    for (int i = 0; i < labels.length; i++) {
      final x = i * width / 6 + (width / 12);
      final textPainter = TextPainter(
        text: TextSpan(text: labels[i], style: textStyle),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, height * 0.85));
    }
    
    // Draw y-axis labels
    for (int i = 0; i < amountLabels.length; i++) {
      final y = height * 0.8 - (i + 1) * (height * 0.8) / 5;
      final textPainter = TextPainter(
        text: TextSpan(text: amountLabels[i], style: textStyle),
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
      final x = i * width / 6 + (width / 12);
      final y = height * 0.8 - data[i] * height * 0.8;
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        // Use quadratic bezier curve for smooth line
        final prevX = (i - 1) * width / 6 + (width / 12);
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
    fillPath.lineTo(width / 12 + (5 * width / 6), height * 0.8);
    fillPath.lineTo(width / 12, height * 0.8);
    fillPath.close();
    
    canvas.drawPath(fillPath, fillPaint);
    
    // Draw the highlighted point at the end of the line
    final highlightPaint = Paint()
      ..color = Color(0xFFAF4BCE)
      ..style = PaintingStyle.fill;
    
    final lastX = 5 * width / 6 + (width / 12);
    final lastY = height * 0.8 - data[5] * height * 0.8;
    
    canvas.drawCircle(Offset(lastX, lastY), 6, highlightPaint);
    
    // Draw border around highlight
    final highlightBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawCircle(Offset(lastX, lastY), 6, highlightBorderPaint);
    
    // Draw the "5K" label above the highlighted point
    final labelPaint = TextPainter(
      text: TextSpan(
        text: '5K',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    labelPaint.layout();
    
    // Draw label background
    final labelBgPaint = Paint()
      ..color = Color(0xFFAF4BCE)
      ..style = PaintingStyle.fill;
    
    final labelWidth = labelPaint.width + 16;
    final labelHeight = labelPaint.height + 8;
    
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        lastX - labelWidth / 2,
        lastY - labelHeight - 10,
        labelWidth,
        labelHeight,
      ),
      Radius.circular(10),
    );
    
    canvas.drawRRect(rrect, labelBgPaint);
    
    // Draw label text
    labelPaint.paint(
      canvas,
      Offset(
        lastX - labelPaint.width / 2,
        lastY - labelPaint.height - 14,
      ),
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}