import 'package:affirmation_app/constants/app_colors.dart';
import 'package:affirmation_app/constants/app_images.dart';
import 'package:affirmation_app/view/widget/my_text_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomDropDown extends StatelessWidget {
  CustomDropDown({
    required this.hint,
    required this.items,
    this.selectedValue,
    required this.onChanged,
    this.bgColor,
    this.marginBottom,
    this.width,
    this.headingWeight,
    this.labelText,
  });

  final List<dynamic>? items;
  String? selectedValue, labelText;
  final ValueChanged<dynamic>? onChanged;
  String hint;
  Color? bgColor;
  double? marginBottom, width;
  FontWeight? headingWeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: marginBottom ?? 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (labelText != null)
            MyText(
              text: labelText!,
              size: 12,
              weight: FontWeight.w500,
              paddingBottom: 8,
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
                      ),
                    ),
                  )
                  .toList(),
              value: selectedValue,
              onChanged: onChanged,
              iconStyleData: IconStyleData(
                icon: Image.asset(
                  Assets.imagesArrowDropDown,
                  height: 8,
                ),
              ),
              isExpanded: false,
              customButton: Container(
                height: 48,
                padding: EdgeInsets.symmetric(
                  horizontal: 14,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: kPrimaryColor,
                  ),
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.transparent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: selectedValue != null && selectedValue == hint
                          ? hint
                          : selectedValue ?? hint,
                      size: 14,
                      color: selectedValue == hint ? kHintColor : kPrimaryColor,
                    ),
                    Image.asset(
                      Assets.imagesArrowDropDown,
                      height: 8,
                    ),
                  ],
                ),
              ),
              menuItemStyleData: MenuItemStyleData(
                height: 40,
              ),
              dropdownStyleData: DropdownStyleData(
                elevation: 3,
                maxHeight: 300,
                offset: Offset(0, -5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: kBlackColor.withOpacity(0.06),
                    width: 0.4,
                  ),
                  borderRadius: BorderRadius.circular(50),
                  color: kBlackColor.withOpacity(0.8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
