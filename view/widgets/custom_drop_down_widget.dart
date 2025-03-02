import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/constants/app_colors.dart';
import 'package:quran_app/view/widgets/my_text_widget.dart';

// Custom Dropdown
class CustomDropDown extends StatelessWidget {
  CustomDropDown({
    required this.hint,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.bgColor,
    this.marginBottom,
    this.width,
    this.labelText,
  });

  final List<dynamic>? items;
  String selectedValue;
  final ValueChanged<dynamic>? onChanged;
  String hint;
  String? labelText;
  Color? bgColor;
  double? marginBottom, width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: marginBottom ?? 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (labelText != null)
            MyText(
              text: labelText!,
              size: 12,
              color: kTextPurple, // ✅ Updated label color
              paddingBottom: 6,
              weight: FontWeight.w500,
            ),
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              items: items!
                  .map(
                    (item) => DropdownMenuItem<dynamic>(
                      value: item,
                      child: MyText(
                        text: item,
                        size: 14,
                        color: kBlack, // ✅ Consistent text color
                      ),
                    ),
                  )
                  .toList(),
              value: selectedValue,
              onChanged: onChanged,
              iconStyleData: const IconStyleData(icon: SizedBox()),
              isDense: true,
              isExpanded: false,
              customButton: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: kCardBackground, // ✅ Updated dropdown background
                  border: Border.all(color: kBorderPurple, width: 1.2), // ✅ Border color
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: selectedValue == hint ? hint : selectedValue,
                      size: 14,
                      color: selectedValue == hint ? kTextGrey : kBlack, // ✅ Consistent text colors
                    ),
                    Image.asset(
                      'assets/images/dropdown_arrow.png',
                      height: 24,
                    ),
                  ],
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(height: 40),
              dropdownStyleData: DropdownStyleData(
                elevation: 6,
                maxHeight: 300,
                offset: const Offset(0, -5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: kPrimaryColor, // ✅ White dropdown background
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Secondary Dropdown
class CustomDropDown2 extends StatelessWidget {
  CustomDropDown2({
    required this.hint,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.bgColor,
    this.marginBottom,
    this.width,
    this.haveLeading = true,
  });

  final List<dynamic>? items;
  String selectedValue;
  final ValueChanged<dynamic>? onChanged;
  String hint;
  Color? bgColor;
  bool? haveLeading;
  double? marginBottom, width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: marginBottom ?? 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          items: items!
              .map(
                (item) => DropdownMenuItem<dynamic>(
                  value: item,
                  child: MyText(
                    text: item,
                    size: 12,
                    color: kBlack, // ✅ Ensured readable text color
                  ),
                ),
              )
              .toList(),
          value: selectedValue,
          onChanged: onChanged,
          iconStyleData: const IconStyleData(icon: SizedBox()),
          isDense: true,
          isExpanded: false,
          customButton: Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: kNavBarColor, // ✅ Updated background color
              border: Border.all(color: kBorderPurple, width: 1), // ✅ Purple border
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (haveLeading!)
                  Image.asset(
                    'assets/images/calender_icon_new.png',
                    height: 14,
                    color: kTextGrey, // ✅ Icon color consistency
                  ),
                MyText(
                  text: selectedValue == hint ? hint : selectedValue,
                  size: 12,
                  color: selectedValue == hint ? kTextGrey : kBlack, // ✅ Text contrast maintained
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: Image.asset(
                    'assets/images/dropdown_arrow.png',
                    height: 14,
                  ),
                ),
              ],
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(height: 35),
          dropdownStyleData: DropdownStyleData(
            elevation: 6,
            maxHeight: 300,
            offset: const Offset(0, -5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: kPrimaryColor, // ✅ White dropdown background
            ),
          ),
        ),
      ),
    );
  }
}
