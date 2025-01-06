// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/constants/app_sizes.dart';
import 'package:forus_app/generated/assets.dart';
import 'package:forus_app/view/widget/common_image_view_widget.dart';
import 'package:forus_app/view/widget/my_text_widget.dart';

class EventAboutUsScreen extends StatefulWidget {
  const EventAboutUsScreen({super.key});

  @override
  State<EventAboutUsScreen> createState() => _EventAboutUsScreenState();
}

class _EventAboutUsScreenState extends State<EventAboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemeColors.getTertiary(context),
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: CommonImageView(
              imagePath: Assets.imagesArrowLeft,
              height: 24,
            ),
          ),
        ),
        title: MyText(
          text: "About US",
          size: 18,
          weight: FontWeight.w700,
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: AppSizes.DEFAULT2,
        children: [
          MyText(
            text:
                "lorem ipsum dolor sit amet, consectetur adipiscing elit. eget lectus neque nisl, ornare. aliquet egestas leo, iaculis venenatis, elit in lectus lobortis. Nulla turpis sed commodo posuere viverra velit quam nisi, tristique. Netus lorem pulvinar justo congue luctus erat tristique eget. Arcu turpis et vitae nibh amet sollicitudin seis sed commodo posuere viverra velit quam nisi, tristique. Netus lorem pulvinar justo congue luctus er Netus lorem pulvinar justo congue luctus.",
            size: 18,
            weight: FontWeight.w500,
            paddingBottom: 10,
              color: kTextGrey4,
          ),
          MyText(
            text:
                "lorem ipsum dolor sit amet, consectetur adipiscing elit. eget lectus neque nisl, ornare. aliquet egestas leo, iaculis venenatis, elit in lectus lobortis. Nulla turpis sed commodo posuere viverra velit quam nisi, tristique. Netus lorem pulvinar justo congue luctus erat tristique eget. Arcu turpis et vitae nibh amet sollicitudin seis sed commodo posuere viverra velit quam nisi, tristique. Netus lorem pulvinar justo congue luctus er Netus lorem pulvinar justo congue luctus.",
            size: 18,
              color: kTextGrey4,
            weight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
