import 'package:affirmation_app/constants/app_fonts.dart';
import 'package:affirmation_app/constants/app_images.dart';
import 'package:affirmation_app/constants/app_sizes.dart';
import 'package:affirmation_app/constants/affirmation_list.dart';
import 'package:affirmation_app/view/widget/my_text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:share_plus/share_plus.dart';
import 'package:affirmation_app/utils/affirmation_writer.dart';

class Affirmation extends StatefulWidget {
  final bool isPremium;

  const Affirmation({Key? key, required this.isPremium}) : super(key: key);

  @override
  State<Affirmation> createState() => _AffirmationState();
}

class _AffirmationState extends State<Affirmation> {
  int _currentIndex = 0;
  List<String> _favorites = [];
  late FirebaseFirestore _firestore;
  User? _user;
  bool _isInitialized = false;
  bool _isLoading = false;
  // List<String> affirmations = [];

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  void _initializeFirebase() async {
    await Firebase.initializeApp();
    setState(() {
      _firestore = FirebaseFirestore.instance;
      _user = FirebaseAuth.instance.currentUser;
      _isInitialized = true;
    });
    _fetchFavorites();
    if (widget.isPremium) {
      _loadPersonalizedAffirmations();
    } else {
      _loadDefaultAffirmations();
    }
  }

  void _loadDefaultAffirmations() {
    // Assuming affirmations is globally accessible and contains default affirmations
    setState(() {
      // This assumes affirmations are directly accessible as a global list
      affirmations = List.from(
          affirmations); // Uncomment if you have a different default list
    });
  }

  void _loadPersonalizedAffirmations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await AffirmationsWriter.generateAndUploadAffirmationsToFirebase();
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(_user!.uid)
          .collection('affirmations')
          .doc('affirmations_csv')
          .get();

      if (doc.exists) {
        if (!mounted) return; // Add this check before calling setState
        setState(() {
          String csvData = (doc.data() as Map<String, dynamic>)['csv_data'];
          affirmations = csvData.split(',').map((e) => e.trim()).toList();
        });
      } else {
        print('No affirmations found for the user');
      }
    } catch (e) {
      print('Failed to load affirmations from Firestore: $e');
    } finally {
      if (!mounted) return; // Add this check before calling setState
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _getCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _toggleFavorite(int index) {
    if (!_isInitialized) return;

    String affirmation = affirmations[index];

    setState(() {
      if (_favorites.contains(affirmation)) {
        _favorites.remove(affirmation);
      } else {
        _favorites.add(affirmation);
      }
    });

    if (_favorites.contains(affirmation)) {
      _firestore
          .collection('users')
          .doc(_user!.uid)
          .collection(
              widget.isPremium ? 'personalized_favorite' : 'likedAffirmations')
          .doc(affirmation)
          .set({'affirmation': affirmation}).then((value) {
        print('Affirmation saved successfully: $affirmation');
      }).catchError((error) {
        print('Failed to save affirmation: $error');
      });
    } else {
      _firestore
          .collection('users')
          .doc(_user!.uid)
          .collection(
              widget.isPremium ? 'personalized_favorite' : 'likedAffirmations')
          .doc(affirmation)
          .delete()
          .then((value) {
        print('Affirmation deleted successfully: $affirmation');
      }).catchError((error) {
        print('Failed to delete affirmation: $error');
      });
    }

    _updateFavorites();
  }

  void _updateFavorites() async {
    if (!_isInitialized) return;

    try {
      await _firestore
          .collection('favoriteAffirmations')
          .doc(_user!.uid)
          .set({'favorites': _favorites});
      print('Favorites updated successfully');
    } catch (e) {
      print('Error updating favorites: $e');
    }
  }

  void _fetchFavorites() async {
    if (!_isInitialized) return;

    try {
      DocumentSnapshot doc = await _firestore
          .collection('favoriteAffirmations')
          .doc(_user!.uid)
          .get();
      if (doc.exists) {
        if (!mounted) return; // Add this check before calling setState
        setState(() {
          var data = doc.data();
          if (data != null) {
            _favorites = List<String>.from(
                (data as Map<String, dynamic>)['favorites'] as List<dynamic>);
          } else {
            print('No favorites found for the user');
          }
        });
      }
      print('Favorites fetched successfully');
    } catch (e) {
      print('Error fetching favorites: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              MyText(text: "Please wait while we fetch affirmations...")
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            itemCount: affirmations.length,
            onPageChanged: _getCurrentIndex,
            scrollDirection: Axis.vertical,
            itemBuilder: (ctx, index) {
              return Center(
                child: MyText(
                  text: affirmations[index],
                  size: 41,
                  weight: FontWeight.w700,
                  textAlign: TextAlign.center,
                  fontFamily: AppFonts.GEORGIA,
                ),
              );
            },
          ),
          Positioned(
            top: 40,
            width: Get.width,
            child: Padding(
              padding: AppSize.HORIZONTAL,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    Assets.imagesArrowBackWhite,
                    height: 50,
                  ),
                  Wrap(
                    spacing: 10,
                    children: [
                      GestureDetector(
                        onTap: () => _toggleFavorite(_currentIndex),
                        child: Icon(
                          _favorites.contains(affirmations[_currentIndex])
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                      // Image.asset(
                      //   Assets.imagesDownload,
                      //   height: 50,
                      // ),
                      GestureDetector(
                        onTap: () {
                          try {
                            Share.share(affirmations[_currentIndex]);
                          } catch (e) {
                            print('Share error: $e');
                          }
                        },
                        child: Image.asset(
                          Assets.imagesShare,
                          height: 50,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_currentIndex == 0)
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: MyText(
                text: 'SCROLL UP',
                weight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
