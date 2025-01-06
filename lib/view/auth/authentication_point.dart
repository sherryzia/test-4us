import 'package:flutter/material.dart';
import 'package:forus_app/controllers/auth/AuthenticationPointController.dart';
import 'package:get/get.dart';

class AuthenticationPoint extends StatelessWidget {

  AuthenticationPoint({super.key});
  final AuthenticationPointController controller = Get.put(AuthenticationPointController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome, Please wait while we check your profile ...',
          style: TextStyle(fontSize: 24), // Customize the text style if needed
        ),
      ),
    );
  }
}
