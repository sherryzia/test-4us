import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_fonts.dart';
import 'my_text_widget.dart';

// ignore: must_be_immutable
class MyTextField extends StatelessWidget {
  MyTextField(
      {Key? key,
      this.controller,
      this.hint,
      this.label,
      this.onChanged,
      this.isObSecure = false,
      this.marginBottom = 16.0,
      this.maxLines = 1,
      this.filledColor,
      this.hintColor,
      this.haveLabel = true,
      this.labelSize,
      this.prefix,
      this.suffix,
      this.labelWeight,
      this.kBorderColor,
      this.kFocusBorderColor,
      this.isReadOnly,
      this.onTap,
      this.compulsory = false,
      this.focusNode})
      : super(key: key);
  String? label, hint;

  TextEditingController? controller;
  ValueChanged<String>? onChanged;
  bool? isObSecure, haveLabel, isReadOnly;
  double? marginBottom;
  int? maxLines;
  double? labelSize;
  FocusNode? focusNode;
  Color? filledColor, hintColor, kBorderColor, kFocusBorderColor;
  Widget? prefix, suffix;
  FontWeight? labelWeight;
  bool? compulsory;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: marginBottom!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (label != null)
            Row(
              children: [
                MyText(
                  text: label ?? '',
                  size: 14,
                  color: kTertiaryColor,
                  paddingBottom: 6,
                  weight: labelWeight ?? FontWeight.w500,
                ),
                if (compulsory == true)
                  MyText(
                    text: ' *',
                    weight: FontWeight.w800,
                    color: kSecondaryColor,
                  )
              ],
            ),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: TextFormField(
              focusNode: focusNode,
              onTap: onTap,
              textAlignVertical: prefix != null || suffix != null
                  ? TextAlignVertical.center
                  : null,
              cursorColor: kSecondaryColor,
              maxLines: maxLines,
              readOnly: isReadOnly ?? false,
              controller: controller,
              onChanged: onChanged,
              textInputAction: TextInputAction.next,
              obscureText: isObSecure!,
              obscuringCharacter: '*',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: kSecondaryColor,
                fontFamily: AppFonts.POPPINS,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: filledColor ?? kPrimaryColor,
                prefixIcon: prefix,
                suffixIcon: suffix,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: maxLines! > 1 ? 15 : 0,
                ),
                hintText: hint,
                hintStyle: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  fontFamily: AppFonts.POPPINS,
                  color: hintColor ?? kTertiaryColor,
                ),
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: kTertiaryColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: kFocusBorderColor ?? kSecondaryColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                errorBorder: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
