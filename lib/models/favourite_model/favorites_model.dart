// models/favorites_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FavoritesModel {
  late FirebaseFirestore _firestore;
  User? _user;
  bool _isInitialized = false;

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
    _firestore = FirebaseFirestore.instance;
    _user = FirebaseAuth.instance.currentUser;
    _isInitialized = true;
  }

  Future<List<String>> fetchFavorites(String collectionName) async {
    if (!_isInitialized) return [];
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(_user!.uid)
          .collection(collectionName)
          .get();

      return snapshot.docs.map((doc) {
        return (doc.data() as Map<String, dynamic>)['affirmation'] as String;
      }).toList();
    } catch (e) {
      print('Error fetching favorites: $e');
      return [];
    }
  }
}
