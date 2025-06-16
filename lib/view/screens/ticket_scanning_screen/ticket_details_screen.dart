// lib/view/screens/ticket_scanning_screen/ticket_details_screen.dart

import 'dart:io';

import 'package:betting_app/constants/app_sizes.dart';
import 'package:betting_app/controllers/ticket_controller.dart';
import 'package:betting_app/view/screens/favourite/favourite_screen.dart';
import 'package:betting_app/view/widgets/common_image_view_widget.dart';
import 'package:betting_app/view/widgets/my_button.dart';
import 'package:betting_app/view/widgets/my_text_widget.dart';
import 'package:betting_app/view/widgets/simple_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../../constants/app_colors.dart';
import '../../../generated/assets.dart';

class TicketDetailsScreen extends StatefulWidget {
  final int ticketId;
  
  const TicketDetailsScreen({Key? key, required this.ticketId}) : super(key: key);

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  final TicketController _ticketController = Get.find<TicketController>();

  @override
  void initState() {
    super.initState();
    _ticketController.getTicketDetails(widget.ticketId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: "Ticket Details",
      ),
      // lib/view/screens/ticket_scanning_screen/ticket_details_screen.dart

// In the bottomNavigationBar section of TicketDetailsScreen
bottomNavigationBar: Obx(() {
  final ticketData = _ticketController.selectedTicket.value;
  final ticket = ticketData['ticket'];
  
  if (ticket == null) {
    return const SizedBox.shrink();
  }
  
  return Padding(
    padding: AppSizes.DEFAULT,
    child: Row(
      children: [
        Expanded(
          child: MyBorderButton(
            buttonText: "Re-scan",
            onTap: () {
              // Show option to take photo or select from gallery
              Get.bottomSheet(
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MyText(
                        text: "Re-scan Ticket",
                        size: 18,
                        weight: FontWeight.w500,
                        color: kBlackColor,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Camera option
                          GestureDetector(
                            onTap: () async {
                              Get.back();
                              final ImagePicker _picker = ImagePicker();
                              final XFile? photo = await _picker.pickImage(
                                source: ImageSource.camera,
                                maxWidth: 1800,
                                maxHeight: 1800,
                              );
                              
                              if (photo != null) {
                                final File file = File(photo.path);
                                await _ticketController.uploadTicket(file, ticketId: ticket['id']);
                              }
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: kQuaternaryLightColor,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Icon(Icons.camera_alt, color: kQuaternaryColor),
                                ),
                                const SizedBox(height: 10),
                                MyText(
                                  text: "Camera",
                                  size: 14,
                                  weight: FontWeight.w400,
                                  color: kBlackColor,
                                ),
                              ],
                            ),
                          ),
                          // Gallery option
                          GestureDetector(
                            onTap: () async {
                              Get.back();
                              final ImagePicker _picker = ImagePicker();
                              final XFile? image = await _picker.pickImage(
                                source: ImageSource.gallery,
                                maxWidth: 1800,
                                maxHeight: 1800,
                              );
                              
                              if (image != null) {
                                final File file = File(image.path);
                                await _ticketController.uploadTicket(file, ticketId: ticket['id']);
                              }
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: kSecondaryLightColor,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Icon(Icons.photo_library, color: kSecondaryColor),
                                ),
                                const SizedBox(height: 10),
                                MyText(
                                  text: "Gallery",
                                  size: 14,
                                  weight: FontWeight.w400,
                                  color: kBlackColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
            radius: 30,
            height: 37,
          ),
        ),
        const SizedBox(width: 10,),
        Expanded(
          child: MyButton(
            height: 37,
            onTap: () {
              _ticketController.toggleFavorite(ticket['id']);
            },
            buttonText: ticket['is_favorite'] ? "Remove from Favorites" : "Add to Favorites",
            backgroundColor: kQuaternaryColor,
          ),
        ),
      ],
    ),
  );
}),
      body: Obx(() {
        if (_ticketController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final ticketData = _ticketController.selectedTicket.value;
        if (ticketData.isEmpty || ticketData['ticket'] == null) {
          return const Center(child: Text('No ticket details available'));
        }

        final ticket = ticketData['ticket'];
        final bets = ticketData['bets'] ?? [];

        return SingleChildScrollView(
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
                        child: ticket['image_path'] != null
                            ? Image.network(
                                ticket['image_path'],
                                height: 100,
                                errorBuilder: (context, error, stackTrace) {
                                  return CommonImageView(
                                    radius: 5,
                                    imagePath: Assets.imagesBil,
                                    height: 100,
                                  );
                                },
                              )
                            : CommonImageView(
                                radius: 5,
                                imagePath: Assets.imagesBil,
                                height: 100,
                              ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.dialog(
                            AlertDialog(
                              title: const Text('Delete Ticket'),
                              content: const Text('Are you sure you want to delete this ticket?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                    _ticketController.deleteTicket(ticket['id']);
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: CommonImageView(
                          svgPath: Assets.svgCancel,
                        ),
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
                      itemCount: bets.length,
                      itemBuilder: (context, index) {
                        final bet = bets[index];
                        
                        // Determine status icon
                        String statusIcon;
                        if (bet['status'] == 'won') {
                          statusIcon = Assets.imagesTick;
                        } else if (bet['status'] == 'lost') {
                          statusIcon = Assets.imagesRed;
                        } else {
                          statusIcon = Assets.imagesYellow;
                        }
                        
                        return Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonImageView(
                                  imagePath: statusIcon,
                                  height: 24,
                                ),
                                const SizedBox(width: 20,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      MyText(
                                        text: "${bet['team_1']} vs ${bet['team_2']}",
                                        size: 14,
                                        weight: FontWeight.w400,
                                        color: kBlackColor,
                                      ),
                                      const SizedBox(height: 6),
                                      MyText(
                                        text: bet['bet_type'] ?? "",
                                        size: 14,
                                        weight: FontWeight.w400,
                                        color: kTertiaryColor,
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          MyText(
                                            text: "Prediction: ${bet['prediction']}",
                                            size: 14,
                                            weight: FontWeight.w500,
                                            color: kSecondaryColor,
                                          ),
                                          MyText(
                                            text: bet['odds'] ?? "",
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
                          text: ticket['total_odd'] ?? "0.00",
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

                          // lib/view/screens/ticket_scanning_screen/ticket_details_screen.dart (continued)
                        ),
                        MyText(
                          text: ticket['total_price'] != null ? 
                                "CHF ${ticket['total_price']}" : "CHF 0.00",
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
                          text: ticket['potential_win'] != null ? 
                                "CHF ${ticket['potential_win']}" : "CHF 0.00",
                          size: 14,
                          weight: FontWeight.w500,
                          color: kSecondaryColor,
                        ),
                      ],
                    ),
                    
                    // Show status banner if not pending
                    if (ticket['status'] != 'pending')
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: ShapeDecoration(
                            color: ticket['status'] == 'all_won' ? kGreenColor : kSecondaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
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
                                text: ticket['status'] == 'all_won' ? "Winner" : "Lost",
                                size: 17,
                                weight: FontWeight.w500,
                                color: kPrimaryColor,
                              ),
                              if (ticket['status'] == 'all_won')
                                MyText(
                                  text: ticket['potential_win'] != null ? 
                                        "CHF ${ticket['potential_win']}" : "CHF 0.00",
                                  size: 17,
                                  weight: FontWeight.w500,
                                  color: kPrimaryColor,
                                ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}