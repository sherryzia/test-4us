import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/view/widget/common_image_view_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChatBubbles extends StatelessWidget {
  ChatBubbles({
    Key? key,
    required this.msg,
    required this.senderType,
    required this.time,
    required this.msgID,
    required this.mediaType,
  }) : super(key: key);
  final String msg, senderType, time, msgID, mediaType;
  // Map<String, dynamic>? normalUserModel;
  // Map<String, dynamic>? otherUserModel;

  @override
  Widget build(BuildContext context) {
    if (mediaType == 'TEXT') {
      return Padding(
        padding: const EdgeInsets.only(
          bottom: 15,
        ),
        child: Align(
          alignment:
              senderType == 'me' ? Alignment.topRight : Alignment.topLeft,
          child: Column(
            crossAxisAlignment: senderType == 'me'
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                  right: senderType == 'me' ? 0 : 60,
                  left: senderType == 'me' ? 60 : 0,
                ),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: senderType == 'me'
                      ? LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            kSecondaryColor,
                            kPurpleColor,
                          ],
                        )
                      : LinearGradient(
                          colors: [
                            kPrimaryColor,
                            kPrimaryColor,
                          ],
                        ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(senderType == 'me' ? 12 : 0),
                    bottomRight: Radius.circular(senderType == 'me' ? 0 : 12),
                  ),
                ),
                child: MyText(
                  text: '$msg',
                  size: 14,
                  weight: FontWeight.w500,
                  color: senderType == 'me' ? kPrimaryColor : kBlackColor,
                ),
              ),
              MyText(
                paddingTop: 8,
                text: time,
                size: 11,
                color: kDarkGreyColor4,
              ),
            ],
          ),
        ),
      );
    } else if (mediaType == 'QUESTION') {
      return Padding(
        padding: const EdgeInsets.only(
          bottom: 15,
        ),
        child: Align(
          alignment:
              senderType == 'me' ? Alignment.topRight : Alignment.topLeft,
          child: Column(
            crossAxisAlignment: senderType == 'me'
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                  right: senderType == 'me' ? 0 : 60,
                  left: senderType == 'me' ? 60 : 0,
                ),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      kSecondaryColor,
                      kPurpleColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    MyText(
                      text: 'Alena Baptista asked',
                      size: 14,
                      weight: FontWeight.w600,
                      color: kPrimaryColor,
                      paddingBottom: 5,
                    ),
                    MyText(
                      text:
                          'If you could instantly master any skill or talent, what would it be and why?',
                      size: 12,
                      weight: FontWeight.w500,
                      color: kPrimaryColor,
                      paddingBottom: 10,
                    ),
                    Image.asset(
                      Assets.imagesAddAnswer,
                      height: 30,
                    ),
                  ],
                ),
              ),
              MyText(
                paddingTop: 8,
                text: time,
                size: 11,
                color: kDarkGreyColor4,
              ),
            ],
          ),
        ),
      );
    } else if (mediaType == 'IMAGE') {
      return Padding(
        padding: const EdgeInsets.only(
          bottom: 15,
        ),
        child: Align(
          alignment:
              senderType == 'me' ? Alignment.topRight : Alignment.topLeft,
          child: Column(
            crossAxisAlignment: senderType == 'me'
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(senderType == 'me' ? 16 : 0),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(senderType == 'me' ? 0 : 16),
                ),
                child: CommonImageView(
                  height: 166,
                  width: 164,
                  url: msg,
                  radius: 12.0,
                ),
              ),
              MyText(
                paddingTop: 8,
                text: time,
                size: 11,
                color: kDarkGreyColor4,
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
