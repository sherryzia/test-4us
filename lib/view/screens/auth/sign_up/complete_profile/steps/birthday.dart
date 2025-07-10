import 'package:candid/constants/app_sizes.dart';
import 'package:candid/utils/global_instances.dart';
import 'package:candid/view/widget/custom_drop_down_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Birthday extends StatefulWidget {
  Birthday({super.key});

  @override
  State<Birthday> createState() => _BirthdayState();
}

class _BirthdayState extends State<Birthday> {
  String? selectedDay = 'Day';
  String? selectedMonth = 'Month';
  String? selectedYear = 'Year';

  @override
  void initState() {
    super.initState();
    // Initialize with existing date if available
    if (profileController.dateOfBirth.value.isNotEmpty) {
      _parseExistingDate();
    }
  }

  void _parseExistingDate() {
    try {
      // Parse existing date format: YYYY-MM-DD
      List<String> parts = profileController.dateOfBirth.value.split('-');
      if (parts.length == 3) {
        selectedYear = parts[0];
        selectedMonth = parts[1];
        selectedDay = parts[2];
      }
    } catch (e) {
      print('Error parsing existing date: $e');
    }
  }

  void _updateDateOfBirth() {
    if (selectedDay != null && selectedDay != 'Day' &&
        selectedMonth != null && selectedMonth != 'Month' &&
        selectedYear != null && selectedYear != 'Year') {
      
      // Format date as YYYY-MM-DD for API
      String formattedDate = '$selectedYear-${selectedMonth!.padLeft(2, '0')}-${selectedDay!.padLeft(2, '0')}';
      
      // Update ProfileController
      profileController.dateOfBirth.value = formattedDate;
      
      print('Date updated: $formattedDate');
    } else {
      // Clear date if incomplete
      profileController.dateOfBirth.value = '';
    }
  }

  List<String> _getDaysInMonth() {
    if (selectedMonth == null || selectedMonth == 'Month' ||
        selectedYear == null || selectedYear == 'Year') {
      return ['Day', for (int i = 1; i <= 31; i++) '$i'];
    }

    int month = int.parse(selectedMonth!);
    int year = int.parse(selectedYear!);
    int daysInMonth = DateTime(year, month + 1, 0).day;

    return ['Day', for (int i = 1; i <= daysInMonth; i++) '$i'];
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      padding: AppSizes.DEFAULT,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomDropDown(
                hint: 'Day',
                items: _getDaysInMonth(),
                selectedValue: selectedDay,
                onChanged: (value) {
                  setState(() {
                    selectedDay = value;
                    // Reset day if it's invalid for the selected month
                    if (selectedDay != 'Day') {
                      List<String> validDays = _getDaysInMonth();
                      if (!validDays.contains(selectedDay)) {
                        selectedDay = 'Day';
                      }
                    }
                  });
                  _updateDateOfBirth();
                },
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: CustomDropDown(
                hint: 'Month',
                items: [
                  'Month',
                  for (int i = 1; i <= 12; i++) '$i',
                ],
                selectedValue: selectedMonth,
                onChanged: (value) {
                  setState(() {
                    selectedMonth = value;
                    // Reset day if it's invalid for the new month
                    if (selectedDay != null && selectedDay != 'Day') {
                      List<String> validDays = _getDaysInMonth();
                      if (!validDays.contains(selectedDay)) {
                        selectedDay = 'Day';
                      }
                    }
                  });
                  _updateDateOfBirth();
                },
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: CustomDropDown(
                hint: 'Year',
                items: [
                  'Year',
                  for (int i = DateTime.now().year - 18; i >= 1960; i--) '$i',
                ],
                selectedValue: selectedYear,
                onChanged: (value) {
                  setState(() {
                    selectedYear = value;
                    // Reset day if it's invalid for the new year (leap year consideration)
                    if (selectedDay != null && selectedDay != 'Day') {
                      List<String> validDays = _getDaysInMonth();
                      if (!validDays.contains(selectedDay)) {
                        selectedDay = 'Day';
                      }
                    }
                  });
                  _updateDateOfBirth();
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        // Age validation message
        if (selectedDay != null && selectedDay != 'Day' &&
            selectedMonth != null && selectedMonth != 'Month' &&
            selectedYear != null && selectedYear != 'Year')
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _calculateAge() >= 18 
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _calculateAge() >= 18 
                    ? Colors.green
                    : Colors.red,
                width: 1,
              ),
            ),
            child: Text(
              _calculateAge() >= 18 
                  ? '✓ You are ${_calculateAge()} years old. You can use this app.'
                  : '✗ You must be 18 or older to use this app. You are ${_calculateAge()} years old.',
              style: TextStyle(
                fontSize: 12,
                color: _calculateAge() >= 18 
                    ? Colors.green[700]
                    : Colors.red[700],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        SizedBox(height: 16),
        // Debug display (remove in production)
        Obx(() => Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'Controller value: "${profileController.dateOfBirth.value}"',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        )),
      ],
    );
  }

  int _calculateAge() {
    if (selectedDay == null || selectedDay == 'Day' ||
        selectedMonth == null || selectedMonth == 'Month' ||
        selectedYear == null || selectedYear == 'Year') {
      return 0;
    }

    try {
      DateTime birthDate = DateTime(
        int.parse(selectedYear!),
        int.parse(selectedMonth!),
        int.parse(selectedDay!),
      );
      DateTime today = DateTime.now();
      int age = today.year - birthDate.year;
      
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      
      return age;
    } catch (e) {
      return 0;
    }
  }
}