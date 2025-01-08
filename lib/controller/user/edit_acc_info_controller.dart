import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swim_strive/constants/app_urls.dart';
import 'package:swim_strive/controller/user/CompleteProfileController.dart';
import 'package:swim_strive/controller/authentication/AuthController.dart';

class EditAccInfoController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  final completeProfileController = Get.find<CompleteProfileController>();
  final globalController = Get.find<AuthController>();

  // Function to update user account information
  Future<void> updateAccountInfo({
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? dob,
    String? pronouns,
    String? zipCode,
  }) async {
    try {
      // Fetch UID from CompleteProfileController
      final String uid = "${globalController.uid}";

      // Create a map to store only changed fields
      Map<String, dynamic> updatedFields = {};

      if (firstName != null && firstName != completeProfileController.firstName) {
        updatedFields['first_name'] = firstName;
        completeProfileController.firstName.value = firstName;
      }
      if (lastName != null && lastName != completeProfileController.lastName) {
        updatedFields['last_name'] = lastName;
        completeProfileController.lastName.value = lastName;
      }
      if (email != null && email != completeProfileController.email) {
        updatedFields['email'] = email;
        completeProfileController.email.value = email;
      }
      if (phoneNumber != null && phoneNumber != completeProfileController.phoneNumber) {
        updatedFields['phone_number'] = phoneNumber;
        completeProfileController.phoneNumber.value = phoneNumber;
      }
      if (dob != null && dob != completeProfileController.dob) {
        updatedFields['dob'] = dob;
        completeProfileController.dob.value = dob;
      }
      if (pronouns != null && pronouns != completeProfileController.pronouns) {
        updatedFields['pronouns'] = pronouns;
        completeProfileController.pronouns.value = pronouns;
      }
      if (zipCode != null && zipCode != completeProfileController.zipCode) {
        updatedFields['zipcode'] = zipCode;
        completeProfileController.zipCode.value = zipCode;
      }

      // Check if there are any changes
      if (updatedFields.isEmpty) {
        Get.snackbar('No Changes', 'No values were changed.',
            backgroundColor: Colors.orange);
        return;
      }

      // Update the users table in Supabase
      final response = await supabase
          .from('users')
          .update(updatedFields)
          .eq('id', uid);

      if (response.error != null) {
        throw Exception(response.error!.message);
      }

      Get.snackbar('Success', 'Account information updated successfully!',
          backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
      print("Error updating account information: $e");
    }
  }
}
