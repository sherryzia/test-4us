// lib/view/screens/favourite/favourite_screen.dart

import 'package:betting_app/constants/app_sizes.dart';
import 'package:betting_app/controllers/ticket_controller.dart';
import 'package:betting_app/view/widgets/common_image_view_widget.dart';
import 'package:betting_app/view/widgets/my_text_widget.dart';
import 'package:betting_app/view/widgets/simple_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../generated/assets.dart';
import '../ticket_scanning_screen/ticket_details_screen.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TicketController _ticketController = Get.find<TicketController>();
    
    return Scaffold(
      appBar: SimpleAppBar(
        title: "Favourite",
      ),
      body: Obx(() {
        if (_ticketController.isLoading.value && _ticketController.favoriteTickets.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (_ticketController.favoriteTickets.isEmpty) {
          return const Center(
            child: Text("No favorite tickets found"),
          );
        }
        
        return Padding(
          padding: AppSizes.DEFAULT,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _ticketController.favoriteTickets.length,
            itemBuilder: (context, index) {
              final ticket = _ticketController.favoriteTickets[index];
              
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      _ticketController.getTicketDetails(ticket['id']);
                      Get.to(() => TicketDetailsScreen(ticketId: ticket['id']));
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(
                                text: ticket['bookmaker'] ?? "Unknown Bookmaker",
                                size: 14,
                                weight: FontWeight.w400,
                                color: kBlackColor,
                              ),
                              const SizedBox(height: 6,),
                              MyText(
                                text: "Date: ${ticket['ticket_date'] ?? 'Unknown Date'}",
                                size: 14,
                                weight: FontWeight.w400,
                                color: kTertiaryColor,
                              ),
                              const SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  MyText(
                                    text: "Total Odds: ${ticket['total_odd'] ?? '0.00'}",
                                    size: 14,
                                    weight: FontWeight.w500,
                                    color: kSecondaryColor,
                                  ),
                                  MyText(
                                    text: "CHF ${ticket['potential_win'] ?? '0.00'}",
                                    size: 14,
                                    weight: FontWeight.w500,
                                    color: kQuaternaryColor,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 20,),
                        GestureDetector(
                          onTap: () {
                            _ticketController.toggleFavorite(ticket['id']);
                          },
                          child: CommonImageView(svgPath: Assets.svgHeartRed,),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15,),
                  const Divider(color: kTertiaryColor,),
                  const SizedBox(height: 15,),
                ],
              );
            },
          ),
        );
      }),
    );
  }
}