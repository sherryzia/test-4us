// profile_photo.dart

import 'dart:io';
import 'package:affirmation_app/main.dart';
import 'package:affirmation_app/view/widget/common_image_view_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePhoto extends StatefulWidget {
  final String? profileImageUrl;
  final void Function(String) onProfileImageUpdated;

  ProfilePhoto({
    Key? key,
    required this.profileImageUrl,
    required this.onProfileImageUpdated,
  }) : super(key: key);

  @override
  _ProfilePhotoState createState() => _ProfilePhotoState();
}

class _ProfilePhotoState extends State<ProfilePhoto> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      try {
        String fileName = 'profile_images/${_user!.uid}.png';
        TaskSnapshot uploadTask =
            await _storage.ref().child(fileName).putFile(file);
        String downloadUrl = await uploadTask.ref.getDownloadURL();
        await _firestore
            .collection('userData')
            .doc(_user!.uid)
            .update({'profileImageUrl': downloadUrl});
        widget.onProfileImageUpdated(downloadUrl);
        Get.snackbar(
          'Success',
          'Profile image updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to update profile image: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          CommonImageView(
            url: widget.profileImageUrl ?? dummyImg,
            height: 160,
            width: 160,
            radius: 80,
            placeHolder: 'assets/images/google.png',
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.white,
                size: 30,
              ),
              onPressed: _pickImage,
            ),
          ),
        ],
      ),
    );
  }
}
