import 'package:flutter/material.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_sizes.dart';
import 'package:restaurant_finder/main.dart';
import 'package:restaurant_finder/view/widget/common_image_view_widget.dart';
import 'package:restaurant_finder/view/widget/custom_app_bar_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Notifications',
      ),
      body: ListView.builder(
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MyText(
                paddingBottom: 6,
                text: index == 0
                    ? 'Today'.toUpperCase()
                    : index == 1
                        ? 'Yesterday'.toUpperCase()
                        : 'Earlier'.toUpperCase(),
                size: 14,
                color: kGreyColor,
                weight: FontWeight.w500,
                paddingTop: index == 0 ? 0 : 16,
              ),
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: BouncingScrollPhysics(),
                itemCount: 4,
                itemBuilder: (context, nIndex) {
                  return _NotificationTile(
                    title: 'Notification Title',
                    time: '2 minutes ago',
                    leading: dummyImg,
                    onTap: () {},
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.leading,
    required this.title,
    required this.time,
    required this.onTap,
  });
  final String title;
  final String leading;
  final String time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kPrimaryColor,
        border: Border.all(
          width: 1.0,
          color: kBorderColor,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonImageView(
            height: 38,
            width: 38,
            radius: 100,
            url: leading,
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyText(
                  text: title,
                  size: 14,
                  weight: FontWeight.w600,
                  paddingBottom: 6,
                ),
                MyText(
                  text: time,
                  size: 12,
                  color: kGreyColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
