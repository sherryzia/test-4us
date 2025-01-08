import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:swim_strive/constants/app_colors.dart';
import 'package:swim_strive/constants/app_urls.dart';
import 'package:swim_strive/main.dart';
import 'package:swim_strive/controller/CompleteProfileController.dart';
import 'package:swim_strive/controller/AuthController.dart';

class EditAccountController extends GetxController {
  final CompleteProfileController completeProfileController = Get.find<CompleteProfileController>();
  final AuthController authController = Get.find<AuthController>();

  File? selectedImage;
  bool isUploading = false;
  String? imageUrl;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final dobController = TextEditingController();
  final zipCodeController = TextEditingController();

  String? selectedPronouns;
  final List<String> pronounsList = ['He/Him', 'She/Her', 'They/Them'];

  @override
  void onInit() {
    super.onInit();
    initializeFields();
  }

  void initializeFields() {
    firstNameController.text = completeProfileController.firstName.value;
    lastNameController.text = completeProfileController.lastName.value;
    emailController.text = completeProfileController.email.value;
    phoneNumberController.text = completeProfileController.phoneNumber.value;
    dobController.text = completeProfileController.dob.value;
    zipCodeController.text = completeProfileController.zipCode.value;
    selectedPronouns = completeProfileController.pronouns.value.isEmpty
        ? null
        : completeProfileController.pronouns.value;
    imageUrl = "${completeProfileController.dpUrl}";
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      selectedImage = File(image.path);
      update();
    }
  }

  Future<void> updateProfile() async {
  isUploading = true;
  update();

  final userId = authController.uid.value;
  final Map<String, dynamic> updatedData = {};

  try {
    // Update basic fields
    if (firstNameController.text.isNotEmpty) {
      updatedData['first_name'] = firstNameController.text;
    }
    if (lastNameController.text.isNotEmpty) {
      updatedData['last_name'] = lastNameController.text;
    }
    if (emailController.text.isNotEmpty) {
      updatedData['email'] = emailController.text;
    }
    if (phoneNumberController.text.isNotEmpty) {
      updatedData['phone_number'] = phoneNumberController.text;
    }
    if (dobController.text.isNotEmpty) {
      updatedData['dob'] = DateFormat('yyyy-MM-dd').parse(dobController.text).toIso8601String();
    }
    if (selectedPronouns != null) {
      updatedData['pronouns'] = selectedPronouns;
    }
    if (zipCodeController.text.isNotEmpty) {
      updatedData['zipcode'] = zipCodeController.text;
    }

    // Handle profile picture
    if (selectedImage != null) {
      final fileName = "${userId}_profile.jpg";

      // Delete old profile picture
      await supabase.storage.from('profiles').remove([fileName]);

      // Upload new profile picture
      await supabase.storage.from('profiles').upload(fileName, selectedImage!);

      // Get public URL for the new profile picture
      final imageUrlResponse = supabase.storage.from('profiles').getPublicUrl(fileName);
      imageUrl = imageUrlResponse;

      // Add profile_picture column update
      updatedData['profile_picture'] = imageUrl;

      // Update local controller
      completeProfileController.dpUrl.value = imageUrl!;
      Get.snackbar("Success", "Profile photo updated successfully.");
    }

    // Update user data in the database
    if (updatedData.isNotEmpty) {
      await supabase.from('users').update(updatedData).eq('id', userId);
      Get.snackbar("Success", "Profile updated successfully.");

      // Update local controller fields
      if (updatedData.containsKey('first_name')) {
        completeProfileController.firstName.value = updatedData['first_name'];
      }
      if (updatedData.containsKey('last_name')) {
        completeProfileController.lastName.value = updatedData['last_name'];
      }
      if (updatedData.containsKey('email')) {
        completeProfileController.email.value = updatedData['email'];
      }
      if (updatedData.containsKey('phone_number')) {
        completeProfileController.phoneNumber.value = updatedData['phone_number'];
      }
      if (updatedData.containsKey('dob')) {
        completeProfileController.dob.value = updatedData['dob'];
      }
      if (updatedData.containsKey('pronouns')) {
        completeProfileController.pronouns.value = updatedData['pronouns'];
      }
      if (updatedData.containsKey('zipcode')) {
        completeProfileController.zipCode.value = updatedData['zipcode'];
      }
    }
  } catch (e) {
    Get.snackbar("Error", "An error occurred while updating the profile.");
    print("Error updating profile: $e");
  } finally {
    isUploading = false;
    update();
  }
}


  void showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}