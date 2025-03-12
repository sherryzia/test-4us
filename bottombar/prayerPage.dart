import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/constants/app_colors.dart';
import 'package:quran_app/controllers/SalahController.dart';

class PrayerPage extends StatelessWidget {
  PrayerPage({super.key});

  final SalahController salahController = Get.put(SalahController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor, // Changed to white background
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Stylish App Bar
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: kShadowColor.withOpacity(0.08),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: kChipBackground,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.auto_awesome,
                            color: kDarkPurpleColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "How to Perform Salah",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: kTextPurple,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Step by Step Guide",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: kTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: kDarkPurpleColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: kDarkPurpleColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: kDarkPurpleColor,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Follow these steps to perform Salah correctly",
                              style: TextStyle(
                                color: kDarkPurpleColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Prayer Steps List
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: Obx(() {
                if (salahController.isLoading.value) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(kDarkPurpleColor),
                      ),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final step = salahController.salahSteps[index];
                      return _buildSalahStep(step, index);
                    },
                    childCount: salahController.salahSteps.length,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalahStep(Map<String, dynamic> step, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kShadowColor.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: kGrey1Color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Theme(
        data: ThemeData(
          dividerColor: Colors.transparent,
          colorScheme: ColorScheme.light(primary: kDarkPurpleColor),
        ),
        child: ExpansionTile(
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: kChipBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                "${index + 1}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kDarkPurpleColor,
                ),
              ),
            ),
          ),
          title: Text(
            step['title'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: kTextPrimary,
            ),
          ),
          subtitle: Text(
            "Tap to see details",
            style: TextStyle(
              fontSize: 12,
              color: kTextSecondary.withOpacity(0.7),
            ),
          ),
          childrenPadding: const EdgeInsets.all(16),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kBackgroundPurpleLight.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: kLightPurpleColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    step['description'],
                    style: const TextStyle(
                      fontSize: 15,
                      color: kTextPrimary,
                      height: 1.6,
                    ),
                  ),
                ),
                if (step['dua'].isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _buildDuaSection(step),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDuaSection(Map<String, dynamic> step) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kWhite,
        border: Border.all(color: kDarkPurpleColor.withOpacity(0.15)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: kShadowColor.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: kDarkPurpleColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  color: kDarkPurpleColor,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  "Dua",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: kDarkPurpleColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kChipBackground.withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              step['dua'],
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 20,
                height: 2.0,
                fontFamily: 'Uthmani',
                color: kTextPrimary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kBackgroundPurpleLight.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: kLightPurpleColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: kDarkPurpleColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "Translation",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: kWhite,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  step['translation'],
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: kTextPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}