import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swim_strive/constants/app_urls.dart';

class CreateGroupController extends GetxController {
  final supabase = Supabase.instance.client;
  final groupNameController = TextEditingController();
  final searchController = TextEditingController();
  var athletes = <Map<String, dynamic>>[].obs;
final RxList<Map<String, dynamic>> filteredAthletes = <Map<String, dynamic>>[].obs;
final RxSet<String> selectedAthletes = <String>{}.obs;
  var isLoading = true.obs;
  var searchQuery = ''.obs;
var isCreatingGroup = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAthletes();
    searchController.addListener(() {
      searchQuery.value = searchController.text.trim().toLowerCase();
      filterAthletes();
    });
  }

  Future<void> fetchAthletes() async {
    try {
      final coachId = supabase.auth.currentUser?.id;

      if (coachId == null) {
        throw Exception("No user logged in");
      }

      final response = await supabase.rpc('fetch_athletes_with_groups', params: {'coach_id': coachId});

      if (response != null) {
        athletes.value = List<Map<String, dynamic>>.from(response);
        filteredAthletes.value = List<Map<String, dynamic>>.from(response);
      }
    } catch (e) {
      print("Error fetching athletes: $e");
      Get.snackbar("Error", "Failed to fetch athletes.");
    } finally {
      isLoading.value = false;
    }
  }

  void filterAthletes() {
    filteredAthletes.value = athletes.where((athlete) {
      final athleteName = athlete['athlete_name'].toLowerCase();
      final groupNames = athlete['group_names']?.toLowerCase() ?? '';
      return athleteName.contains(searchQuery.value) || groupNames.contains(searchQuery.value);
    }).toList();
  }
void toggleAthleteSelection(String athleteId) {
  if (selectedAthletes.contains(athleteId)) {
    selectedAthletes.remove(athleteId);
  } else {
    selectedAthletes.add(athleteId);
  }
  print("Updated selected athletes: $selectedAthletes");
  selectedAthletes.refresh(); // Ensure UI updates
}




  Future<void> createGroup() async {
  final groupName = groupNameController.text.trim();

  if (groupName.isEmpty || selectedAthletes.isEmpty) {
    Get.snackbar("Error", "Group name and athletes cannot be empty.");
    return;
  }

  try {
    isCreatingGroup.value = true; // Start creating group
    final coachId = supabase.auth.currentUser?.id;

    if (coachId == null) {
      throw Exception("No user logged in");
    }

    final groupResponse = await supabase.from('groups').insert({
      'group_name': groupName,
      'coach_user_id': coachId,
    }).select('id').single();

    if (groupResponse == null || groupResponse['id'] == null) {
      throw Exception("Group creation failed: Unable to fetch group ID.");
    }

    final groupId = groupResponse['id'];

    final groupAthletes = selectedAthletes.map((athleteId) {
      return {
        'group_id': groupId,
        'athlete_user_id': athleteId,
      };
    }).toList();

    await supabase.from('group_membership').insert(groupAthletes);

    Get.snackbar("Success", "Group created successfully!");
  } catch (e) {
    print("Error creating group: $e");
    Get.snackbar("Error", "Failed to create group: $e");
  } finally {
    isCreatingGroup.value = false; // Reset button state
  }
}
}
