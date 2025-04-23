import 'package:flutter/material.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_images.dart';
import 'package:restaurant_finder/constants/app_sizes.dart';
import 'package:restaurant_finder/main.dart';
import 'package:restaurant_finder/view/widget/common_image_view_widget.dart';
import 'package:restaurant_finder/view/widget/custom_app_bar_widget.dart';
import 'package:restaurant_finder/view/widget/my_button_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_field_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Edit Profile',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: AppSizes.DEFAULT,
              physics: BouncingScrollPhysics(),
              children: [
                _Heading(
                  title: 'Avatar',
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      width: 1.0,
                      color: kBorderColor,
                    ),
                  ),
                  child: Row(
                    children: [
                      CommonImageView(
                        height: 54,
                        width: 54,
                        radius: 100.0,
                        url: dummyImg,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                MyText(
                                  text: 'Browse ',
                                  size: 16,
                                  color: kSecondaryColor,
                                  weight: FontWeight.bold,
                                ),
                                MyText(
                                  text: 'your profile picture',
                                ),
                              ],
                            ),
                            MyText(
                              paddingTop: 8,
                              text: 'JPEGs or PNGs only',
                              size: 14,
                              color: kGreyColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                _Heading(
                  title: 'Personal Information',
                ),
                SizedBox(
                  height: 16,
                ),
                MyTextField(
                  labelText: 'Full Name',
                  hintText: 'Leaon John',
                ),
                MyTextField(
                  labelText: 'Email Address',
                  hintText: 'leaonjohn@gmail.com',
                ),
                MyTextField(
                  labelText: 'Password',
                  hintText: '****************',
                ),
              ],
            ),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: MyButton(
              buttonText: 'Update',
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading({
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Image.asset(
            Assets.imagesHeading,
            height: 24,
            color: kSecondaryColor,
          ),
          MyText(
            paddingLeft: 10,
            text: title,
            size: 16,
            weight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
