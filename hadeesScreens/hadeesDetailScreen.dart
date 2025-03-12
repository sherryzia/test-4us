import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/constants/app_colors.dart';
import 'package:quran_app/controllers/HadithController.dart';
import 'package:quran_app/view/widgets/appBar.dart';

class HadithDetailScreen extends StatelessWidget {
  HadithDetailScreen({Key? key}) : super(key: key);

  final HadithController hadithController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: simpleAppBar2(
        title: "Hadiths - ${hadithController.selectedChapterNumber.value}",
        haveBackButton: true,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (hadithController.isHadithLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: kPurpleColor),
            );
          }

          if (hadithController.hadiths.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.article_outlined,
                    size: 64,
                    color: kDarkPurpleColor.withOpacity(0.7),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No Hadiths available",
                    style: TextStyle(
                      fontSize: 18,
                      color: kTextSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: hadithController.hadiths.length,
                  itemBuilder: (context, index) {
                    var hadith = hadithController.hadiths[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: kShadowColor.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                          color: kLightGray.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with hadith number & status badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: kBackgroundPurpleLight,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: kPurpleColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "#${hadith['hadithNumber']}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: kWhite,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          hadith['book'] != null
                                              ? "${hadith['book']['bookName']}"
                                              : "",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: kDarkPurpleColor,
                                          ),
                                        ),
                                        if (hadith['volume'] != null) 
                                          Text(
                                            "Volume ${hadith['volume']}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: kTextSecondary,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: kPurpleColor, width: 1),
                                  ),
                                  child: Text(
                                    "${hadith['status'] ?? 'Unknown'}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: kPurpleColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Content section
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Chapter Information with card-like appearance
                                if (hadith['chapter'] != null) ...[
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: kChipBackground.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.bookmark,
                                              size: 16,
                                              color: kDarkPurpleColor,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                "Chapter: ${hadith['chapter']['chapterEnglish']}",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: kDarkPurpleColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (hadith['chapter']['chapterUrdu'] != null) ...[
                                          const SizedBox(height: 6),
                                          Text(
                                            hadith['chapter']['chapterUrdu'],
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: kTextPrimary,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],

                                // Narrator
                                if (hadith['englishNarrator'] != null && hadith['englishNarrator'].isNotEmpty) ...[
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.person,
                                        size: 16,
                                        color: kDarkPurpleColor,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          hadith['englishNarrator'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FontStyle.italic,
                                            color: kDarkPurpleColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                ],

                                // Arabic Text with decorative border
                                if (hadith['hadithArabic'] != null && hadith['hadithArabic'].isNotEmpty) ...[
                                  _buildTextSection(
                                    title: "Arabic Text",
                                    content: hadith['hadithArabic'],
                                    isRtl: true,
                                    icon: Icons.format_quote,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  const SizedBox(height: 16),
                                ],

                                // English Translation
                                if (hadith['hadithEnglish'] != null && hadith['hadithEnglish'].isNotEmpty) ...[
                                  _buildTextSection(
                                    title: "English Translation",
                                    content: hadith['hadithEnglish'],
                                    icon: Icons.translate,
                                  ),
                                  const SizedBox(height: 16),
                                ],

                                // Urdu Translation
                                if (hadith['hadithUrdu'] != null && hadith['hadithUrdu'].isNotEmpty) ...[
                                  _buildTextSection(
                                    title: "Urdu Translation",
                                    content: hadith['hadithUrdu'],
                                    isRtl: true,
                                    icon: Icons.translate,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Pagination Controls - Styled
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: kShadowColor.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPageButton(
                      onPressed: hadithController.currentPage.value > 1
                          ? () {
                              hadithController.fetchHadiths(
                                hadithController.selectedBookSlug.value,
                                hadithController.selectedChapterNumber.value,
                                page: hadithController.currentPage.value - 1,
                              );
                            }
                          : null,
                      icon: Icons.arrow_back_ios_rounded,
                      label: "Previous",
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: kChipBackground,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Page ${hadithController.currentPage.value} of ${hadithController.totalPages.value}",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: kDarkPurpleColor,
                        ),
                      ),
                    ),
                    _buildPageButton(
                      onPressed: hadithController.currentPage.value < hadithController.totalPages.value
                          ? () {
                              hadithController.fetchHadiths(
                                hadithController.selectedBookSlug.value,
                                hadithController.selectedChapterNumber.value,
                                page: hadithController.currentPage.value + 1,
                              );
                            }
                          : null,
                      icon: Icons.arrow_forward_ios_rounded,
                      label: "Next",
                      isNext: true,
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // Helper method to build consistent text sections
  Widget _buildTextSection({
    required String title,
    required String content,
    bool isRtl = false,
    IconData icon = Icons.text_fields,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kLightPurpleColor.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: kDarkPurpleColor,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: kDarkPurpleColor,
                ),
              ),
            ],
          ),
          const Divider(height: 16, color: kLightPurpleColor),
          Text(
            content,
            textAlign: isRtl ? TextAlign.right : TextAlign.left,
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            style: TextStyle(
              fontSize: fontSize,
              color: kTextPrimary,
              fontWeight: fontWeight,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for pagination buttons
  Widget _buildPageButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
    bool isNext = false,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: kPurpleColor,
        foregroundColor: kWhite,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
        disabledBackgroundColor: kLightGray,
        disabledForegroundColor: kMediumGray,
      ),
      child: Row(
        children: [
          if (!isNext) Icon(icon, size: 14),
          if (!isNext) const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isNext) const SizedBox(width: 4),
          if (isNext) Icon(icon, size: 14),
        ],
      ),
    );
  }
}