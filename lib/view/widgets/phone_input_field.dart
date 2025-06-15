import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../constants/app_colors.dart';

class PhoneNumberInput extends StatefulWidget {
  @override
  _PhoneNumberInputState createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  @override
  Widget build(BuildContext context) {
    return const IntlPhoneField(
      decoration: InputDecoration(
        hintText: '576 889 324',
        hintStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: kHintColor,
        ),
        fillColor: kPrimaryColor,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: kTFBorderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: kTertiaryColor, width: 1),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      ),
      dropdownTextStyle: TextStyle(color: kSecondaryColor),
      flagsButtonPadding: EdgeInsets.only(right: 8.0, left: 12),
      disableLengthCheck: true,
      dropdownIconPosition: IconPosition.trailing,
      cursorColor: kTertiaryColor,
      cursorHeight: 18,
      showDropdownIcon: false,
      initialCountryCode: 'US',
      keyboardType: TextInputType.number,
    );
  }
}
