import 'package:ecomanga/common/buttons/dynamic_button.dart';
import 'package:ecomanga/features/home/market_place/payment_screen.dart';
import 'package:ecomanga/features/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title:
            const Text('Shopping Cart', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Progress Indicator
          Padding(
            padding: EdgeInsets.all(16.h),
            child: Row(
              children: [
                _buildProgressDot('Cart\nConfirmation', true, first: true),
                Expanded(child: _buildProgressLine(true)),
                _buildProgressDot('Delivery\nMethod', true),
                Expanded(child: _buildProgressLine(false)),
                _buildProgressDot('Complete\nPayment', false),
                Expanded(child: _buildProgressLine(false)),
                _buildProgressDot('Order\nCompleted', false, last: true),
              ],
            ),
          ),

          // Cart Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildCartItem(
                  'Classic bamboo furniture chair',
                  '\$35',
                  'https://rukminim2.flixcart.com/image/1200/1200/xif0q/kid-seating/a/y/y/15-no-25-cane-1-shopbaby02small-brown-zaancreation-brown-45-original-imah4b8zz2tzffnq.jpeg',
                ),
                _buildCartItem(
                  'Lightweight ecofriendly bag',
                  '\$12',
                  'https://m.media-amazon.com/images/I/71cnDsVF27L._AC_UY1100_.jpg',
                ),
                _buildCartItem(
                  'Quartz set of biodegradable detergent',
                  '\$29',
                  'https://satopradhan.com/cdn/shop/files/natural-laundry-liquid-700ml-and-1-9kg-or-biodegradable-detergent-with-enzymes-or-baby-safe-and-pet-safe-satopradhan-1-31878023610594_1200x1200_crop_center.jpg?v=1696575093',
                ),
                const SizedBox(height: 20),

                // Summary
                const Text('Items (3)', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                _buildSummaryRow('Shipping', '\$10.00'),
                _buildSummaryRow('Import charges', '\$12.00'),
                const Divider(height: 32),
                _buildSummaryRow('Total Price', '\$98', isBold: true),
              ],
            ),
          ),

          // Checkout Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: DynamicButton.fromText(
              text: "Proceed to Checkout",
              onPressed: () {
                Utils.go(
                  context: context,
                  screen: const PaymentMethodScreen(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressDot(String label, bool isActive,
      {bool first = false, bool last = false}) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.green : Colors.grey.shade300,
            border: Border.all(
              color: isActive ? Colors.green : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: isActive
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : null,
        ),
        SizedBox(
          height: 4.h,
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? Colors.black : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine(bool isActive) {
    return Container(
      height: 2,
      color: isActive ? Colors.green : Colors.grey.shade300,
    );
  }

  Widget _buildCartItem(String title, String price, String image) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.w),
      padding: EdgeInsets.all(8.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child:
                Image.network(image, width: 80, height: 80, fit: BoxFit.cover),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.blue)),
                SizedBox(height: 4.h),
                Text(price,
                    style: const TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove, color: Colors.grey),
                onPressed: () {},
              ),
              Text('1'),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.grey),
                onPressed: () {},
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String amount, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
