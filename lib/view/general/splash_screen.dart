import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:forus_app/controllers/SplashScreenController.dart';
import 'package:forus_app/generated/assets.dart';

class SplashScreen extends StatelessWidget {
  final SplashController controller = Get.put(SplashController());

  // Add a named key parameter to the constructor
  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
            () => Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.imagesSplashVenderProvider),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            if (controller.isLoading.value)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
