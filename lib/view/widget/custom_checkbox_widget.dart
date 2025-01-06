import 'package:forus_app/constants/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'my_text_widget.dart';

class TermsCheckbox extends StatefulWidget {
  final String? text;
  final Color? textcolor;
  final Function(bool) onChanged;

  const TermsCheckbox({
    Key? key,
    this.text,
    required this.onChanged,
    this.textcolor,
  }) : super(key: key);

  @override
  _TermsCheckboxState createState() => _TermsCheckboxState();
}

class _TermsCheckboxState extends State<TermsCheckbox> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isChecked = !_isChecked;
            });
            widget.onChanged(_isChecked);
          },
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(3),
              // color: _isChecked ? kPrimaryColor : Colors.transparent,
              border: Border.all(
                // color: kGrey,
                width: 1,
              ),
            ),
            child: _isChecked
                ? Icon(
                    Icons.check,
                    color: kWhite,
                    size: 15,
                  )
                : null,
          ),
        ),
        SizedBox(width: 8),
        Flexible(
          child: MyText(
            text: widget.text ?? '',
            size: 12,
            fontFamily: AppFonts.INTER,
            weight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
