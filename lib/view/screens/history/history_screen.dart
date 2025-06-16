// lib/view/screens/history/history_screen.dart

import 'package:betting_app/constants/app_sizes.dart';
import 'package:betting_app/controllers/ticket_controller.dart';
import 'package:betting_app/view/screens/outcomes/outcome_win_screen.dart';
import 'package:betting_app/view/widgets/common_image_view_widget.dart';
import 'package:betting_app/view/widgets/my_button.dart';
import 'package:betting_app/view/widgets/my_text_widget.dart';
import 'package:betting_app/view/widgets/simple_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../generated/assets.dart';
import '../ticket_scanning_screen/ticket_details_screen.dart';
// lib/view/screens/history/history_screen.dart

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TicketController _ticketController = Get.find<TicketController>();
  
  @override
  void initState() {
    super.initState();
    _refreshHistory();
    
    // Add listener to refresh when history is cleared
    ever(_ticketController.historyTickets, (_) => setState(() {}));
  }
  
  void _refreshHistory() {
    _ticketController.fetchTicketHistory();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: "History",
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshHistory,
            color: kQuaternaryColor,
          ),
        ],
      ),
      body: Obx(() {
        if (_ticketController.isLoading.value && _ticketController.historyTickets.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (_ticketController.historyTickets.isEmpty) {
          return const Center(
            child: Text("No ticket history found"),
          );
        }
        
        return Padding(
          padding: AppSizes.HORIZONTAL,
          child: ListView.builder(
            itemCount: _ticketController.historyTickets.length,
            itemBuilder: (context, index) {
              final ticket = _ticketController.historyTickets[index];
              
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    children: [
                      CommonImageView(imagePath: Assets.imagesBill,),
                      Positioned(
                        right: 15,
                        top: 15,
                        child: GestureDetector(
                          onTap: () {
                            Get.dialog(
                              AlertDialog(
                                title: const Text('Delete Ticket'),
                                content: const Text('Are you sure you want to delete this ticket from history?'),
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
                            imagePath: Assets.imagesDelete,
                            height: 32,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: kBlackColor,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(
                                text: ticket['bookmaker'] ?? "Unknown Bookmaker",
                                size: 12,
                                weight: FontWeight.w500,
                                color: kSecondaryColor,
                              ),
                              const SizedBox(height: 6,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  MyText(
                                    text: "Total Odds: ${ticket['total_odd'] ?? '0.00'}",
                                    size: 10,
                                    weight: FontWeight.w400,
                                    color: kQuaternaryColor,
                                  ),
                                  SizedBox(
                                    width: 87,
                                    height: 22,
                                    child: MyButton(
                                      onTap: () {
                                        _ticketController.getTicketDetails(ticket['id']);
                                        Get.to(() => TicketDetailsScreen(ticketId: ticket['id']));
                                      },
                                      backgroundColor: kQuaternaryLightColor,
                                      buttonText: "Show Results",
                                      fontColor: kQuaternaryColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                    ),
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
              );
            },
          ),
        );
      }),
    );
  }
}