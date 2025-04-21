// success_page.dart
import 'package:ecomanga/common/buttons/dynamic_button.dart';
import 'package:ecomanga/features/home/root_screen.dart';
import 'package:ecomanga/features/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/icons/success_icon.png",
              height: 200,
            ),
            _headingText("Congratulations!"),
            SizedBox(height: 10.h),
            _normalText("Your purchase order has"),
            _normalText("been placed successfully"),
            SizedBox(height: 20.h),
            DynamicButton.fromText(
                text: "Back to Homepage",
                onPressed: () {
                  Utils.go(context: context, screen: const RootScreen());
                })
          ],
        ),
      ),
    );
  }

  _headingText(String text) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 25.sp, fontWeight: FontWeight.bold, color: Colors.black),
    );
  }

  _normalText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 16.sp, color: Colors.grey),
    );
  }
}
