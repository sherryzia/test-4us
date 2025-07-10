import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/view/widget/custom_scaffold_widget.dart';
import 'package:candid/view/widget/my_button_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:candid/view/widget/simple_app_bar_widget.dart';
import 'package:flutter/material.dart';

class SocialLinks extends StatelessWidget {
  const SocialLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SimpleAppBar(
            title: 'Social Links',
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: AppSizes.DEFAULT,
              physics: BouncingScrollPhysics(),
              children: [
                _LinksTile(
                  icon: Assets.imagesFacebookLink,
                  onTap: () {},
                  title: 'Facebook',
                  userName: 'Zaire Torff',
                ),
                _LinksTile(
                  icon: Assets.imagesInstagramLink,
                  onTap: () {},
                  title: 'Instagram',
                  userName: '@Zaire Torff',
                ),
                _LinksTile(
                  icon: Assets.imagesTwitter,
                  onTap: () {},
                  title: 'Twitter',
                  userName: '@Zaire Torff',
                ),
              ],
            ),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: MyButton(
              buttonText: 'Save',
              weight: FontWeight.w500,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _LinksTile extends StatelessWidget {
  const _LinksTile({
    required this.title,
    required this.onTap,
    required this.icon,
    required this.userName,
  });
  final String icon;
  final String title;
  final String userName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: kPrimaryColor,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 20,
              color: Color(0xff515151).withOpacity(0.05),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(
              icon,
              height: 24,
              width: 24,
            ),
            Expanded(
              child: MyText(
                paddingLeft: 7,
                text: title,
                size: 14,
              ),
            ),
            MyText(
              text: userName,
              size: 12,
              color: kBlackColor2,
            ),
          ],
        ),
      ),
    );
  }
}
