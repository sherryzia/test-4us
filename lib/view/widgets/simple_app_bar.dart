import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import 'my_text_widget.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onBackIconTap;
  final Color? bgColor;
  final Color? contentColor;
  final List<Widget>? actions;
  final bool showLeading;

  SimpleAppBar({
    this.title,
    this.onBackIconTap,
    this.bgColor,
    this.contentColor,
    this.actions,
    this.showLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kBlackColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: showLeading
          ? GestureDetector(
              onTap: onBackIconTap ?? () => Navigator.of(context).pop(),
              child: const Icon(Icons.arrow_back_outlined,color: kQuaternaryColor, size: 25),
            )
          : null,
      centerTitle: true,
      title: Text(
        title ?? '',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: contentColor ?? kQuaternaryColor,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(46.0); // Define the AppBar height
}

// AppBar homeAppBar({
//   String? title,
//   VoidCallback? onBackIconTap,
//   Color? bgColor,
//   Color? contentColor,
//   PreferredSizeWidget? bottom,
//   Widget? searchwidget,
//   bool? issearch = false,
//   bool? haveBackButton = true,
//   List<Widget>? actions,
// }) {
//   return AppBar(
//     toolbarHeight: 76,
//     backgroundColor: bgColor ?? Color(0xfffafafa),
//     centerTitle: true,
//     leadingWidth: issearch == true ? Get.width : 200,
//     leading: issearch == true
//         ? Row(
//             children: [
//               SizedBox(
//                 width: 16,
//               ),
//               GestureDetector(
//                 onTap: onBackIconTap ?? () => Get.back(),
//                 child: Image.asset(
//                   Assets.imagesBack,
//                   height: 24,
//                 ),
//               ),
//               searchwidget ?? Container(),
//             ],
//           )
//         : Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               if (issearch == false)
//                 Row(
//                   children: [
//                     SizedBox(
//                       width: 10,
//                     ),
//                     CommonImageView(
//                       imagePath: Assets.imagesHi,
//                       height: 30,
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           MyText(text: 'Hello,'),
//                           MyText(
//                             text: 'Good Morning',
//                             weight: FontWeight.w600,
//                             size: 16,
//                           )
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               if (haveBackButton == true)
//                 Row(
//                   children: [],
//                 ),
//             ],
//           ),
//     title: MyText(
//       text: title ?? '',
//       size: 16,
//       weight: FontWeight.w600,
//       color: contentColor ?? kPrimaryColor,
//     ),
//     actions: actions,
//     bottom: bottom,
//   );
// }
