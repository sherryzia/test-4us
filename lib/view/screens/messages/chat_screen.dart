import 'dart:async';

import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/main.dart';
import 'package:candid/view/screens/schedule_video_call/schedule_video_call.dart';
import 'package:candid/view/widget/chat_bubble_widget.dart';
import 'package:candid/view/widget/common_image_view_widget.dart';
import 'package:candid/view/widget/my_button_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:candid/view/widget/send_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ChatScreen extends StatelessWidget {
  ChatScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.only(
              top: 52,
              left: 16,
              right: 5,
              bottom: 12.5,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back),
                ),
                SizedBox(
                  width: 13,
                ),
                CommonImageView(
                  height: 36,
                  width: 36,
                  radius: 100.0,
                  url: dummyImg,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MyText(
                        text: 'Alena Baptista',
                        size: 14,
                        weight: FontWeight.w600,
                        paddingBottom: 4,
                      ),
                      MyText(
                        text: 'Online',
                        size: 10,
                        color: kSecondaryColor,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.bottomSheet(
                      ScheduleVideoCall(),
                      isScrollControlled: true,
                    );
                  },
                  child: Image.asset(
                    Assets.imagesVideoDateIcon,
                    height: 34,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                PopupMenuButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        height: 30,
                        onTap: () {
                          Get.dialog(_BlockAccountDialog());
                        },
                        child: MyText(
                          text: 'Block',
                          size: 14,
                        ),
                      ),
                      PopupMenuItem(
                        height: 30,
                        child: MyText(
                          text: 'Clear Chat',
                          size: 14,
                        ),
                      ),
                      PopupMenuItem(
                        height: 30,
                        child: MyText(
                          text: 'Mute Notifications',
                          size: 14,
                        ),
                      ),
                    ];
                  },
                  child: Image.asset(
                    Assets.imagesMoreVert,
                    height: 24,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: Get.height,
                  width: Get.width,
                  child: ListView.builder(
                    reverse: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: 10,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                      bottom: 100,
                      top: 30,
                    ),
                    itemBuilder: (context, index) {
                      return ChatBubbles(
                        mediaType: index == 4
                            ? 'IMAGE'
                            : index == 3
                                ? 'QUESTION'
                                : 'TEXT',
                        msgID: index.toString(),
                        senderType: index.isEven
                            ? 'me'
                            : index == 3
                                ? 'me'
                                : 'Other',
                        time: DateFormat('h:mm a').format(DateTime.now()),
                        msg: index == 4
                            ? dummyImg
                            : index.isEven
                                ? 'Hello, how are you?'
                                : 'I’m doing good. thanks.',
                      );
                    },
                  ),
                ),
                SendField(
                  onImagePick: () async {},
                  onSendTap: () async {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BlockAccountDialog extends StatelessWidget {
  const _BlockAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          color: kPrimaryColor,
          margin: AppSizes.DEFAULT,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: AppSizes.DEFAULT,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyText(
                  text: 'Are you sure you sure you want to block this account?',
                  size: 20,
                  lineHeight: 1.5,
                  weight: FontWeight.w600,
                  textAlign: TextAlign.center,
                  paddingBottom: 25,
                ),
                Row(
                  children: [
                    Expanded(
                      child: MyButton(
                        bgColor: kLightGreyColor.withOpacity(0.5),
                        textColor: kTertiaryColor,
                        buttonText: 'Cancel',
                        onTap: () {
                          Get.back();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: MyButton(
                        buttonText: 'Block',
                        onTap: () {
                          Get.back();
                         
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AccountBlocked extends StatelessWidget {
  const _AccountBlocked({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          color: kPrimaryColor,
          margin: AppSizes.DEFAULT.copyWith(
            left: 40,
            right: 40,
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
                  paddingBottom: 10,
                  text: 'Account has been blocked',
                  size: 18,
                  lineHeight: 1.5,
                  weight: FontWeight.w600,
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

