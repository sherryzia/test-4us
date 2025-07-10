import 'package:flutter/material.dart';
import 'package:candid/constants/app_colors.dart';
import 'package:candid/controller/AuthenticationPointController.dart';
import 'package:get/get.dart';

class AuthenticationPoint extends StatelessWidget {
  AuthenticationPoint({super.key});
  final AuthenticationPointController controller = Get.put(AuthenticationPointController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16), // Adds spacing between the indicator and text
            Text(
              "Loading",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
