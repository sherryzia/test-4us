import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_fonts.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/view/widget/common_image_view_widget.dart';
import 'package:candid/view/widget/custom_scaffold_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:candid/view/widget/simple_app_bar_widget.dart';
import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          simpleAppBar(
            title: 'Activity',
          ),
          Expanded(
            child: ListView.builder(
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
                      color: kDarkGreyColor4,
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
                          isCrushed: nIndex == 1,
                          title: nIndex == 1
                              ? 'Crush on you! You both have a shared interest: Running'
                              : 'you! You both have a shared interest: Running',
                          time: '2 minutes ago',
                          leading: Assets.imagesNotificationIcon,
                          onTap: () {},
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
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
    required this.isCrushed,
  });
  final String title;
  final String leading;
  final String time;
  final bool isCrushed;
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
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 20,
            color: kBlackColor.withOpacity(0.1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CommonImageView(
                height: 42,
                width: 42,
                radius: 100,
                imagePath: leading,
              ),
              if (isCrushed)
                Positioned(
                  left: -5,
                  bottom: -10,
                  child: Image.asset(
                    Assets.imagesCrushNotifications,
                    height: 26,
                  ),
                ),
              if (isCrushed)
                Positioned(
                  bottom: 0,
                  right: 2,
                  child: Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kOnlineColor,
                      border: Border.all(
                        width: 1.0,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 12,
                      color: kBlackColor,
                      fontFamily: AppFonts.URBANIST,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(
                        text: 'Eric Likes ',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          foreground: Paint()
                            ..shader = LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                kSecondaryColor,
                                kPurpleColor,
                              ],
                            ).createShader(
                              Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                            ),
                        ),
                      ),
                      TextSpan(
                        text: title,
                      ),
                    ],
                  ),
                ),
                MyText(
                  textAlign: TextAlign.end,
                  paddingTop: 4,
                  text: time,
                  size: 12,
                  color: kDarkGreyColor4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
