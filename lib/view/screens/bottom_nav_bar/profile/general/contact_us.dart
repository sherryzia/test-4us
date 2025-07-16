import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:affirmation_app/constants/app_colors.dart';
import 'package:affirmation_app/constants/app_images.dart';
import 'package:affirmation_app/view/widget/simple_app_bar_widget.dart';
import 'package:flutter/material.dart';

class contactUsScreen extends StatefulWidget {
  @override
  _contactUsScreenState createState() => _contactUsScreenState();
}

class _contactUsScreenState extends State<contactUsScreen> {
  String? _fetchedString;

  @override
  void initState() {
    super.initState();
    _fetchStringFromFirestore();
  }

  Future<void> _fetchStringFromFirestore() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('contactUs')
          .doc('contactUs')
          .get();

      if (snapshot.exists) {
        setState(() {
          _fetchedString = snapshot['message'];
        });
      } else {
        setState(() {
          _fetchedString = 'No data available';
        });
      }
    } catch (e) {
      setState(() {
        _fetchedString = 'Error fetching data: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.imagesBgImage),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 8,
            sigmaY: 8,
          ),
          child: Container(
            color: kBlackColor.withOpacity(0.75),
            child: Column(
              children: [
                SimpleAppBar(
                  title: 'Contact Us',
                  haveLeading: true,
                ),
                Expanded(
                  child: Center(
                    child: _fetchedString == null
                        ? CircularProgressIndicator()
                        : Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              _fetchedString!,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
