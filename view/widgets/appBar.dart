
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/constants/app_colors.dart';
import 'package:quran_app/view/widgets/my_text_widget.dart';




AppBar HomeAppBar({

  required BuildContext context,
  
  String? toGive,
  String? toSpend,
  Widget? leadingWidget,
  VoidCallback? leadingAction,
  List<Widget>? actions,
  Color? backgroundColor,
  double? elevation,
  Color? titleColor,
  bool centerTitle = true,
  Widget? title, // Add the custom title parameter
}) {
  bool hasActions = actions != null && actions.isNotEmpty;

  return AppBar(
    backgroundColor: kWhite,
    elevation: 0,
    titleSpacing: 0,
    surfaceTintColor: kWhite,
    leading: leadingWidget ?? IconButton(
      icon: Icon(
        Icons.menu,
        color: kTextPurple,
      ),
      onPressed: leadingAction ?? () {},
    ),
    title: title != null
        ? Padding(
            padding: EdgeInsets.only(left: !hasActions ? 20 : 0),
            child: title,
          )
        : Padding(
            padding: EdgeInsets.only(left: !hasActions ? 20 : 0),
            child: Row(
              mainAxisAlignment: hasActions ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
              children: [
                if (hasActions) Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kDarkGray,
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MyText(
                            text: 'Hello',
                            color: kBlack,
                            size: 10.5,
                            weight: FontWeight.w700,
                          ),
                          
                        ],
                      ),
                      SizedBox(width: 10),
                      MyText(text: "XX" , color: kBlack, size: 10.5, weight: FontWeight.w700),
                      SizedBox(width: 10),
                      
                    ],
                  ),
                ),
                if (hasActions) Spacer(),
              ],
            ),
          ),
    actions: actions ?? [],
  );
}


AppBar simpleAppBar2({
  String? title,
  double? size,
  VoidCallback? onBackIconTap,
  Color? bgColor,
  Color? contentColor,
  bool haveBackButton = true,
  bool centerTitle = false,
  List<Widget>? actions,
}) {
  return AppBar(
    backgroundColor: bgColor ?? kWhite,
    surfaceTintColor: kWhite,
    centerTitle: centerTitle,
    
    iconTheme: IconThemeData(
      color: Colors.transparent,
    ),
    leadingWidth: haveBackButton ? 42 : 0,
    leading: haveBackButton
        ? GestureDetector(
            onTap: onBackIconTap ?? () => Get.back(),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Icon(
                Icons.arrow_back_ios,
                color: contentColor ?? kBlack,
              ),
            ),
          )
        : null,
    title: MyText(
      text: title ?? '',
      size:size?? 16,
      weight: FontWeight.w600,
      color: contentColor ?? kBlack,
    ),
    actions: actions,
  );
}