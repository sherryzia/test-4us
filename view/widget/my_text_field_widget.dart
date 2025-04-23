import 'package:flutter/material.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';

// ignore: must_be_immutable
class MyTextField extends StatefulWidget {
  MyTextField({
    Key? key,
    this.controller,
    this.hintText,
    this.labelText,
    this.onChanged,
    this.isObSecure = false,
    this.marginBottom = 20.0,
    this.maxLines = 1,
    this.labelSize,
    this.prefix,
    this.suffix,
    this.isReadOnly,
    this.onTap,
    this.isOutlineBorder = false,
  }) : super(key: key);

  String? labelText, hintText;
  TextEditingController? controller;
  ValueChanged<String>? onChanged;
  bool? isObSecure, isReadOnly, isOutlineBorder;
  double? marginBottom;
  int? maxLines;
  double? labelSize;
  Widget? prefix, suffix;
  final VoidCallback? onTap;

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.marginBottom!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.labelText != null)
            MyText(
              text: widget.labelText ?? '',
              size: widget.labelSize ?? 14,
              weight: FontWeight.bold,
              paddingBottom: !widget.isOutlineBorder! ? 6 : 0,
            ),
          TextFormField(
            onTap: widget.onTap,
            textAlignVertical: widget.prefix != null || widget.suffix != null
                ? TextAlignVertical.center
                : null,
            cursorColor: kBlackColor,
            maxLines: widget.maxLines,
            readOnly: widget.isReadOnly ?? false,
            controller: widget.controller,
            onChanged: widget.onChanged,
            textInputAction: TextInputAction.next,
            obscureText: widget.isObSecure!,
            obscuringCharacter: '*',
            style: TextStyle(
              fontSize: 14,
              color: kBlackColor,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              prefixIcon: widget.prefix,
              suffixIcon: widget.suffix,
              contentPadding: EdgeInsets.symmetric(
                horizontal: !widget.isOutlineBorder! ? 14 : 0,
                vertical: widget.maxLines! > 1 ? 15 : 0,
              ),
              hintText: widget.hintText,
              hintStyle: TextStyle(
                fontSize: 12,
                color: kQuaternaryColor.withOpacity(0.5),
                fontWeight: FontWeight.w500,
              ),
              border: InputBorder.none,
              enabledBorder: !widget.isOutlineBorder!
                  ? OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kBorderColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    )
                  : UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: kBorderColor,
                        width: 1,
                      ),
                    ),
              focusedBorder: !widget.isOutlineBorder!
                  ? OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kBorderColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    )
                  : UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: kBorderColor,
                        width: 1,
                      ),
                    ),
              errorBorder: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }
}
