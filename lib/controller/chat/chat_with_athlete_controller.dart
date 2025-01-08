import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatWithAthleteController extends GetxController {
  final supabase = Supabase.instance.client;

  var groups = <Map<String, dynamic>>[].obs;
  var athletes = <Map<String, dynamic>>[].obs;
  var filteredGroups = <Map<String, dynamic>>[].obs;
  var filteredAthletes = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGroupsAndAthletes();

    // Listen to search query changes
    searchQuery.listen((query) {
      filterResults(query);
    });
  }

  Future<void> fetchGroupsAndAthletes() async {
    isLoading.value = true;
    try {
      final coachId = supabase.auth.currentUser?.id;

      if (coachId == null) {
        throw Exception("No user logged in");
      }

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
              'athlete_user_id, users!coach_athlete_relationship_athlete_user_id_fkey(first_name, last_name, id)')
          .eq('coach_user_id', coachId);

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
