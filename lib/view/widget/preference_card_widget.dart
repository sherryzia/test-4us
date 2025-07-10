import 'dart:ui';

import 'package:candid/constants/app_colors.dart';
import 'package:candid/view/widget/custom_check_box_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class PreferenceCard extends StatelessWidget {
  const PreferenceCard({
    super.key,
    required this.title,
    required this.items,
    required this.onSelect,
    required this.selectedValue,
    this.isOnFilter = false,
  });
  final String title;
  final List<String> items;
  final String selectedValue;
  final VoidCallback onSelect;
  final bool? isOnFilter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 30,
            sigmaY: 30,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isOnFilter!
                  ? kSecondaryColor.withOpacity(0.1)
                  : kGreyColor2.withOpacity(0.6),
              border: GradientBoxBorder(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    kSecondaryColor,
                    kPurpleColor,
                  ],
                ),
                width: 0.76,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyText(
                  paddingLeft: 10,
                  paddingTop: 14,
                  paddingBottom: 12,
                  weight: FontWeight.w600,
                  text: title,
                  size: 13,
                  color: isOnFilter! ? kPrimaryColor : kBlackColor,
                ),
                Container(
                  height: 0.76,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        kSecondaryColor,
                        kPurpleColor,
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                ...List.generate(
                  items.length,
                  (index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 6, 0, 8),
                      child: Row(
                        children: [
                          CustomCheckBox2(
                            unSelectedColor: kSecondaryColor,
                            isRadio: true,
                            isActive: selectedValue == items[index],
                            onTap: onSelect,
                          ),
                          Expanded(
                            child: MyText(
                              paddingLeft: 6,
                              text: items[index],
                              size: 13,
                              weight: FontWeight.w500,
                              color: isOnFilter!
                                  ? kPrimaryColor
                                  : kDarkGreyColor7.withOpacity(0.68),
                            ),
                          ),
                        ],
                      ),
                    );
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
