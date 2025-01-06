import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/constants/app_fonts.dart';
import 'package:forus_app/constants/app_sizes.dart';
import 'package:forus_app/controllers/auth/SignUpController.dart';
import 'package:forus_app/generated/assets.dart';
import 'package:forus_app/view/auth/login_screen.dart';
import 'package:forus_app/view/widget/common_image_view_widget.dart';
import 'package:forus_app/view/widget/my_button_widget.dart';
import 'package:forus_app/view/widget/my_text_widget.dart';
import 'package:forus_app/view/widget/my_text_field.dart';

class SignUpScreen extends StatelessWidget {
  final SignUpController controller = Get.put(SignUpController());

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemeColors.getTertiary(context),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: AppThemeColors.getTertiary(context),
      body: Obx(
        () => ListView(
          padding: AppSizes.DEFAULT,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyText(
                  text: 'Sign Up',
                  size: 24,
                  paddingTop: 20,
                  fontFamily: AppFonts.NUNITO_SANS,
                  weight: FontWeight.w800,
                ),
                MyText(
                  text: 'Enter your credentials to continue',
                  size: 16,
                  paddingTop: 5,
                  color: kTextGrey,
                  fontFamily: AppFonts.NUNITO_SANS,
                  weight: FontWeight.w500,
                ),
                Gap(20),
                MyTextField(
                  controller: controller.fullNameController,
                  hint: 'Full name',
                  labelColor: kBlack,
                  hintColor: kTextGrey,
                  radius: 8,
                  suffix: Padding(
                    padding: const EdgeInsets.all(12),
                    child: CommonImageView(
                      imagePath: Assets.imagesPersongrey,
                      height: 22,
                    ),
                  ),
                  filledColor: kTransperentColor,
                  kBorderColor: kBorderGrey,
                  kFocusBorderColor: KColor1,
                ),
                Gap(16),
                MyTextField(
                  controller: controller.emailController,
                  hint: 'Email address',
                  hintColor: kTextGrey,
                  labelColor: kBlack,
                  radius: 8,
                  suffix: Padding(
                    padding: const EdgeInsets.all(12),
                    child: CommonImageView(
                      imagePath: Assets.imagesGreyemail,
                      height: 22,
                    ),
                  ),
                  filledColor: kTransperentColor,
                  kBorderColor: kBorderGrey,
                  kFocusBorderColor: KColor1,
                ),
                Gap(16),

                Obx(() => SizedBox(
      height: 48, // Adjust height as needed
      child: DropdownButtonFormField<String>(
        value: controller.selectedUserType.value,
        items: [
          DropdownMenuItem(
            value: 'customer',
            child: Text('Customer'),
          ),
          DropdownMenuItem(
            value: 'eventOrganizer',
            child: Text('Event Organizer'),
          ),
          DropdownMenuItem(
            value: 'serviceProvider',
            child: Text('Service Provider'),
          ),
        ],
        onChanged: (value) {
          if (value != null) {
            controller.selectedUserType.value = value;
          }
        },
        decoration: InputDecoration(
          labelText: 'User Type',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Adjust padding
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0), // Optional: same as above
            borderSide: BorderSide(
              color: kswtich, // Color for enabled state
              width: 1.0,
            ),
          ),
        ),
        dropdownColor: Colors.white, // Set dropdown background color if needed
        alignment: Alignment.bottomLeft, // Aligns dropdown menu properly
      ),
    )),

                Gap(16),

                Container(
  margin: EdgeInsets.only(bottom: 16),
  padding: EdgeInsets.symmetric(horizontal: 12),
  decoration: BoxDecoration(
    border: Border.all(color: kBorderGrey),
    borderRadius: BorderRadius.circular(12),
  ),
  child: Row(
    children: [
      GestureDetector(
        onTap: () {
          showCountryPicker(
            context: context,
            showPhoneCode: true,
            onSelect: (Country country) {
              controller.selectedCountryCode.value = '+${country.phoneCode}';
            },
          );
        },
        child: Obx(
          () => Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            // decoration: BoxDecoration(
            //   border: Border.all(color: kBorderGrey),
            //   borderRadius: BorderRadius.circular(12),
            // ),
            child: Row(
              children: [
                Text(
                  controller.selectedCountryCode.value,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: AppFonts.NUNITO_SANS,
                    color: kTextGrey,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(Icons.keyboard_arrow_down_outlined, color: kBlack),
              ],
            ),
          ),
        ),
      ),
      const Gap(10),
      Expanded(
        child: TextField(
          controller: controller.phoneNumberController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Phone number',
            hintStyle: TextStyle(
              fontSize: 14,
              fontFamily: AppFonts.NUNITO_SANS,
              color: kTextGrey,
            ),
          ),
        ),
      ),
      CommonImageView(
        imagePath: Assets.imagesCall,
        height: 22,
      ),
    ],
  ),
),
                Gap(16),
                MyTextField(
                  controller: controller.passwordController,
                  hint: 'Password',
                  hintColor: kTextGrey,
                  labelColor: kBlack,
                  radius: 8,
                  isObSecure:
                      controller.isPasswordHidden.value, // Toggle visibility
                  suffix: Obx(() => IconButton(
                        icon: Icon(
                          controller.isPasswordHidden.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: kTextGrey,
                        ),
                        onPressed: () {
                          controller.isPasswordHidden.value =
                              !controller.isPasswordHidden.value;
                        },
                      )),
                  filledColor: kTransperentColor,
                  kBorderColor: kBorderGrey,
                  kFocusBorderColor: KColor1,
                ),
                Gap(16),
                MyTextField(
                  controller: controller.confirmPasswordController,
                  hint: 'Confirm password',
                  hintColor: kTextGrey,
                  labelColor: kWhite,
                  radius: 8,
                  isObSecure: controller
                      .isConfirmPasswordHidden.value, // Toggle visibility
                  suffix: Obx(() => IconButton(
                        icon: Icon(
                          controller.isConfirmPasswordHidden.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: kTextGrey,
                        ),
                        onPressed: () {
                          controller.isConfirmPasswordHidden.value =
                              !controller.isConfirmPasswordHidden.value;
                        },
                      )),
                  filledColor: kTransperentColor,
                  kBorderColor: kBorderGrey,
                  kFocusBorderColor: KColor1,
                ),
                Gap(25),
                MyButton(
                  buttonText:
                      controller.isLoading.value ? "Signing Up..." : "Sign Up",
                  radius: 14,
                  textSize: 18,
                  weight: FontWeight.w800,
                  onTap: controller.isLoading.value
                      ? () {} // No-op function to handle the disabled state
                      : () {
                          controller.signUp(); // Call your async method here
                        },
                ),
                Gap(25),
                InkWell(
                  onTap: () {
                    // Navigate to login screen
                    Get.to(() => LoginScreen());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(
                        text: 'Already have an account?',
                        size: 16,
                        color: kTextGrey,
                        fontFamily: AppFonts.NUNITO_SANS,
                        weight: FontWeight.w600,
                      ),
                      MyText(
                        text: ' Login',
                        size: 16,
                        color: kTextOrange,
                        fontFamily: AppFonts.NUNITO_SANS,
                        weight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
