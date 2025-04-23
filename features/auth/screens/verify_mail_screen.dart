import 'dart:async';
import 'package:ecomanga/common/buttons/dynamic_button.dart';
import 'package:ecomanga/controllers/controllers.dart';
import 'package:ecomanga/features/auth/screens/login_screen.dart';
import 'package:ecomanga/features/home/root_screen.dart';
import 'package:ecomanga/features/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;
  int secondsRemaining = 30;
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    
    // User needs to be created & signed in before checking verification
    isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;
    
    if (!isEmailVerified) {
      // Start timer for auto-checking verification status
      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
      
      // Start countdown timer for resend button
      startResendCountdown();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    // Need to reload user data to get updated verification status
    await FirebaseAuth.instance.currentUser?.reload();
    
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;
    });
    
    if (isEmailVerified) {
      timer?.cancel();
      // Navigate to home after verification
      Utils.go(context: context, screen: const RootScreen(), replace: true);
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();
      
      setState(() {
        canResendEmail = false;
      });
      
      startResendCountdown();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification email sent. Please check your inbox.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send verification email: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void startResendCountdown() {
    setState(() {
      secondsRemaining = 30;
      canResendEmail = false;
    });
    
    countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (secondsRemaining > 0) {
          setState(() {
            secondsRemaining--;
          });
        } else {
          setState(() {
            canResendEmail = true;
          });
          timer.cancel();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? "your email";

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
                      "A verification email has been sent to "),
                ],
              ),
              Row(
                children: [
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15.h),
                ],
              ),
              SizedBox(height: 15.h),
              _normalText(
                "Please check your inbox and click the verification link to continue. "
                "If you don't see it, check your spam folder."
              ),
              SizedBox(height: 30.h),
              DynamicButton.fromText(
                text: "I've verified my email",
                onPressed: () async {
                  // Manually trigger verification check
                  await checkEmailVerified();
                  
                  if (!isEmailVerified) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email not verified yet. Please check your inbox and click the verification link.'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 20.h),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Didn't receive any email? ",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: 'Resend verification email',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: canResendEmail ? Colors.green : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = canResendEmail 
                            ? () => sendVerificationEmail() 
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Center(
                child: canResendEmail 
                  ? Container() 
                  : _normalText("Request a new email in 00:${secondsRemaining.toString().padLeft(2, '0')}"),
              ),
              SizedBox(height: 30.h),
              _buildBackToLoginButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackToLoginButton() {
    return Center(
      child: TextButton(
        onPressed: () {
          // Sign out and go back to login
          FirebaseAuth.instance.signOut();
          Utils.go(
            context: context, 
            screen: const LoginScreen(), 
            replace: true
          );
        },
        child: Text(
          "Cancel and return to login",
          style: TextStyle(
            color: Colors.red,
            fontSize: 14.sp,
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