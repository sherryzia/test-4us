import 'dart:io';
import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/controller/edit_profile_controller.dart';
import 'package:candid/main.dart';
import 'package:candid/view/screens/profile/preferences/adventure_chill_zone.dart';
import 'package:candid/view/screens/profile/preferences/ambition_alley.dart';
import 'package:candid/view/screens/profile/preferences/heartbeats_playlists.dart';
import 'package:candid/view/screens/profile/preferences/highlight_reels.dart';
import 'package:candid/view/screens/profile/preferences/life_style_lowdown.dart';
import 'package:candid/view/screens/profile/preferences/mind_soul.dart';
import 'package:candid/view/widget/common_image_view_widget.dart';
import 'package:candid/view/widget/custom_scaffold_widget.dart';
import 'package:candid/view/widget/my_button_widget.dart';
import 'package:candid/view/widget/my_text_field_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:candid/view/widget/simple_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the EditProfileController
    final editController = Get.put(EditProfileController());

    return Scaffold(
      body: CustomScaffold(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SimpleAppBar(
              title: 'Edit Profile',
              actions: [
                // Add reset button if there are changes
                Obx(() => editController.hasChanges.value
                    ? TextButton(
                        onPressed: editController.resetForm,
                        child: Text(
                          'Reset',
                          style: TextStyle(color: kPrimaryColor),
                        ),
                      )
                    : SizedBox.shrink()),
              ],
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: AppSizes.DEFAULT,
                physics: BouncingScrollPhysics(),
                children: [
                  // Profile Image Section
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Stack(
                          children: [
                            Obx(() {
                              // Show selected image, current profile picture, or default
                              if (editController.selectedImage.value != null) {
                                return Container(
                                  height: 103,
                                  width: 103,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: FileImage(editController.selectedImage.value!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              } else {
                                return CommonImageView(
                                  height: 103,
                                  width: 103,
                                  radius: 100.0,
                                  url: editController.currentProfilePicture.value.isNotEmpty
                                      ? editController.currentProfilePicture.value
                                      : dummyImg,
                                  fit: BoxFit.cover,
                                );
                              }
                            }),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: editController.showImagePickerOptions,
                                child: Container(
                                  height: 32,
                                  width: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: kPrimaryColor,
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0, 4),
                                        blurRadius: 12,
                                        color: kBlackColor.withOpacity(0.05),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      Assets.imagesEditPhoto,
                                      height: 18,
                                      color: kSecondaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Image.asset(
                            Assets.imagesAvatarStars,
                            height: 110,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  
                  // Edit Details Section
                  _Heading(title: 'Edit details'),
                  
                  SimpleTextField(
                    controller: editController.nameController,
                    labelText: 'Name',
                    hintText: 'Enter your name',
                  ),
                  
                  SimpleTextField(
                    controller: editController.emailController,
                    labelText: 'Email Address',
                    hintText: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  
                  Obx(() => SimpleTextField(
                    controller: editController.passwordController,
                    labelText: 'Password',
                    hintText: 'Enter new password (optional)',
                    isObscure: !editController.isPasswordVisible.value,
                    suffixIcon: GestureDetector(
                      onTap: editController.togglePasswordVisibility,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            editController.isPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 18,
                            color: kSecondaryColor,
                          ),
                        ],
                      ),
                    ),
                  )),
                  
                  SimpleTextField(
                    controller: editController.taglineController,
                    labelText: 'Tagline',
                    hintText: 'Enter your tagline',
                  ),
                  
                  SimpleTextField(
                    controller: editController.locationController,
                    labelText: 'Add Location',
                    hintText: 'Enter your location',
                    suffixIcon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          Assets.imagesLocationPin,
                          height: 18,
                        ),
                      ],
                    ),
                  ),
                  
                  SimpleTextField(
                    controller: editController.aboutMeController,
                    maxLines: 4,
                    labelText: 'About Me',
                    hintText: 'Tell us about yourself',
                    marginBottom: 20,
                  ),
                  
                  // Preferences Section
                  _Heading(title: 'Preferences'),
                  
                  _ProfileTile(
                    icon: Assets.imagesHighLightReel,
                    title: 'Highlight Reel',
                    onTap: () {
                      Get.bottomSheet(
                        HighlightReels(),
                        isScrollControlled: true,
                      );
                    },
                  ),
                  _Divider(),
                  
                  _ProfileTile(
                    icon: Assets.imagesLifeStyleLowDown,
                    title: 'Lifestyle Lowdown',
                    onTap: () {
                      Get.bottomSheet(
                        LifeStyleLowdown(),
                        isScrollControlled: true,
                      );
                    },
                  ),
                  _Divider(),
                  
                  _ProfileTile(
                    icon: Assets.imagesAdventureIcon,
                    title: 'Adventure & Chill Zone',
                    onTap: () {
                      Get.bottomSheet(
                        AdventureChillZone(),
                        isScrollControlled: true,
                      );
                    },
                  ),
                  _Divider(),
                  
                  _ProfileTile(
                    icon: Assets.imagesAmbition,
                    title: 'Ambition Alley',
                    onTap: () {
                      Get.bottomSheet(
                        AmbitionAlley(),
                        isScrollControlled: true,
                      );
                    },
                  ),
                  _Divider(),
                  
                  _ProfileTile(
                    icon: Assets.imagesHeartBeats,
                    title: 'Heartbeats & Playlists',
                    onTap: () {
                      Get.bottomSheet(
                        HeartbeatsPlaylists(),
                        isScrollControlled: true,
                      );
                    },
                  ),
                  _Divider(),
                  
                  _ProfileTile(
                    icon: Assets.imagesMindIcon,
                    title: 'Mind & Soul Matters',
                    onTap: () {
                      Get.bottomSheet(
                        MindSoul(),
                        isScrollControlled: true,
                      );
                    },
                  ),
                ],
              ),
            ),
            
            // Update Button
            Padding(
              padding: AppSizes.DEFAULT,
              child: Obx(() => MyButton(
                buttonText: editController.isLoading.value ? 'Updating...' : 'Update',
                onTap: editController.isLoading.value ? (){} : editController.updateProfile,
                // Change button color based on whether there are changes
                bgColor: editController.hasChanges.value ? kSecondaryColor : Colors.grey,
              )),
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      height: 1,
      color: kBorderColor,
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });
  
  final String icon, title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            Image.asset(
              icon,
              height: 18,
              width: 18,
            ),
            Expanded(
              child: MyText(
                paddingLeft: 8,
                text: title,
                size: 12,
                weight: FontWeight.w500,
              ),
            ),
            Image.asset(
              Assets.imagesArrowNextIos,
              height: 12,
            )
          ],
        ),
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading({required this.title});
  
  final String title;

  @override
  Widget build(BuildContext context) {
    return MyText(
      text: title,
      size: 16,
      paddingBottom: 16,
      weight: FontWeight.w600,
    );
  }
}