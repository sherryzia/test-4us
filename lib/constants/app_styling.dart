import 'package:flutter/material.dart';

import 'app_colors.dart';

BoxDecoration circle(Color color, Color? borderColor) {
  return BoxDecoration(
      shape: BoxShape.circle,
      color: color,
      border: Border.all(color: borderColor ?? Colors.transparent));
}

BoxDecoration rounded(Color color) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(15),
    color: color,
    boxShadow: [
      BoxShadow(
        color: kBlackColor.withOpacity(0.1),
        blurRadius: 5,
        offset: Offset(2, 2), // Shadow position
      ),
    ],
  );
}

BoxDecoration roundedsr(Color color, double radius) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    color: color,
    boxShadow: [
      BoxShadow(
        color: kBlackColor.withOpacity(0.2),
        blurRadius: 5,
        offset: Offset(2, 2), // Shadow position
      ),
    ],
  );
}

class KTertiaryColor {}

BoxDecoration rounded2(Color color, Color? borderColor) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: color,
    border: Border.all(
      color: borderColor ?? Colors.transparent,
    ),
  );
}

BoxDecoration rounded2r(Color color, Color? borderColor, double radius) {
  return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: color,
      border: Border.all(color: borderColor ?? Colors.transparent));
}

BoxDecoration roundedr(Color color, double radius) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    color: color,
  );
}

ShapeDecoration shadowDecoration(double radius) {
  return ShapeDecoration(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
    ),
    shadows: const [
      BoxShadow(
        color: Color(0x14000000),
        blurRadius: 24,
        offset: Offset(0, 0),
        spreadRadius: 0,
      )
    ],
  );
}
