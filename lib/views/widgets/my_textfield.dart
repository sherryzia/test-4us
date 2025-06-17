import 'package:country_code_picker/country_code_picker.dart';
import 'package:expensary/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../constants/app_fonts.dart';
import 'my_text.dart';

class MyTextField extends StatefulWidget {
  final bool isReadOnly;
  final Function(String)? onCountryCodeChanged;
  final String? label, hint, suffixtext, prefixtext;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted; // Add this parameter
  final bool? isObSecure,
      haveLabel,
      isFilled,
      isright,
      useCountryCodePicker,
      showFlag;
  final double? marginBottom, labelSize, radius;
  final int? maxLines;
  final Widget? suffixIcon, prefixIcon;
  final Color? filledColor,
      focusedFilledColor,
      hintColor,
      bordercolor,
      fhintColor;
  final TextInputType? keyboardType;
  final VoidCallback? suffixTap;
  final List<TextInputFormatter>? inputFormatters;

  const MyTextField({
    Key? key,
    this.controller,
    this.hint,
    this.label,
    this.onChanged,
    this.onFieldSubmitted, // Initialize the parameter
    this.isObSecure = false,
    this.marginBottom = 15.0,
    this.maxLines,
    this.isFilled = true,
    this.filledColor,
    this.focusedFilledColor = kwhite,
    this.fhintColor = kblue,
    this.hintColor,
    this.bordercolor,
    this.isright,
    this.radius = 10,
    this.haveLabel = true,
    this.labelSize,
    this.prefixIcon,
    this.suffixtext,
    this.prefixtext,
    this.suffixIcon,
    this.suffixTap,
    this.isReadOnly = false,
    this.onCountryCodeChanged,
    this.keyboardType,
    this.showFlag,
    this.useCountryCodePicker = false,
    this.inputFormatters,
  }) : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late FocusNode _focusNode;
  final ValueNotifier<bool> _focusNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _focusNotifier.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    _focusNotifier.value = _focusNode.hasFocus;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.marginBottom!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.label != null)
            MyText(
              text: widget.label ?? '',
              size: widget.labelSize ?? 16,
              paddingBottom: 8,
              weight: FontWeight.w500,
              color: kblack,
            ),
          ValueListenableBuilder(
            valueListenable: _focusNotifier,
            builder: (_, isFocused, child) {
              final shouldShowFocused = isFocused && !widget.isReadOnly;

              return TextFormField(
                keyboardType: widget.keyboardType,
                maxLines: widget.maxLines ?? 1,
                controller: widget.controller,
                onChanged: widget.onChanged,
                onFieldSubmitted: widget.onFieldSubmitted,
                textInputAction: TextInputAction.done,
                readOnly: widget.isReadOnly,
                obscureText: widget.isObSecure!,
                obscuringCharacter: '*',
                inputFormatters: widget.inputFormatters,
                style: TextStyle(
                  fontFamily: AppFonts.SFDISPLAY,
                  fontSize: 15,
                  color: kblack,
                ),
                textAlign:
                    widget.isright == true ? TextAlign.right : TextAlign.left,
                // Don't assign focus node if the field is read-only
                focusNode: widget.isReadOnly ? null : _focusNode,
                decoration: InputDecoration(
                  prefixIcon: widget.useCountryCodePicker == true
                      ? Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Theme(
                            data: ThemeData(),
                            child: CountryCodePicker(
                              padding: EdgeInsets.all(0),
                              onChanged: (code) {
                                if (widget.onCountryCodeChanged != null) {
                                  widget.onCountryCodeChanged!(code.dialCode!);
                                }
                              },
                              initialSelection: 'US',
                              showDropDownButton: false,
                              flagDecoration:
                                  BoxDecoration(shape: BoxShape.circle),
                              // Remove the favorite parameter to eliminate pinned countries
                              // favorite: ['+39', 'FR'],
                              showCountryOnly: false,
                              showOnlyCountryWhenClosed: false,
                              alignLeft: false,
                            ),
                          ),
                        )
                      : widget.prefixIcon,
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  hintText: widget.hint,
                  suffixIcon: widget.suffixIcon != null
                      ? GestureDetector(
                          onTap: widget.suffixTap,
                          child: widget.suffixIcon,
                        )
                      : null,
                  prefix: widget.prefixtext != null
                      ? GestureDetector(
                          onTap: widget.suffixTap,
                          child: Text(
                            widget.prefixtext!,
                            style: TextStyle(
                              fontFamily: AppFonts.SFDISPLAY,
                              fontSize: 14,
                              color: shouldShowFocused ? korange : korange,
                            ),
                          ),
                        )
                      : null,
                  suffix: widget.suffixtext != null
                      ? GestureDetector(
                          onTap: widget.suffixTap,
                          child: Text(
                            widget.suffixtext!,
                            style: TextStyle(
                              fontFamily: AppFonts.SFDISPLAY,
                              fontSize: 14,
                              color: shouldShowFocused ? korange : korange,
                            ),
                          ),
                        )
                      : null,
                  hintStyle: TextStyle(
                    fontFamily: AppFonts.SFDISPLAY,
                    fontSize: 14,
                    color: shouldShowFocused
                        ? widget.fhintColor
                        : widget.hintColor,
                  ),
                  filled: true,
                  fillColor: shouldShowFocused
                      ? widget.focusedFilledColor
                      : widget.filledColor ?? kgrey2,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: widget.bordercolor ?? ktransparent, width: 1),
                    borderRadius: BorderRadius.circular(widget.radius ?? 10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: widget.isReadOnly
                            ? (widget.bordercolor ?? ktransparent)
                            : (widget.bordercolor ?? kblue),
                        width: 1),
                    borderRadius: BorderRadius.circular(widget.radius ?? 10),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class DatePickerField extends StatefulWidget {
  final String? label;
  final String? hint;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final Color? iconColor;
  final ValueChanged<DateTime>? onDateSelected;
  final bool isReadOnly;
  final bool showYear; // New parameter

  const DatePickerField({
    Key? key,
    this.label,
    this.hint,
    this.icon,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.iconColor,
    this.onDateSelected,
    this.isReadOnly = false,
    this.showYear = false, // Default value is false
  }) : super(key: key);

  @override
  _DatePickerFieldState createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  late TextEditingController _dateController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(text: widget.hint);
  }

  Future<void> _selectDate(BuildContext context) async {
    // If field is read-only, don't show the date picker
    if (widget.isReadOnly) return;
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1925),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // Format date based on showYear parameter
        _dateController.text = widget.showYear
            ? DateFormat('MMMM d, yyyy').format(_selectedDate!)  // Month Date, Year
            : DateFormat('MMMM d').format(_selectedDate!);       // Month Date
      });
      // Notify parent widget of the selected date
      if (widget.onDateSelected != null) {
        widget.onDateSelected!(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: widget.label ?? '',
          size: 16,
          paddingBottom: 8,
          weight: FontWeight.w500,
          color: widget.textColor ?? kblack,
        ),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? kgrey2,
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: widget.borderColor ?? Colors.transparent),
            ),
            child: Row(
              children: [
                Icon(widget.icon, size: 22, color: widget.iconColor ?? kblack2),
                SizedBox(width: 12),
                Text(
                  _dateController.text,
                  style: TextStyle(
                    fontFamily: AppFonts.SFDISPLAY,
                    fontSize: 14,
                    color: widget.isReadOnly 
                        ? (widget.textColor ?? kblack2) // Use a greyed out color if read-only
                        : (widget.textColor ?? kblack2),
                  ),
                ),
                Spacer(),
                // Show a different icon for read-only fields
                
              ],
            ),
          ),
        ),
      ],
    );
  }
}