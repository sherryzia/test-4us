// personal_details.dart

import 'dart:ui';
import 'package:affirmation_app/constants/app_colors.dart';
import 'package:affirmation_app/constants/app_sizes.dart';
import 'package:affirmation_app/utils/profile_photo.dart';
import 'package:affirmation_app/view/widget/my_textfield_widget.dart';
import 'package:affirmation_app/view/widget/simple_app_bar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({Key? key}) : super(key: key);

  @override
  _PersonalDetailsState createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  Map<String, dynamic>? _userData;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      DocumentSnapshot snapshot =
          await _firestore.collection('userData').doc(_user!.uid).get();
      setState(() {
        _userData = snapshot.data() as Map<String, dynamic>?;
        if (_userData != null) {
          nameController.text = _userData!['name'] ?? '';
          emailController.text = _user!.email ?? '';
          phoneController.text = _userData!['mobileNumber'] ?? '';
          addressController.text = _userData!['address'] ?? '';
          _profileImageUrl = _userData!['profileImageUrl'];
          print('Profile Image URL: $_profileImageUrl'); // Debug print
        }
      });
    }
  }

  void _updateProfileImage(String url) {
    setState(() {
      _profileImageUrl = url;
    });
  }

  String capitalizeEachWord(String input) {
    if (input.isEmpty) return input;
    return input.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: CustomBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SimpleAppBar(
              title: 'Personal Details',
              haveLeading: true,
            ),
            Expanded(
              child: ListView(
                padding: AppSize.DEFAULT,
                physics: BouncingScrollPhysics(),
                children: [
                  SizedBox(height: 20),
                  ProfilePhoto(
                    profileImageUrl: _profileImageUrl,
                    onProfileImageUpdated: _updateProfileImage,
                  ),
                  SizedBox(height: 20),
                  buildSection(
                    title: 'Name',
                    child: buildEditableTextField(
                      controller: nameController,
                      hintText: _userData?['name'] != null
                          ? capitalizeEachWord(_userData!['name'])
                          : '',
                      fieldName: 'name',
                    ),
                  ),
                  buildSection(
                    title: 'Email',
                    child: buildEditableTextField(
                      controller: emailController,
                      hintText: _user!.email ?? '',
                      fieldName: 'email',
                    ),
                  ),
                  buildSection(
                    title: 'Mobile Number',
                    child: buildEditableTextField(
                      controller: phoneController,
                      hintText: _userData?['mobileNumber'] != null
                          ? capitalizeEachWord(_userData!['mobileNumber'])
                          : '',
                      fieldName: 'mobileNumber',
                    ),
                  ),
                  buildSection(
                    title: 'Address',
                    child: buildEditableTextField(
                      controller: addressController,
                      hintText: _userData?['address'] != null
                          ? capitalizeEachWord(_userData!['address'])
                          : '',
                      maxLines: 3,
                      fieldName: 'address',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSection({required String title, required Widget child}) {
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
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget buildEditableTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    required String fieldName,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                _showEditDialog(controller, fieldName);
              },
              child: MyTextField(
                hintText: hintText,
                controller: controller,
                isEnabled: false,
                maxLines: maxLines,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              _showEditDialog(controller, fieldName);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showEditDialog(
      TextEditingController controller, String fieldName) async {
    String initialValue = controller.text;
    TextEditingController dialogController =
        TextEditingController(text: initialValue);

    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              const Color.fromARGB(255, 149, 149, 149).withOpacity(0.4),
          title: Text(
            'Edit $fieldName',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: dialogController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter new $fieldName',
              hintStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () async {
                String newValue = dialogController.text.trim();
                if (newValue.isNotEmpty) {
                  try {
                    await _firestore
                        .collection('userData')
                        .doc(_user!.uid)
                        .update({fieldName: newValue});

                    setState(() {
                      controller.text = newValue;
                      _userData![fieldName] = newValue;
                    });
                    Navigator.pop(context);

                    Get.snackbar(
                      'Success',
                      'Updated $fieldName successfully',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  } catch (e) {
                    Get.snackbar(
                      'Error',
                      'Failed to update $fieldName: $e',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                } else {
                  Get.snackbar(
                    'Error',
                    'Please enter a valid $fieldName',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }
}

class CustomBackground extends StatelessWidget {
  final Widget child;

  const CustomBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg_image.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 8,
          sigmaY: 8,
        ),
        child: Container(
          color: Colors.black.withOpacity(0.75),
          child: child,
        ),
      ),
    );
  }
}
