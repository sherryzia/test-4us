import 'package:ecomanga/common/buttons/dynamic_button.dart';
import 'package:ecomanga/features/home/root_screen.dart';
import 'package:ecomanga/features/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  @override
  Widget build(BuildContext context) {
    final FocusNode pinFocusNode = FocusNode();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),
              Image.asset(
                'assets/icons/app_icon.png',
                height: 80,
              ),
              _headingText("Verify email"),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _normalText(
                      "Please enter the 6-digit code sent to your email "),
                ],
              ),
              Row(
                children: [
                  Text(
                    'sumitsingh@gmail.com',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _normalText("for verification"),
                  SizedBox(
                    height: 15.h,
                  ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              Pinput(
                focusNode: pinFocusNode,
                length: 6,
                defaultPinTheme: PinTheme(
                  width: 50,
                  height: 50,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                focusedPinTheme: PinTheme(
                  width: 50,
                  height: 50,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                submittedPinTheme: PinTheme(
                  width: 50,
                  height: 50,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onCompleted: (pin) {},
              ),
              SizedBox(height: 30.h),
              DynamicButton.fromText(
                text: "Verify email",
                onPressed: () {
                  Utils.go(
                    context: context,
                    screen: const RootScreen(),
                  );
                },
              ),
              SizedBox(height: 20.h),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Didn't receive any code? ",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: 'Resend Again',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Handle resend action
                          },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Center(
                child: _normalText("Request a new code in 00:30s"),
              )
            ],
          ),
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
      style: TextStyle(fontSize: 14.sp, color: Colors.black),
    );
  }
}
