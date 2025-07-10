import 'package:candid/constants/app_colors.dart';
import 'package:candid/view/widget/my_text_widget.dart';
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
    this.marginBottom = 16,
    this.labelText,
    this.labelColor = kTertiaryColor,
    this.radius,
    this.labelSize,
  });

  final List<dynamic>? items;
  String? selectedValue, labelText;
  final ValueChanged<dynamic>? onChanged;
  String hint;
  Color? bgColor, labelColor;
  double? marginBottom, radius, labelSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: marginBottom!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (labelText != null)
            MyText(
              text: labelText!,
              size: labelSize ?? 12,
              color: labelColor,
              weight: FontWeight.w600,
              paddingBottom: 8,
            ),
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              barrierColor: Colors.transparent,
              hint: MyText(
                text: '$hint',
                size: 12,
                color: kHintColor,
              ),
              items: items!
                  .map(
                    (item) => DropdownMenuItem<dynamic>(
                      value: item,
                      child: MyText(
                        text: item,
                        size: 12,
                      ),
                    ),
                  )
                  .toList(),
              value: selectedValue,
              onChanged: onChanged,
              customButton: Container(
                height: 48,
                padding: EdgeInsets.only(left: 14, right: 8),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(radius ?? 8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: MyText(
                        text: selectedValue == null ? hint : selectedValue!,
                        size: 12,
                        color:
                            selectedValue == null ? kHintColor : kTertiaryColor,
                        weight: FontWeight.w500,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      size: 22,
                      color: kSecondaryColor,
                    ),
                  ],
                ),
              ),
              menuItemStyleData: MenuItemStyleData(
                height: 40,
                padding: EdgeInsets.symmetric(horizontal: 14),
              ),
              dropdownStyleData: DropdownStyleData(
                elevation: 3,
                maxHeight: 300,
                offset: Offset(0, -5),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: kInputBorderColor,
                    width: 0.4,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
