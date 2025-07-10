import 'package:candid/constants/app_images.dart';
import 'package:flutter/material.dart';

class CustomBackground extends StatelessWidget {
  final Widget child;
  final String? bgImage;
  const CustomBackground({
    super.key,
    this.bgImage = Assets.imagesBg,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(bgImage!),
            fit: BoxFit.cover,
          ),
        ),
        child: child,
      ),
    );
  }
}
