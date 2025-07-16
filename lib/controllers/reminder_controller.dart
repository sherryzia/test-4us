// controllers/reminder_controller.dart

import 'package:affirmation_app/services/notification_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:affirmation_app/models/reminder_model.dart';
import 'dart:math';

import '../constants/affirmation_list.dart';

List<String> aff = affirmations = List.from(affirmations);

class ReminderController extends GetxController {
  var reminderModel = ReminderModel(
    startTime: TimeOfDay(hour: 9, minute: 0),
    endTime: TimeOfDay(hour: 11, minute: 0),
    value: 10.0,
  ).obs;

  @override
  void onInit() {
    super.onInit();
    loadTimes();
  }

  int getRandomNumber(int min, int max) {
    var random = Random();
    return (min + random.nextInt(max - min + 1));
  }

  Future<void> loadTimes() async {
    await reminderModel.value.loadTimes();
    reminderModel.refresh();
  }

  Future<void> saveTimes() async {
    await reminderModel.value.saveTimes();
  }

  Future<void> selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? reminderModel.value.startTime
          : reminderModel.value.endTime,
    );
    if (picked != null) {
      if (isStartTime) {
        reminderModel.value.startTime = picked;
      } else {
        reminderModel.value.endTime = picked;
      }
      await saveTimes();
      reminderModel.refresh();
    }
  }

  void scheduleNotifications() async {
    final startTimeInSeconds = reminderModel.value.startTime.hour * 3600 +
        reminderModel.value.startTime.minute * 60;
    final endTimeInSeconds = reminderModel.value.endTime.hour * 3600 +
        reminderModel.value.endTime.minute * 60;
    final totalSeconds = endTimeInSeconds - startTimeInSeconds;
    final intervalSeconds = (totalSeconds / reminderModel.value.value).round();

    await AwesomeNotifications().cancelAll();

    for (int i = 0; i < reminderModel.value.value; i++) {
      final notificationTimeInSeconds =
          startTimeInSeconds + intervalSeconds * i;
      final notificationHour = (notificationTimeInSeconds ~/ 3600) % 24;
      final notificationMinute = (notificationTimeInSeconds % 3600) ~/ 60;
      final notificationSecond = notificationTimeInSeconds % 60;
      int randomNumber = getRandomNumber(1, aff.length);
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: i,
          channelKey: 'high_importance_channel',
          title: "Ocular Vision ",
          body: aff[randomNumber - 1],
          notificationLayout: NotificationLayout.BigText,
        ),
        schedule: NotificationCalendar(
          hour: notificationHour,
          minute: notificationMinute,
          second: notificationSecond,
          millisecond: 0,
          repeats: true,
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'check',
            label: 'Check it out',
            // actionType: ActionType.SilentAction,
            color: Colors.green,
          ),
        ],
      );
    }
  }

  void trigger_notification() async {
    await NotificationService.showNotification(
      title: "Ocular Vision",
      body: "Your notification alert has been set!",
    );
  }
}
