// models/reminder_model.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReminderModel {
  TimeOfDay startTime;
  TimeOfDay endTime;
  double value;

  ReminderModel(
      {required this.startTime, required this.endTime, required this.value});

  Future<void> loadTimes() async {
    final prefs = await SharedPreferences.getInstance();
    final startHour = prefs.getInt('startHour') ?? 9;
    final startMinute = prefs.getInt('startMinute') ?? 0;
    final endHour = prefs.getInt('endHour') ?? 11;
    final endMinute = prefs.getInt('endMinute') ?? 0;

    startTime = TimeOfDay(hour: startHour, minute: startMinute);
    endTime = TimeOfDay(hour: endHour, minute: endMinute);
  }

  Future<void> saveTimes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('startHour', startTime.hour);
    await prefs.setInt('startMinute', startTime.minute);
    await prefs.setInt('endHour', endTime.hour);
    await prefs.setInt('endMinute', endTime.minute);
  }
}
