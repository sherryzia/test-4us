import 'package:affirmation_app/constants/app_colors.dart';
import 'package:affirmation_app/constants/app_sizes.dart';
import 'package:affirmation_app/main.dart';
import 'package:affirmation_app/view/widget/common_image_view_widget.dart';
import 'package:affirmation_app/view/widget/my_text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({Key? key}) : super(key: key);

  @override
  _HomeScreenViewState createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  User? _user;
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('userData')
          .doc(_user!.uid)
          .get();

      if (mounted) {
        setState(() {
          _userData = snapshot.data() as Map<String, dynamic>?;
          _isLoading = false;
          _profileImageUrl = _userData?['profileImageUrl'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _userData == null
              ? Center(
                  child: MyText(
                      text: 'No data found', size: 18, color: Colors.white))
              : Padding(
                  padding: AppSize.DEFAULT,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 60),
                      MyText(
                        text: 'Welcome, ${_userData!['name']}',
                        size: 24,
                        color: Colors.white,
                        weight: FontWeight.bold,
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: CommonImageView(
                          height: 160,
                          width: 160,
                          url: _profileImageUrl ??
                              dummyImg, // Replace with actual user image URL if available
                          radius:
                              80, // Ensure radius is half of the size for a circular image
                        ),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          physics: BouncingScrollPhysics(),
                          children: [
                            _buildInfoTile('Age Group', _userData!['ageGroup']),
                            _buildInfoTile(
                                'Occupation', _userData!['selectedOccupation']),
                            _buildInfoTile(
                                'Current Income', _userData!['currentIncome']),
                            _buildInfoTile('Desired Occupation',
                                _userData!['selectedDesiredOccupation']),
                            _buildInfoTile(
                                'Desired Income', _userData!['desiredIncome']),
                            _buildInfoTile(
                                'Debt Amount', _userData!['debtAmount']),
                            _buildInfoTile(
                                'Debt Type', _userData!['selectedDebtType']),
                            _buildInfoTile(
                                'Mobile Number', _userData!['mobileNumber']),
                            _buildInfoTile('Address', _userData!['address']),
                            _buildInfoTile('Savings Goals', _userData!['goal']),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kGreyColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            text: title,
            size: 16,
            color: Colors.white70,
            weight: FontWeight.w600,
          ),
          SizedBox(height: 8),
          MyText(
            text: value,
            size: 18,
            color: Colors.white,
            weight: FontWeight.w400,
          ),
        ],
      ),
    );
  }
}
