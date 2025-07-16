// home_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:affirmation_app/models/user_model.dart';

class HomeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Rx<User?> user = Rx<User?>(null);
  Rx<UserModel?> userModel = Rx<UserModel?>(null);
  RxBool isLoading = RxBool(true);

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
    ever(user, _fetchUserData);
  }

  // lib/controllers/home_controller.dart

  Future<void> _fetchUserData(User? user) async {
    if (user != null) {
      DocumentSnapshot snapshot =
          await _firestore.collection('userData').doc(user.uid).get();
      if (snapshot.exists) {
        userModel.value = UserModel(
          uid: user.uid,
          name: snapshot['name'],
          profileImageUrl: snapshot[
              'profileImageUrl'], // Ensure this matches your Firestore field
          ageGroup:
              snapshot['ageGroup'], // Ensure this matches your Firestore field
          selectedOccupation: snapshot[
              'selectedOccupation'], // Ensure this matches your Firestore field
          currentIncome: snapshot[
              'currentIncome'], // Ensure this matches your Firestore field
          selectedDesiredOccupation: snapshot[
              'selectedDesiredOccupation'], // Ensure this matches your Firestore field
          desiredIncome: snapshot[
              'desiredIncome'], // Ensure this matches your Firestore field
          debtAmount: snapshot[
              'debtAmount'], // Ensure this matches your Firestore field
          selectedDebtType: snapshot[
              'selectedDebtType'], // Ensure this matches your Firestore field
          mobileNumber: snapshot[
              'mobileNumber'], // Ensure this matches your Firestore field
          address:
              snapshot['address'], // Ensure this matches your Firestore field
          goal: snapshot['goal'],
          email: '', // Ensure this matches your Firestore field
        );
        isLoading.value = false;
      } else {
        isLoading.value = false;
        // Handle scenario where user data does not exist
      }
    } else {
      isLoading.value = false;
      // Handle scenario where user is not authenticated
    }
  }
}
