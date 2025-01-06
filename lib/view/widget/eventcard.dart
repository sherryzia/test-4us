import 'package:flutter/material.dart';
import 'package:forus_app/view/event_organizer/event_home/events_postdetail.dart';
import 'package:forus_app/view/widget/common_image_view_widget.dart';
import 'package:forus_app/view/widget/my_text_widget.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/generated/assets.dart';

class EventCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
         Get.to(() => EventPostDetailScreen());
      },
      child: Container(
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kBorderGrey),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(5, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonImageView(
              imagePath: Assets.imagesEventhome1,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: "Coachella Valley Music",
                    size: 14,
                    weight: FontWeight.bold,
                  ),
                  Gap(16),
      
                  // Tags
                  Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFF4E6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child:
                         MyText(text: "Free", size: 12, color: kTextOrange),
                      ),
                      Gap(8),
                      MyText(
                        text: " •  ",
                        size: 12,
                        color: kTextOrange,
                      ),
                      MyText(
                        text: "  Business",
                        size: 12,
                        color: kTextGrey,
                        weight: FontWeight.w500,
                      ),
                      Gap(8),
                      MyText(
                        text: "  • ",
                        size: 12,
                        color: kTextOrange,
                        weight: FontWeight.w500,
                      ),
                      MyText(
                        text: " Conference",
                        size: 12,
                        color: kTextGrey,
                        weight: FontWeight.w500,
                      ),
                    ],
                  ),
                  Gap(16),
      
                  // Date and Location
                  Row(
                    children: [
                      CommonImageView(
                        imagePath: Assets.imagesCalendarorange,
                        height: 20,
                      ),
                      Gap(8),
                      MyText(
                        text: "Friday, 27 Feb 2023 4:30 PM",
                        size: 12,
                        weight: FontWeight.w500,
                        color: kTextGrey,
                      ),
                    ],
                  ),
                  Gap(8),
                  Row(
                    children: [
                      CommonImageView(
                        imagePath: Assets.imagesLocationorange,
                        height: 20,
                      ),
                      Gap(8),
                      Expanded(
                        child: MyText(
                          text: "6391 Elgin St. Celina, Delaware 10299",
                          size: 12,
                          weight: FontWeight.w500,
                          color: kTextGrey,
                        ),
                      ),
                    ],
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
