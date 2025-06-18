// Updated lib/views/screens/add_expense_screen.dart
import 'package:expensary/constants/colors.dart';
import 'package:expensary/controllers/add_expense_controller.dart';
import 'package:expensary/controllers/bottom_nav_controller.dart';
import 'package:expensary/views/widgets/custom_app_bar.dart';
import 'package:expensary/views/widgets/my_text.dart';
import 'package:expensary/views/widgets/my_Button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddExpenseScreen extends StatelessWidget {
  const AddExpenseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AddExpenseController controller = Get.put(AddExpenseController());
    final BottomNavController navController = Get.find<BottomNavController>();
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        title: 'Add Expenses',
        type: AppBarType.withProfile,
        hasUnderline: true,
        onProfileTap: () {
          // Handle profile tap
          Get.snackbar(
            'Profile',
            'Profile button tapped',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              backgroundColor,
              backgroundColor.withOpacity(0.8),
              Color(0xFF1A1A2E).withOpacity(0.9),
            ],
          ),
        ),
        child: Column(
          children: [
            // Enhanced Form Content
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      
                      // Enhanced Transaction Section
                      _buildEnhancedSection(
                        title: 'TRANSACTION',
                        icon: Icons.schedule,
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: controller.selectTime,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: kwhite.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: kwhite.withOpacity(0.1),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        color: kblue,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: MyText(
                                          text: controller.timeController.text.isEmpty 
                                              ? 'Select Time' 
                                              : controller.timeController.text,
                                          size: 16,
                                          color: controller.timeController.text.isEmpty 
                                              ? kwhite.withOpacity(0.6) 
                                              : kwhite,
                                          weight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: GestureDetector(
                                onTap: controller.selectDate,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: kwhite.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: kwhite.withOpacity(0.1),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        color: kgreen,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: MyText(
                                          text: controller.dateController.text.isEmpty 
                                              ? 'Select Date' 
                                              : controller.dateController.text,
                                          size: 16,
                                          color: controller.dateController.text.isEmpty 
                                              ? kwhite.withOpacity(0.6) 
                                              : kwhite,
                                          weight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Rest of the form fields...
                      const SizedBox(height: 24),
                      
                      // Added Merchant/Title Field
                      _buildEnhancedSection(
                        title: 'MERCHANT',
                        icon: Icons.store,
                        child: Container(
                          decoration: BoxDecoration(
                            color: kwhite.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: kwhite.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                child: Icon(
                                  Icons.storefront,
                                  color: korange,
                                  size: 24,
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: controller.titleController,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    color: kwhite,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Enter merchant name',
                                    hintStyle: TextStyle(
                                      color: kwhite.withOpacity(0.6),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Enhanced Category Section
                      _buildEnhancedSection(
                        title: 'CATEGORY',
                        icon: Icons.category,
                        child: Obx(() => _buildEnhancedDropdownField(
                          value: controller.selectedCategory.value,
                          items: controller.categories,
                          onChanged: controller.changeCategory,
                          icon: Icons.shopping_bag,
                          color: kpurple,
                        )),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Enhanced Amount Section
                      _buildEnhancedSection(
                        title: 'AMOUNT',
                        icon: Icons.currency_rupee,
                        child: Container(
                          decoration: BoxDecoration(
                            color: kwhite.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: kwhite.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                child: Icon(
                                  Icons.currency_rupee,
                                  color: kgreen,
                                  size: 24,
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: controller.amountController,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                    color: kwhite,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: '2,999',
                                    hintStyle: TextStyle(
                                      color: kwhite.withOpacity(0.6),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Enhanced Currency Section
                      _buildEnhancedSection(
                        title: 'CURRENCY',
                        icon: Icons.attach_money,
                        child: Obx(() => _buildEnhancedDropdownField(
                          value: controller.selectedCurrency.value,
                          items: controller.currencies,
                          onChanged: controller.changeCurrency,
                          icon: Icons.language,
                          color: kblue,
                        )),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Enhanced Payment Method Section
                      _buildEnhancedSection(
                        title: 'PAYMENT METHOD',
                        icon: Icons.payment,
                        child: Obx(() => _buildEnhancedDropdownField(
                          value: controller.selectedPaymentMethod.value,
                          items: controller.paymentMethods,
                          onChanged: controller.changePaymentMethod,
                          icon: Icons.credit_card,
                          color: korange,
                        )),
                      ),
                      
                      const SizedBox(height: 50),
                      
                      // Updated Save Button - now navigates back to home screen
                      MyButton(
                        onTap: () {
                          // Save the expense
                          controller.saveExpense();
                          
                          // Navigate back to home screen (index 0)
                          navController.currentIndex.value = 0;
                          navController.selectedTabIndex.value = 0;
                        },
                        buttonText: 'Save Expense',
                        width: 200,
                        height: 56,
                        fillColor: Color(0xFF8E2DE2),
                        fontColor: kwhite,
                        fontSize: 18,
                        radius: 28,
                        hasgrad: true,
                        fontWeight: FontWeight.w600,
                        icon: Icons.save,
                        iconPosition: IconPosition.left,
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Cancel Button - navigate back to previous screen
                      MyButton(
                        onTap: () {
                          // Just navigate back to home
                          navController.currentIndex.value = 0;
                          navController.selectedTabIndex.value = 0;
                        },
                        buttonText: 'Cancel',
                        width: 200,
                        height: 56,
                        fillColor: Colors.transparent,
                        outlineColor: kwhite.withOpacity(0.2),
                        fontColor: kwhite,
                        fontSize: 18,
                        radius: 28,
                        fontWeight: FontWeight.w600,
                      ),
                      
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // No need for a bottom navigation bar here - it's already in the MainNavigationScreen
    );
  }
  
  // Your existing helper methods...
  Widget _buildEnhancedSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, childWidget) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    kblack2.withOpacity(0.4),
                    kblack2.withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: kwhite.withOpacity(0.15),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: kblack.withOpacity(0.3),
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
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: kwhite.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          icon,
                          color: kwhite.withOpacity(0.8),
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      MyText(
                        text: title,
                        size: 13,
                        weight: FontWeight.w700,
                        color: kwhite.withOpacity(0.8),
                        letterSpacing: 1.2,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  child,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildEnhancedDropdownField({
    required String value,
    required List<String> items,
    required Function(String) onChanged,
    required IconData icon,
    required Color color,
  }) {
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: MyText(
              text: value,
              size: 16,
              weight: FontWeight.w600,
              color: kwhite,
            ),
          ),
          PopupMenuButton<String>(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kwhite.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: kwhite.withOpacity(0.8),
                size: 20,
              ),
            ),
            color: kblack2.withOpacity(0.95),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: kwhite.withOpacity(0.2)),
            ),
            elevation: 20,
            onSelected: onChanged,
            itemBuilder: (context) => items.map((item) => 
              PopupMenuItem<String>(
                value: item,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: item == value ? color.withOpacity(0.1) : Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      if (item == value)
                        Icon(
                          Icons.check_circle,
                          color: color,
                          size: 18,
                        ),
                      if (item == value) const SizedBox(width: 12),
                      MyText(
                        text: item,
                        size: 15,
                        color: kwhite,
                        weight: item == value ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ],
                  ),
                ),
              ),
            ).toList(),
          ),
        ],
      ),
    );
  }
}