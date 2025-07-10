import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_fonts.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    this.hint,
    this.readOnly = false,
    this.onTap,
    this.controller,
    this.onChanged,
    this.validator,
  });

  final String? hint;
  final bool? readOnly;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly!,
      onTap: onTap,
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      cursorColor: kTertiaryColor,
      textAlignVertical: TextAlignVertical.center,
      textInputAction: TextInputAction.done,
      // onTapOutside: (_) {
      //   FocusScope.of(context).unfocus();
      // },
      style: TextStyle(
        fontSize: 12,
        color: kTertiaryColor,
        fontWeight: FontWeight.w400,
        fontFamily: AppFonts.URBANIST,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 12,
          color: kHintColor,
          fontWeight: FontWeight.w400,
          fontFamily: AppFonts.URBANIST,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 0,
        ),
        prefixIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(
            //   Assets.imagesSearch,
            //   height: 18,
            // ),
          ],
        ),
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    );
  }
}
