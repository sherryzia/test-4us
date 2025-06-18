// views/screens/home_content.dart (Updated)
import 'package:expensary/constants/colors.dart';
import 'package:expensary/views/widgets/custom_app_bar.dart';
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
      appBar: CustomAppBar(
        title: 'Home',
        type: AppBarType.withProfile,
        onProfileTap: () {
          Get.snackbar(
            'Profile',
            'Profile button tapped',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Circular Progress Chart
                    Obx(() => Center(
                      child: Container(
                        width: 280,
                        height: 280,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
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
                    
                    const SizedBox(height: 10),
                    
                    // Rotating Tips Card
                    _buildRotatingTipsCard(controller, context),
                    
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRotatingTipsCard(HomeController controller, BuildContext context) {
    return Obx(() {
      final currentTip = controller.currentTip;
      
      return GestureDetector(
        onHorizontalDragEnd: (details) {
          // Handle swipe gestures
          if (details.primaryVelocity! > 0) {
            // Swiped right (previous tip)
            controller.goToPreviousTip();
          } else if (details.primaryVelocity! < 0) {
            // Swiped left (next tip)
            controller.goToNextTip();
          }
        },
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          transitionBuilder: (child, animation) {
            return SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: Offset(0.3, 0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: Container(
            key: ValueKey(controller.currentTipIndex.value),
            width: double.infinity,
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
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: kwhite.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF8E2DE2).withOpacity(0.2),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with navigation dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Colors.amber,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        MyText(
                          text: 'Tips',
                          size: 16,
                          weight: FontWeight.w600,
                          color: kwhite.withOpacity(0.9),
                        ),
                      ],
                    ),
                    // Navigation dots
                    Row(
                      children: List.generate(
                        controller.tips.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == controller.currentTipIndex.value
                                ? Colors.amber
                                : kwhite.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Tip title
                MyText(
                  text: currentTip!.title,
                  size: 18,
                  weight: FontWeight.bold,
                  color: kwhite,
                  lineHeight: 1.3,
                ),
                
                const SizedBox(height: 8),
                
                // Tip description
                MyText(
                  text: currentTip.description,
                  size: 14,
                  color: kwhite.withOpacity(0.8),
                  lineHeight: 1.4,
                ),
                
                const SizedBox(height: 16),
                
                
                // Swipe indicator
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.swipe,
                        color: kwhite.withOpacity(0.5),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      MyText(
                        text: 'Swipe for more tips',
                        size: 12,
                        color: kwhite.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
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
      case 'amazon':
        return Icons.shopping_cart;
      case 'mcdonalds':
        return Icons.fastfood;
      case 'starbucks':
        return Icons.coffee;
      case 'mastercard':
        return Icons.credit_card;
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