import 'dart:ui';

import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_fonts.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/view/screens/home/premium_filters/premium_filters.dart';
import 'package:candid/view/widget/custom_drop_down_widget.dart';
import 'package:candid/view/widget/custom_slider_thumb_widget.dart';
import 'package:candid/view/widget/custom_slider_tool_tip.dart';
import 'package:candid/view/widget/my_button_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:get/get.dart';

class Filter extends StatefulWidget {
  const Filter({super.key});

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  double _lowerDistance = 0;

  double _maxDistance = 40;

  double _lowerAge = 19;

  double _maxAge = 65;
  GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 10,
            sigmaY: 10,
          ),
          child: Container(
            height: Get.height * 0.9,
            padding: AppSizes.DEFAULT,
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: 'Filter',
                      size: 20,
                      color: kPrimaryColor,
                      weight: FontWeight.bold,
                    ),
                    MyText(
                      text: 'Clear',
                      size: 16,
                      color: kSecondaryColor,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    padding: AppSizes.VERTICAL,
                    physics: BouncingScrollPhysics(),
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            height: 1.5,
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: kPrimaryColor.withOpacity(.9),
                            fontFamily: AppFonts.URBANIST,
                          ),
                          children: [
                            TextSpan(text: 'Try '),
                            TextSpan(
                              text: 'Premium Filters',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: kSecondaryColor,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Scrollable.ensureVisible(
                                    _key.currentContext!,
                                    curve: Curves.bounceIn,
                                    duration: Duration(
                                      milliseconds: 300,
                                    ),
                                  );
                                },
                            ),
                            TextSpan(
                              text:
                                  ' to highlight your ideal matches while keeping everyone in view.',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      MyText(
                        text: 'Interested In',
                        size: 16,
                        color: kPrimaryColor,
                        weight: FontWeight.w600,
                        paddingBottom: 8,
                      ),
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          children: List.generate(
                            3,
                            (index) {
                              final List<String> _items = [
                                'Men',
                                'Women',
                                'Both',
                              ];
                              return Expanded(
                                child: Container(
                                  height: Get.height,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    gradient: index == 0
                                        ? LinearGradient(
                                            begin: Alignment.bottomLeft,
                                            end: Alignment.topRight,
                                            colors: [
                                              kSecondaryColor,
                                              kPurpleColor,
                                            ],
                                          )
                                        : LinearGradient(
                                            begin: Alignment.bottomLeft,
                                            end: Alignment.topRight,
                                            colors: [
                                              kPrimaryColor,
                                              kPrimaryColor,
                                            ],
                                          ),
                                  ),
                                  child: Center(
                                    child: MyText(
                                      size: 16,
                                      weight: FontWeight.w500,
                                      color: index == 0
                                          ? kPrimaryColor
                                          : kTertiaryColor,
                                      text: _items[index],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomDropDown(
                        labelSize: 16,
                        labelColor: kPrimaryColor,
                        radius: 50.0,
                        labelText: 'Location',
                        hint: 'Chicago, USA',
                        items: [
                          'Chicago, USA',
                        ],
                        onChanged: (v) {},
                        selectedValue: 'Chicago, USA',
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: MyText(
                              text: 'Distance',
                              size: 16,
                              color: kPrimaryColor,
                              weight: FontWeight.w600,
                            ),
                          ),
                          MyText(
                            text: '${_lowerDistance.toInt()} miles',
                            color: kSecondaryColor,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      FlutterSlider(
                        values: [_lowerDistance, _maxDistance],
                        rangeSlider: false,
                        min: 0,
                        max: 100,
                        tooltip: CustomSliderToolTip(),
                        // handlerWidth: Get.width * 0.03,
                        handlerHeight: 18,
                        handler: FlutterSliderHandler(
                          decoration: BoxDecoration(),
                          child: CustomSliderThumb(),
                        ),
                        rightHandler: FlutterSliderHandler(
                          decoration: BoxDecoration(),
                          child: CustomSliderThumb(),
                        ),
                        trackBar: FlutterSliderTrackBar(
                          activeTrackBarHeight: 7,
                          inactiveTrackBarHeight: 7,
                          activeTrackBar: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [
                                kSecondaryColor,
                                kPurpleColor,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          inactiveTrackBar: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onDragging: (handlerIndex, lowerValue, upperValue) {
                          setState(() {
                            _lowerDistance = lowerValue;
                            _maxDistance = upperValue;
                          });
                        },
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     MyText(
                      //       size: 10,
                      //       color: kPrimaryColor,
                      //       weight: FontWeight.w600,
                      //       text: '0 km',
                      //     ),
                      //     MyText(
                      //       size: 10,
                      //       color: kPrimaryColor,
                      //       weight: FontWeight.w600,
                      //       text: '100 km',
                      //     ),
                      //   ],
                      // ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: MyText(
                              text:
                                  'See people slightly further away if I run out',
                              size: 12,
                              color: kPrimaryColor,
                            ),
                          ),
                          Transform.scale(
                            scale: 0.65,
                            alignment: Alignment.centerRight,
                            child: CupertinoSwitch(
                              activeColor: kSecondaryColor,
                              value: true,
                              onChanged: (v) {},
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          MyText(
                            text: 'Age',
                            size: 16,
                            color: kPrimaryColor,
                            weight: FontWeight.w600,
                            paddingBottom: 5,
                          ),
                          MyText(
                            text: ' (18 Onwards)',
                            size: 12,
                            color: kPrimaryColor,
                            paddingBottom: 5,
                          ),
                          Spacer(),
                          MyText(
                            text:
                                '${_maxAge >= 65 ? '65+' : '${_maxAge.toInt()}'}',
                            color: kSecondaryColor,
                          ),
                        ],
                      ),
                      FlutterSlider(
                        values: [_lowerAge, _maxAge],
                        rangeSlider: true,
                        min: 18,
                        max: 65,
                        tooltip: CustomSliderToolTip(),
                        // handlerWidth: Get.width * 0.03,
                        handlerHeight: 18,
                        handler: FlutterSliderHandler(
                          decoration: BoxDecoration(),
                          child: CustomSliderThumb(),
                        ),
                        rightHandler: FlutterSliderHandler(
                          decoration: BoxDecoration(),
                          child: CustomSliderThumb(),
                        ),
                        trackBar: FlutterSliderTrackBar(
                          activeTrackBarHeight: 7,
                          inactiveTrackBarHeight: 7,
                          activeTrackBar: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [
                                kSecondaryColor,
                                kPurpleColor,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          inactiveTrackBar: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onDragging: (handlerIndex, lowerValue, upperValue) {
                          setState(() {
                            _lowerAge = lowerValue;
                            _maxAge = upperValue;
                          });
                        },
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: MyText(
                              text:
                                  'See people 2 years either side if i run out',
                              size: 12,
                              color: kPrimaryColor,
                            ),
                          ),
                          Transform.scale(
                            scale: 0.65,
                            alignment: Alignment.centerRight,
                            child: CupertinoSwitch(
                              activeColor: kSecondaryColor,
                              value: true,
                              onChanged: (v) {},
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                        key: _key,
                      ),
                      MyText(
                        text: 'Premium Filters',
                        size: 16,
                        color: kPrimaryColor,
                        weight: FontWeight.w600,
                        paddingBottom: 8,
                      ),
                      PremiumFilters(),
                    ],
                  ),
                ),
                MyButton(
                  buttonText: 'Apply',
                  onTap: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
