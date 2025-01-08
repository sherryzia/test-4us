import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swim_strive/controller/authentication/AuthController.dart';

class AWCChatWithAthleteController extends GetxController {
  final supabase = Supabase.instance.client;

  var groups = <Map<String, dynamic>>[].obs;
  var athletes = <Map<String, dynamic>>[].obs;
  var filteredGroups = <Map<String, dynamic>>[].obs;
  var filteredAthletes = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var searchQuery = ''.obs;
  var coachId = '';

  @override
  void onInit() {
    super.onInit();
    fetchGroupsAndAthletes();

    // Listen to search query changes
    searchQuery.listen((query) {
      filterResults(query);
    });
  }
final athleteId = Get.find<AuthController>().uid.value;
  Future<void> fetchGroupsAndAthletes() async {
    isLoading.value = true;
    try {
    
    final athleteResponseCid = await supabase
          .from('coach_athlete_relationship')
          .select(
              'coach_user_id, athlete_user_id')
          .eq('athlete_user_id', athleteId);

      if (athleteResponseCid != null) {
        //coachId = List<Map<String, dynamic>>.from(athleteResponse)[0]['coach_user_id'];
         coachId = athleteResponseCid[0]['coach_user_id'];
      }

// store coach id against current uid to variable

      // Fetch groups
      final groupResponse = await supabase
          .from('groups')
          .select('id, group_name, coach_user_id, group_membership(count)')
          .eq('coach_user_id', coachId);

      if (groupResponse != null) {
        groups.value = List<Map<String, dynamic>>.from(groupResponse);
        filteredGroups.value = groups; // Initialize filtered list
      }

      // Fetch athletes
      final athleteResponse = await supabase
          .from('coach_athlete_relationship')
          .select(
              'coach_user_id, athlete_user_id, users!coach_athlete_relationship_athlete_user_id_fkey(first_name, last_name, id)')
          .eq('athlete_user_id', athleteId);

      if (athleteResponse != null) {
        athletes.value = List<Map<String, dynamic>>.from(athleteResponse)
            .map((e) => {
                  'full_name':
                      '${e['users']['first_name']} ${e['users']['last_name']}',
                  'id': e['users']['id'],
                })
            .toList();
        filteredAthletes.value = athletes; // Initialize filtered list
      }
    } catch (e) {
      print("Error fetching data: $e");
      Get.snackbar("Error", "Failed to fetch data.");
    } finally {
      isLoading.value = false;
    }
  }

  void filterResults(String query) {
    final lowerCaseQuery = query.toLowerCase();

    filteredGroups.value = groups.where((group) {
      final groupName = group['group_name'].toLowerCase();
      return groupName.contains(lowerCaseQuery);
    }).toList();

    filteredAthletes.value = athletes.where((athlete) {
      final athleteName = athlete['full_name'].toLowerCase();
      return athleteName.contains(lowerCaseQuery);
    }).toList();
  }
}
