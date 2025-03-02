import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/constants/app_colors.dart';
import 'package:quran_app/controllers/DuaController.dart';
import 'package:quran_app/view/duaDetailsPage.dart';

class DuaPage extends StatelessWidget {
  final DuaController duaController = Get.put(DuaController());

  DuaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: kBackgroundPurpleLight,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: kShadowColor.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: kPurpleColor,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Daily Duas",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kTextPurple,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Find meaningful duas for every occasion",
                            style: TextStyle(
                              fontSize: 12,
                              color: kTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "All Available Duas",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: kTextPrimary,
                    ),
                  ),
                  Obx(
                    () => duaController.isLoading.value
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(kPurpleColor),
                            ),
                          )
                        : Text(
                            "${duaController.combinedDuas.length} Duas",
                            style: TextStyle(
                              fontSize: 14,
                              color: kTextSecondary,
                            ),
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Dua List
              Expanded(
                child: Obx(() {
                  if (duaController.isLoading.value &&
                      duaController.combinedDuas.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(kPurpleColor),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Loading duas...",
                            style: TextStyle(
                              color: kTextSecondary,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (duaController.combinedDuas.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: kLightGray,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "No Duas available",
                            style: TextStyle(
                              fontSize: 18,
                              color: kTextSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () =>
                                duaController.fetchDuasFromValidCategories(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kDarkPurpleColor,
                              foregroundColor: kWhite,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text("Refresh"),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: duaController.combinedDuas.length,
                    itemBuilder: (context, index) {
                      final dua = duaController.combinedDuas[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        shadowColor: kShadowColor.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: kLightGray.withOpacity(0.5),
                            width: 0.5,
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Get.to(() => DuaDetailsPage(
                                  category: dua['category'],
                                  duaId: dua['id'].toString(),
                                ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 16.0,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: kChipBackground,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${index + 1}",
                                      style: TextStyle(
                                        color: kDarkPurpleColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        dua['title'] ?? "No title",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: kTextPrimary,
                                        ),
                                      ),
                                      // if (dua['category'] != null)
                                      //   Padding(
                                      //     padding: const EdgeInsets.only(top: 4),
                                      //     child: Text(
                                      //       "Category: ${dua['category']}",
                                      //       style: TextStyle(
                                      //         fontSize: 12,
                                      //         color: kTextSecondary,
                                      //       ),
                                      //     ),
                                      //   ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: kMediumGray,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
