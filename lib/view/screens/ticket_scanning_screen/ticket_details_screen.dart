import 'package:betting_app/constants/app_sizes.dart';
import 'package:betting_app/view/screens/favourite/favourite_screen.dart';
import 'package:betting_app/view/screens/ticket_scanning_screen/scan_ticket_screen.dart';
import 'package:betting_app/view/widgets/common_image_view_widget.dart';
import 'package:betting_app/view/widgets/my_button.dart';
import 'package:betting_app/view/widgets/my_text_widget.dart';
import 'package:betting_app/view/widgets/simple_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../../constants/app_colors.dart';
import '../../../generated/assets.dart';

class TicketDetailsScreen extends StatefulWidget {
  const TicketDetailsScreen({Key? key}) : super(key: key);

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  String? _scanResult = "No result yet";
  final List<Map<String, dynamic>> data = [
    {
      "title": "UEFA Champions League 2024/25 - League Stage - Winner",
      "subtitle": "Championship Outright",
      "team": "Bayern Munich",
      "odds": "500.00",
      "image":Assets.imagesTick
    },
    {
      "title": "UEFA Champions League 2024/25 - League Stage - Winner",
      "subtitle": "Championship Outright",
      "team": "Manchester United",
      "odds": "500.00",
      "image":Assets.imagesYellow
    },
    {
      "title": "UEFA Champions League 2024/25 - League Stage - Winner",
      "subtitle": "Championship Outright",
      "team": "LiverPool",
      "odds": "500.00",
      "image":Assets.imagesRed
    },
    // Add more entries here
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: "Scan Ticket",
      ),
      bottomNavigationBar: Padding(
        padding: AppSizes.DEFAULT,
        child: Row(
          children: [
            Expanded(
                child: MyBorderButton(
                buttonText: "Re-scan",
                    onTap: () async {
                      //Get.to(() => const ScanTicketScreen());
                      String? res = await SimpleBarcodeScanner.scanBarcode(
                        context,
                        barcodeAppBar: const BarcodeAppBar(
                          appBarTitle: 'Scan Ticket',
                          centerTitle: true,
                          enableBackButton: true,
                          backButtonIcon: Icon(Icons.arrow_back),
                        ),
                        isShowFlashIcon: true, // Show flash icon
                        delayMillis: 2000,     // Scanning delay
                        cameraFace: CameraFace.back, // Use back camera
                      );

                      // Update the scanned result
                      setState(() {
                        _scanResult = res;
                      });
                    },
                  radius: 30,
                  height: 37,
                ),
            ),
            const SizedBox(width: 10,),
            Expanded(
                child: MyButton(
                  height: 37,
                    onTap: (){
                      Get.to(() => const FavouriteScreen());
                    },
                    buttonText: "Save to Favourite",
                  backgroundColor: kQuaternaryColor,
                )),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: kBlackColor,
              child: Padding(
                padding: AppSizes.HORIZONTAL,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 20,),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CommonImageView(
                        radius: 5,
                        imagePath: Assets.imagesBil,
                        height: 100,
                      ),
                    ),
                    CommonImageView(
                      svgPath: Assets.svgCancel,
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: AppSizes.DEFAULT,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: "Ticket Details",
                    size: 17,
                    weight: FontWeight.w500,
                    color: kBlackColor,
                  ),
                  const SizedBox(height: 10,),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
                      return Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonImageView(
                                imagePath: item["image"],
                                height: 24,
                              ),
                              const SizedBox(width: 20,),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyText(
                                      text: item["title"],
                                      size: 14,
                                      weight: FontWeight.w400,
                                      color: kBlackColor,
                                    ),
                                    const SizedBox(height: 6),
                                    MyText(
                                      text: item["subtitle"],
                                      size: 14,
                                      weight: FontWeight.w400,
                                      color: kTertiaryColor,
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        MyText(
                                          text: item["team"],
                                          size: 14,
                                          weight: FontWeight.w500,
                                          color: kSecondaryColor,
                                        ),
                                        MyText(
                                          text: item["odds"],
                                          size: 14,
                                          weight: FontWeight.w500,
                                          color: kQuaternaryColor,
                                        ),
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Divider(
                              color: kTertiaryColor,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(
                        text: "Total Quotation",
                        size: 14,
                        weight: FontWeight.w500,
                        color: kBlackColor,
                      ),
                      MyText(
                        text: "555.65",
                        size: 14,
                        weight: FontWeight.w500,
                        color: kBlackColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(
                        text: "Stake",
                        size: 14,
                        weight: FontWeight.w500,
                        color: kBlackColor,
                      ),
                      MyText(
                        text: "CHF 5.00",
                        size: 14,
                        weight: FontWeight.w500,
                        color: kBlackColor,
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Divider(
                      color: kSecondaryColor,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(
                        text: "Possible Prize",
                        size: 14,
                        weight: FontWeight.w500,
                        color: kSecondaryColor,
                      ),
                      MyText(
                        text: "CHF 2500.00",
                        size: 14,
                        weight: FontWeight.w500,
                        color: kSecondaryColor,
                      ),
                    ],
                  ),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}


