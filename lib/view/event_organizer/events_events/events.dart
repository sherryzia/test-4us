import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/constants/app_fonts.dart';
import 'package:forus_app/constants/app_sizes.dart';
import 'package:forus_app/generated/assets.dart';
import 'package:forus_app/view/event_organizer/events_events/create_event.dart';
import 'package:forus_app/view/event_organizer/events_events/event_participants.dart';
import 'package:forus_app/view/widget/common_image_view_widget.dart';
import 'package:forus_app/view/widget/custom_drop_down_widget.dart';
import 'package:forus_app/view/widget/dasheddivider.dart';
import 'package:forus_app/view/widget/eventcard.dart';
import 'package:forus_app/view/widget/my_button_widget.dart';
import 'package:forus_app/view/widget/my_text_widget.dart';
import 'package:forus_app/view/widget/my_text_field.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({
    super.key,
  });

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  String _selectedEventType = 'Paid';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFloatingButton(
        onPressed: () {
          Get.to(() => CreateEventScreen());
        },
      ),
      appBar: AppBar(
        backgroundColor: AppThemeColors.getTertiary(context),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: MyText(
          text: "Events",
          size: 18,
          textAlign: TextAlign.center,
          fontFamily: AppFonts.NUNITO_SANS,
          weight: FontWeight.w700,
        ),
      ),
      backgroundColor: AppThemeColors.getTertiary(context),
      body: Padding(
        padding: AppSizes.DEFAULT2,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Center align the row contents
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Center align vertically
                    children: [
                      Expanded(
                        child: MyTextField(
                          marginBottom: 0,
                          hint: 'Search User',
                          hintColor: kTextGrey,
                          labelColor: kWhite,
                          radius: 8,
                          prefix: Padding(
                            padding: const EdgeInsets.all(12),
                            child: CommonImageView(
                              imagePath: Assets.imagesSearchNormal,
                              height: 20,
                            ),
                          ),
                          filledColor: kTransperentColor,
                          kBorderColor: kBorderGrey,
                          kFocusBorderColor: KColor1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 1),
                        child: InkWell(
                          onTap: () {
                            FilterBottomSheet();
                          },
                          child: CommonImageView(
                            imagePath: Assets.imagesFliter,
                            height: 50,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gap(16),
                  ToggleButtons(),
                  Gap(16),
                  EventCard(),
                  Gap(16),
                  EventCard(),
                  Gap(16),
                  EventCard(),
                  Gap(16),
                  EventCard(),
                  Gap(16),
                  EventCard(),
                  Gap(16),
                  EventCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void FilterBottomSheet() {
    Get.bottomSheet(
      isScrollControlled: true, // Allows better control over scrolling

      SizedBox(
        height: Get.height * 0.64,
        child: Container(
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
          ),
          child: Column(
            children: [
              Padding(
                padding: AppSizes.DEFAULT,
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 5,
                          margin: const EdgeInsets.symmetric(horizontal: 160),
                          decoration: BoxDecoration(
                            color: kDividerGrey3,
                            borderRadius: BorderRadius.circular(90),
                          ),
                        ),
                        Gap(24),
                        MyText(
                          text: "Filter Events",
                          size: 16,
                          color: kBlack,
                          weight: FontWeight.w700,
                        ),
                      ],
                    ),
                    Gap(18),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          text: "Location",
                          size: 12,
                          paddingBottom: 5,
                          color: kBlack,
                          weight: FontWeight.w400,
                        ),
                        MyTextField(
                          hint: 'Search by Location',
                          hintColor: kTextGrey,
                          labelColor: kBlack,
                          radius: 8,
                          suffix: Padding(
                            padding: const EdgeInsets.all(12),
                            child: CommonImageView(
                              imagePath: Assets.imagesLocationGrey,
                              height: 22,
                            ),
                          ),
                          filledColor: kTransperentColor,
                          kBorderColor: kBorderGrey,
                          kFocusBorderColor: KColor1,
                        ),
                        MyText(
                          text: "Event Date",
                          size: 12,
                          paddingBottom: 5,
                          color: kBlack,
                          weight: FontWeight.w400,
                        ),
                        MyTextField(
                          hint: 'Select Event Date',
                          hintColor: kTextGrey,
                          labelColor: kBlack,
                          radius: 8,
                          suffix: Padding(
                            padding: const EdgeInsets.all(12),
                            child: CommonImageView(
                              imagePath: Assets.imagesCalendar,
                              height: 22,
                            ),
                          ),
                          filledColor: kTransperentColor,
                          kBorderColor: kBorderGrey,
                          kFocusBorderColor: KColor1,
                        ),
                        CustomDropDown(
                          labelText: "Event Category",
                          hint: 'Category1',
                          items: [
                            'Category1',
                            'Category2',
                            'Category3',
                          ],
                          selectedValue: 'Category1',
                          onChanged: (v) {},
                        ),
                        CustomDropDown(
                          labelText: "Event Sub Category",
                          hint: 'Category1',
                          items: [
                            'Category1',
                            'Category2',
                            'Category3',
                          ],
                          selectedValue: 'Category1',
                          onChanged: (v) {},
                        ),
                        MyText(
                          text: 'Event Type',
                          size: 16,
                          color: kBlack,
                          textAlign: TextAlign.center,
                          fontFamily: AppFonts.NUNITO_SANS,
                          weight: FontWeight.w800,
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'Free',
                                  groupValue: _selectedEventType,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedEventType = value!;
                                    });
                                  },
                                  activeColor: kTextDarkorange,
                                ),
                                MyText(
                                  text: 'Free Event',
                                  size: 15,
                                  color: kTextGrey,
                                  textAlign: TextAlign.center,
                                  fontFamily: AppFonts.NUNITO_SANS,
                                  weight: FontWeight.w500,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'Paid',
                                  groupValue: _selectedEventType,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedEventType = value!;
                                    });
                                  },
                                  activeColor: kTextDarkorange,
                                ),
                                MyText(
                                  text: 'Paid Event',
                                  size: 15,
                                  color: kTextGrey,
                                  textAlign: TextAlign.center,
                                  fontFamily: AppFonts.NUNITO_SANS,
                                  weight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Gap(18),
                    Row(
                      spacing: 17,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyButton2(
                          width: 137,
                          buttonText: "Reset",
                          radius: 14,
                          textSize: 20,
                          textColor: kTextDarkorange,
                          bgColor: kbuttoncolor,
                          weight: FontWeight.w800,
                          onTap: () {
                            Get.back();
                          },
                        ),
                        MyButton2(
                          width: 137,
                          buttonText: "Apply",
                          radius: 14,
                          textSize: 20,
                          weight: FontWeight.w800,
                          onTap: () {
                                Get.to(() => EventparticipantsScreens());
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ToggleButtons extends StatefulWidget {
  @override
  _ToggleButtonsState createState() => _ToggleButtonsState();
}

class _ToggleButtonsState extends State<ToggleButtons> {
  int _selectedIndex = 0; // Start with the first index selected

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: kDividerGrey),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          // First Button
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
              },
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: _selectedIndex == 0
                      ? LinearGradient(
                          colors: [
                            Color(0xFFE7AF74),
                            Color(0xFFA76B2C),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )
                      : null,
                  color: _selectedIndex == 0 ? null : Colors.transparent,
                ),
                margin: EdgeInsets.all(4),
                child: Center(
                  child: Text(
                    'Upcoming',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedIndex == 0 ? Colors.white : kTextGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Second Button
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: _selectedIndex == 1
                      ? LinearGradient(
                          colors: [
                            Color(0xFFE7AF74),
                            Color(0xFFA76B2C),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )
                      : null,
                  color: _selectedIndex == 1 ? null : Colors.transparent,
                ),
                margin: EdgeInsets.all(4),
                child: Center(
                  child: Text(
                    'Ongoing',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedIndex == 1 ? Colors.white : kTextGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Third Button
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
              },
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: _selectedIndex == 2
                      ? LinearGradient(
                          colors: [
                            Color(0xFFE7AF74),
                            Color(0xFFA76B2C),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )
                      : null,
                  color: _selectedIndex == 2 ? null : Colors.transparent,
                ),
                margin: EdgeInsets.all(4),
                child: Center(
                  child: Text(
                    'Past',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedIndex == 2 ? Colors.white : kTextGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomFloatingButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kWhite, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Color(0xFFE7AF74),
              Color(0xFFA76B2C),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
            child: CommonImageView(
          imagePath: Assets.imagesCalendarAdd,
          height: 24,
        )),
      ),
    );
  }
}
