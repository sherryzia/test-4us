import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_fonts.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_styling.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class MyTextField extends StatefulWidget {
  MyTextField({
    Key? key,
    this.controller,
    this.hintText,
    this.labelText,
    this.onChanged,
    this.isObscure = false,
    this.marginBottom = 12.0,
    this.maxLines = 1,
    this.hintColor,
    this.labelSize,
    this.fillColor,
    this.isReadOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  String? hintText, labelText;
  TextEditingController? controller;
  ValueChanged<String>? onChanged;
  bool? isObscure;
  double? marginBottom;
  int? maxLines;
  double? labelSize;
  Color? hintColor, fillColor;
  bool? isReadOnly;
  String? prefixIcon;
  Widget? suffixIcon;
  TextInputType? keyboardType;

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Container(
            height: 57,
            padding: EdgeInsets.symmetric(horizontal: 10),
            margin: EdgeInsets.only(bottom: widget.marginBottom!),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                width: 1.0,
                color: kBorderColor2,
              ),
            ),
            child: Row(
              children: [
                Image.asset(
                  widget.prefixIcon!,
                  width: 38,
                  height: 38,
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      textAlignVertical: TextAlignVertical.center,
                      cursorColor: kSecondaryColor,
                      readOnly: widget.isReadOnly!,
                      maxLines: widget.maxLines,
                      controller: widget.controller,
                      onChanged: widget.onChanged,
                      textInputAction: TextInputAction.next,
                      obscureText: widget.isObscure!,
                      keyboardType: widget.keyboardType,
                      style: TextStyle(
                        fontSize: 14,
                        color: kBlackColor,
                        fontFamily: AppFonts.URBANIST,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 0,
                        ),
                        hintText: widget.hintText,
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: kQuaternaryColor,
                          fontFamily: AppFonts.URBANIST,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                if (widget.suffixIcon != null) widget.suffixIcon!,
                SizedBox(
                  width: 8,
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            left: 58,
            child: MyText(
              text: widget.labelText!,
              size: 12,
              weight: FontWeight.w600,
              color: kBlackColor,
              fontFamily: AppFonts.URBANIST,
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class PhoneField extends StatefulWidget {
  PhoneField({
    Key? key,
    this.controller,
    this.onChanged,
    this.marginBottom = 16.0,
    this.selectedCountryCode,
    this.onCountryChanged,
  }) : super(key: key);

  TextEditingController? controller;
  ValueChanged<String>? onChanged;
  double? marginBottom;
  RxString? selectedCountryCode;
  Function(Country)? onCountryChanged;

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  final FocusNode _focusNode = FocusNode();
  
  // Default country
  Country selectedCountry = Country(
    phoneCode: '1',
    countryCode: 'US',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'United States',
    example: '2012345678',
    displayName: 'United States',
    displayNameNoCountryCode: 'United States',
    e164Key: '',
  );

  @override
  void initState() {
    super.initState();
    // Initialize with Pakistan if needed (based on your location)
    selectedCountry = Country(
      phoneCode: '92',
      countryCode: 'PK',
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: 'Pakistan',
      example: '3001234567',
      displayName: 'Pakistan',
      displayNameNoCountryCode: 'Pakistan',
      e164Key: '',
    );
    
    // Update the controller's selected country code
    if (widget.selectedCountryCode != null) {
      widget.selectedCountryCode!.value = '+${selectedCountry.phoneCode}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: widget.marginBottom ?? 16.0),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          width: 1.0,
          color: kBorderColor2,
        ),
      ),
      child: TextFormField(
        focusNode: _focusNode,
        onTap: () {
          _focusNode.requestFocus();
        },
        onTapOutside: (_) {
          FocusScope.of(context).unfocus();
        },
        textCapitalization: TextCapitalization.sentences,
        cursorColor: kSecondaryColor,
        controller: widget.controller,
        keyboardType: TextInputType.number,
        onChanged: widget.onChanged,
        textInputAction: TextInputAction.next,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          fontSize: 14,
          fontFamily: AppFonts.URBANIST,
          color: kQuaternaryColor,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          hintText: '${selectedCountry.example}',
          hintStyle: TextStyle(
            fontSize: 14,
            fontFamily: AppFonts.URBANIST,
            color: kQuaternaryColor.withOpacity(0.5),
          ),
          prefixIcon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(right: 15),
                height: 32,
                width: 85,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: MyText(
                        paddingLeft: 15,
                        onTap: () {
                          showCountryPicker(
                            context: context,
                            countryListTheme: CountryListThemeData(
                              flagSize: 25,
                              backgroundColor: Colors.white,
                              textStyle: TextStyle(
                                fontSize: 14,
                                color: kQuaternaryColor,
                                fontFamily: AppFonts.URBANIST,
                              ),
                              bottomSheetHeight: 500,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                              searchTextStyle: TextStyle(
                                fontSize: 14,
                                color: kQuaternaryColor,
                                fontFamily: AppFonts.URBANIST,
                              ),
                              inputDecoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 15),
                                hintText: 'Search country...',
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: kQuaternaryColor,
                                  fontFamily: AppFonts.URBANIST,
                                ),
                                prefixIcon: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      Assets.imagesSearchIcon,
                                      height: 24,
                                      color: kQuaternaryColor,
                                    ),
                                  ],
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: kBorderColor2,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: kBorderColor2,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: kBorderColor2,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: kBorderColor2,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                            onSelect: (Country country) {
                              setState(() {
                                selectedCountry = country;
                              });
                              
                              // Update the controller's selected country code
                              if (widget.selectedCountryCode != null) {
                                widget.selectedCountryCode!.value = '+${country.phoneCode}';
                              }
                              
                              // Call the callback if provided
                              if (widget.onCountryChanged != null) {
                                widget.onCountryChanged!(country);
                              }
                              
                              print('Selected country: ${country.displayName} (+${country.phoneCode})');
                            },
                          );
                        },
                        text: '${selectedCountry.flagEmoji} +${selectedCountry.phoneCode}',
                        color: kQuaternaryColor,
                        size: 15,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 20,
                      color: kBorderColor2,
                    ),
                  ],
                ),
              ),
            ],
          ),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  CustomTextField({
    Key? key,
    this.controller,
    this.hintText,
    this.labelText,
    this.onChanged,
    this.isObSecure = false,
    this.marginBottom = 16.0,
    this.maxLines = 1,
    this.labelSize,
    this.prefix,
    this.suffix,
    this.isReadOnly,
    this.onTap,
  }) : super(key: key);

  String? labelText, hintText;
  TextEditingController? controller;
  ValueChanged<String>? onChanged;
  bool? isObSecure, isReadOnly;
  double? marginBottom;
  int? maxLines;
  double? labelSize;
  Widget? prefix, suffix;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: marginBottom!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (labelText != null)
            MyText(
              text: labelText ?? '',
              size: labelSize ?? 12,
              paddingBottom: 6,
              weight: FontWeight.bold,
            ),
          Container(
            decoration: AppStyling.LIST_TILE_12,
            child: TextFormField(
              onTap: onTap,
              textAlignVertical: prefix != null || suffix != null
                  ? TextAlignVertical.center
                  : null,
              cursorColor: kTertiaryColor,
              maxLines: maxLines,
              readOnly: isReadOnly ?? false,
              controller: controller,
              onChanged: onChanged,
              textInputAction: TextInputAction.next,
              obscureText: isObSecure!,
              obscuringCharacter: '*',
              style: TextStyle(
                fontSize: 12,
                color: kTertiaryColor,
              ),
              decoration: InputDecoration(
                prefixIcon: prefix,
                suffixIcon: suffix,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: maxLines! > 1 ? 15 : 0,
                ),
                hintText: hintText,
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: kHintColor,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomPhoneField extends StatefulWidget {
  CustomPhoneField({
    Key? key,
    this.controller,
    this.onChanged,
    this.marginBottom = 16.0,
    this.labelText = '',
  }) : super(key: key);

  TextEditingController? controller;
  ValueChanged<String>? onChanged;
  double? marginBottom;
  final String? labelText;

  @override
  State<CustomPhoneField> createState() => _CustomPhoneFieldState();
}

class _CustomPhoneFieldState extends State<CustomPhoneField> {
  String countryFlag = '🇺🇸';
  String countryCode = '1';
  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.labelText!.isNotEmpty)
            MyText(
              text: 'Phone Number',
              size: 12,
              paddingBottom: 6,
              weight: FontWeight.bold,
            ),
          Container(
            decoration: AppStyling.LIST_TILE_12,
            child: TextFormField(
              keyboardType: TextInputType.phone,
              textAlignVertical: TextAlignVertical.center,
              cursorColor: kTertiaryColor,
              controller: widget.controller,
              onChanged: widget.onChanged,
              textInputAction: TextInputAction.next,
              style: TextStyle(
                fontSize: 12,
                color: kTertiaryColor,
              ),
              decoration: InputDecoration(
                prefixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyText(
                      paddingLeft: 15,
                      paddingRight: 10,
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          countryListTheme: CountryListThemeData(
                            flagSize: 25,
                            backgroundColor: kPrimaryColor,
                            textStyle: TextStyle(
                              fontSize: 14,
                              color: kTertiaryColor,
                            ),
                            bottomSheetHeight: 500,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25.0),
                              topRight: Radius.circular(25.0),
                            ),
                            searchTextStyle: TextStyle(
                              fontSize: 14,
                              color: kTertiaryColor,
                            ),
                            inputDecoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 15),
                              fillColor: kLightGreyColor,
                              filled: true,
                              hintText: 'Search',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: kHintColor,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                          onSelect: (Country country) {
                            setState(() {
                              countryFlag = country.flagEmoji;
                              countryCode = country.countryCode;
                            });
                          },
                        );
                      },
                      text: '${countryFlag} +${countryCode}',
                      size: 14,
                      weight: FontWeight.w600,
                    ),
                  ],
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                hintText: '000 000 0000',
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: kHintColor,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class SimpleTextField extends StatefulWidget {
  SimpleTextField({
    Key? key,
    this.controller,
    this.hintText,
    this.labelText,
    this.onChanged,
    this.isObscure = false,
    this.marginBottom = 12.0,
    this.maxLines = 1,
    this.hintColor,
    this.labelSize,
    this.fillColor,
    this.isReadOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  String? hintText, labelText;
  TextEditingController? controller;
  ValueChanged<String>? onChanged;
  bool? isObscure;
  double? marginBottom;
  int? maxLines;
  double? labelSize;
  Color? hintColor, fillColor;
  bool? isReadOnly;
  String? prefixIcon;
  Widget? suffixIcon;
  TextInputType? keyboardType;

  @override
  State<SimpleTextField> createState() => _SimpleTextFieldState();
}

class _SimpleTextFieldState extends State<SimpleTextField> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(
              15,
              widget.maxLines! > 1 ? 30 : 0,
              0,
              widget.maxLines! > 1 ? 30 : 0,
            ),
            margin: EdgeInsets.only(bottom: widget.marginBottom!),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                width: 1.0,
                color: kBorderColor2,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      textAlignVertical: TextAlignVertical.center,
                      cursorColor: kSecondaryColor,
                      readOnly: widget.isReadOnly!,
                      keyboardType: widget.keyboardType,
                      maxLines: widget.maxLines,
                      controller: widget.controller,
                      onChanged: widget.onChanged,
                      textInputAction: TextInputAction.next,
                      obscureText: widget.isObscure!,
                      style: TextStyle(
                        fontSize: 12,
                        color: kBlackColor,
                        fontFamily: AppFonts.URBANIST,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 0,
                        ),
                        hintText: widget.hintText,
                        hintStyle: TextStyle(
                          fontSize: 12,
                          color: kQuaternaryColor,
                          fontFamily: AppFonts.URBANIST,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                if (widget.suffixIcon != null) widget.suffixIcon!,
                SizedBox(
                  width: 8,
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            left: 15,
            child: MyText(
              text: widget.labelText!,
              size: 12,
              color: kDarkGreyColor,
              weight: FontWeight.w600,
              fontFamily: AppFonts.URBANIST,
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class SimpleTextField2 extends StatefulWidget {
  SimpleTextField2({
    Key? key,
    this.controller,
    this.hintText,
    this.onChanged,
  }) : super(key: key);

  String? hintText;
  TextEditingController? controller;
  ValueChanged<String>? onChanged;

  @override
  State<SimpleTextField2> createState() => _SimpleTextField2State();
}

class _SimpleTextField2State extends State<SimpleTextField2> {
  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focus) {
        setState(() {
          isFocused = focus;
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: TextFormField(
          cursorColor: Color(0xff8428F8),
          controller: widget.controller,
          onChanged: widget.onChanged,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          textAlign: TextAlign.center,
          maxLength: 2,
          obscuringCharacter: '*',
          style: TextStyle(
            fontSize: 30,
            color: kBlackColor,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor:
                isFocused ? Color(0xff8428F8).withOpacity(0.12) : kPrimaryColor,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 0,
            ),
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontSize: 30,
              color: kBlackColor,
              fontWeight: FontWeight.w500,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(
                color: Color(0xff8428F8),
                width: 1,
              ),
            ),
            errorBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
