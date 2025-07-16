import 'dart:convert';
import 'package:affirmation_app/constants/api_key.dart';
import 'package:affirmation_app/models/chat_message.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ChatController extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners(); // Notify listeners to update the UI
  }

  Future<void> sendMessage(String message) async {
    _messages.add(ChatMessage(role: 'user', content: message));
    _setLoading(true); // Start loading

    final defaultPrompt =
        "You are the Affirmation Chatbot! You are here to help me with affirmations, motivation, and encouragement. I will ask you questions or request affirmations to uplift my spirits and stay motivated. Whether I need a boost for my day or some positive reinforcement, you are here for me!\nYou won't respond to anything else than the above prompt.\n";

    final promptMessage = '$defaultPrompt\n$message';

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/completions'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'model': 'gpt-3.5-turbo-instruct',
          'prompt': promptMessage,
          'max_tokens': 4000,
          'temperature': 0,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final botMessage = data['choices'][0]['text'];

        _messages.add(ChatMessage(role: 'bot', content: botMessage.trim()));
      } else {
        _messages.add(ChatMessage(
          role: 'bot',
          content: 'Failed to load response from API: ${response.statusCode}',
        ));
      }
    } catch (e) {
      _messages.add(ChatMessage(
        role: 'bot',
        content: 'An error occurred: ${e.toString()}',
      ));
    } finally {
      _setLoading(false); // Stop loading
    }
  }
}
