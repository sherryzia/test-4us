import 'package:flutter/material.dart';
import 'package:quran_app/constants/app_colors.dart';
import 'package:quran_app/constants/app_fonts.dart';
import 'package:quran_app/view/widgets/my_text_widget.dart';

// ignore: must_be_immutable
class MyTextField extends StatelessWidget {
  MyTextField({
    Key? key,
    this.controller,
    this.hint,
    this.label,
    this.onChanged,
    this.isObSecure = false,
    this.marginBottom = 16.0,
    this.maxLines = 1,
    this.labelSize,
    this.prefix,
    this.suffix,
    this.labelWeight,
    this.isReadOnly,
    this.isWhite = false,
    this.onTap,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  String? label, hint;
  TextEditingController? controller;
  ValueChanged<String>? onChanged;
  bool? isObSecure, isReadOnly, isWhite;
  double? marginBottom;
  int? maxLines;
  double? labelSize;
  Widget? prefix, suffix;
  FontWeight? labelWeight;
  final VoidCallback? onTap;
  //keyboard
  TextInputType keyboardType;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: marginBottom!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (label != null)
            MyText(
              text: label ?? '',
              size: labelSize ?? 12,
              color: kTextPurple,
              paddingBottom: 6,
              weight: labelWeight ?? FontWeight.w500,
            ),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: TextFormField(
              onTap: onTap,
              textAlignVertical: prefix != null || suffix != null
                  ? TextAlignVertical.center
                  : null,
              cursorColor: isWhite! ? kPrimaryColor : kPurpleColor,
              maxLines: maxLines,
              readOnly: isReadOnly ?? false,
              controller: controller,
              onChanged: onChanged,
              textInputAction: TextInputAction.next,
              obscureText: isObSecure!,
              keyboardType: keyboardType,
              obscuringCharacter: '*',
              style: TextStyle(
                fontSize: 14,
                color: isWhite! ? kPrimaryColor : kTextPurple,
                fontFamily: AppFonts.INTER,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor:
                    isWhite! ? kPrimaryColor.withOpacity(0.2) : kBackgroundWhite,
                prefixIcon: prefix,
                suffixIcon: suffix,
                
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: maxLines! > 1 ? 15 : 0,
                ),
                hintText: hint,
                hintStyle: TextStyle(
                  fontSize: 14,
                  fontFamily: AppFonts.INTER,
                  color: isWhite! ? kPrimaryColor : kTextGrey,
                ),
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isWhite! ? kPrimaryColor : kBorderColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isWhite! ? kPrimaryColor : kBorderColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
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
