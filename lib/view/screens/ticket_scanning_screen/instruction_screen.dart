import 'package:betting_app/constants/app_sizes.dart';
import 'package:betting_app/view/screens/ticket_scanning_screen/ticket_details_screen.dart';
import 'package:betting_app/view/widgets/common_image_view_widget.dart';
import 'package:betting_app/view/widgets/my_button.dart';
import 'package:betting_app/view/widgets/my_text_widget.dart';
import 'package:betting_app/view/widgets/simple_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../constants/app_colors.dart';
import '../../../generated/assets.dart';



class InstructionScreen extends StatelessWidget {
  const InstructionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackGroundColor,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back_outlined,color: kBlackColor, size: 25),
        ),

        centerTitle: true,
        title: const Text(
          'Scan Ticket',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kBlackColor,
          ),
        ),
      ),
      body: Padding(
        padding:AppSizes.DEFAULT,
        child: Center(
          child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CommonImageView(imagePath: Assets.imagesMbl,height: 140,),
              const SizedBox(height: 30,),
              MyText(
                  text: "Make sure to scan only the text\n without the QR Code",
                size: 17,
                weight: FontWeight.w400,
                color: kSecondaryColor,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30,),
              SizedBox(
                width: 170,
                  child: MyButton(onTap: (){
                    Get.to(() => const TicketDetailsScreen());
                  }, buttonText: "Got It")),
            ],
          ),
        ),
      ),
    );
  }
}
