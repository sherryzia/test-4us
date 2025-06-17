// views/screens/home_content.dart
import 'package:expensary/constants/colors.dart';
import 'package:expensary/views/widgets/custom_app_bar.dart'; // Import the custom app bar
import 'package:expensary/controllers/home_controller.dart';
import 'package:expensary/models/expense_item_model.dart';
import 'package:expensary/views/widgets/balance_circle_painter.dart';
import 'package:expensary/views/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    
    return Scaffold(
      backgroundColor: backgroundColor,
      // Using the custom app bar with title and profile type
      appBar: CustomAppBar(
        title: 'Home',
        type: AppBarType.withProfile,
        onProfileTap: () {
          // Handle profile tap
          Get.snackbar(
            'Profile',
            'Profile button tapped',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      ),
      body: Column(
        children: [
          // Expanded content area
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    
                    // Circular Progress Chart
                    Obx(() => Center(
                      child: Container(
                        width: 280,
                        height: 280,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Custom Circular Progress with half red, half green
                            SizedBox(
                              width: 240,
                              height: 240,
                              child: CustomPaint(
                                painter: BalanceCirclePainter(
                                  spentPercentage: controller.spentPercentage,
                                  availablePercentage: controller.availablePercentage,
                                ),
                              ),
                            ),
                            
                            // Center text
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MyText(
                                  text: '₨${_formatCurrency(controller.availableBalance.value)}',
                                  size: 28,
                                  weight: FontWeight.bold,
                                  color: kwhite,
                                ),
                                const SizedBox(height: 4),
                                MyText(
                                  text: 'Available Balance',
                                  size: 14,
                                  color: kwhite.withOpacity(0.7),
                                ),
                                const SizedBox(height: 8),
                                MyText(
                                  text: 'Spent: ₨${_formatCurrency(controller.spentAmount.value)}',
                                  size: 12,
                                  color: kred.withOpacity(0.8),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
                    
                    const SizedBox(height: 40),
                    
                    // Tip of the Day Card
                    Obx(() => _buildTipCard(controller, context)),
                    
                    const SizedBox(height: 30),
                    
                    // Expenses Section Header
                    _buildExpensesHeader(),
                    
                    const SizedBox(height: 20),
                    
                    // Expenses List
                    Obx(() => Column(
                      children: controller.expenses.map((expense) => 
                        _buildExpenseItem(expense)
                      ).toList(),
                    )),
                    
                    const SizedBox(height: 20),
                    
                   
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(HomeController controller, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kblack2.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: kwhite.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            text: 'Tip of the Day',
            size: 16,
            weight: FontWeight.w500,
            color: kwhite.withOpacity(0.8),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: MyText(
                  text: controller.tipTitle.value,
                  size: 18,
                  weight: FontWeight.w600,
                  color: kwhite,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: kwhite.withOpacity(0.7),
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 3,
            width: double.infinity,
            decoration: BoxDecoration(
              color: kgrey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 3,
                width: MediaQuery.of(context).size.width * controller.tipProgress.value,
                decoration: BoxDecoration(
                  color: kgreen,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpensesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MyText(
          text: 'Expenses',
          size: 24,
          weight: FontWeight.bold,
          color: kwhite,
        ),
        GestureDetector(
          onTap: () {
            // Navigate to all expenses
            Get.snackbar('Navigation', 'See all expenses');
          },
          child: MyText(
            text: 'See all',
            size: 16,
            weight: FontWeight.w500,
            color: kblue,
          ),
        ),
      ],
    );
  }

  
  Widget _buildExpenseItem(ExpenseItem expense) {
    IconData iconData = _getIconData(expense.iconData);
    Color iconBg = expense.iconBg == 'white' ? kwhite : kblack;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              iconData,
              color: iconBg == kwhite ? kblack : kwhite,
              size: 24,
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
                  size: 16,
                  weight: FontWeight.w600,
                  color: kwhite,
                ),
                const SizedBox(height: 4),
                MyText(
                  text: expense.date,
                  size: 14,
                  color: kwhite.withOpacity(0.6),
                ),
              ],
            ),
          ),
          
          // Amount
          MyText(
            text: '${expense.amount > 0 ? '+' : ''}₨${_formatCurrency(expense.amount.abs())}',
            size: 16,
            weight: FontWeight.bold,
            color: expense.amount > 0 ? kgreen : kred,
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'sports_basketball':
        return Icons.sports_basketball;
      case 'apple':
        return Icons.phone_iphone;
      case 'local_taxi':
        return Icons.local_taxi;
      default:
        return Icons.shopping_bag;
    }
  }

  String _formatCurrency(double amount) {
    return amount.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), 
      (Match m) => '${m[1]},'
    );
  }
}