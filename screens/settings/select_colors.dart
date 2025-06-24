import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_sizes.dart';
import 'package:restaurant_finder/view/widget/custom_app_bar_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';
import 'package:restaurant_finder/controller/choose_color_controller.dart';

class SelectColors extends StatelessWidget {
  const SelectColors({super.key});

  final List<Color> colorOptions = const [
    Color(0xffE02C2C),
    Color(0xff302CE0),
    Color(0xff3FA02F),
    Color(0xff97298C),
    Color(0xff299783),
    Color(0xffD9E82C),
    Color(0xff000000),
    Color(0xffF35656),
    Color(0xffE2E2E2),
    Color(0xff444444),
  ];

  @override
  Widget build(BuildContext context) {
    final ChooseColorController controller = Get.find<ChooseColorController>();

    return Scaffold(
      appBar: simpleAppBar(title: 'selectAppColor'.tr),
      body: ListView.builder(
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        itemCount: colorOptions.length,
        itemBuilder: (context, index) {
          final color = colorOptions[index];
          return Obx(
            () => GestureDetector(
              onTap: () => controller.onUserSelect(color),
              child: Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 2.0,
                    color:
                        controller.currentThemeColor.value == color
                            ? color
                            : kBorderColor,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                        border:
                            controller.currentThemeColor.value == color
                                ? Border.all(color: Colors.black, width: 2)
                                : null,
                      ),
                      child:
                          controller.currentThemeColor.value == color
                              ? Icon(Icons.check, color: Colors.white)
                              : null,
                    ),
                    Expanded(
                      child: MyText(
                        paddingLeft: 12,
                        text: 'chooseYourFavoriteColor'.tr,
                        size: 16,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
