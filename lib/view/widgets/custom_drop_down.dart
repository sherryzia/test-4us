import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import 'my_text_widget.dart';

// ignore: must_be_immutable
class CustomDropDown extends StatelessWidget {
  CustomDropDown({
    required this.label,
    required this.hint,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.mBottom,
  });

  final List<dynamic> items;
  final String selectedValue;
  final ValueChanged<dynamic> onChanged;
  final String hint;
  final String label;
  double? mBottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: mBottom ?? 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MyText(
            text: label,
            size: 12,
            color: kBlackColor,
            paddingBottom: 6,
            weight: FontWeight.w700,
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              items: items
                  .map(
                    (item) => DropdownMenuItem<dynamic>(
                      value: item,
                      child: MyText(
                        text: item,
                        size: 12,
                        color: kTertiaryColor,
                      ),
                    ),
                  )
                  .toList(),
              value: selectedValue,
              onChanged: onChanged,
              iconStyleData: IconStyleData(iconSize: 6),
              isDense: true,
              isExpanded: false,
              customButton: Container(
                height: 48,
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  border: Border.all(
                    color: kTertiaryColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: selectedValue == hint ? hint : selectedValue,
                      size: 14,
                      color:
                          selectedValue == hint ? kTertiaryColor : kTertiaryColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 18,
                          color: kSecondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              menuItemStyleData: MenuItemStyleData(
                height: 35,
              ),
              dropdownStyleData: DropdownStyleData(
                elevation: 3,
                maxHeight: 300,
                offset: Offset(0, -5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: kPrimaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class SimpleDropDown extends StatelessWidget {
  SimpleDropDown({
    required this.items,
    this.selectedValue,
    required this.onChanged,
    this.width,
    this.header,
  });

  final List<dynamic>? items;
  String? selectedValue;
  final ValueChanged<dynamic>? onChanged;
  double? width;
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          items: List.generate(
            items!.length,
            (index) {
              return DropdownMenuItem<dynamic>(
                value: items![index],
                child: Row(
                  children: [
                    Expanded(
                      child: MyText(
                        text: items![index],
                        size: 12,
                        weight: FontWeight.w600,
                        color: kTertiaryColor,
                      ),
                    ),
                    if (selectedValue == items![index])
                      Icon(
                        Icons.check,
                        color: kSecondaryColor,
                        size: 18,
                      ),
                  ],
                ),
              );
            },
          ),
          value: selectedValue,
          onChanged: onChanged,
          isDense: true,
          isExpanded: false,
          customButton: header,
          menuItemStyleData: MenuItemStyleData(
            height: 38,
          ),
          dropdownStyleData: DropdownStyleData(
            elevation: 3,
            width: width,
            maxHeight: 300,
            offset: Offset(0, -5),
            decoration: BoxDecoration(
              border: Border.all(
                color: kTertiaryColor.withOpacity(0.06),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(16),
              color: kPrimaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
