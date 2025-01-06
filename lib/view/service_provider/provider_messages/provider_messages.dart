import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/constants/app_fonts.dart';
import 'package:forus_app/constants/app_sizes.dart';
import 'package:forus_app/generated/assets.dart';
import 'package:forus_app/view/service_provider/provider_messages/chat_messages.dart';
import 'package:forus_app/view/widget/common_image_view_widget.dart';
import 'package:forus_app/view/widget/my_text_widget.dart';
import 'package:forus_app/view/widget/my_text_field.dart';

class ProviderMessagesScreen extends StatefulWidget {
  final bool messages;
  const ProviderMessagesScreen({super.key, this.messages = false});

  @override
  State<ProviderMessagesScreen> createState() => _ProviderMessagesScreenState();
}

class _ProviderMessagesScreenState extends State<ProviderMessagesScreen> {
  final List<ChatMessage> messages = [
    ChatMessage(
      senderName: 'Jakarta Gadget',
      message: 'Hey i just saw your..',
      timeAgo: '1hr',
      avatarUrl: Assets.imagesChat1,
    ),
    ChatMessage(
      senderName: 'Glodok Elektronik',
      message: 'I am interest to sell you.',
      timeAgo: '2hr',
      avatarUrl: Assets.imagesChat2,
      notificationCount: 3,
    ),
    ChatMessage(
      senderName: 'Mikiku ID',
      message: 'Please let me know when can we.',
      timeAgo: '4hr',
      avatarUrl: Assets.imagesChat3,
    ),
    ChatMessage(
      senderName: 'Sunday Alley',
      message: 'it’s right now out of stock..',
      timeAgo: '4hr',
      avatarUrl: Assets.imagesChat4,
    ),
    ChatMessage(
      senderName: 'Jakarta Gadget',
      message: 'Hey i just saw your..',
      timeAgo: '1hr',
      avatarUrl: Assets.imagesChat1,
    ),
    ChatMessage(
      senderName: 'Glodok Elektronik',
      message: 'I am interest to sell you.',
      timeAgo: '2hr',
      avatarUrl: Assets.imagesChat2,
      notificationCount: 3,
    ),
    ChatMessage(
      senderName: 'Mikiku ID',
      message: 'Please let me know when can we.',
      timeAgo: '4hr',
      avatarUrl: Assets.imagesChat3,
    ),
    ChatMessage(
      senderName: 'Sunday Alley',
      message: 'it’s right now out of stock..',
      timeAgo: '4hr',
      avatarUrl: Assets.imagesChat4,
    ),
    ChatMessage(
      senderName: 'Jakarta Gadget',
      message: 'Hey i just saw your..',
      timeAgo: '1hr',
      avatarUrl: Assets.imagesChat1,
    ),
    ChatMessage(
      senderName: 'Glodok Elektronik',
      message: 'I am interest to sell you.',
      timeAgo: '2hr',
      avatarUrl: Assets.imagesChat2,
      notificationCount: 3,
    ),
    ChatMessage(
      senderName: 'Mikiku ID',
      message: 'Please let me know when can we.',
      timeAgo: '4hr',
      avatarUrl: Assets.imagesChat3,
    ),
    ChatMessage(
      senderName: 'Sunday Alley',
      message: 'it’s right now out of stock..',
      timeAgo: '4hr',
      avatarUrl: Assets.imagesChat4,
    ),
    ChatMessage(
      senderName: 'Jakarta Gadget',
      message: 'Hey i just saw your..',
      timeAgo: '1hr',
      avatarUrl: Assets.imagesChat1,
    ),
    ChatMessage(
      senderName: 'Glodok Elektronik',
      message: 'I am interest to sell you.',
      timeAgo: '2hr',
      avatarUrl: Assets.imagesChat2,
      notificationCount: 3,
    ),
    ChatMessage(
      senderName: 'Mikiku ID',
      message: 'Please let me know when can we.',
      timeAgo: '4hr',
      avatarUrl: Assets.imagesChat3,
    ),
    ChatMessage(
      senderName: 'Sunday Alley',
      message: 'it’s right now out of stock..',
      timeAgo: '4hr',
      avatarUrl: Assets.imagesChat4,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemeColors.getTertiary(context),
        title: MyText(
          text: "Messages ",
          size: 18,
          textAlign: TextAlign.center,
          fontFamily: AppFonts.NUNITO_SANS,
          weight: FontWeight.w700,
        ),
        centerTitle: true,
      ),
      backgroundColor: AppThemeColors.getTertiary(context),
     
      body: Padding(
        padding: AppSizes.DEFAULT2,
        child: Column(
          children: [
            if (widget.messages == true)
              Expanded(
                child: Center(
                  child: CommonImageView(
                    imagePath: Assets.imagesNoMessages,
                    height: 220,
                  ),
                ),
              )
            else
              Expanded(
                child: Column(
                  children: [
                    MyTextField(
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
                    Gap(20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) => Slidable(
                          key: Key(messages[index].senderName),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            extentRatio: 0.20,
                            children: [
                              Container(
                                child: Center(
                                  child: CommonImageView(
                                    imagePath: Assets.imagesTrash,
                                    height: 50,
                                  ),
                                ),
                              )
                            ],
                          ),
                          child: ChatListItem(message: messages[index]),
                        ),
                      ),
                    ),
                 
                 
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String senderName;
  final String message;
  final String timeAgo;
  final String avatarUrl;
  final int? notificationCount;

  ChatMessage({
    required this.senderName,
    required this.message,
    required this.timeAgo,
    required this.avatarUrl,
    this.notificationCount,
  });
}

class ChatListItem extends StatelessWidget {
  final ChatMessage message;

  const ChatListItem({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

          Get.to(() => ProviderChatScreen());
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: kDividerGrey2,
              width: 1,
            ),
          ),
        ),
        child: ListTile(
          leading: CommonImageView(
            imagePath: message.avatarUrl,
            height: 50,
          ),
          title: Row(
            children: [
              Expanded(
                child: MyText(
                  text: message.senderName,
                  size: 15,
                  fontFamily: AppFonts.NUNITO_SANS,
                  weight: FontWeight.w600,
                ),
              ),
              MyText(
                text: message.timeAgo,
                size: 12,
                paddingBottom: 8,
                fontFamily: AppFonts.NUNITO_SANS,
                weight: FontWeight.w500,
                color: kTextGrey,
              ),
            ],
          ),
          subtitle: Row(
            children: [
              Expanded(
                child: MyText(
                  text: message.message,
                  size: 14,
                  fontFamily: AppFonts.NUNITO_SANS,
                  weight: FontWeight.w500,
                  color: kTextGrey,
                ),
              ),
              if (message.notificationCount != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: kContainerColorOrang2,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: MyText(
                    text: message.notificationCount.toString(),
                    size: 12,
                    fontFamily: AppFonts.NUNITO_SANS,
                    weight: FontWeight.w700,
                    color: kWhite,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
