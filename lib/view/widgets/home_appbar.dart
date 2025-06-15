import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../generated/assets.dart';
import 'common_image_view_widget.dart';
import 'my_text_widget.dart';

class HomeAppbar extends StatelessWidget {
  const HomeAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CommonImageView(
          svgPath: Assets.svgCross,
          height: 30,
        ),
        const SizedBox(width: 20,),
        CommonImageView(
          imagePath: Assets.imagesSplashLogo,
          height: 30,
        ),
      ],
    );
  }
}
