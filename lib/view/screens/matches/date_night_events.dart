import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_fonts.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/constants/app_styling.dart';
import 'package:candid/main.dart';
import 'package:candid/view/screens/messages/video_call/video_call.dart';
import 'package:candid/view/widget/common_image_view_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DateNightEvents extends StatefulWidget {
  const DateNightEvents({super.key});

  @override
  State<DateNightEvents> createState() => _DateNightEventsState();
}

class _DateNightEventsState extends State<DateNightEvents> {
  int _currentIndex = 0;

  void _getCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> _tabs = [
      'Pending',
      'Accepted',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: AppSizes.DEFAULT,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: kPrimaryColor.withOpacity(0.4),
          ),
          child: Row(
            children: List.generate(
              _tabs.length,
              (index) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _getCurrentIndex(index),
                    child: AnimatedContainer(
                      margin: EdgeInsets.only(
                        left: index == 0 ? 0 : 4,
                        right: index == 0 ? 4 : 0,
                      ),
                      duration: Duration(
                        milliseconds: 180,
                      ),
                      height: Get.height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: _currentIndex == index
                            ? kSecondaryColor
                            : kPrimaryColor,
                        border: Border.all(
                          width: 1.0,
                          color: _currentIndex == index
                              ? kSecondaryColor
                              : kBorderColor,
                        ),
                      ),
                      child: Center(
                        child: MyText(
                          text: _tabs[index],
                          size: 14,
                          weight: FontWeight.w600,
                          color: _currentIndex == index
                              ? kPrimaryColor
                              : kTertiaryColor,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          child: _currentIndex == 0 ? _Pending() : _Accepted(),
        ),
      ],
    );
  }
}

class _Pending extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.fromLTRB(20, 0, 20, 100),
      physics: BouncingScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: kPrimaryColor,
            boxShadow: [
              AppStyling.DEFAULT_SHADOW,
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  CommonImageView(
                    height: 48,
                    width: 48,
                    radius: 6,
                    url: dummyImg,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          text: 'Melisa Thomas',
                          size: 14,
                          weight: FontWeight.w600,
                          paddingBottom: 6,
                        ),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 11,
                              color: kBlackColor,
                              fontFamily: AppFonts.URBANIST,
                            ),
                            children: [
                              TextSpan(
                                text: 'Date Night request for ',
                              ),
                              TextSpan(
                                text: 'Sat, 13 Sept',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: ' at ',
                              ),
                              TextSpan(
                                text: '12:00 pm',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  MyText(
                    text: '         ' +
                        '“Message of the next person sent you at the time of sending you the dating request” will be here.',
                    weight: FontWeight.w500,
                    lineHeight: 1.5,
                    size: 12,
                  ),
                  Positioned(
                    left: 0,
                    top: -3,
                    child: Image.asset(
                      Assets.imagesHeartCommas,
                      height: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            kSecondaryColor,
                            kPurpleColor,
                          ],
                        ),
                        border: Border.all(
                          width: 1.0,
                          color: Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(4),
                          splashColor: kPrimaryColor.withOpacity(0.1),
                          highlightColor: kPrimaryColor.withOpacity(0.1),
                          onTap: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                Assets.imagesAcceptIcon,
                                color: kPrimaryColor,
                                height: 12,
                              ),
                              MyText(
                                paddingLeft: 4,
                                paddingRight: 6,
                                size: 12,
                                weight: FontWeight.w600,
                                text: 'Accept',
                                color: kPrimaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    flex: 6,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.0,
                                color: kRedColor,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(4),
                                splashColor: kRedColor.withOpacity(0.1),
                                highlightColor: kRedColor.withOpacity(0.1),
                                onTap: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      Assets.imagesRejectIcon,
                                      color: kRedColor,
                                      height: 10,
                                    ),
                                    MyText(
                                      paddingLeft: 6,
                                      paddingRight: 6,
                                      size: 12,
                                      weight: FontWeight.w600,
                                      text: 'Reject',
                                      color: kRedColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.0,
                                color: kSecondaryColor,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(4),
                                splashColor: kSecondaryColor.withOpacity(0.1),
                                highlightColor:
                                    kSecondaryColor.withOpacity(0.1),
                                onTap: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Image.asset(
                                      Assets.imagesRescheduleIcon,
                                      color: kSecondaryColor,
                                      height: 13,
                                    ),
                                    Expanded(
                                      child: MyText(
                                        paddingLeft: 6,
                                        paddingRight: 6,
                                        size: 12,
                                        weight: FontWeight.w600,
                                        text: 'Reschedule',
                                        color: kSecondaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Accepted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.fromLTRB(20, 0, 20, 100),
      physics: BouncingScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 8),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: kPrimaryColor,
            boxShadow: [
              AppStyling.DEFAULT_SHADOW,
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Row(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              CommonImageView(
                                height: 48,
                                width: 48,
                                radius: 6,
                                url: dummyImg,
                              ),
                              Positioned(
                                top: -10,
                                right: 0,
                                child: Image.asset(
                                  Assets.imagesMatchedImageIcon,
                                  height: 8,
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                left: -8,
                                child: Image.asset(
                                  Assets.imagesMatchedImageIcon,
                                  height: 8,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              CommonImageView(
                                height: 34,
                                width: 34,
                                radius: 4,
                                url: dummyImg,
                              ),
                              Positioned(
                                top: -8,
                                right: -5,
                                child: Image.asset(
                                  Assets.imagesMatchedImageIcon,
                                  height: 8,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 15,
                        right: 0,
                        child: Center(
                          child: Image.asset(
                            Assets.imagesMatchIconNew,
                            height: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MyText(
                          text: 'Melisa Thomas & Kevin',
                          size: 14,
                          weight: FontWeight.w600,
                          paddingBottom: 6,
                        ),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 10.5,
                              color: kBlackColor,
                              fontFamily: AppFonts.URBANIST,
                            ),
                            children: [
                              TextSpan(
                                text: 'Date confirmed for ',
                              ),
                              TextSpan(
                                text: 'Sat, 13 Sept',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: ' at ',
                              ),
                              TextSpan(
                                text: '12:00 pm',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  MyText(
                    text: '         ' +
                        '“Message of the next person sent you at the time of sending you the dating request” will be here.',
                    weight: FontWeight.w500,
                    lineHeight: 1.5,
                    size: 12,
                  ),
                  Positioned(
                    left: 0,
                    top: -3,
                    child: Image.asset(
                      Assets.imagesHeartCommas,
                      height: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            kSecondaryColor,
                            kPurpleColor,
                          ],
                        ),
                        border: Border.all(
                          width: 1.0,
                          color: Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(4),
                          splashColor: kPrimaryColor.withOpacity(0.1),
                          highlightColor: kPrimaryColor.withOpacity(0.1),
                          onTap: () {
                            Get.to(() => VideoCall());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 8,
                              ),
                              Image.asset(
                                Assets.imagesVideoCamera,
                                color: kPrimaryColor,
                                height: 14,
                              ),
                              Expanded(
                                child: MyText(
                                  paddingLeft: 4,
                                  paddingRight: 4,
                                  size: 12,
                                  weight: FontWeight.w600,
                                  text: 'Join Date',
                                  color: kPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Container(
                    width: 110,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.0,
                        color: kSecondaryColor,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(4),
                        splashColor: kSecondaryColor.withOpacity(0.1),
                        highlightColor: kSecondaryColor.withOpacity(0.1),
                        onTap: () {},
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 6,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 8,
                              ),
                              Image.asset(
                                Assets.imagesRescheduleIcon,
                                color: kSecondaryColor,
                                height: 13,
                              ),
                              Expanded(
                                child: MyText(
                                  paddingLeft: 4,
                                  paddingRight: 4,
                                  size: 12,
                                  weight: FontWeight.w600,
                                  text: 'Reschedule',
                                  color: kSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Container(
                    width: 80,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.0,
                        color: kRedColor,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(4),
                        splashColor: kRedColor.withOpacity(0.1),
                        highlightColor: kRedColor.withOpacity(0.1),
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              Assets.imagesRejectIcon,
                              color: kRedColor,
                              height: 10,
                            ),
                            MyText(
                              paddingLeft: 4,
                              paddingRight: 4,
                              size: 12,
                              weight: FontWeight.w600,
                              text: 'Cancel',
                              color: kRedColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
