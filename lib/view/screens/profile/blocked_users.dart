import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/main.dart';
import 'package:candid/view/widget/common_image_view_widget.dart';
import 'package:candid/view/widget/custom_scaffold_widget.dart';
import 'package:candid/view/widget/my_button_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:candid/view/widget/simple_app_bar_widget.dart';
import 'package:flutter/material.dart';


class BlockedUsers extends StatelessWidget {
  const BlockedUsers({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SimpleAppBar(
            title: 'Blocked Users',
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              padding: AppSizes.DEFAULT,
              physics: BouncingScrollPhysics(),
              itemCount: 10,
              itemBuilder: (context, index) {
                return _LinksTile(
                  image: dummyImg,
                  onTap: () {},
                  title: 'Kadin Schleifer',
                );
              },
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
    required this.image,
  });
  final String image;
  final String title;

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
            CommonImageView(
              height: 40,
              width: 40,
              radius: 100.0,
              url: image,
            ),
            Expanded(
              child: MyText(
                paddingLeft: 12,
                text: title,
                size: 14,
                weight: FontWeight.w500,
              ),
            ),
            Image.asset(
              Assets.imagesBlocked,
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}
