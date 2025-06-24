import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/constants/app_sizes.dart';
import 'package:restaurant_finder/view/widget/custom_app_bar_widget.dart';
import 'package:restaurant_finder/view/widget/my_button_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_field_widget.dart';

class AddNewCard extends StatelessWidget {
  const AddNewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(title: 'addNewCard'.tr),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: AppSizes.DEFAULT,
              physics: BouncingScrollPhysics(),
              children: [
                MyTextField(
                  labelText: 'cardHolderName'.tr,
                  hintText: 'name'.tr,
                ),
                MyTextField(
                  labelText: 'cardNumber'.tr,
                  hintText: 'cardNumberHint'.tr,
                ),
                Row(
                  children: [
                    Expanded(
                      child: MyTextField(
                        labelText: 'expiryDate'.tr,
                        hintText: 'mmYy'.tr,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: MyTextField(
                        labelText: 'cvv'.tr,
                        hintText: 'cvvHint'.tr,
                      ),
                    ),
                  ],
                ),
                MyTextField(
                  labelText: 'zipPostalCode'.tr,
                  hintText: 'zipHint'.tr,
                ),
              ],
            ),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: MyButton(
              buttonText: 'save'.tr,
              onTap: () {
                Get.back();
              },
            ),
          ),
        ],
      ),
    );
  }
}
