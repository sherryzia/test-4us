// views/screens/add_expense_screen.dart
import 'package:expensary/constants/colors.dart';
import 'package:expensary/controllers/add_expense_controller.dart';
import 'package:expensary/views/widgets/my_text.dart';
import 'package:expensary/views/widgets/my_textfield.dart';
import 'package:expensary/views/widgets/my_Button.dart';
import 'package:expensary/views/widgets/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddExpenseScreen extends StatelessWidget {
  const AddExpenseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AddExpenseController controller = Get.put(AddExpenseController());
    
    return Scaffold(
      backgroundColor: backgroundColor,
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
        child: SafeArea(
          child: Column(
            children: [
              // Enhanced Header Section
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: kblack.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: kwhite.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: kwhite.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: kwhite,
                          size: 20,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        MyText(
                          text: 'Add Expenses',
                          size: 24,
                          weight: FontWeight.bold,
                          color: kwhite,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 40,
                          height: 3,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [kpurple, Color(0xFF8E2DE2)],
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
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
                        
                        // Enhanced Save Button
                        TweenAnimationBuilder(
                          duration: Duration(milliseconds: 800),
                          tween: Tween<double>(begin: 0, end: 1),
                          builder: (context, double value, child) {
                            return Transform.scale(
                              scale: 0.8 + (0.2 * value),
                              child: Opacity(
                                opacity: value,
                                child: GestureDetector(
                                  onTap: controller.saveExpense,
                                  child: Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF8E2DE2),
                                          Color(0xFF4A00E0),
                                          Color(0xFF6A1B9A),
                                        ],
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFF8E2DE2).withOpacity(0.4),
                                          blurRadius: 25,
                                          offset: Offset(0, 15),
                                          spreadRadius: 2,
                                        ),
                                        BoxShadow(
                                          color: Color(0xFF4A00E0).withOpacity(0.3),
                                          blurRadius: 15,
                                          offset: Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: kwhite.withOpacity(0.2),
                                          width: 2,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: kwhite,
                                        size: 45,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
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
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
  
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