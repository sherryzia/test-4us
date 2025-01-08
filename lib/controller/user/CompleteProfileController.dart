import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swim_strive/constants/app_urls.dart';
import 'package:swim_strive/controller/authentication/AuthController.dart';

class CompleteProfileController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
final authController = Get.find<AuthController>();
  // User fields
  var email = ''.obs;
  var role = ''.obs;
  var firstName = ''.obs;
  var lastName = ''.obs;
  var fullName = ''.obs;
  var phoneNumber = ''.obs;
  var dob = ''.obs;
  var gender = ''.obs;
  var pronouns = ''.obs;
  var race = ''.obs;
  var zipCode = ''.obs;
var dpUrl = ''.obs;
var supabaseUrl = 'https://ecjdlraardhjaukplvum.supabase.co/storage/v1/object/public/profiles';



  // Function to fetch user data
  Future<void> fetchUserProfile( String uid) async {
    try {
      // Fetch the uid from the global controller

      // Query the users table
      final response = await supabase.from('users').select().eq('id', uid).maybeSingle();

      if (response == null) {
        throw Exception("User not found.");
      }

      // Update the controller fields
      email.value = response['email'] ?? '';
      role.value = response['role'] ?? '';
      firstName.value = response['first_name'] ?? '';
      lastName.value = response['last_name'] ?? '';
      phoneNumber.value = response['phone_number'] ?? '';
      dob.value = response['dob'] ?? '';
      gender.value = response['gender'] ?? '';
      pronouns.value = response['pronouns'] ?? '';
      race.value = response['race'] ?? '';
      zipCode.value = response['zipcode'] ?? '';
      fullName.value = "${firstName.value} ${lastName.value}";
      dpUrl.value = "${supabaseUrl}/${authController.uid}_profile.jpg";

      Get.snackbar('Success', 'Profile loaded successfully!',
          backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
      print("Error fetching user profile: $e");
    }
  }


  Future<void> PrintAllData() async {
    print("Email: $email");
    print("Role: $role");
    print("First Name: $firstName");
    print("Last Name: $lastName");
    print("Full Name: $fullName");
    print("Phone Number: $phoneNumber");
    print("Date of Birth: $dob");
    print("Gender: $gender");
    print("Pronouns: $pronouns");
    print("Race: $race");
    print("Zip Code: $zipCode");
  }


 // Clear user profile data
  void clearProfileData() {
    
    email.value = '';
    role.value = '';
    firstName.value = '';
    lastName.value = '';
    phoneNumber.value = '';
    dob.value = '';
    gender.value = '';
    pronouns.value = '';
    race.value = '';
    zipCode.value = '';
  }


}
