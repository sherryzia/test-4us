import 'package:flutter/material.dart';
import 'package:forus_app/constants/app_fonts.dart';
import 'package:forus_app/generated/assets.dart';
import 'package:forus_app/view/auth/authentication_point.dart';
import 'package:forus_app/view/widget/common_image_view_widget.dart';
import 'package:forus_app/view/widget/my_text_widget.dart';
import 'package:get/get.dart';

class UserUnderVerificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          // Navigate to AuthenticationPoint on pull to refresh
          Get.off(() => AuthenticationPoint());
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight, // Ensure full-screen height
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CommonImageView(
                        imagePath: Assets.imagesNodataHome,
                        height: 285,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: MyText(
                          text:
                              "Thank you for showing your interest to be a part of our community! Your profile is under verification so we'll notify you once it has been approved.",
                          size: 18,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
