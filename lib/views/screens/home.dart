// // Home Controller
// import 'package:get/get.dart';

// // Home Screen View
// import 'package:expensary/constants/colors.dart';
// import 'package:expensary/views/widgets/my_text.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'dart:math' as math;

// class HomeController extends GetxController {
//   // Observable variables
//   final RxDouble availableBalance = 112908.0.obs;
//   final RxDouble monthlyBudget = 150000.0.obs;
//   final RxDouble spentAmount = 37092.0.obs;
  
//   // Computed values
//   double get spentPercentage => spentAmount.value / monthlyBudget.value;
//   double get availablePercentage => availableBalance.value / monthlyBudget.value;
  
//   // Tip of the day
//   final RxString tipTitle = 'Prepare a Budget and Abide by it'.obs;
//   final RxDouble tipProgress = 0.4.obs;
  
//   // Sample expenses data
//   final RxList<ExpenseItem> expenses = <ExpenseItem>[
//     ExpenseItem(
//       title: 'Nike Air Max 2090',
//       date: '09 Oct 2023',
//       amount: -16999,
//       iconData: 'sports_basketball',
//       iconBg: 'white',
//     ),
//     ExpenseItem(
//       title: 'iPad Pro',
//       date: '10 Oct 2023',
//       amount: -79999,
//       iconData: 'apple',
//       iconBg: 'black',
//     ),
//     ExpenseItem(
//       title: 'Uber',
//       date: '5 Mar 2023',
//       amount: 50,
//       iconData: 'local_taxi',
//       iconBg: 'black',
//     ),
//   ].obs;
  
//   @override
//   void onInit() {
//     super.onInit();
//     // Initialize data or fetch from API
//     loadData();
//   }
  
//   void loadData() {
//     // Simulate API call or load from local storage
//     // This is where you'd fetch real data
//   }
  
//   void addExpense() {
//     // Handle add expense action
//     Get.snackbar(
//       'Add Expense',
//       'Navigate to add expense screen',
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   }
// }

// // Expense Item Model
// class ExpenseItem {
//   final String title;
//   final String date;
//   final double amount;
//   final String iconData;
//   final String iconBg;
  
//   ExpenseItem({
//     required this.title,
//     required this.date,
//     required this.amount,
//     required this.iconData,
//     required this.iconBg,
//   });
// }

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final HomeController controller = Get.put(HomeController());
    
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header Section
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   MyText(
//                     text: 'Home',
//                     size: 28,
//                     weight: FontWeight.bold,
//                     color: kwhite,
//                   ),
//                   CircleAvatar(
//                     radius: 20,
//                     backgroundColor: korange,
//                     child: Icon(
//                       Icons.person,
//                       color: kwhite,
//                       size: 24,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
            
//             // Expanded content area
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(height: 20),
                      
//                       // Circular Progress Chart
//                       Obx(() => Center(
//                         child: Container(
//                           width: 280,
//                           height: 280,
//                           child: Stack(
//                             alignment: Alignment.center,
//                             children: [
//                               // Custom Circular Progress with half red, half green
//                               SizedBox(
//                                 width: 240,
//                                 height: 240,
//                                 child: CustomPaint(
//                                   painter: BalanceCirclePainter(
//                                     spentPercentage: controller.spentPercentage,
//                                     availablePercentage: controller.availablePercentage,
//                                   ),
//                                 ),
//                               ),
                              
//                               // Center text
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   MyText(
//                                     text: '₹${controller.availableBalance.value.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
//                                     size: 28,
//                                     weight: FontWeight.bold,
//                                     color: kwhite,
//                                   ),
//                                   const SizedBox(height: 4),
//                                   MyText(
//                                     text: 'Available Balance',
//                                     size: 14,
//                                     color: kwhite.withOpacity(0.7),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   MyText(
//                                     text: 'Spent: ₹${controller.spentAmount.value.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
//                                     size: 12,
//                                     color: kred.withOpacity(0.8),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       )),
                      
//                       const SizedBox(height: 40),
                      
//                       // Tip of the Day Card
//                       Obx(() => Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.all(20),
//                         decoration: BoxDecoration(
//                           color: kblack2.withOpacity(0.3),
//                           borderRadius: BorderRadius.circular(16),
//                           border: Border.all(
//                             color: kwhite.withOpacity(0.1),
//                             width: 1,
//                           ),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             MyText(
//                               text: 'Tip of the Day',
//                               size: 16,
//                               weight: FontWeight.w500,
//                               color: kwhite.withOpacity(0.8),
//                             ),
//                             const SizedBox(height: 12),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: MyText(
//                                     text: controller.tipTitle.value,
//                                     size: 18,
//                                     weight: FontWeight.w600,
//                                     color: kwhite,
//                                   ),
//                                 ),
//                                 Icon(
//                                   Icons.arrow_forward_ios,
//                                   color: kwhite.withOpacity(0.7),
//                                   size: 16,
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 8),
//                             Container(
//                               height: 3,
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                 color: kgrey.withOpacity(0.2),
//                                 borderRadius: BorderRadius.circular(2),
//                               ),
//                               child: Align(
//                                 alignment: Alignment.centerLeft,
//                                 child: Container(
//                                   height: 3,
//                                   width: MediaQuery.of(context).size.width * controller.tipProgress.value,
//                                   decoration: BoxDecoration(
//                                     color: kgreen,
//                                     borderRadius: BorderRadius.circular(2),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       )),
                      
//                       const SizedBox(height: 30),
                      
//                       // Expenses Section Header
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           MyText(
//                             text: 'Expenses',
//                             size: 24,
//                             weight: FontWeight.bold,
//                             color: kwhite,
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               // Navigate to all expenses
//                               Get.snackbar('Navigation', 'See all expenses');
//                             },
//                             child: MyText(
//                               text: 'See all',
//                               size: 16,
//                               weight: FontWeight.w500,
//                               color: kblue,
//                             ),
//                           ),
//                         ],
//                       ),
                      
//                       const SizedBox(height: 20),
                      
//                       // Expenses List
//                       Obx(() => Column(
//                         children: controller.expenses.map((expense) => 
//                           _buildExpenseItem(expense)
//                         ).toList(),
//                       )),
                      
//                       const SizedBox(height: 20),
                      
//                       // Add Button
//                       Center(
//                         child: GestureDetector(
//                           onTap: controller.addExpense,
//                           child: Container(
//                             width: 56,
//                             height: 56,
//                             decoration: BoxDecoration(
//                               color: kpurple,
//                               shape: BoxShape.circle,
//                             ),
//                             child: Icon(
//                               Icons.add,
//                               color: kwhite,
//                               size: 28,
//                             ),
//                           ),
//                         ),
//                       ),
                      
//                       const SizedBox(height: 100), // Space for bottom navigation
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
      
//       // Bottom Navigation Bar
//       bottomNavigationBar: Container(
//         height: 80,
//         decoration: BoxDecoration(
//           color: backgroundColor,
//           border: Border(
//             top: BorderSide(
//               color: kwhite.withOpacity(0.1),
//               width: 1,
//             ),
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             _buildNavItem(Icons.home, true),
//             _buildNavItem(Icons.bar_chart, false),
//             _buildNavItem(Icons.account_balance_wallet, false),
//             _buildNavItem(Icons.person, false),
//           ],
//         ),
//       ),
//     );
//   }
  
//   Widget _buildExpenseItem(ExpenseItem expense) {
//     IconData iconData;
//     Color iconBg;
    
//     // Map string to IconData
//     switch (expense.iconData) {
//       case 'sports_basketball':
//         iconData = Icons.sports_basketball;
//         break;
//       case 'apple':
//         iconData = Icons.phone_iphone; // Using phone icon for Apple
//         break;
//       case 'local_taxi':
//         iconData = Icons.local_taxi;
//         break;
//       default:
//         iconData = Icons.shopping_bag;
//     }
    
//     // Map string to Color
//     iconBg = expense.iconBg == 'white' ? kwhite : kblack;
    
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Row(
//         children: [
//           // Icon
//           Container(
//             width: 48,
//             height: 48,
//             decoration: BoxDecoration(
//               color: iconBg,
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               iconData,
//               color: iconBg == kwhite ? kblack : kwhite,
//               size: 24,
//             ),
//           ),
          
//           const SizedBox(width: 16),
          
//           // Title and Date
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 MyText(
//                   text: expense.title,
//                   size: 16,
//                   weight: FontWeight.w600,
//                   color: kwhite,
//                 ),
//                 const SizedBox(height: 4),
//                 MyText(
//                   text: expense.date,
//                   size: 14,
//                   color: kwhite.withOpacity(0.6),
//                 ),
//               ],
//             ),
//           ),
          
//           // Amount
//           MyText(
//             text: '${expense.amount > 0 ? '+' : ''}₹${expense.amount.abs().toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
//             size: 16,
//             weight: FontWeight.bold,
//             color: expense.amount > 0 ? kgreen : kred,
//           ),
//         ],
//       ),
//     );
//   }
  
//   Widget _buildNavItem(IconData icon, bool isActive) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       child: Icon(
//         icon,
//         color: isActive ? kpurple : kwhite.withOpacity(0.5),
//         size: 28,
//       ),
//     );
//   }
// }

// // Custom Painter for Half Red, Half Green Circle
// class BalanceCirclePainter extends CustomPainter {
//   final double spentPercentage;
//   final double availablePercentage;
  
//   BalanceCirclePainter({
//     required this.spentPercentage,
//     required this.availablePercentage,
//   });
  
//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = size.width / 2 - 10;
    
//     // Background circle
//     final backgroundPaint = Paint()
//       ..color = Colors.grey.withOpacity(0.2)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 12;
    
//     canvas.drawCircle(center, radius, backgroundPaint);
    
//     // Spent amount (Red - Left half)
//     final spentPaint = Paint()
//       ..color = Colors.red
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 12
//       ..strokeCap = StrokeCap.round;
    
//     // Available amount (Green - Right half)
//     final availablePaint = Paint()
//       ..color = Colors.green
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 12
//       ..strokeCap = StrokeCap.round;
    
//     // Draw spent arc (left half)
//     canvas.drawArc(
//       Rect.fromCircle(center: center, radius: radius),
//       math.pi, // Start from left (180 degrees)
//       math.pi * spentPercentage, // Sweep based on spent percentage
//       false,
//       spentPaint,
//     );
    
//     // Draw available arc (right half)
//     canvas.drawArc(
//       Rect.fromCircle(center: center, radius: radius),
//       0, // Start from right (0 degrees)
//       math.pi * availablePercentage, // Sweep based on available percentage
//       false,
//       availablePaint,
//     );
//   }
  
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }