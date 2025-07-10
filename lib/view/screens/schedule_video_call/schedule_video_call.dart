import 'dart:async';

import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_fonts.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/view/screens/schedule_video_call/scheduled_video_date_details.dart';
import 'package:candid/view/widget/my_button_widget.dart';
import 'package:candid/view/widget/my_text_field_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleVideoCall extends StatefulWidget {
  const ScheduleVideoCall({super.key});

  @override
  State<ScheduleVideoCall> createState() => _ScheduleVideoCallState();
}

class _ScheduleVideoCallState extends State<ScheduleVideoCall> {
  DateTime selectedTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.only(top: 55),
        height: Get.height * 0.9,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.imagesVdBg),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(22),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: AppSizes.HORIZONTAL,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(Assets.imagesVdtBg),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: MyText(
                      text: 'virtual Date!'.toUpperCase(),
                      size: 20,
                      fontFamily: GoogleFonts.familjenGrotesk().fontFamily,
                      weight: FontWeight.w700,
                      color: kPrimaryColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Icon(
                    Icons.arrow_back_ios,
                    color: Colors.transparent,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: AppSizes.HORIZONTAL,
                physics: BouncingScrollPhysics(),
                children: [
                  Image.asset(
                    Assets.imagesVd,
                    height: 98,
                  ),
                  MyText(
                    paddingTop: 12,
                    text:
                        'Ready to take the next step? Propose a Date Night with your Match and enjoy a genuine online date experience.',
                    size: 12,
                    lineHeight: 1.3,
                    textAlign: TextAlign.center,
                    color: kHintColor,
                    paddingBottom: 20,
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: kPrimaryColor,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 12,
                          color: kBlackColor.withOpacity(0.16),
                        ),
                      ],
                    ),
                    child: EasyDateTimeLine(
                      initialDate: DateTime.now(),
                      onDateChange: (selectedDate) {
                        //`selectedDate` the new date selected.
                      },
                      activeColor: kSecondaryColor,
                      headerProps: const EasyHeaderProps(
                        showHeader: true,
                        monthPickerType: MonthPickerType.switcher,
                        dateFormatter: DateFormatter.fullDateMonthAsStrDY(),
                        selectedDateStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        monthStyle: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      timeLineProps: EasyTimeLineProps(
                        vPadding: 0,
                        hPadding: 12,
                      ),
                      dayProps: EasyDayProps(
                        height: 76.0,
                        width: 40.0,
                        dayStructure: DayStructure.dayNumDayStr,
                        inactiveDayStyle: DayStyle(
                          dayNumStyle: TextStyle(
                            fontSize: 16.0,
                            height: 1.5,
                            color: kTertiaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          dayStrStyle: TextStyle(
                            fontSize: 12.0,
                            height: 1.5,
                            color: kTertiaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        activeDayStyle: DayStyle(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [
                                kSecondaryColor,
                                kPurpleColor,
                              ],
                            ),
                          ),
                          dayNumStyle: TextStyle(
                            fontSize: 16.0,
                            height: 1.5,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          dayStrStyle: TextStyle(
                            fontSize: 12.0,
                            height: 2.5,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        todayStyle: DayStyle(
                          decoration: BoxDecoration(),
                          dayNumStyle: TextStyle(
                            fontSize: 16.0,
                            height: 1.5,
                            color: kTertiaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          dayStrStyle: TextStyle(
                            fontSize: 12.0,
                            height: 1.5,
                            color: kTertiaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          splashBorder: BorderRadius.zero,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: kPrimaryColor,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 12,
                          color: kBlackColor.withOpacity(0.16),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          paddingTop: 20,
                          text: 'Select Time',
                          size: 12,
                          weight: FontWeight.w600,
                          paddingRight: 20,
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    SimpleTextField2(
                                      hintText: '00',
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    GradientText(
                                      'HOURS',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: AppFonts.URBANIST,
                                      ),
                                      gradientType: GradientType.linear,
                                      colors: [
                                        kSecondaryColor,
                                        kPurpleColor,
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Image.asset(
                                  Assets.imagesSeprator,
                                  height: 20,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    SimpleTextField2(
                                      hintText: '00',
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    GradientText(
                                      'MINUTES',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: AppFonts.URBANIST,
                                      ),
                                      gradientType: GradientType.linear,
                                      colors: [
                                        kSecondaryColor,
                                        kPurpleColor,
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(1),
                          height: 48,
                          width: 42,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [
                                kSecondaryColor,
                                kPurpleColor,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 4),
                                blurRadius: 12,
                                color: kBlackColor.withOpacity(.25),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: List.generate(
                              2,
                              (index) {
                                return Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: index == 0
                                          ? Colors.transparent
                                          : kPrimaryColor,
                                    ),
                                    child: Center(
                                      child: MyText(
                                        text: index == 0 ? "PM" : "AM",
                                        size: 12,
                                        weight: FontWeight.w500,
                                        color: index == 0
                                            ? kPrimaryColor
                                            : kBlackColor,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  MyText(
                    paddingBottom: 6,
                    paddingTop: 20,
                    text: 'Leave a Message',
                    size: 12,
                    weight: FontWeight.w600,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: kPrimaryColor,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 12,
                          color: kBlackColor.withOpacity(0.16),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: TextFormField(
                        maxLines: 5,
                        style: TextStyle(
                          fontSize: 14,
                          color: kTertiaryColor,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Type here...',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: kHintColor,
                          ),
                          fillColor: kPrimaryColor,
                          filled: true,
                          border: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MyButton(
                    buttonText: 'Send invite',
                    onTap: () {
                      Get.dialog(_VideoDateScheduled());
                      Timer(
                        2.seconds,
                        () {
                          Get.back();
                          Get.back();
                          Get.to(() => ScheduledVideoDateDetails());
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Calendar extends StatefulWidget {
  const _Calendar({Key? key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<_Calendar> {
  @override
  Widget build(BuildContext context) {
    final _DEFAULT_TEXT_STYLE = TextStyle(
      fontSize: 12,
      color: kPrimaryColor,
      fontFamily: AppFonts.URBANIST,
    );

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            kSecondaryColor,
            kPurpleColor,
          ],
        ),
      ),
      child: TableCalendar(
        headerStyle: _header(),
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: DateTime.now(),
        rowHeight: 40,
        daysOfWeekHeight: 50,
        daysOfWeekStyle: DaysOfWeekStyle(
          dowTextFormatter: (date, locale) {
            return DateFormat.E(locale).format(date).toUpperCase();
          },
          weekdayStyle: _DEFAULT_TEXT_STYLE.copyWith(
            color: kPrimaryColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          weekendStyle: _DEFAULT_TEXT_STYLE.copyWith(
            color: kPrimaryColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        calendarStyle: CalendarStyle(
          tablePadding: EdgeInsets.zero,
          defaultTextStyle: _DEFAULT_TEXT_STYLE,
          selectedTextStyle: _DEFAULT_TEXT_STYLE.copyWith(
            color: kTertiaryColor,
          ),
          todayTextStyle: _DEFAULT_TEXT_STYLE.copyWith(
            color: kTertiaryColor,
          ),
          disabledTextStyle: _DEFAULT_TEXT_STYLE.copyWith(
            color: kPrimaryColor,
          ),
          holidayTextStyle: _DEFAULT_TEXT_STYLE.copyWith(
            color: kPrimaryColor,
          ),
          outsideTextStyle: _DEFAULT_TEXT_STYLE.copyWith(
            color: kPrimaryColor,
          ),
          weekendTextStyle: _DEFAULT_TEXT_STYLE.copyWith(
            color: kPrimaryColor,
          ),
          rangeEndTextStyle: _DEFAULT_TEXT_STYLE,
          weekNumberTextStyle: _DEFAULT_TEXT_STYLE,
          rangeStartTextStyle: _DEFAULT_TEXT_STYLE,
          withinRangeTextStyle: _DEFAULT_TEXT_STYLE,
          selectedDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kPrimaryColor,
          ),
          todayDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kPrimaryColor,
          ),
        ),
      ),
    );
  }

  HeaderStyle _header() {
    return HeaderStyle(
      headerPadding: EdgeInsets.all(8),
      formatButtonVisible: false,
      titleCentered: true,
      titleTextStyle: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: kPrimaryColor,
      ),
      titleTextFormatter: (date, locale) {
        return DateFormat.yMMMMd(locale).format(date).toUpperCase();
      },
      leftChevronMargin: EdgeInsets.zero,
      leftChevronPadding: EdgeInsets.zero,
      leftChevronIcon: Container(
        height: 32,
        width: 32,
        child: Icon(
          Icons.arrow_back,
          size: 18,
          color: kPrimaryColor,
        ),
      ),
      rightChevronMargin: EdgeInsets.zero,
      rightChevronPadding: EdgeInsets.zero,
      rightChevronIcon: Container(
        height: 32,
        width: 32,
        child: Icon(
          Icons.arrow_forward,
          size: 18,
          color: kPrimaryColor,
        ),
      ),
    );
  }
}

class _VideoDateScheduled extends StatelessWidget {
  const _VideoDateScheduled({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          color: kPrimaryColor,
          margin: AppSizes.DEFAULT.copyWith(
            left: 30,
            right: 30,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: AppSizes.DEFAULT,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 16,
                ),
                Image.asset(
                  Assets.imagesCongratsCheck,
                  height: 151,
                ),
                MyText(
                  paddingTop: 16,
                  paddingBottom: 4,
                  text: 'Video Date Scheduled',
                  size: 22,
                  lineHeight: 1.5,
                  weight: FontWeight.w600,
                  textAlign: TextAlign.center,
                ),
                MyText(
                  text: 'Video Date has been Scheduled successfully',
                  size: 14,
                  lineHeight: 1.5,
                  color: kHintColor,
                  paddingBottom: 10,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
