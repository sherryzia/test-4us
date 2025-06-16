// lib/view/screens/settings/setting_screen.dart

import 'package:betting_app/constants/app_sizes.dart';
import 'package:betting_app/controllers/auth_controller.dart';
import 'package:betting_app/controllers/ticket_controller.dart';
import 'package:betting_app/services/auth_service.dart';
import 'package:betting_app/view/screens/history/history_screen.dart';
import 'package:betting_app/view/screens/launch/get_started_screen.dart';
import 'package:betting_app/view/screens/settings/account_setting_screen.dart';
import 'package:betting_app/view/widgets/common_image_view_widget.dart';
import 'package:betting_app/view/widgets/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../generated/assets.dart';
import '../../widgets/simple_app_bar.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final TicketController ticketController = Get.find<TicketController>();
    
    return Scaffold(
      appBar: SimpleAppBar(
        showLeading: false,
        title: "Settings",
      ),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: Column(
          children: [
            // User profile section with reactive updates
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
                children: [
                  // Profile image from user data or default
                  Obx(() {
                    final userData = Get.find<AuthService>().user.value;
                    return userData['profile_image'] != null
                      ? CommonImageView(
                          url: userData['profile_image'],
                          height: 55,
                          radius: 27.5,
                        )
                      : CommonImageView(
                          imagePath: Assets.imagesProfile,
                          height: 55,
                        );
                  }),
                  const SizedBox(width: 15),
                  // Username from user data
                  Obx(() {
                    final userData = Get.find<AuthService>().user.value;
                    final fullName = "${userData['first_name'] ?? ''} ${userData['last_name'] ?? ''}";
                    return MyText(
                      text: fullName.trim().isNotEmpty ? fullName : "User",
                      size: 17,
                      weight: FontWeight.w500,
                      color: kBlackColor,
                    );
                  }),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Get.to(() => const AccountSettingScreen());
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 5, left: 6, right: 10, bottom: 5),
                      decoration: ShapeDecoration(
                        color: kQuaternaryLightColor,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1, color: kQuaternaryColor),
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: Row(
                        children: [
                          CommonImageView(svgPath: Assets.svgEdit),
                          const SizedBox(width: 8),
                          MyText(
                            text: "Edit",
                            size: 10,
                            weight: FontWeight.w500,
                            color: kQuaternaryColor,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.topLeft,
              child: MyText(
                text: "Settings",
                size: 15,
                weight: FontWeight.w500,
                color: kTertiaryColor,
              ),
            ),
            const SizedBox(height: 20),
            // Clear History button with confirmation dialog
            buildClearHistoryButton(
              text: 'Clear History',
              onTap: () {
                // Show confirmation dialog
                Get.dialog(
                  AlertDialog(
                    title: const Text('Clear History'),
                    content: const Text('Are you sure you want to clear your betting history? This action cannot be undone.'),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back(); // Close dialog
                          ticketController.clearHistory(); // Call clear history method
                        },
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                );
              },
            ),
            buildClearHistoryButton(
              text: 'Purchase',
              onTap: () {
                Get.to(() => const GetStartedScreen());
              },
            ),
            buildClearHistoryButton(
              text: 'Remove Ads',
              onTap: () {
                Get.to(() => const GetStartedScreen());
              },
            ),
            const SizedBox(height: 50),
            // Logout button with confirmation dialog
            GestureDetector(
              onTap: () {
                // Show confirmation dialog
                Get.dialog(
                  AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back(); // Close dialog
                          authController.logout(); // Call logout method
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: ShapeDecoration(
                    color: kSecondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 20,
                        offset: Offset(0, 0),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.logout, color: kPrimaryColor),
                      const SizedBox(width: 10),
                      MyText(
                        text: "Log Out",
                        size: 17,
                        weight: FontWeight.w500,
                        color: kPrimaryColor,
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward, color: kPrimaryColor),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildClearHistoryButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Container(
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
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(
                text: text,
                size: 17,
                weight: FontWeight.w500,
                color: kBlackColor,
              ),
              const Icon(Icons.arrow_forward, color: kSecondaryColor),
            ],
          ),
        ),
      ),
    );
  }
}