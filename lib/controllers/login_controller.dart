import 'package:affirmation_app/view/screens/auth/login/login.dart';
import 'package:affirmation_app/view/screens/homescreen/premium_sub.dart';
import 'package:affirmation_app/view/screens/launch/splash_screen.dart';
import 'package:affirmation_app/view/screens/profile_settings/subscription.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:affirmation_app/services/firebase_auth_services.dart';
import 'package:affirmation_app/view/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:affirmation_app/view/screens/auth/sign_up/complete_profile.dart';

class LoginController extends GetxController {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signInWithEmailAndPassword(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      User? user =
          await _authService.signInWithEmailAndPassword(email, password);
      if (user != null) {
        await _navigateBasedOnPremiumStatus(user);
      } else {
        Get.snackbar(
            'Error', 'Failed to sign in. Please check your credentials.', backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign in. Please try again.', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        await _navigateBasedOnPremiumStatus(user);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign in successful',style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.green,
          ),
        );
      } else {
        Get.snackbar('Error', 'Failed to sign in with Google.', backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign in with Google.', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  bool _checkRequiredFields(Map<String, dynamic> userData) {
    final requiredFields = [
      'address',
      'ageGroup',
      'currentIncome',
      'debtAmount',
      'desiredIncome',
      'email',
      'goal',
      'mobileNumber',
      'name',
      'premium',
      'selectedDebtType',
      'selectedDesiredOccupation',
      'selectedOccupation',
    ];

    for (String field in requiredFields) {
      if (!userData.containsKey(field) ||
          userData[field] == null ||
          userData[field].toString().isEmpty) {
        return false;
      }
    }
    return true;
  }

  Future<void> _navigateBasedOnPremiumStatus(User user) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('userData')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      final userData = userDoc.data();

      if (userData == null ||
          !userData.containsKey('address') ||
          !userData.containsKey('ageGroup') ||
          !userData.containsKey('currentIncome') ||
          !userData.containsKey('debtAmount') ||
          !userData.containsKey('desiredIncome') ||
          !userData.containsKey('email') ||
          !userData.containsKey('goal') ||
          !userData.containsKey('mobileNumber') ||
          !userData.containsKey('name') ||
          !userData.containsKey('premium') ||
          !userData.containsKey('selectedDebtType') ||
          !userData.containsKey('selectedDesiredOccupation') ||
          !userData.containsKey('selectedOccupation')) {
        // If required fields are missing, navigate to CompleteProfile
        Get.offAll(() => CompleteProfile());
      } else if (userData['premium'] == true) {
        Get.offAll(() => BottomNavBar());
      } else {
        Get.offAll(() => PremiumSub());
      }
    } else {
      // If the user document does not exist, navigate to CompleteProfile
      Get.offAll(() => CompleteProfile());
    }
  }

  Future<void> resetPassword(BuildContext context) async {
    String email = emailController.text.trim();
    if (email.isEmpty) {
      Get.snackbar('Error', 'Please enter your email.', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      await _authService.resetPassword(email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password reset email sent to $email",style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 5),
        ),
      );
    } catch (e) {
      print('Error sending password reset email: $e');
      String errorMessage = 'Failed to send reset email. Please try again.';
      Get.snackbar('Error', errorMessage);
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // Sign out from Google if the user is signed in with Google
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }

      // Navigate to the sign-in page or any other appropriate page
      Get.offAll(() => SplashScreen());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signed out successfully')),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign out. Please try again.');
    }
  }

  // @override
  // void onClose() {
  //   emailController.dispose();
  //   passwordController.dispose();
  //   super.onClose();
  // }
}
