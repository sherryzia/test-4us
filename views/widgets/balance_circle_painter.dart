// lib/views/widgets/balance_circle_painter.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:expensary/constants/colors.dart';

class BalanceCirclePainter extends CustomPainter {
  final double spentPercentage;
  final double availablePercentage;
  // Add income percentage to properly visualize it
  final double incomePercentage;

  BalanceCirclePainter({
    required this.spentPercentage,
    required this.availablePercentage,
    this.incomePercentage = 0.0, // Default to 0 if not provided
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    final strokeWidth = radius * 0.18;
    final innerRadius = radius - strokeWidth / 2;

    // Create a background circle (light gray)
    final backgroundPaint = Paint()
      ..color = kwhite.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, innerRadius, backgroundPaint);

    // The circle is divided into three sections:
    // 1. Income section (green)
    // 2. Expense section (red)
    // 3. Available balance section (blue)

    // Calculate the start angles and sweep angles for each section
    double startAngle = -pi / 2; // Start from top (12 o'clock position)
    
    // Income arc (green)
    if (incomePercentage > 0) {
      final incomePaint = Paint()
        ..color = kgreen
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      final incomeSweep = 2 * pi * incomePercentage;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: innerRadius),
        startAngle,
        incomeSweep,
        false,
        incomePaint,
      );
      
      startAngle += incomeSweep;
    }
    
    // Expense arc (red)
    if (spentPercentage > 0) {
      final expensePaint = Paint()
        ..color = kred
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      final expenseSweep = 2 * pi * spentPercentage;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: innerRadius),
        startAngle,
        expenseSweep,
        false,
        expensePaint,
      );
      
      startAngle += expenseSweep;
    }
    
    // Available balance arc (blue)
    if (availablePercentage > 0) {
      final balancePaint = Paint()
        ..color = kblue
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      final balanceSweep = 2 * pi * availablePercentage;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: innerRadius),
        startAngle,
        balanceSweep,
        false,
        balancePaint,
      );
    }
    
    // Draw inner circle with progress
    final innerCircleRadius = innerRadius * 0.7;
    
    // Inner circle background
    final innerBackgroundPaint = Paint()
      ..color = kwhite.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 0.6
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, innerCircleRadius, innerBackgroundPaint);
    
    // Inner progress to show budget utilization
    // Calculate what percentage of budget is used (spent / budget)
    final budgetUsedPercentage = min(spentPercentage / (spentPercentage + availablePercentage), 1.0);
    
    if (budgetUsedPercentage > 0) {
      final innerProgressPaint = Paint()
        ..color = budgetUsedPercentage > 0.8 ? kred : 
                 (budgetUsedPercentage > 0.6 ? korange : kgreen)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth * 0.6
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: innerCircleRadius),
        -pi / 2,
        2 * pi * budgetUsedPercentage,
        false,
        innerProgressPaint,
      );
    }
    
    // Draw center circle
    final centerCirclePaint = Paint()
      ..color = Color(0xFF211134).withOpacity(0.8)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, innerRadius * 0.55, centerCirclePaint);
    
    // Add decorative dots around the circle
    final dotPaint = Paint()
      ..color = kwhite.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    final int numDots = 24;
    final double dotRadius = radius * 0.015;
    final double dotDistance = radius * 1.15;
    
    for (int i = 0; i < numDots; i++) {
      final angle = 2 * pi * i / numDots;
      final dotCenter = Offset(
        center.dx + dotDistance * cos(angle),
        center.dy + dotDistance * sin(angle),
      );
      canvas.drawCircle(dotCenter, dotRadius, dotPaint);
    }
  }

  @override
  bool shouldRepaint(BalanceCirclePainter oldDelegate) {
    return oldDelegate.spentPercentage != spentPercentage ||
           oldDelegate.availablePercentage != availablePercentage ||
           oldDelegate.incomePercentage != incomePercentage;
  }
}