// lib/view/screens/settings/account_setting_screen.dart

import 'package:betting_app/constants/app_sizes.dart';
import 'package:betting_app/controllers/account_controller.dart';
import 'package:betting_app/view/widgets/common_image_view_widget.dart';
import 'package:betting_app/view/widgets/my_button.dart';
import 'package:betting_app/view/widgets/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants/app_colors.dart';
import '../../../generated/assets.dart';
import '../../../services/auth_service.dart';
import '../../widgets/simple_app_bar.dart';

class AccountSettingScreen extends StatelessWidget {
  const AccountSettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get account controller
    final AccountController controller = Get.find<AccountController>();
    // Get auth service for user data
    final AuthService authService = Get.find<AuthService>();
    
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
                    // Profile Image with Edit Button
                    Obx(() {
                      final userData = authService.user.value;
                      return Stack(
                        children: [
                          // Profile Image
                          if (controller.profileImage.value != null)
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: FileImage(controller.profileImage.value!),
                            )
                          else if (userData['profile_image'] != null)
                            CommonImageView(
                              url: userData['profile_image'],
                              height: 100,
                              radius: 50,
                            )
                          else
                            CommonImageView(
                              imagePath: Assets.imagesProfile,
                              height: 100,
                            ),
                          
                          // Edit Button
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
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
                                            onTap: () {
                                              Navigator.pop(context);
                                              controller.pickImage(ImageSource.camera);
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.photo_library),
                                            title: const Text('Choose from gallery'),
                                            onTap: () {
                                              Navigator.pop(context);
                                              controller.pickImage(ImageSource.gallery);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
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
                      );
                    }),
                    
                    // Update image button if new image is selected
                    Obx(() => controller.profileImage.value != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Obx(() => controller.isLoading.value
                            ? const CircularProgressIndicator()
                            : MyButton(
                                onTap: controller.updateProfileImage,
                                buttonText: "Update Profile Picture",
                                backgroundColor: kQuaternaryColor,
                                fontSize: 14,
                                height: 36,
                              )
                          ),
                        )
                      : const SizedBox(height: 40)
                    ),
                    
                    // Username section
                    Obx(() {
                      final userData = authService.user.value;
                      final fullName = "${userData['first_name'] ?? ''} ${userData['last_name'] ?? ''}";
                      
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: MyText(
                          text: "Username",
                          size: 14,
                          weight: FontWeight.w500,
                        ),
                        subtitle: MyText(
                          text: fullName.trim().isNotEmpty ? fullName : "Not set",
                          size: 17,
                          weight: FontWeight.w400,
                          color: kBlackColor,
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            _showEditNameDialog(context, controller);
                          },
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
                        )
                      );
                    }),
                    
                    // Phone number section
                    Obx(() {
                      final userData = authService.user.value;
                      
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: MyText(
                          text: "Phone Number",
                          size: 14,
                          weight: FontWeight.w500,
                        ),
                        subtitle: MyText(
                          text: userData['phone'] ?? "Not set",
                          size: 17,
                          weight: FontWeight.w400,
                          color: kBlackColor,
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            _showEditPhoneDialog(context, controller);
                          },
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
                      );
                    }),
                    
                    // Email section
                    Obx(() {
                      final userData = authService.user.value;
                      
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: MyText(
                          text: "Email",
                          size: 14,
                          weight: FontWeight.w500,
                        ),
                        subtitle: MyText(
                          text: userData['email'] ?? "Not set",
                          size: 17,
                          weight: FontWeight.w400,
                          color: kBlackColor,
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            _showEditEmailDialog(context, controller);
                          },
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
                      );
                    }),
                  ],
                ),
              ),
              
              const SizedBox(height: 10),
              
              // Data History section
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
                        // Handle restore functionality
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
              
              const SizedBox(height: 50),
              
              // Delete Account button
              GestureDetector(
                onTap: () {
                  _showDeleteAccountDialog(context, controller);
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: ShapeDecoration(
                    color: kSecondaryLightColor,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1, color: kSecondaryColor),
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
                        text: "Delete Account",
                        size: 17,
                        weight: FontWeight.w500,
                        color: kSecondaryColor,
                      ),
                      const Icon(Icons.arrow_forward, color: kSecondaryColor)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Edit name dialog
  void _showEditNameDialog(BuildContext context, AccountController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Name'),
          content: Form(
            key: controller.editNameFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: controller.firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => controller.validateRequired(value, 'First name'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller.lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => controller.validateRequired(value, 'Last name'),
                ),
                
                // Display validation errors if any
                Obx(() => controller.validationErrors.isNotEmpty
                  ? Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: kSecondaryLightColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: kSecondaryColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: controller.validationErrors.entries.map((entry) => 
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              "• ${entry.value}",
                              style: const TextStyle(
                                color: kSecondaryColor,
                                fontSize: 12,
                              ),
                            ),
                          )
                        ).toList(),
                      ),
                    )
                  : const SizedBox.shrink()
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            Obx(() => controller.isLoading.value
              ? const CircularProgressIndicator()
              : TextButton(
                  onPressed: controller.updateName,
                  child: const Text('Save'),
                )
            ),
          ],
        );
      },
    );
  }
  
  // Edit phone dialog
  void _showEditPhoneDialog(BuildContext context, AccountController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Phone Number'),
          content: Form(
            key: controller.editPhoneFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: controller.phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: controller.validatePhone,
                ),
                
                // Display validation errors if any
                Obx(() => controller.validationErrors.isNotEmpty
                  ? Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: kSecondaryLightColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: kSecondaryColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: controller.validationErrors.entries.map((entry) => 
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              "• ${entry.value}",
                              style: const TextStyle(
                                color: kSecondaryColor,
                                fontSize: 12,
                              ),
                            ),
                          )
                        ).toList(),
                      ),
                    )
                  : const SizedBox.shrink()
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            Obx(() => controller.isLoading.value
              ? const CircularProgressIndicator()
              : TextButton(
                  onPressed: controller.updatePhone,
                  child: const Text('Save'),
                )
            ),
          ],
        );
      },
    );
  }
  
  // Edit email dialog
  void _showEditEmailDialog(BuildContext context, AccountController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Email'),
          content: Form(
            key: controller.editEmailFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: controller.emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: controller.validateEmail,
                ),
                
                // Display validation errors if any
                Obx(() => controller.validationErrors.isNotEmpty
                  ? Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: kSecondaryLightColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: kSecondaryColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: controller.validationErrors.entries.map((entry) => 
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              "• ${entry.value}",
                              style: const TextStyle(
                                color: kSecondaryColor,
                                fontSize: 12,
                              ),
                            ),
                          )
                        ).toList(),
                      ),
                    )
                  : const SizedBox.shrink()
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            Obx(() => controller.isLoading.value
              ? const CircularProgressIndicator()
              : TextButton(
                  onPressed: controller.updateEmail,
                  child: const Text('Save'),
                )
            ),
          ],
        );
      },
    );
  }
  
  // Delete account dialog
  void _showDeleteAccountDialog(BuildContext context, AccountController controller) {
    // Reset password field
    controller.passwordController.clear();
    controller.validationErrors.clear();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: Form(
            key: controller.deleteAccountFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'This action cannot be undone. To confirm deletion, please enter your password:',
                  style: TextStyle(
                    color: kTertiaryColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() => TextFormField(
                  controller: controller.passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscurePassword.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                        color: kTertiaryColor,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  ),
                  obscureText: controller.obscurePassword.value,
                  validator: controller.validatePassword,
                )),
                
                // Display validation errors if any
                Obx(() => controller.validationErrors.isNotEmpty
                  ? Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: kSecondaryLightColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: kSecondaryColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: controller.validationErrors.entries.map((entry) => 
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              "• ${entry.value}",
                              style: const TextStyle(
                                color: kSecondaryColor,
                                fontSize: 12,
                              ),
                            ),
                          )
                        ).toList(),
                      ),
                    )
                  : const SizedBox.shrink()
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            Obx(() => controller.isLoading.value
              ? const CircularProgressIndicator()
              : TextButton(
                  onPressed: () {
                    // Show additional confirmation dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Deletion'),
                          content: const Text(
                            'Are you absolutely sure you want to delete your account? This action cannot be undone.',
                            style: TextStyle(
                              color: kSecondaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close confirmation dialog
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close confirmation dialog
                                controller.deleteAccount(); // Proceed with deletion
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: kSecondaryColor,
                              ),
                              child: const Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: kSecondaryColor,
                  ),
                  child: const Text('Delete'),
                )
            ),
          ],
        );
      },
    );
  }
}