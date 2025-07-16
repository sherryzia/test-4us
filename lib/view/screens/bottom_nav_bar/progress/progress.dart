import 'dart:async';
import 'dart:math';

import 'package:affirmation_app/constants/affirmation_list.dart';
import 'package:affirmation_app/constants/app_colors.dart';
import 'package:affirmation_app/constants/app_images.dart';
import 'package:affirmation_app/constants/app_sizes.dart';
import 'package:affirmation_app/view/screens/bottom_nav_bar/profile/set_affirmation_reminder.dart';
import 'package:affirmation_app/view/widget/my_text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  Map<String, dynamic>? _userData;
  List<DateTime> _visitDates = [];
  String _currentAffirmation = '';
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _updateUserVisit();
    affirmation();
    _startAffirmationTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void affirmation() {
    setState(() {
      _currentAffirmation = _getRandomAffirmation();
    });
  }

  String _getRandomAffirmation() {
    final random = Random();
    return affirmations[random.nextInt(affirmations.length)];
  }

  void _startAffirmationTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        _currentAffirmation = _getRandomAffirmation();
      });
    });
  }

  Future<void> _fetchUserData() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      DocumentSnapshot snapshot =
          await _firestore.collection('userData').doc(_user!.uid).get();
      setState(() {
        _userData = snapshot.data() as Map<String, dynamic>?;
        if (_userData != null && _userData!['visitDates'] != null) {
          List<dynamic> dates = _userData!['visitDates'];
          _visitDates =
              dates.map((date) => (date as Timestamp).toDate()).toList();
        }
      });
    }
  }

  Future<void> _updateUserVisit() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      _visitDates.add(DateTime.now());
      await _firestore.collection('userData').doc(_user!.uid).update({
        'visitDates':
            _visitDates.map((date) => Timestamp.fromDate(date)).toList(),
      });
    }
  }

  String capitalizeEachWord(String input) {
    if (input.isEmpty) return input;
    return input.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  double calculatePercentage() {
    if (_userData == null) return 0;

    int currentIncome = int.tryParse(_userData?['currentIncome'] ?? '0') ?? 0;
    int desiredIncome = int.tryParse(_userData?['desiredIncome'] ?? '0') ?? 0;

    return (currentIncome / (desiredIncome == 0 ? 1 : desiredIncome));
  }

  int calculateStreak() {
    if (_visitDates.isEmpty) return 0;

    _visitDates.sort((a, b) => b.compareTo(a));

    int streak = 1;
    for (int i = 1; i < _visitDates.length; i++) {
      if (_visitDates[i].difference(_visitDates[i - 1]).inDays == 1) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: EdgeInsets.only(top: 40),
          padding: EdgeInsets.only(
            bottom: 8,
            left: 16,
            right: 16,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: kGreyColor3,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MyText(
                      text:
                          "Welcome back, ${_userData?['name'] != null ? capitalizeEachWord(_userData!['name']) : ''}",
                      size: 22.88,
                      weight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                  onTap: () => Get.to(
                        () => SetAffirmationReminder(),
                      ),
                  child: Image.asset(
                    Assets.imagesBellIconBg,
                    height: 50,
                  )),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: AppSize.DEFAULT,
            physics: BouncingScrollPhysics(),
            children: [
              MyText(
                text: 'Your Progress',
                size: 21,
                weight: FontWeight.w500,
                paddingBottom: 17,
              ),
              Container(
                padding: AppSize.DEFAULT,
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: CircularStepProgressIndicator(
                        height: 207,
                        width: 207,
                        totalSteps: 100,
                        currentStep: (100 * calculatePercentage()).toInt(),
                        startingAngle: -pi / 2,
                        selectedColor: kPrimaryColor,
                        unselectedColor: kGreyColor6,
                        roundedCap: (_, isSelected) => isSelected,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Wrap(
                              children: [
                                MyText(
                                  text: (100 * calculatePercentage())
                                      .toStringAsFixed(0),
                                  size: 51,
                                  weight: FontWeight.w500,
                                  fontFamily: GoogleFonts.roboto().fontFamily,
                                ),
                                MyText(
                                  text: '%',
                                  size: 27,
                                  weight: FontWeight.w500,
                                  fontFamily: GoogleFonts.roboto().fontFamily,
                                ),
                              ],
                            ),
                            MyText(
                              text: 'You are doing Good Keep up the Good Work',
                              size: 10.27,
                              weight: FontWeight.w500,
                              textAlign: TextAlign.center,
                              paddingTop: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    MyText(
                      text: _currentAffirmation,
                      paddingTop: 29,
                    ),
                  ],
                ),
              ),
              MyText(
                text: 'Achievements',
                size: 21,
                weight: FontWeight.w500,
                paddingTop: 29,
              ),
              Container(
                padding: AppSize.DEFAULT,
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MyText(
                      text: 'Current Streak: ${calculateStreak()} days',
                      size: 16,
                      weight: FontWeight.w500,
                      paddingTop: 8,
                    ),
                    MyText(
                      text:
                          'Longest Streak: ${_userData?['longestStreak'] ?? calculateStreak()} days',
                      size: 16,
                      weight: FontWeight.w500,
                      paddingTop: 8,
                    ),
                    // Add more achievements as needed
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
