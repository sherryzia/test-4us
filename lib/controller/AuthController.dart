import 'package:get/get.dart';

class AuthController extends GetxController {
  // Basic Profile Information
  var uid = ''.obs;


  // Method to handle final submission or moving to the next part of the form
  void AuthIdPrint() {
    // Perform final validation and submission here
    print("Auth Controller: ");
    print("User ID: ${uid.value}");
    
  }
}
