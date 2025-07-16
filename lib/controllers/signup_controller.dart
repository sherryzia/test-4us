import 'package:affirmation_app/models/auth_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:affirmation_app/view/screens/auth/sign_up/complete_profile.dart';

class SignUpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signUp(String name, String email, String password, BuildContext context) async {
    if (!_validateEmail(email)) {
      _showErrorSnackBar('Invalid email format.', Colors.red);
      return;
    }

    if (!_validatePassword(password)) {
      _showErrorSnackBar('Password must be at least 8 characters long and include both letters and numbers.', Colors.red);
      return;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        UserModel userModel = UserModel(name: name, email: email);
        await FirebaseFirestore.instance
            .collection('userData')
            .doc(userCredential.user!.uid)
            .set(userModel.toJson());
        _showErrorSnackBar('Signup successful!', Colors.green); // This should be a success message now
        Get.to(() => CompleteProfile());
      } else {
        _showErrorSnackBar("Failed to sign up. Please try again.", Colors.red);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _showErrorSnackBar('The password provided is too weak.', Colors.red);
      } else if (e.code == 'email-already-in-use') {
        _showErrorSnackBar('The account already exists for that email.', Colors.red);
      }
    } catch (e) {
      _showErrorSnackBar(e.toString(), Colors.red);
    }
  }

  bool _validateEmail(String email) {
    Pattern pattern = r'^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$';
    RegExp regex = RegExp(pattern.toString());
    return regex.hasMatch(email);
  }

  bool _validatePassword(String password) {
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasLetters = password.contains(RegExp(r'[a-zA-Z]'));
    return password.length > 7 && hasDigits && hasLetters;
  }

  void _showErrorSnackBar(String message, Color bgColor) {
    Get.snackbar(
      'Error', // Title can be kept generic or empty
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: bgColor,
      colorText: Colors.white,
      margin: EdgeInsets.all(10),
      borderRadius: 0,
      duration: Duration(seconds: 5),
    );
  }
}
