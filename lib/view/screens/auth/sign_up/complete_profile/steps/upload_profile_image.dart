import 'dart:io';
import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/utils/global_instances.dart';
import 'package:candid/view/widget/my_button_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';

class UploadProfileImage extends StatefulWidget {
  const UploadProfileImage({super.key});

  @override
  State<UploadProfileImage> createState() => _UploadProfileImageState();
}

class _UploadProfileImageState extends State<UploadProfileImage> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _showImageSourceDialog() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            child: Wrap(
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      MyText(
                        text: 'Select Image Source',
                        size: 18,
                        weight: FontWeight.w600,
                        color: kBlackColor,
                        paddingBottom: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage(ImageSource.camera);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                decoration: BoxDecoration(
                                  color: kSecondaryColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.camera_alt,
                                      size: 40,
                                      color: kPrimaryColor,
                                    ),
                                    SizedBox(height: 8),
                                    MyText(
                                      text: 'Camera',
                                      size: 14,
                                      weight: FontWeight.w500,
                                      color: kPrimaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage(ImageSource.gallery);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                decoration: BoxDecoration(
                                  color: kSecondaryColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.photo_library,
                                      size: 40,
                                      color: kPrimaryColor,
                                    ),
                                    SizedBox(height: 8),
                                    MyText(
                                      text: 'Gallery',
                                      size: 14,
                                      weight: FontWeight.w500,
                                      color: kPrimaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      MyButton(
                        buttonText: 'Cancel',
                        bgColor: Colors.grey[300],
                        textColor: kBlackColor,
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80, // Compress image to 80% quality
        maxWidth: 1024, // Limit width to 1024 pixels
        maxHeight: 1024, // Limit height to 1024 pixels
      );

      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        
        // Update ProfileController with selected image
        profileController.setProfileImage(imageFile);
        
        Get.snackbar(
          'Success',
          'Profile image selected successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
        
        print('Image selected: ${pickedFile.path}');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      padding: AppSizes.DEFAULT,
      children: [
        SizedBox(height: 40),
        Center(
          child: GestureDetector(
            onTap: _showImageSourceDialog,
            child: Stack(
              children: [
                Obx(() => Container(
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kPrimaryColor,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 10,
                        color: kBlackColor.withOpacity(0.1),
                      ),
                    ],
                    image: profileController.profileImage.value != null
                        ? DecorationImage(
                            image: FileImage(profileController.profileImage.value!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: profileController.profileImage.value == null
                      ? Center(
                          child: Image.asset(
                            Assets.imagesAvatar,
                            height: 120,
                            color: Color(0xff999999).withOpacity(0.7),
                          ),
                        )
                      : null,
                )),
                Positioned(
                  bottom: 0,
                  right: 5,
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 10,
                          color: kBlackColor.withOpacity(0.1),
                        ),
                      ],
                      shape: BoxShape.circle,
                      color: kSecondaryColor,
                    ),
                    child: Center(
                      child: Image.asset(
                        Assets.imagesEditPhoto,
                        height: 24,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 40),
        // Upload section
        Obx(() => profileController.profileImage.value == null
            ? DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(12),
                color: kSecondaryColor,
                dashPattern: [6, 6],
                strokeWidth: 2,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 48,
                        color: kSecondaryColor,
                      ),
                      SizedBox(height: 16),
                      MyText(
                        text: 'Upload Profile Picture',
                        size: 16,
                        color: kSecondaryColor,
                        weight: FontWeight.w600,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      MyText(
                        text:
                            'Take a picture or upload a profile picture to showcase your best self.',
                        size: 12,
                        color: kBlackColor.withOpacity(0.7),
                        textAlign: TextAlign.center,
                        lineHeight: 1.4,
                      ),
                      SizedBox(height: 20),
                      MyButton(
                        height: 42,
                        buttonText: 'Choose Image',
                        onTap: _showImageSourceDialog,
                      ),
                    ],
                  ),
                ),
              )
            : Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: kSecondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kSecondaryColor, width: 1),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 48,
                      color: kSecondaryColor,
                    ),
                    SizedBox(height: 16),
                    MyText(
                      text: 'Profile Image Selected!',
                      size: 16,
                      color: kSecondaryColor,
                      weight: FontWeight.w600,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    MyText(
                      text: 'Tap on the image above to change it.',
                      size: 12,
                      color: kBlackColor.withOpacity(0.7),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    MyButton(
                      height: 42,
                      buttonText: 'Change Image',
                      bgColor: Colors.transparent,
                      textColor: kSecondaryColor,
                      borderColor: kSecondaryColor,
                      onTap: _showImageSourceDialog,
                    ),
                  ],
                ),
              )),
        SizedBox(height: 20),
        // Debug info (remove in production)
        Obx(() => profileController.profileImage.value != null
            ? Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Selected: ${profileController.profileImage.value!.path.split('/').last}',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              )
            : SizedBox()),
      ],
    );
  }
}