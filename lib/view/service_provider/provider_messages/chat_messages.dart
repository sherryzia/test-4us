// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:forus_app/constants/app_colors.dart';
// import 'package:forus_app/constants/app_fonts.dart';
// import 'package:forus_app/generated/assets.dart';
// import 'package:forus_app/view/widget/my_text_widget.dart';

// import '../../widget/common_image_view_widget.dart';

// class ProviderChatScreen extends StatefulWidget {
//   const ProviderChatScreen({super.key});

//   @override
//   State<ProviderChatScreen> createState() => _ProviderChatScreenState();
// }

// class _ProviderChatScreenState extends State<ProviderChatScreen> {
//   final List<ChatMessage> messages = [
//     ChatMessage(
//   day: null, // Optional field; can be omitted or explicitly set to null
//   text: "Good Morning Bhineka",
//   time: "10:16 PM",
//   isSender: true,
// ),

//     ChatMessage(
//       text: "Hey.. Very Very Good Morning",
//       time: "10:17 PM",
//       isSender: false,
//     ),
//     ChatMessage(
//       text: "I wanted to order this hoodies t shirt",
//       time: "10:19 PM",
//       isSender: true,
//     ),
//     ChatMessage(
//       text: "Ok! How many t shirt you want?",
//       time: "10:22 PM",
//       isSender: false,
//     ),
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppThemeColors.getTertiary(context),
//         leading: InkWell(
//           onTap: () {
//             Get.back();
//           },
//           child: Padding(
//             padding: const EdgeInsets.all(14),
//             child: CommonImageView(
//               imagePath: Assets.imagesArrowLeft,
//               height: 24,
//             ),
//           ),
//         ),
//         title: Row(
//           spacing: 12,
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             CommonImageView(
//               imagePath: Assets.imagesChat2,
//               height: 36,
//             ),
//             MyText(
//               text: 'Bhineka',
//               size: 18,
//               textAlign: TextAlign.center,
//               fontFamily: AppFonts.NUNITO_SANS,
//               weight: FontWeight.w600,
//             ),
//           ],
//         ),
//       ),
//       backgroundColor: AppThemeColors.getTertiary(context),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: messages.length,
//                 itemBuilder: (context, index) {
//                   return ChatBubble(message: messages[index]);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ChatMessage {
//   final String text;
//   final String? day;

//   final String time;
//   final bool isSender;

//   ChatMessage(
//     this.day, {
//     required this.text,
//     required this.time,
//     required this.isSender,
//   });
// }

// class ChatBubble extends StatelessWidget {
//   final ChatMessage message;

//   const ChatBubble({super.key, required this.message});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         if (message.day != null)
//           MyText(
//             text: message.day!,
//             size: 16,
//             fontFamily: AppFonts.NUNITO_SANS,
//             weight: FontWeight.w600,
//             color: kTertiaryColor2,
//           ),
//         Column(
//           crossAxisAlignment: message.isSender
//               ? CrossAxisAlignment.end
//               : CrossAxisAlignment.start,
//           children: [
//             Container(
//               margin: const EdgeInsets.symmetric(vertical: 5),
//               padding: const EdgeInsets.all(10),
//               constraints: const BoxConstraints(maxWidth: 250),
//               decoration: BoxDecoration(
//                 color: message.isSender ? kborderOrange : KColor14,
//                 borderRadius: BorderRadius.only(
//                     topLeft: const Radius.circular(16),
//                     topRight: const Radius.circular(16),
//                     bottomLeft: message.isSender
//                         ? const Radius.circular(16)
//                         : Radius.zero,
//                     bottomRight: message.isSender
//                         ? Radius.zero
//                         : const Radius.circular(16)),
//               ),
//               child: MyText(
//                 text: message.text,
//                 size: 15,
//                 fontFamily: AppFonts.NUNITO_SANS,
//                 weight: FontWeight.w600,
//                 color: !message.isSender! ? kborder : kWhite,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//               child: MyText(
//                 text: message.time,
//                 size: 11,
//                 fontFamily: AppFonts.NUNITO_SANS,
//                 weight: FontWeight.w500,
//                 color: kTextGrey,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:forus_app/view/widget/common_image_view_widget.dart';
import 'package:get/get.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/constants/app_fonts.dart';
import 'package:forus_app/constants/app_sizes.dart';
import 'package:forus_app/generated/assets.dart';
import 'package:forus_app/view/widget/my_text_widget.dart';
import 'package:forus_app/view/widget/my_text_field.dart';


class ProviderChatScreen extends StatefulWidget {
  const ProviderChatScreen({super.key});

  @override
  State<ProviderChatScreen> createState() => _ProviderChatScreenState();
}

class _ProviderChatScreenState extends State<ProviderChatScreen> {
  final List<ChatMessage> messages = [
    ChatMessage(
      day: "Today",
      text: "Good Morning Bhineka",
      time: "10:16 PM",
      isSender: true,
    ),
    ChatMessage(
      text: "Hey.. Very Very Good Morning",
      time: "10:17 PM",
      isSender: false,
    ),
    ChatMessage(
      text: "I wanted to order this hoodies t shirt",
      time: "10:19 PM",
      isSender: true,
    ),
    ChatMessage(
      text: "Ok! How many t shirt you want?",
      time: "10:22 PM",
      isSender: false,
    ),
    ChatMessage(
      text: "Hey.. Very Very Good Morning",
      time: "10:17 PM",
      isSender: false,
    ),
    ChatMessage(
      text: "I wanted to order this hoodies t shirt",
      time: "10:19 PM",
      isSender: true,
    ),
    ChatMessage(
      text: "Ok! How many t shirt you want?",
      time: "10:22 PM",
      isSender: false,
    ),
    ChatMessage(
      text: "Hey.. Very Very Good Morning",
      time: "10:17 PM",
      isSender: false,
    ),
    ChatMessage(
      text: "I wanted to order this hoodies t shirt",
      time: "10:19 PM",
      isSender: true,
    ),
    ChatMessage(
      text: "Ok! How many t shirt you want?",
      time: "10:22 PM",
      isSender: false,
    ),
    ChatMessage(
      text: "Hey.. Very Very Good Morning",
      time: "10:17 PM",
      isSender: false,
    ),
    ChatMessage(
      text: "I wanted to order this hoodies t shirt",
      time: "10:19 PM",
      isSender: true,
    ),
    ChatMessage(
      text: "Ok! How many t shirt you want?",
      time: "10:22 PM",
      isSender: false,
    ),
    ChatMessage(
      text: "Hey.. Very Very Good Morning",
      time: "10:17 PM",
      isSender: false,
    ),
    ChatMessage(
      text: "I wanted to order this hoodies t shirt",
      time: "10:19 PM",
      isSender: true,
    ),
    ChatMessage(
      text: "Ok! How many t shirt you want?",
      time: "10:22 PM",
      isSender: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemeColors.getTertiary(context),
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: CommonImageView(
              imagePath: Assets.imagesArrowLeft,
              height: 24,
            ),
          ),
        ),
        title: Row(
          children: [
            CommonImageView(
              imagePath: Assets.imagesChat2,
              height: 36,
            ),
            const SizedBox(width: 12),
            MyText(
              text: 'Bhineka',
              size: 18,
              textAlign: TextAlign.center,
              fontFamily: AppFonts.NUNITO_SANS,
              weight: FontWeight.w600,
            ),
          ],
        ),
      ),
      backgroundColor: AppThemeColors.getTertiary(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView.builder(
              padding: AppSizes.DEFAULT2,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(message: messages[index]);
              },
            ),
          ),
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: kWhite,
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.9),
                  blurRadius: 10,
                  offset: const Offset(8, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: MyTextField(
                      hint: 'Say Something...',
                      hintsize: 16,
                      hintColor: kTextDarkorange4,
                      labelColor: kTextDarkorange4,
                      filledColor: kTransperentColor,
                      kBorderColor: kWhite,
                      kFocusBorderColor: kWhite,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: CommonImageView(
                    imagePath: Assets.imagesSend,
                    height: 40,
                    width: 40,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String? day; // Optional field
  final String text;
  final String time;
  final bool isSender;

  ChatMessage({
    this.day,
    required this.text,
    required this.time,
    required this.isSender,
  });
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (message.day != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: MyText(
              text: message.day!,
              size: 16,
              fontFamily: AppFonts.NUNITO_SANS,
              weight: FontWeight.w600,
              color: kTertiaryColor2,
            ),
          ),
        Align(
          alignment:
              message.isSender ? Alignment.centerRight : Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: message.isSender
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.all(10),
                constraints: const BoxConstraints(maxWidth: 250),
                decoration: BoxDecoration(
                  color: message.isSender ? kborderOrange : KColor14,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: message.isSender
                        ? const Radius.circular(16)
                        : Radius.zero,
                    bottomRight: message.isSender
                        ? Radius.zero
                        : const Radius.circular(16),
                  ),
                ),
                child: MyText(
                  text: message.text,
                  size: 15,
                  fontFamily: AppFonts.NUNITO_SANS,
                  weight: FontWeight.w600,
                  color: message.isSender ? kWhite : kTextGrey2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: MyText(
                  text: message.time,
                  size: 11,
                  fontFamily: AppFonts.NUNITO_SANS,
                  weight: FontWeight.w500,
                  color: kTextGrey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
