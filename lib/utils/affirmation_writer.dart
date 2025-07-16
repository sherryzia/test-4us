import 'dart:convert';

import 'package:affirmation_app/constants/api_key.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class AffirmationsWriter {
  static User? _user;
  static Map<String, dynamic>? _userData;

  static const String defaultPromptTemplate =
      "Generate 30 affirmations based on the following user data: {ageGroup}, {selectedOccupation}, {currentIncome}, {selectedDesiredOccupation}, {desiredIncome}, {debtAmount}, {goal}. Each affirmation must be under 40 words and refer to the user as \"YOU\". Ensure that the affirmations do not include any commas and that any numerical values are written without commas for thousands or other separations.";

  static String _generatePrompt(Map<String, dynamic> userData) {
    return defaultPromptTemplate
        .replaceAll("{ageGroup}", userData['ageGroup'])
        .replaceAll("{selectedOccupation}", userData['selectedOccupation'])
        .replaceAll("{currentIncome}", userData['currentIncome'])
        .replaceAll("{selectedDesiredOccupation}",
            userData['selectedDesiredOccupation'])
        .replaceAll("{desiredIncome}", userData['desiredIncome'])
        .replaceAll("{debtAmount}", userData['debtAmount'])
        .replaceAll("{goal}", userData['goal']);
  }

  static Future<List<String>> generateAndUploadAffirmationsToFirebase() async {
    await _fetchUserData();

    if (_userData == null) {
      throw Exception('User data not available');
    }

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'model': 'gpt-3.5-turbo-instruct',
        'prompt': _generatePrompt(_userData!),
        'max_tokens': 4000,
        'temperature': 0.5,
        'n': 1,
      }),
    );

    if (response.statusCode == 200) {
      List<String> affirmations = _extractAffirmations(response.body);
      await _uploadAffirmationsToFirebase(affirmations);
      return affirmations;
    } else {
      print('Failed to generate affirmations: ${response.statusCode}');
      throw Exception('Failed to generate affirmations');
    }
  }

  static List<String> _extractAffirmations(String responseBody) {
    List<String> affirmations = [];
    var jsonResponse = json.decode(responseBody);
    if (jsonResponse['choices'] != null) {
      jsonResponse['choices'].forEach((choice) {
        List<String> lines = choice['text'].toString().split('\n');
        lines.forEach((line) {
          if (line.trim().isNotEmpty) {
            RegExp regExp = RegExp(r'^(\d+)\.\s(.+)');
            if (regExp.hasMatch(line)) {
              Match? match = regExp.firstMatch(line);
              if (match != null) {
                affirmations.add(match.group(2)!);
              }
            }
          }
        });
      });
    }
    return affirmations;
  }

  static Future<void> _fetchUserData() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('userData')
          .doc(_user!.uid)
          .get();
      _userData = snapshot.data() as Map<String, dynamic>?;
    }
  }

  static Future<void> _uploadAffirmationsToFirebase(
      List<String> affirmations) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      String csvData =
          affirmations.map((affirmation) => '"$affirmation"').join(', ');

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('affirmations')
          .doc('affirmations_csv')
          .set({'csv_data': csvData});

      print(
          'Affirmations uploaded to Firebase Firestore for user: ${user.uid}');
    } catch (e) {
      print('Failed to upload affirmations to Firebase Firestore: $e');
    }
  }
}
