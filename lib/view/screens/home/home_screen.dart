import 'package:betting_app/constants/app_sizes.dart';
import 'package:betting_app/view/screens/favourite/favourite_screen.dart';
import 'package:betting_app/view/screens/history/history_screen.dart';
import 'package:betting_app/view/screens/ticket_scanning_screen/ticket_details_screen.dart';
import 'package:betting_app/view/widgets/common_image_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../../constants/app_colors.dart';
import '../../../generated/assets.dart';
import '../../widgets/my_button.dart';
import '../../widgets/my_text_widget.dart';
import '../ticket_scanning_screen/instruction_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Map<String, String>> items = [
    {"name": "Favorites", "image": Assets.svgHeart},
    {"name": "History", "image": Assets.svgHistory},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: ()  {
          Get.to(() => const InstructionScreen());
        },
        child: Container(
          decoration: ShapeDecoration(
            color: kPrimaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 23.64,
                offset: Offset(0, 0),
                spreadRadius: 0,
              )
            ],
          ),
          child: CommonImageView(
            svgPath: Assets.svgScan,
          ),
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kBlackColor,
        title: const Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Bet',
                style: TextStyle(
                  color: kQuaternaryColor,
                  fontSize: 22,
                  fontFamily: 'Gotham Rounded',
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: 'Vault',
                style: TextStyle(
                  color: kSecondaryColor,
                  fontSize: 22,
                  fontFamily: 'Gotham Rounded',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          CommonImageView(
            imagePath: Assets.imagesProfile,
            height: 40,
          ),
          const SizedBox(width: 22),
        ],
      ),
      body: ListView(
        children: [
          Container(
            padding: AppSizes.DEFAULT,
            decoration: const BoxDecoration(
                color: kBlackColor,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(15),

              )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: MyText(
                    text: "Welcome Back!",
                    size: 12,
                    weight: FontWeight.w400,
                    color: kPrimaryColor,
                  ),
                ),
                MyText(
                  text: "David Beckham",
                  size: 17,
                  weight: FontWeight.w700,
                  color: kQuaternaryColor,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: AppSizes.HORIZONTAL,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: GestureDetector(
                    onTap: (){
                      if (item["name"] == "Favorites") {
                        Get.to(() => const FavouriteScreen());
                      } else if (item["name"] == "History") {
                        Get.to(() => const HistoryScreen());
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 20,
                            offset: Offset(0, 0),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyText(
                            text: item["name"] ?? "",
                            size: 14,
                            weight: FontWeight.w500,
                            color: kBlackColor,
                          ),
                          CommonImageView(
                            svgPath: item["image"] ?? "",
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 15),
                  child: GestureDetector(
                    onTap: (){
                      Get.to(() => const TicketDetailsScreen());
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        children: [
                          CommonImageView(imagePath: Assets.imagesBill,),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration:  const BoxDecoration(
                                color: kBlackColor,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyText(
                                    text: "UEFA Champions League 2024/25 - League Stage",
                                    size: 12,
                                    weight: FontWeight.w500,
                                    color: kSecondaryColor,
                                  ),
                                  const SizedBox(height: 6,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyText(
                                        text: "Bayern Munich",
                                        size: 10,
                                        weight: FontWeight.w400,
                                        color: kQuaternaryColor,
                                      ),


                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );

              },),
          ),
        ],
      ),
    );
  }
}
