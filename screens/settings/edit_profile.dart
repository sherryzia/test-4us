import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_images.dart';
import 'package:restaurant_finder/constants/app_sizes.dart';
import 'package:restaurant_finder/controller/edit_profile_controller.dart';
import 'package:restaurant_finder/main.dart';
import 'package:restaurant_finder/view/widget/common_image_view_widget.dart';
import 'package:restaurant_finder/view/widget/custom_app_bar_widget.dart';
import 'package:restaurant_finder/view/widget/my_button_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_field_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';
import 'package:restaurant_finder/controller/theme_controller.dart';

class EditProfile extends StatelessWidget {
  final EditProfileController controller = Get.put(EditProfileController());

  EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    
    return Obx(() {
      final isDark = themeController.isDarkMode;
      
      return Scaffold(
        backgroundColor: isDark ? kBlackColor : Colors.white,
        appBar: simpleAppBar(title: 'editProfile'.tr),
        body: Obx(() => controller.isLoading.value 
          ? Center(child: CircularProgressIndicator(color: kSecondaryColor))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Error message
                Obx(() => controller.errorMessage.value.isNotEmpty
                  ? Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.red.shade100,
                      child: Text(
                        controller.errorMessage.value,
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  : SizedBox.shrink()
                ),
                
                // Success message
                Obx(() => controller.successMessage.value.isNotEmpty
                  ? Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.green.shade100,
                      child: Text(
                        controller.successMessage.value,
                        style: TextStyle(color: Colors.green),
                      ),
                    )
                  : SizedBox.shrink()
                ),
                
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    padding: AppSizes.DEFAULT,
                    physics: BouncingScrollPhysics(),
                    children: [
                      _Heading(
                        title: 'avatar'.tr,
                        isDark: isDark,
                      ),
                      GestureDetector(
                        onTap: () => controller.pickImage(),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: 1.0,
                              color: kBorderColor,
                            ),
                            color: isDark ? kDialogBlack : Colors.white,
                          ),
                          child: Row(
                            children: [
                              Obx(() => controller.selectedImage.value != null
                                // Show selected image if available
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.file(
                                      controller.selectedImage.value!,
                                      height: 54,
                                      width: 54,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                // Otherwise show current image or placeholder
                                : CommonImageView(
                                    height: 54,
                                    width: 54,
                                    radius: 100.0,
                                    url: controller.currentImageUrl.value.isNotEmpty
                                      ? controller.currentImageUrl.value
                                      : dummyImg,
                                  ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      children: [
                                        MyText(
                                          text: 'browse'.tr + ' ',
                                          size: 16,
                                          color: kSecondaryColor,
                                          weight: FontWeight.bold,
                                        ),
                                        MyText(
                                          text: 'yourProfilePicture'.tr,
                                          color: isDark ? kDarkTextColor : null,
                                        ),
                                      ],
                                    ),
                                    MyText(
                                      paddingTop: 8,
                                      text: 'jpegsOrPngsOnly'.tr,
                                      size: 14,
                                      color: isDark ? kDarkTextColor : kGreyColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      _Heading(
                        title: 'personalInformation'.tr,
                        isDark: isDark,
                      ),
                      SizedBox(height: 16),
                      MyTextField(
                        controller: controller.nameController,
                        labelText: 'fullName'.tr,
                        hintText: 'enterYourFullName'.tr,
                      ),
                      MyTextField(
                        controller: controller.emailController,
                        labelText: 'emailAddress'.tr,
                        hintText: 'enterYourEmail'.tr,
                        isReadOnly: true, // Email cannot be changed
                      ),
                      MyTextField(
                        controller: controller.passwordController,
                        labelText: 'newPasswordOptional'.tr,
                        hintText: 'leaveBlankToKeepCurrent'.tr,
                        isObSecure: true,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: AppSizes.DEFAULT,
                  child: Obx(() => MyButton(
                    buttonText: controller.isLoading.value ? 'updating'.tr : 'update'.tr,
                    onTap: controller.isLoading.value ? (){} : controller.updateProfile,
                  )),
                ),
              ],
            ),
        ),
      );
    });
  }
}

class _Heading extends StatelessWidget {
  const _Heading({required this.title, this.isDark = false});
  final String title;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Image.asset(Assets.imagesHeading, height: 24, color: kSecondaryColor),
          MyText(
            paddingLeft: 10,
            text: title,
            size: 16,
            weight: FontWeight.w600,
            color: isDark ? kTertiaryColor : null,
          ),
        ],
      ),
    );
  }
}