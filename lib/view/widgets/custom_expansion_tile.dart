
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_styling.dart';
import 'my_text_widget.dart';

// ignore: must_be_immutable
class CustomExpansionTile extends StatefulWidget {
  CustomExpansionTile(
      {super.key,
      required this.title,
      this.isoption = false,
      this.ontap,
      this.isExpanded = false,
      required this.children});
  String title;
  bool? isoption;
  List<Widget> children;
  bool? isExpanded = false;
  void Function(bool)? ontap;
  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Container(
              decoration: rounded2(
                  kPrimaryColor,
                  widget.isoption == true
                      ? widget.isExpanded == true
                          ? kSecondaryColor
                          : kTertiaryColor
                      : kTertiaryColor),
              height: 55,
            ),
            ExpansionTile(
                trailing: widget.isoption == true
                    ? AnimatedContainer(
                        duration: const Duration(
                          milliseconds: 230,
                        ),
                        curve: Curves.easeInOut,
                        height: 21,
                        width: 21,
                        decoration: circle(kPrimaryColor, kTertiaryColor),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: widget.isExpanded == true
                                        ? kSecondaryColor
                                        : Colors.transparent,
                                    width: 5)),
                          ),
                        ),
                      )
                    : null,
                iconColor: widget.isoption == true ? Colors.transparent : null,
                collapsedIconColor:
                    widget.isoption == true ? Colors.transparent : null,
                // collapsedBackgroundColor: Color.fromARGB(255, 255, 255, 255),
                //  backgroundColor: Color.fromARGB(200, 255, 255, 255),
                onExpansionChanged: widget.ontap ??
                    (expanded) {
                      setState(() {
                        widget.isExpanded = expanded;
                      });
                    },
                collapsedTextColor: kTertiaryColor,
                textColor: kTertiaryColor,
                title: Row(
                  children: [
                    Expanded(
                      child: MyText(
                        text: widget.title,
                        size: 12,
                        paddingRight: 20,
                      ),
                    ),
                  ],
                ),
                children: widget.children),
          ],
        ),
      ),
    );
  }
}
