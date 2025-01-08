import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swim_strive/main.dart';

class ChatHeadsController extends GetxController {
  final supabase = Supabase.instance.client;

  var chatHeads = <Map<String, dynamic>>[].obs; // Unified list of chat heads
  var isLoading = true.obs;

  String currentUserId = Supabase.instance.client.auth.currentUser?.id ?? '';

  @override
  void onInit() {
    super.onInit();
    fetchChatHeads();
  }

  Future<void> fetchChatHeads() async {
    isLoading.value = true;
    try {
      final directChats = await _fetchDirectChats();
      final groupChats = await _fetchGroupChats();

      // Combine and sort by latest message time
      final allChats = [...directChats, ...groupChats];
      allChats.sort((a, b) => DateTime.parse(b['last_message_time'])
          .compareTo(DateTime.parse(a['last_message_time'])));

      chatHeads.value = allChats;
    } catch (e) {
      print("Error fetching chat heads: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<Map<String, dynamic>>> _fetchDirectChats() async {
    final response = await supabase
        .from('direct_messages')
        .select('id, sender_id, receiver_id, message, created_at')
        .or('sender_id.eq.$currentUserId,receiver_id.eq.$currentUserId')
        .order('created_at', ascending: false);

    if (response == null || response.isEmpty) return [];

    final grouped = <String, Map<String, dynamic>>{};

    for (var chat in response) {
      final chatPartnerId =
          chat['sender_id'] == currentUserId ? chat['receiver_id'] : chat['sender_id'];

      if (!grouped.containsKey(chatPartnerId)) {
        final userDetails = await supabase
            .from('users')
            .select('first_name, last_name, profile_picture')
            .eq('id', chatPartnerId)
            .single();

        grouped[chatPartnerId] = {
          'type': 'direct',
          'chat_id': chatPartnerId,
          'name': '${userDetails['first_name']} ${userDetails['last_name']}',
          'profile_picture': userDetails['profile_picture'] ?? dummyImg,
          'last_message': chat['message'],
          'last_message_time': chat['created_at'],
        };
      }
    }

    return grouped.values.toList();
  }

  Future<List<Map<String, dynamic>>> _fetchGroupChats() async {
    final response = await supabase
        .from('group_messages')
        .select('id, group_id, message, created_at, groups(group_name)')
        .order('created_at', ascending: false);

    if (response == null || response.isEmpty) return [];

    final grouped = <String, Map<String, dynamic>>{};

    for (var chat in response) {
      final groupId = chat['group_id'];

      if (!grouped.containsKey(groupId)) {
        final groupMembersResponse = await supabase
            .from('group_membership')
            .select('users(profile_picture)')
            .eq('group_id', groupId);

        final groupMemberImages = groupMembersResponse
            .map<String>((member) => member['users']['profile_picture'] ?? dummyImg)
            .toList();

        grouped[groupId] = {
          'type': 'group',
          'chat_id': groupId,
          'name': chat['groups']['group_name'],
          'profile_picture': null,
          'last_message': chat['message'],
          'last_message_time': chat['created_at'],
          'group_member_images': groupMemberImages,
        };
      }
    }

    return grouped.values.toList();
  }
}
