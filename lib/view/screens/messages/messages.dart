import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_fonts.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/main.dart';
import 'package:candid/view/screens/messages/chat_screen.dart';
import 'package:candid/view/screens/notifications/notifications.dart';
import 'package:candid/view/widget/common_image_view_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:candid/view/widget/stories_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        physics: BouncingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              automaticallyImplyLeading: false,
              titleSpacing: 20.0,
              pinned: true,
              floating: false,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      MyText(
                        text: 'Chats',
                        size: 20,
                        weight: FontWeight.w600,
                      ),
                      Positioned(
                        top: -24,
                        left: -10,
                        child: Image.asset(
                          Assets.imagesTitleHearts,
                          height: 41.68,
                        ),
                      ),
                      Positioned(
                        top: -3,
                        right: -10,
                        child: Image.asset(
                          Assets.imagesTitleHeartsFilled,
                          height: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => Notifications());
                    },
                    child: Image.asset(
                      Assets.imagesNotifications,
                      height: 32,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          ];
        },
        body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: BouncingScrollPhysics(),
          children: [
            MyText(
              paddingLeft: 20,
              text: 'New Connections',
              size: 16,
              paddingBottom: 8,
              weight: FontWeight.w600,
            ),
            Stories(),
            Container(
              margin: EdgeInsets.only(
                top: 7,
                bottom: 1,
              ),
              height: 1,
              color: kBorderColor2,
            ),
            MyText(
              paddingTop: 19,
              paddingLeft: 20,
              text: 'Inbox',
              size: 16,
              weight: FontWeight.w600,
              paddingBottom: 6,
            ),
            ListView.builder(
              itemCount: 10,
              shrinkWrap: true,
              padding: EdgeInsets.only(
                bottom: 100,
                top: 0,
              ),
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return _ChatHeadTile(
                  isDelivered: index.isEven,
                  isOnline: index.isEven,
                  isSeen: index.isEven,
                  unReadMessages: index.isEven ? null : 10,
                  personImage: dummyImg,
                  personName: 'Jordyn Curtis',
                  lastMessage: 'You got a new match, Click to view!',
                  time: 'Just Now',
                  onTap: () {
                    Get.to(() => ChatScreen());
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatHeadTile extends StatelessWidget {
  const _ChatHeadTile({
    required this.personName,
    required this.personImage,
    required this.lastMessage,
    required this.time,
    required this.onTap,
    required this.isOnline,
    required this.isDelivered,
    required this.isSeen,
    this.unReadMessages,
  });
  final String personName;
  final String personImage;
  final String lastMessage;
  final String time;
  final VoidCallback onTap;
  final bool isOnline;
  final bool isDelivered;
  final bool isSeen;
  final int? unReadMessages;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: kQuaternaryColor.withOpacity(0.05),
        highlightColor: kQuaternaryColor.withOpacity(0.05),
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 8,
            bottom: 8,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CommonImageView(
                    height: 52,
                    width: 52,
                    radius: 100.0,
                    url: personImage,
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      height: 12,
                      width: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isOnline ? kOnlineColor : kOfflineColor,
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
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MyText(
                      text: personName,
                      size: 16,
                      paddingBottom: 4,
                    ),
                    MyText(
                      text: lastMessage,
                      size: 12,
                      color: kDarkGreyColor,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MyText(
                    text: time,
                    size: 12,
                    color: kDarkGreyColor,
                  ),
                  if (unReadMessages != null)
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kSecondaryColor,
                      ),
                      child: Center(
                        child: FittedBox(
                          child: MyText(
                            text: unReadMessages.toString(),
                            color: kPrimaryColor,
                            fontFamily: AppFonts.URBANIST,
                            size: 11,
                          ),
                        ),
                      ),
                    )
                  else if (isDelivered)
                    Image.asset(
                      Assets.imagesDoubleTick,
                      height: 24,
                      color: isSeen ? kSecondaryColor : null,
                    )
                  else
                    Image.asset(
                      Assets.imagesSingleTick,
                      height: 24,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
