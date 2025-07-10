import 'dart:ui';
import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/main.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class MatchCard extends StatelessWidget {
  const MatchCard({
    super.key,
    required this.isCrushed,
    required this.index,
    required this.isOnline,
    required this.isAway,
    required this.isLocked,
  });
  final bool isCrushed;
  final bool isOnline;
  final bool isAway;
  final bool isLocked;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 4),
                blurRadius: 12,
                color: kBlackColor.withOpacity(0.3),
              )
            ],
            border: GradientBoxBorder(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  isCrushed ? kSecondaryColor : kPrimaryColor,
                  isCrushed ? kPurpleColor : kPrimaryColor,
                ],
              ),
              width: 2.0,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(index.isEven ? 20 : 4),
              bottomLeft: Radius.circular(index.isEven ? 20 : 4),
              topRight: Radius.circular(index.isEven ? 4 : 20),
              bottomRight: Radius.circular(index.isEven ? 4 : 20),
            ),
            image: DecorationImage(
              image: NetworkImage(dummyImg),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (isLocked)
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 8,
                        sigmaY: 8,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.16),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            width: 0.5,
                            color: kPrimaryColor,
                          ),
                        ),
                        child: Center(
                          child: Image.asset(
                            Assets.imagesLocked,
                            height: 26,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              SizedBox(
                height: 5,
              ),
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: kBlackColor.withOpacity(0.27),
                      borderRadius: BorderRadius.circular(12),
                      border: GradientBoxBorder(
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            kSecondaryColor,
                            kPurpleColor,
                          ],
                        ),
                        width: 1.5,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 8,
                          sigmaY: 8,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: kBlackColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: kPrimaryColor,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              MyText(
                                text: 'Kevin James, 28',
                                size: 13,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                color: kPrimaryColor,
                                paddingBottom: 4,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    Assets.imagesLocationPin,
                                    height: 12,
                                  ),
                                  MyText(
                                    paddingBottom: 0.5,
                                    paddingLeft: 3,
                                    paddingRight: 3,
                                    text: 'Dallas, Texas',
                                    size: 10,
                                    color: kPrimaryColor.withOpacity(0.6),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        color: isOnline
                            ? kOnlineColor
                            : isAway
                                ? kRecentOnlineColor
                                : kOfflineColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 0.7,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (isCrushed)
          Positioned(
            top: 8,
            right: -5,
            child: Image.asset(
              Assets.imagesCrushedImage,
              height: 32,
            ),
          ),
      ],
    );
  }
}
