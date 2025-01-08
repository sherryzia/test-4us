import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rxdart/rxdart.dart' as rx;

class CoachChatController extends GetxController {
  final supabase = Supabase.instance.client;

  var messages = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs; // For initial message fetch
  var isSending = false.obs; // For sending a message

  // Future<void> fetchMessages(String chatId, bool isGroupChat) async {
  //   if (isSending.value) return; // Skip fetch if a message is being sent
  //   isLoading.value = true;
  //   try {
  //     List<Map<String, dynamic>> fetchedMessages;

  //     if (isGroupChat) {
  //       final response = await supabase
  //           .from('group_messages')
  //           .select('id, group_id, sender_id, message, created_at')
  //           .eq('group_id', chatId)
  //           .order('created_at', ascending: true);

  //       fetchedMessages = response != null
  //           ? List<Map<String, dynamic>>.from(response)
  //           : [];
  //     } else {
  //       final response = await supabase
  //           .from('direct_messages')
  //           .select('id, sender_id, receiver_id, message, created_at')
  //           .or('sender_id.eq.$chatId,receiver_id.eq.$chatId')
  //           .order('created_at', ascending: true);

  //       fetchedMessages = response != null
  //           ? List<Map<String, dynamic>>.from(response)
  //           : [];
  //     }

  //     for (var message in fetchedMessages) {
  //       final senderId = message['sender_id'];
  //       if (senderId != null) {
  //         final userResponse = await supabase
  //             .from('users')
  //             .select('profile_picture')
  //             .eq('id', senderId)
  //             .single();

  //         message['profile_picture'] =
  //             userResponse?['profile_picture'] ?? null;
  //       }
  //     }

  //     messages.value = fetchedMessages;
  //   } catch (e) {
  //     print("Error fetching messages: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }


 Stream<List<Map<String, dynamic>>> fetchMessages(String chatId, bool isGroupChat) {
  final table = isGroupChat ? 'group_messages' : 'direct_messages';

  if (isGroupChat) {
    return supabase
        .from(table)
        .stream(primaryKey: ['id'])
        .eq('group_id', chatId)
        .order('created_at', ascending: true)
        .asyncMap((data) async {
          return _enrichMessages(data);
        });
  } else {
    final senderStream = supabase
        .from(table)
        .stream(primaryKey: ['id'])
        .eq('sender_id', chatId)
        .order('created_at', ascending: true);

    final receiverStream = supabase
        .from(table)
        .stream(primaryKey: ['id'])
        .eq('receiver_id', chatId)
        .order('created_at', ascending: true);

    // Combine the two streams and sort them by created_at
    return rx.Rx.combineLatest2(
      senderStream,
      receiverStream,
      (List<dynamic> senderData, List<dynamic> receiverData) {
        final allMessages = [...senderData, ...receiverData];
        allMessages.sort((a, b) {
          final dateA = DateTime.parse(a['created_at']);
          final dateB = DateTime.parse(b['created_at']);
          return dateA.compareTo(dateB);
        });
        return allMessages;
      },
    ).asyncMap((data) async {
      return _enrichMessages(data);
    });
  }
}

// Helper function to enrich messages with sender information
Future<List<Map<String, dynamic>>> _enrichMessages(List<dynamic> data) async {
  final List<Map<String, dynamic>> enrichedMessages = [];
  for (final message in data) {
    final senderId = message['sender_id'];
    final sender = await supabase
        .from('users')
        .select('first_name, last_name, profile_picture')
        .eq('id', senderId)
        .single();

    enrichedMessages.add({
      ...message,
      'sender_name': '${sender['first_name']} ${sender['last_name']}',
      'profile_picture': sender['profile_picture'],
    });
  }
  return enrichedMessages;
}




  Future<void> sendMessage({
    required String chatId,
    required bool isGroupChat,
    required String content,
    required String senderId,
  }) async {
    try {
      // Immediately display the new message locally
      final tempMessage = {
        'id': DateTime.now().toString(),
        'sender_id': senderId,
        'message': content,
        'created_at': DateTime.now().toIso8601String(),
        'profile_picture': null,
      };

      messages.add(tempMessage);
      isSending.value = true; // Show sending state

      // Asynchronously push the message to the database
      if (isGroupChat) {
        await supabase.from('group_messages').insert({
          'group_id': chatId,
          'sender_id': senderId,
          'message': content,
        });
      } else {
        await supabase.from('direct_messages').insert({
          'sender_id': senderId,
          'receiver_id': chatId,
          'message': content,
        });
      }
    } catch (e) {
      print("Error sending message: $e");
      Get.snackbar("Error", "Failed to send message.");
    } finally {
      isSending.value = false;
    }
  }
}

