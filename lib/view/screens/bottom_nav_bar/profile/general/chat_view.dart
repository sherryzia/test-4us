import 'dart:ui';
import 'package:affirmation_app/constants/app_colors.dart';
import 'package:affirmation_app/constants/app_images.dart';
import 'package:affirmation_app/controllers/chat_controller.dart';
import 'package:affirmation_app/models/chat_message.dart';
import 'package:affirmation_app/view/widget/simple_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatController(),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.imagesBgImage),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 8,
              sigmaY: 8,
            ),
            child: Container(
              color: kBlackColor.withOpacity(0.75),
              child: Stack(
                children: [
                  Column(
                    children: [
                      SimpleAppBar(
                        title: 'Chatbot',
                        haveLeading: true,
                      ),
                      Expanded(
                        child: Consumer<ChatController>(
                          builder: (context, chatController, _) {
                            return ListView.builder(
                              itemCount: chatController.isLoading
                                  ? chatController.messages.length + 1
                                  : chatController.messages.length,
                              itemBuilder: (context, index) {
                                if (index == chatController.messages.length) {
                                  // Display the progress bar at the end
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  );
                                }
                                final ChatMessage message =
                                    chatController.messages[index];
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  decoration: BoxDecoration(
                                    color: message.role == 'user'
                                        ? Color.fromARGB(131, 0, 0, 0)
                                        : Color.fromARGB(141, 255, 254, 254),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    message.content,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: message.role == 'user'
                                          ? Colors.white
                                          : Colors.black,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Consumer<ChatController>(
                        builder: (context, chatController, _) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _controller,
                                    decoration: InputDecoration(
                                      hintText: 'Enter your message',
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 20,
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                IconButton(
                                  icon: Icon(
                                    Icons.send,
                                    color: const Color.fromARGB(
                                        255, 166, 166, 166),
                                  ),
                                  onPressed: () async {
                                    final message = _controller.text.trim();
                                    if (message.isNotEmpty) {
                                      final chatController =
                                          context.read<ChatController>();

                                      await chatController.sendMessage(message);

                                      _controller.clear();
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  // Consumer<ChatController>(
                  //   builder: (context, chatController, _) {
                  //     return chatController.isLoading
                  //         ? Center(
                  //             child: CircularProgressIndicator(),
                  //           )
                  //         : SizedBox.shrink();
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
