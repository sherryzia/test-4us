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
      appBar: simpleAppBar(
        title: 'Add New Card',
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: AppSizes.DEFAULT,
              physics: BouncingScrollPhysics(),
              children: [
                MyTextField(
                  labelText: 'Card Holder Name',
                  hintText: 'Name',
                ),
                MyTextField(
                  labelText: 'Card Number',
                  hintText: 'XXXX   XXXX   XXXX   XXXX',
                ),
                Row(
                  children: [
                    Expanded(
                      child: MyTextField(
                        labelText: 'Expiry Date',
                        hintText: 'MM/YY',
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: MyTextField(
                        labelText: 'CVV',
                        hintText: '***',
                      ),
                    ),
                  ],
                ),
                MyTextField(
                  labelText: 'ZIP / Postal Code',
                  hintText: 'XXXX',
                ),
              ],
            ),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: MyButton(
              buttonText: 'Save',
              onTap: () {
                Get.back();
              },
            ),
          )
        ],
      ),
    );
  }
}
