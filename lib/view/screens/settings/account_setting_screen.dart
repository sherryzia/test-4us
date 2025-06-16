// lib/view/screens/settings/account_setting_screen.dart

import 'dart:io';

import 'package:betting_app/constants/app_sizes.dart';
import 'package:betting_app/controllers/global_controller.dart';
import 'package:betting_app/view/widgets/common_image_view_widget.dart';
import 'package:betting_app/view/widgets/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants/app_colors.dart';
import '../../../generated/assets.dart';
import '../../widgets/simple_app_bar.dart';

class AccountSettingScreen extends StatelessWidget {
  const AccountSettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use UserController instead of individual controllers
    final UserController userController = Get.find<UserController>();
    
    // Controllers for form inputs
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    
    return Scaffold(
      appBar: SimpleAppBar(
        title: "Account",
      ),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: ShapeDecoration(
                  color: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 20,
                      offset: Offset(0, 0),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    // Profile Image Section - Reactive
                    Obx(() => Stack(
                      children: [
                        // Profile Image
                        userController.hasProfileImage
                          ? CommonImageView(
                              url: userController.profileImageUrl.value,
                              height: 100,
                              radius: 50,
                            )
                          : Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: kSecondaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: MyText(
                                  text: userController.initials,
                                  size: 32,
                                  weight: FontWeight.bold,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                        
                        // Edit Button
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => _showImagePicker(context, userController),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: ShapeDecoration(
                                color: kBlackColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Center(
                                child: CommonImageView(
                                  svgPath: Assets.svgEditIcon,
                                  height: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                    
                    const SizedBox(height: 40),
                    
                    // Username Section - Reactive
                    Obx(() => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: MyText(
                        text: "Username",
                        size: 14,
                        weight: FontWeight.w500,
                      ),
                      subtitle: MyText(
                        text: userController.fullName.value.isNotEmpty 
                            ? userController.fullName.value 
                            : "Not set",
                        size: 17,
                        weight: FontWeight.w400,
                        color: kBlackColor,
                      ),
                      trailing: GestureDetector(
                        onTap: () => _showEditNameDialog(
                          context, 
                          userController,
                          firstNameController,
                          lastNameController,
                        ),
                        child: RichText(
                          text: const TextSpan(
                            text: "Edit",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: kQuaternaryColor,
                              decoration: TextDecoration.underline,
                              decorationColor: kQuaternaryColor,
                            ),
                          ),
                        ),
                      ),
                    )),
                    
                    // Phone Number Section - Reactive
                    Obx(() => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: MyText(
                        text: "Phone Number",
                        size: 14,
                        weight: FontWeight.w500,
                      ),
                      subtitle: MyText(
                        text: userController.phone.value.isNotEmpty
                            ? userController.phone.value
                            : "Not set",
                        size: 17,
                        weight: FontWeight.w400,
                        color: kBlackColor,
                      ),
                      trailing: GestureDetector(
                        onTap: () => _showEditPhoneDialog(
                          context, 
                          userController,
                          phoneController,
                        ),
                        child: RichText(
                          text: const TextSpan(
                            text: "Edit",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: kQuaternaryColor,
                              decoration: TextDecoration.underline,
                              decorationColor: kQuaternaryColor,
                            ),
                          ),
                        ),
                      ),
                    )),
                    
                    // Email Section - Reactive
                    Obx(() => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: MyText(
                        text: "Email",
                        size: 14,
                        weight: FontWeight.w500,
                      ),
                      subtitle: MyText(
                        text: userController.email.value.isNotEmpty
                            ? userController.email.value
                            : "Not set",
                        size: 17,
                        weight: FontWeight.w400,
                        color: kBlackColor,
                      ),
                      trailing: GestureDetector(
                        onTap: () => _showEditEmailDialog(
                          context, 
                          userController,
                          emailController,
                        ),
                        child: RichText(
                          text: const TextSpan(
                            text: "Edit",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: kQuaternaryColor,
                              decoration: TextDecoration.underline,
                              decorationColor: kQuaternaryColor,
                            ),
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
              
              // Rest of your UI (Data History, Delete Account, etc.)
              const SizedBox(height: 10),
              
              // Data History section (same as before)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: ShapeDecoration(
                  color: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 20,
                      offset: Offset(0, 0),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: "Data History",
                      size: 17,
                      weight: FontWeight.w500,
                      color: kBlackColor,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.snackbar(
                          'Info',
                          'Data restoration feature coming soon',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      child: RichText(
                        text: const TextSpan(
                          text: "Restore",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: kQuaternaryColor,
                            decoration: TextDecoration.underline,
                            decorationColor: kQuaternaryColor,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Helper methods for dialogs
  void _showImagePicker(BuildContext context, UserController userController) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    await userController.updateProfile(profileImage: File(image.path));
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    await userController.updateProfile(profileImage: File(image.path));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
  
  void _showEditNameDialog(
    BuildContext context, 
    UserController userController,
    TextEditingController firstNameController,
    TextEditingController lastNameController,
  ) {
    // Pre-fill controllers with current values
    firstNameController.text = userController.firstName;
    lastNameController.text = userController.lastName;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Name'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            Obx(() => userController.isLoading.value
              ? const CircularProgressIndicator()
              : TextButton(
                  onPressed: () async {
                    final success = await userController.updateProfile(
                      firstName: firstNameController.text.trim(),
                      lastName: lastNameController.text.trim(),
                    );
                    if (success) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Save'),
                )
            ),
          ],
        );
      },
    );
  }
  
  void _showEditPhoneDialog(
    BuildContext context, 
    UserController userController,
    TextEditingController phoneController,
  ) {
    phoneController.text = userController.phone.value;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Phone Number'),
          content: TextField(
            controller: phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            Obx(() => userController.isLoading.value
              ? const CircularProgressIndicator()
              : TextButton(
                  onPressed: () async {
                    final success = await userController.updateProfile(
                      newPhone: phoneController.text.trim(),
                    );
                    if (success) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Save'),
                )
            ),
          ],
        );
      },
    );
  }
  
  void _showEditEmailDialog(
    BuildContext context, 
    UserController userController,
    TextEditingController emailController,
  ) {
    emailController.text = userController.email.value;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Email'),
          content: TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            Obx(() => userController.isLoading.value
              ? const CircularProgressIndicator()
              : TextButton(
                  onPressed: () async {
                    final success = await userController.updateProfile(
                      newEmail: emailController.text.trim(),
                    );
                    if (success) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Save'),
                )
            ),
          ],
        );
      },
    );
  }
}