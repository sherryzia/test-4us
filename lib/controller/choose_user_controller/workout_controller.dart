import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WorkoutController extends GetxController {
  final supabase = Supabase.instance.client;
  var workouts = <Map<String, dynamic>>[].obs; // Observable list of workouts
  var isLoading = true.obs; // Observable loading state

  @override
  void onInit() {
    super.onInit();
    fetchWorkouts(); // Fetch workouts when the controller is initialized
  }

  Future<void> fetchWorkouts() async {
    try {
      isLoading.value = true; // Set loading state to true
      
      // Perform the Supabase query
      final response = await supabase.from('workouts').select();

      // print('Response: $response');

      if (response != null) {
        workouts.value = List<Map<String, dynamic>>.from(response); // Assign fetched data
      } else {
        print('No workouts found in the database.');
      }
    } catch (e) {
      print('Error fetching workouts: $e');
    } finally {
      isLoading.value = false; // Set loading state to false
    }
  }
}
