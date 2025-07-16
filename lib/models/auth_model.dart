// models/auth_model.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// user_model.dart
class UserModel {
  final String name;
  final String email;

  UserModel({required this.name, required this.email});

  Map<String, dynamic> toJson() {
    return {
      'FULL_NAME': name,
      'EMAIL': email,
    };
  }
}

class AuthModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> createUser(String email, String password) {
    return _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> saveUserData(String uid, Map<String, dynamic> data) {
    return _firestore.collection('userData').doc(uid).set(data);
  }
}
