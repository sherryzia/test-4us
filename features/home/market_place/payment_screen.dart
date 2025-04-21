import 'package:ecomanga/common/buttons/dynamic_button.dart';
import 'package:ecomanga/features/home/market_place/succss.page.dart';
import 'package:ecomanga/features/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  int selectedPaymentMethod = 0;
  bool saveCard = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Payment method',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildProgressDot('Cart\nConfirmation', true, true),
                Expanded(child: _buildProgressLine(true)),
                _buildProgressDot('Delivery\nMethod', true, true),
                Expanded(child: _buildProgressLine(false)),
                _buildProgressDot('Complete\nPayment', false, false),
                Expanded(child: _buildProgressLine(false)),
                _buildProgressDot('Order\nCompleted', false, false),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),

            Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20.h,
            ),

            // Payment Methods
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPaymentOption(0, 'assets/icons/masterCard.png'),
                _buildPaymentOption(1, 'assets/icons/applepay.png'),
                _buildPaymentOption(2, 'assets/icons/paypal.png'),
                _buildPaymentOption(3, 'assets/icons/googlepay.png'),
              ],
            ),
            SizedBox(
              height: 30.h,
            ),

            Expanded(
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Name',
                      filled: true,
                      fillColor: Colors.green.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Card number',
                      filled: true,
                      fillColor: Colors.green.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Expiry date',
                            filled: true,
                            fillColor: Colors.green.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'CVV',
                            filled: true,
                            fillColor: Colors.green.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Checkbox(
                        value: saveCard,
                        onChanged: (value) {
                          setState(() => saveCard = value!);
                        },
                        activeColor: Colors.green,
                      ),
                      const Text('Save credit card details'),
                    ],
                  ),
                ],
              ),
            ),

            DynamicButton.fromText(
              text: "Proceed to pay",
              onPressed: () {
                Utils.go(
                  context: context,
                  screen: const SuccessPage(),
                );
              },
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(int index, String assetPath) {
    bool isSelected = selectedPaymentMethod == index;
    return GestureDetector(
      onTap: () => setState(() => selectedPaymentMethod = index),
      child: Container(
        width: 70,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image.asset(assetPath, scale: 2),
      ),
    );
  }

  Widget _buildProgressDot(String label, bool isCompleted, bool isActive) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? Colors.green
                : (isActive ? Colors.white : Colors.grey.shade300),
            border: Border.all(
              color: isCompleted
                  ? Colors.green
                  : (isActive ? Colors.green : Colors.grey.shade300),
              width: 2,
            ),
          ),
          child: isCompleted
              ? Icon(Icons.check, size: 16, color: Colors.white)
              : null,
        ),
        SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: isCompleted || isActive ? Colors.black : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine(bool isCompleted) {
    return Container(
      height: 2,
      color: isCompleted ? Colors.green : Colors.grey.shade300,
    );
  }
}
