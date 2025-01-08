import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swim_strive/constants/app_urls.dart';
import 'package:swim_strive/controller/user/CompleteProfileController.dart';
import 'package:swim_strive/controller/authentication/AuthController.dart';
import 'package:swim_strive/view/screens/athlete/a_membership/membership_athlete.dart';
import 'package:swim_strive/view/screens/athlete_with_coach/awc_membership/membership_athlete_with_coach.dart';

class AthleteWithCoachPersonalInformationController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
      final profileController = Get.find<CompleteProfileController>();

  Future<void> updatePersonalInformation({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String birthDate,
    required String gender,
    String? pronouns,
    String? race,
    required String zipCode,
  }) async {
    try {
      // Fetch the uid from the global controller
      final String uid ="${Get.find<AuthController>().uid}";

      // Update the user's information in the database
      final response = await supabase.from('users').update({
        'first_name': firstName,
        'last_name': lastName,
        'phone_number': phoneNumber,
        'dob': birthDate,
        'gender': gender,
        'pronouns': pronouns,
        'race': race,
        'zipcode': zipCode,
      }).eq('id', uid);


      Get.snackbar('Success', 'Personal information updated successfully!',
          backgroundColor: Colors.green);

          profileController.fetchUserProfile( uid);
          profileController.PrintAllData();
Get.to(() => MembershipAthleteWithCoach());
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
      print("Error updating personal information: $e");
    }
  }
}
