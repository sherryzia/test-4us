// ignore: must_be_immutable
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/constants/app_fonts.dart';
import 'package:forus_app/generated/assets.dart';
import 'package:forus_app/view/widget/my_text_widget.dart';


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
  final String selectedValue;
  final ValueChanged<dynamic>? onChanged;
  final String hint;
  final String? labelText;
  final Color? bgColor;
  final double? marginBottom, width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: marginBottom ?? 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (labelText != null)
            MyText(
              paddingBottom: 5,
              text: labelText!.toUpperCase(),
              weight: FontWeight.w900,
              fontFamily: AppFonts.NUNITO_SANS,
              textAlign: TextAlign.start,
              size: 12,
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
              value: selectedValue == hint ? null : selectedValue,
              hint: MyText(
                text: hint,
                size: 12,
                color: kTextGrey,
                
              fontFamily: AppFonts.NUNITO_SANS,
              ),
              onChanged: onChanged,
              iconStyleData: IconStyleData(
                icon: const SizedBox(),
              ),
              isDense: true,
              isExpanded: true,
              customButton: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: kborderGrey2,
                    width: 1,
                  ),
                  color: kWhite,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: selectedValue == hint ? hint : selectedValue,
                      size: 12,
                      color: kTextGrey,
                      weight: FontWeight.w300,
              fontFamily: AppFonts.NUNITO_SANS,
                    ),
                    Image.asset(
                      Assets.imagesDropdownarrow2,
                      height: 14,
                    ),
                  ],
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 35,
              ),
              dropdownStyleData: DropdownStyleData(
                elevation: 6,
                maxHeight: 300,
                offset: const Offset(0, -5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: kWhite),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
