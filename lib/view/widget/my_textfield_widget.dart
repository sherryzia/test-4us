import 'package:affirmation_app/constants/app_fonts.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

// ignore: must_be_immutable
class MyTextField extends StatelessWidget {
  MyTextField({
    Key? key,
    this.controller,
    this.keyboardType,
    this.hintText,
    this.marginBottom = 18,
    this.isObSecure = false,
    this.maxLength,
    this.maxLines = 1,
    this.isEnabled = true,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.onTap,
    this.haveSuffix = false,
    this.havePrefix = false,
    this.onChanged,
    this.suffixIconSize,
    this.onSuffixTap,
    this.radius,
  }) : super(key: key);
  String? hintText, suffixIcon, prefixIcon;
  double? marginBottom, suffixIconSize, radius;
  bool? isObSecure, isEnabled, haveSuffix, havePrefix;
  int? maxLength, maxLines;
  VoidCallback? onSuffixTap;

  TextInputType? keyboardType;
  TextEditingController? controller;
  FormFieldValidator<String>? validator;
  ValueChanged<String>? onChanged;

  VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: marginBottom!,
      ),
      child: TextFormField(
        cursorColor: kPrimaryColor,
        onTap: onTap,
        enabled: isEnabled,
        validator: validator,
        maxLines: maxLines,
        maxLength: maxLength,
        onChanged: onChanged,
        obscureText: isObSecure!,
        obscuringCharacter: '*',
        controller: controller,
        textInputAction: TextInputAction.next,
        textAlignVertical: suffixIcon != null ? TextAlignVertical.center : null,
        keyboardType: keyboardType,
        style: TextStyle(
          fontSize: 14,
          color: kPrimaryColor,
          fontFamily: AppFonts.MONTSERRAT,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14,
            vertical: maxLines! > 1 ? 15 : 0,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14,
            color: kHintColor,
            fontFamily: AppFonts.MONTSERRAT,
          ),
          suffixIconConstraints: BoxConstraints(
            minWidth: haveSuffix! ? 40 : 16,
          ),
          prefixIconConstraints: BoxConstraints(
            minWidth: haveSuffix! ? 40 : 16,
          ),
          suffixIcon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (haveSuffix!)
                Padding(
                  padding: const EdgeInsets.only(
                    right: 14,
                  ),
                  child: GestureDetector(
                    onTap: onSuffixTap,
                    child: Image.asset(
                      suffixIcon!,
                      height: suffixIconSize ?? 20,
                    ),
                  ),
                ),
            ],
          ),
          prefixIcon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (havePrefix!)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                  ),
                  child: Image.asset(
                    prefixIcon!,
                    height: 20,
                    color: kGrey6Color,
                  ),
                ),
            ],
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: kPrimaryColor,
            ),
            borderRadius: BorderRadius.circular(radius ?? 56),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 56),
            borderSide: BorderSide(
              width: 1.12,
              color: kPrimaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
