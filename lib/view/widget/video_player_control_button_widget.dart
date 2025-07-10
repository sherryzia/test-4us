import 'dart:ui';
import 'package:candid/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class VideoPlayerControlButton extends StatelessWidget {
  const VideoPlayerControlButton({
    super.key,
    required this.icon,
    required this.onTap,
  });
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              border: GradientBoxBorder(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    kPrimaryColor,
                    Color(0xff999999),
                  ],
                ),
                width: 1,
              ),
              shape: BoxShape.circle,
              color: kPrimaryColor.withOpacity(0.36),
            ),
            child: Center(
              child: Image.asset(
                icon,
                height: 21,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
