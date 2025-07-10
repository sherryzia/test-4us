import 'package:candid/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    required this.child,
  });
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.imagesBgImage),
            fit: BoxFit.cover,
          ),
        ),
        child: child,
      ),
    );
  }
}
