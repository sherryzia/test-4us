// islamic_calendar_controller.dart
import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:quran_app/controllers/IslamicCalenderController.dart';
import 'package:table_calendar/table_calendar.dart';

// islamic_calendar_screen.dart
import 'package:flutter/material.dart';



class IslamicCalendarScreen extends StatelessWidget {
  const IslamicCalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the controller
    final controller = Get.put(IslamicCalendarController());
    
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 180.0,
              floating: false,
              pinned: true,
              backgroundColor: Colors.purple.shade800,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Islamic Calendar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background design with moon graphic overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colors.purple.shade900,
                            Colors.purple.shade800,
                            Colors.purple.shade700,
                          ],
                        ),
                      ),
                    ),
                    // Decorative elements
                    Positioned(
                      top: -30,
                      right: -30,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),
                    // Moon crescent icon
                    Positioned(
                      top: 60,
                      right: 20,
                      child: Icon(
                        Icons.nightlight_round,
                        size: 48,
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ),
                    // Overlay gradient
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Obx(() => IconButton(
                  icon: Icon(
                    controller.calendarView.value == 'gregorian' 
                        ? Icons.calendar_today 
                        : Icons.calendar_month,
                    color: Colors.white,
                  ),
                  tooltip: 'Toggle Calendar Type',
                  onPressed: controller.toggleCalendarView,
                )),
                IconButton(
                  icon: const Icon(Icons.info_outline, color: Colors.white),
                  onPressed: () {
                    _showInfoDialog(context, controller);
                  },
                ),
              ],
            ),
          ];
        },
        body: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            image: DecorationImage(
              image: AssetImage('assets/images/pattern_bg.png'),
              fit: BoxFit.cover,
              opacity: 0.03,
            ),
          ),
          child: Column(
            children: [
              _buildDateDisplay(controller),
              Expanded(
                child: Obx(() => controller.calendarView.value == 'gregorian'
                    ? _buildGregorianCalendar(controller)
                    : _buildHijriCalendar(controller)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateDisplay(IslamicCalendarController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 2,
          ),
        ],
        border: Border.all(
          color: Colors.purple.shade100,
          width: 1,
        ),
      ),
      child: Obx(() {
        final events = controller.getEventsForCurrentHijriDate();
        
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            size: 14,
                            color: Colors.purple.shade400,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Gregorian',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        controller.getFormattedGregorianDate(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.purple.shade100,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.nightlight,
                            size: 14,
                            color: Colors.purple.shade400,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Hijri',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        controller.getFormattedHijriDate(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade900,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (events.isNotEmpty) ...[
              Divider(
                height: 30,
                thickness: 1,
                color: Colors.purple.shade50,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: controller.getEventColor(events[0].importance).withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 36,
                      decoration: BoxDecoration(
                        color: controller.getEventColor(events[0].importance),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            events[0].name,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple.shade900,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            events[0].description,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.info_outline,
                        size: 18,
                        color: Colors.purple.shade600,
                      ),
                      onPressed: () {
                        Get.dialog(
                          AlertDialog(
                            title: Text(
                              events[0].name,
                              style: TextStyle(
                                color: Colors.purple.shade800,
                              ),
                            ),
                            content: Text(events[0].description),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(),
                                child: Text(
                                  'Close',
                                  style: TextStyle(
                                    color: Colors.purple.shade600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              if (events.length > 1)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.event_note,
                        size: 14,
                        color: Colors.purple.shade400,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '+ ${events.length - 1} more event(s)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.purple.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        );
      }),
    );
  }

  Widget _buildGregorianCalendar(IslamicCalendarController controller) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.purple.shade100,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() => TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: controller.focusedGregorianDate.value,
              calendarFormat: controller.calendarFormat.value,
              startingDayOfWeek: StartingDayOfWeek.sunday,
              daysOfWeekHeight: 40,
              rowHeight: 48,
              selectedDayPredicate: (day) {
                return isSameDay(controller.selectedGregorianDate.value, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                controller.updateHijriFromGregorian(selectedDay);
                controller.focusedGregorianDate.value = focusedDay;
              },
              onFormatChanged: (format) {
                controller.calendarFormat.value = format;
              },
              onPageChanged: (focusedDay) {
                controller.focusedGregorianDate.value = focusedDay;
              },
              calendarStyle: CalendarStyle(
                markersMaxCount: 3,
                markerDecoration: BoxDecoration(
                  color: Colors.purple.shade500,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.purple.shade300.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.purple.shade600,
                  shape: BoxShape.circle,
                ),
                outsideDaysVisible: false,
                weekendTextStyle: TextStyle(color: Colors.purple.shade300),
                holidayTextStyle: TextStyle(color: Colors.red.shade400),
              ),
              headerStyle: HeaderStyle(
                formatButtonShowsNext: false,
                titleCentered: true,
                formatButtonVisible: true,
                titleTextStyle: TextStyle(
                  color: Colors.purple.shade900,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
                formatButtonDecoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                formatButtonTextStyle: TextStyle(
                  color: Colors.purple.shade700,
                  fontSize: 13,
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: Colors.purple.shade600,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: Colors.purple.shade600,
                ),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  color: Colors.purple.shade800,
                  fontWeight: FontWeight.bold,
                ),
                weekendStyle: TextStyle(
                  color: Colors.purple.shade400,
                  fontWeight: FontWeight.bold,
                ),
              ),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  // Convert Gregorian to Hijri
                  final hijriDate = HijriCalendar.fromDate(date);
                  
                  // Check if this Hijri date has any events
                  final islamicEvents = controller.getEventsForHijriDate(hijriDate);
                  
                  if (islamicEvents.isEmpty) {
                    return null;
                  }
                  
                  // Show dot for the event
                  return Positioned(
                    bottom: 2,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: controller.getEventColor(islamicEvents[0].importance),
                      ),
                    ),
                  );
                },
              ),
            )),
          ),
        ),
      ),
    );
  }

  Widget _buildHijriCalendar(IslamicCalendarController controller) {
    // Current hijri date for reference
    final currentHijri = controller.selectedHijriDate.value;
    
    // Get the first day of the current hijri month
    final firstDayOfMonth = HijriCalendar()
      ..hYear = currentHijri.hYear
      ..hMonth = currentHijri.hMonth
      ..hDay = 1;
    
    // Convert to Gregorian for grid calculation
    final firstDayGregorian = firstDayOfMonth.hijriToGregorian(
      firstDayOfMonth.hYear,
      firstDayOfMonth.hMonth,
      firstDayOfMonth.hDay,
    );
    
    // Calculate the weekday of the first day (0 = Sunday, 6 = Saturday)
    final firstDayWeekday = firstDayGregorian.weekday % 7;
    
    // Get days in month
    final daysInMonth = HijriCalendar().getDaysInMonth(
      currentHijri.hYear,
      currentHijri.hMonth,
    );
    
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.purple.shade100,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              // Calendar header with decorative elements
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.purple.shade100,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.chevron_left,
                        color: Colors.purple.shade700,
                      ),
                      onPressed: () {
                        final newDate = HijriCalendar()
                          ..hYear = currentHijri.hMonth == 1
                              ? currentHijri.hYear - 1
                              : currentHijri.hYear
                          ..hMonth = currentHijri.hMonth == 1
                              ? 12
                              : currentHijri.hMonth - 1
                          ..hDay = 1;
                        controller.updateGregorianFromHijri(newDate);
                      },
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.nightlight_round,
                            size: 18,
                            color: Colors.purple.shade600,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${controller.getHijriMonthName(currentHijri.hMonth)} ${currentHijri.hYear}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple.shade900,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.chevron_right,
                        color: Colors.purple.shade700,
                      ),
                      onPressed: () {
                        final newDate = HijriCalendar()
                          ..hYear = currentHijri.hMonth == 12
                              ? currentHijri.hYear + 1
                              : currentHijri.hYear
                          ..hMonth = currentHijri.hMonth == 12
                              ? 1
                              : currentHijri.hMonth + 1
                          ..hDay = 1;
                        controller.updateGregorianFromHijri(newDate);
                      },
                    ),
                  ],
                ),
              ),
              
              // Weekday headers
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.purple.shade50,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _weekdayLabel('Sun'),
                    _weekdayLabel('Mon'),
                    _weekdayLabel('Tue'),
                    _weekdayLabel('Wed'),
                    _weekdayLabel('Thu'),
                    _weekdayLabel('Fri', isWeekend: true),
                    _weekdayLabel('Sat', isWeekend: true),
                  ],
                ),
              ),
              
              // Calendar grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: firstDayWeekday + daysInMonth,
                  itemBuilder: (context, index) {
                    // Empty cells for days before the 1st of month
                    if (index < firstDayWeekday) {
                      return Container();
                    }
                    
                    // Actual day cells
                    final hijriDay = index - firstDayWeekday + 1;
                    
                    // Create hijri date for this cell
                    final cellHijriDate = HijriCalendar()
                      ..hYear = currentHijri.hYear
                      ..hMonth = currentHijri.hMonth
                      ..hDay = hijriDay;
                    
                    // Check for events
                    final events = controller.getEventsForHijriDate(cellHijriDate);
                    final hasEvents = events.isNotEmpty;
                    final eventImportance = hasEvents ? events[0].importance : '';
                    
                    // Check if this is the selected day
                    final isSelected = cellHijriDate.hDay == currentHijri.hDay;
                    
                    // Check if this is today
                    final now = HijriCalendar.now();
                    final isToday = now.hYear == cellHijriDate.hYear &&
                        now.hMonth == cellHijriDate.hMonth &&
                        now.hDay == cellHijriDate.hDay;
                    
                    return InkWell(
                      onTap: () {
                        controller.updateGregorianFromHijri(cellHijriDate);
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? Colors.purple.shade600
                              : isToday
                                  ? Colors.purple.shade100
                                  : null,
                          border: hasEvents
                              ? Border.all(
                                  color: controller.getEventColor(eventImportance),
                                  width: 2,
                                )
                              : isToday && !isSelected
                                  ? Border.all(
                                      color: Colors.purple.shade300,
                                      width: 1,
                                    )
                                  : null,
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.purple.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            hijriDay.toString(),
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : hasEvents 
                                      ? controller.getEventColor(eventImportance)
                                      : isToday
                                          ? Colors.purple.shade800
                                          : Colors.grey.shade800,
                              fontWeight: isSelected || isToday || hasEvents 
                                  ? FontWeight.bold 
                                  : null,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _weekdayLabel(String text, {bool isWeekend = false}) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: isWeekend 
            ? Colors.purple.shade400
            : Colors.purple.shade800,
      ),
    );
  }

  void _showInfoDialog(BuildContext context, IslamicCalendarController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.purple.shade700,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Islamic Calendar Guide',
                style: TextStyle(
                  color: Colors.purple.shade900,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.purple.shade100,
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'The Islamic (Hijri) calendar is a lunar calendar consisting of 12 months in a year of 354 or 355 days.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.purple.shade700,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Important Islamic Dates',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.purple.shade900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildEventInfoItem('1 Muharram', 'Islamic New Year', Colors.red.shade600),
                _buildEventInfoItem('10 Muharram', 'Day of Ashura', Colors.red.shade600),
                _buildEventInfoItem('12 Rabi al-Awwal', 'Mawlid al-Nabi', Colors.red.shade600),
                _buildEventInfoItem('27 Rajab', 'Laylat al-Miraj', Colors.red.shade600),
                _buildEventInfoItem('15 Sha\'ban', 'Laylat al-Bara\'ah', Colors.orange.shade700),
                _buildEventInfoItem('1 Ramadan', 'Beginning of Ramadan', Colors.red.shade600),
                _buildEventInfoItem('27 Ramadan', 'Laylat al-Qadr', Colors.red.shade600),
                _buildEventInfoItem('1 Shawwal', 'Eid al-Fitr', Colors.red.shade600),
                _buildEventInfoItem('8-10 Dhu al-Hijjah', 'Hajj Pilgrimage', Colors.red.shade600),
                _buildEventInfoItem('9 Dhu al-Hijjah', 'Day of Arafah', Colors.red.shade600),
                _buildEventInfoItem('10 Dhu al-Hijjah', 'Eid al-Adha', Colors.red.shade600),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.purple.shade100,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 18,
                        color: Colors.purple.shade700,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Tap on any date to see events or switch between Gregorian and Hijri views',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.purple.shade900,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              child: Text(
                'Close',
                style: TextStyle(
                  color: Colors.purple.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildEventInfoItem(String date, String event, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.purple,

                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Modified controller to match the purple theme


// Updated bindings
class IslamicCalendarBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IslamicCalendarController>(() => IslamicCalendarController());
  }
}

