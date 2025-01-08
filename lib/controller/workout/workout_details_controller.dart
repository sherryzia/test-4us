import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WorkoutDetailsController extends GetxController {
  final supabase = Supabase.instance.client;

  var workoutIntro = {}.obs; // Observable map for workout introduction
  var workoutTrainings = <Map<String, dynamic>>[].obs; // Observable list for trainings
  var isLoading = true.obs; // Loading state

  Future<void> fetchWorkoutDetails(String workoutId) async {
    try {
      isLoading.value = true;

      // Fetch workout introduction
      final introResponse = await supabase
          .from('workout_intro')
          .select('*')
          .eq('workout_id', workoutId)
          .single();

      if (introResponse != null) {
        workoutIntro.value = introResponse;
      } else {
        workoutIntro.value = {};
      }

      // Fetch workout trainings
      final trainingResponse = await supabase
          .from('workout_trainings')
          .select('*')
          .eq('workout_id', workoutId);

      if (trainingResponse != null) {
        workoutTrainings.value = List<Map<String, dynamic>>.from(trainingResponse);
      } else {
        workoutTrainings.value = [];
      }
    } catch (e) {
      print('Error fetching workout details: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
