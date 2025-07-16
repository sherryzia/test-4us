import 'package:affirmation_app/constants/app_colors.dart';
import 'package:affirmation_app/constants/app_images.dart';
import 'package:affirmation_app/constants/app_sizes.dart';
import 'package:affirmation_app/constants/app_styling.dart';
import 'package:affirmation_app/view/screens/auth/sign_up/complete_profile.dart';
import 'package:affirmation_app/view/widget/my_button_widget.dart';
import 'package:affirmation_app/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:affirmation_app/controllers/reminder_controller.dart';

class SetAffirmationReminder extends StatelessWidget {
  final ReminderController controller = Get.put(ReminderController());

  String _formatTimeOfDay(TimeOfDay time) {
    final format = MaterialLocalizations.of(Get.context!).formatTimeOfDay(time);
    return format;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
      },
      child: Scaffold(
        body: CustomBackground(
          child: Column(
            children: [
              Expanded(
                child: Obx(
                  () => ListView(
                    padding: AppSize.DEFAULT,
                    physics: BouncingScrollPhysics(),
                    children: [
                      Image.asset(
                        Assets.imagesAffirmationImage,
                        height: 207,
                      ),
                      MyText(
                        text: 'Set Daily Affirmation Reminders.',
                        size: 25,
                        weight: FontWeight.w600,
                        textAlign: TextAlign.center,
                        paddingTop: 7,
                        paddingBottom: 29,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 21),
                        decoration: AppStyling.cardDecoration,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: MyText(
                                      text: 'Start Time',
                                      size: 18,
                                      weight: FontWeight.w500,
                                    ),
                                  ),
                                  Container(
                                    height: 31,
                                    decoration: BoxDecoration(
                                      color: kGreyColor8.withOpacity(0.13),
                                      borderRadius: BorderRadius.circular(21),
                                    ),
                                    child: InkWell(
                                      onTap: () => controller.selectTime(context, true),
                                      child: Center(
                                        child: MyText(
                                          text: _formatTimeOfDay(controller.reminderModel.value.startTime),
                                          size: 13,
                                          weight: FontWeight.w500,
                                          paddingLeft: 14,
                                          paddingRight: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 24),
                              height: 1,
                              color: kGreyColor9,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: MyText(
                                      text: 'End Time',
                                      size: 18,
                                      weight: FontWeight.w500,
                                    ),
                                  ),
                                  Container(
                                    height: 31,
                                    decoration: BoxDecoration(
                                      color: kGreyColor8.withOpacity(0.13),
                                      borderRadius: BorderRadius.circular(21),
                                    ),
                                    child: InkWell(
                                      onTap: () => controller.selectTime(context, false),
                                      child: Center(
                                        child: MyText(
                                          text: _formatTimeOfDay(controller.reminderModel.value.endTime),
                                          size: 13,
                                          weight: FontWeight.w500,
                                          paddingLeft: 14,
                                          paddingRight: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 21),
                       Container(
                        padding: EdgeInsets.symmetric(vertical: 21),
                        decoration: AppStyling.cardDecoration,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            MyText(
                              text: 'How Many',
                              size: 18,
                              weight: FontWeight.w500,
                              paddingBottom: 11,
                              paddingLeft: 21,
                            ),
                            Stack(
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 21), // Match this padding to align labels with the slider thumbs
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: List.generate(10, (index) {
                                          return Text('${index + 1}', style: TextStyle(fontSize: 12, color: Colors.white));
                                        }),
                                      ),
                                    ),
                                    Slider(
                                      value: controller.reminderModel.value.value,
                                      min: 1,
                                      max: 10,
                                      divisions: 9,
                                      label: '${controller.reminderModel.value.value.round()}',
                                      onChanged: (value) {
                                        controller.reminderModel.value.value = value;
                                        controller.reminderModel.refresh();
                                      },
                                      activeColor: kPrimaryColor,
                                      inactiveColor: kPrimaryColor.withOpacity(0.1),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 21),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: AppSize.DEFAULT,
                child: MyButton(
                  buttonText: 'Allow & Save',
                  onTap: () {
                    controller.scheduleNotifications();
                    controller.trigger_notification();
                    Get.back();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
