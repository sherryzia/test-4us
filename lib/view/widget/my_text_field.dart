import 'package:flutter/material.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/constants/app_fonts.dart';
import 'my_text_widget.dart';

class MyTextField extends StatelessWidget {
  String? label, fontFamily, hint, initialValue;
  TextEditingController? controller;
  ValueChanged<String>? onChanged;
  bool? isObSecure, haveLabel, isReadOnly;
  double? marginBottom, radius;
  int? maxLines;
  double? labelSize, hintsize;
  FocusNode? focusNode;
  Color? filledColor,
      focusedFillColor,
      hintColor,
      kBorderColor,
      kFocusBorderColor,
      labelColor;
  Widget? prefix, suffix;
  FontWeight? labelWeight;
  final VoidCallback? onTap;

  final double? height;
  final double? Width;
  final TextInputType? keyboardType;

  MyTextField({
    Key? key,
    this.controller,
    this.hint,
    this.label,
    this.onChanged,
    this.isObSecure = false,
    this.marginBottom = 16.0,
    this.maxLines = 1,
    this.filledColor,
    this.focusedFillColor,
    this.hintColor,
    this.labelColor,
    this.haveLabel = true,
    this.labelSize,
    this.hintsize,
    this.prefix,
    this.suffix,
    this.labelWeight,
    this.kBorderColor,
    this.kFocusBorderColor,
    this.isReadOnly,
    this.onTap,
    this.focusNode,
    this.radius,
    this.height,
    this.Width,
    this.keyboardType,
    this.initialValue, // New parameter for initial value
  }) : super(key: key) {
    // Initialize the controller with the initial value if provided
    if (controller == null) {
      controller = TextEditingController(text: initialValue);
    } else if (initialValue != null && controller!.text.isEmpty) {
      controller!.text = initialValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: marginBottom ?? 0), // Handle null with default value
      child: Column(
        children: [
          if (label != null)
            MyText(
              text: label ?? '',
              size: labelSize ?? 21,
              color: labelColor ?? kBlack,
              paddingBottom: 8,
              weight: labelWeight ?? FontWeight.w700,
            ),
          ClipRRect(
            borderRadius: BorderRadius.circular(radius ?? 30),
            child: Container(
              height: height,
              width: Width,
              child: TextFormField(
                focusNode: focusNode,
                onTap: onTap,
                textAlignVertical: (prefix != null || suffix != null)
                    ? TextAlignVertical.center
                    : null,
                maxLines: maxLines ?? 1, // Provide default value for maxLines
                readOnly: isReadOnly ?? false,
                controller: controller,
                onChanged: onChanged,
                textInputAction: TextInputAction.next,
                obscureText:
                    isObSecure ?? false, // Provide default value for isObSecure
                obscuringCharacter: '*',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: fontFamily ?? AppFonts.NUNITO_SANS,
                  color: AppThemeColors.getPrimaryColor(context),
                ),
                decoration: InputDecoration(
                  prefixIcon: prefix,
                  suffixIcon: suffix,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: (maxLines ?? 1) > 1 ? 15 : 0,
                  ),
                  hintText: hint,
                  hintStyle: TextStyle(
                    fontSize: hintsize ?? 14,
                    fontFamily: fontFamily ?? AppFonts.NUNITO_SANS,
                    color: hintColor ?? AppThemeColors.getPrimaryColor(context),
                  ),
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kBorderColor ?? KColor14,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(radius ?? 30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kFocusBorderColor ?? KColor14,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(radius ?? 30),
                  ),
                  errorBorder: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
