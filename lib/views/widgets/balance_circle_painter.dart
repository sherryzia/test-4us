// views/widgets/balance_circle_painter.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

class BalanceCirclePainter extends CustomPainter {
  final double spentPercentage;
  final double availablePercentage;
  
  BalanceCirclePainter({
    required this.spentPercentage,
    required this.availablePercentage,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    
    // Background circle
    final backgroundPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;
    
    canvas.drawCircle(center, radius, backgroundPaint);
    
    // Spent amount (Red - Left half)
    final spentPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    
    // Available amount (Green - Right half)
    final availablePaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    
    // Draw spent arc (left half)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi, // Start from left (180 degrees)
      math.pi * spentPercentage, // Sweep based on spent percentage
      false,
      spentPaint,
    );
    
    // Draw available arc (right half)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0, // Start from right (0 degrees)
      math.pi * availablePercentage, // Sweep based on available percentage
      false,
      availablePaint,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}