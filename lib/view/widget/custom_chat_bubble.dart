import 'package:flutter/material.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'common_image_view_widget.dart';
import 'my_text_widget.dart';

class MessageBubble extends StatelessWidget {
  final String sender;
  final String message;
  final String time;
  final bool isMe;
  final String profilePic;

  MessageBubble({
        required this.sender,
        required this.profilePic,
        required this.message,
        required this.time,
        required this.isMe
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16, left: 16, right: 16),
      child: Row(
        children: [
          CommonImageView(
            imagePath: profilePic,
            height: 40,
            width: 40,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 18, bottom: 4, top: 4),
                      child: MyText(
                        text: sender,
                        size: 16,
                        weight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 4, left: 48, right: 18, bottom: 4),
                      child: MyText(
                        text: time,
                        color: kSecondaryColor,
                        size: 12,
                        weight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          // color: kPrimaryLightColor4,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: MyText(
                          text: message,
                          textOverflow: TextOverflow.visible,
                          size: 13,
                          weight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubbleSender extends StatelessWidget {
  final String sender;
  final String message;
  final String time;
  final bool isMe;
  final String profilePic;

  MessageBubbleSender(
      {required this.sender,
      required this.profilePic,
      required this.message,
      required this.time,
      required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 18, bottom: 4, right: 18),
                child: Text(sender,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, color: kWhite)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4, left: 48, right: 48),
                child: Text(
                  time,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    // color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    message,
                    style: TextStyle(color: isMe ? Colors.white : Colors.black),
                  ),
                ),
              ),
              SizedBox(width: 8),
              CommonImageView(
                imagePath: profilePic,
                height: 40,
                width: 40,
              )
            ],
          ),
        ],
      ),
    );
  }
}

class DateDivider extends StatelessWidget {
  final DateTime date;

  DateDivider({required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey[300])),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Today',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey[300])),
        ],
      ),
    );
  }
}
