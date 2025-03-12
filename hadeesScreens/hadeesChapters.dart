import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/constants/app_colors.dart';
import 'package:quran_app/controllers/HadithController.dart';
import 'package:quran_app/view/widgets/appBar.dart';

class HadithChaptersScreen extends StatelessWidget {
  HadithChaptersScreen({Key? key}) : super(key: key);

  final HadithController hadithController = Get.find(); // Get the existing controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: simpleAppBar2(
        title: "Chapters - ${hadithController.selectedBookSlug.value}", 
        haveBackButton: true, 
        centerTitle: true
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (hadithController.isChaptersLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: kPurpleColor),
            );
          }

          if (hadithController.chapters.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.book_outlined,
                    size: 64,
                    color: kDarkPurpleColor.withOpacity(0.7),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No chapters available",
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

          return ListView.builder(
            itemCount: hadithController.chapters.length,
            itemBuilder: (context, index) {
              var chapter = hadithController.chapters[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
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
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      // Navigate to chapter details or hadiths list
                      hadithController.fetchHadiths(chapter['bookSlug'], chapter['chapterNumber']);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Chapter number in a circle
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: kChipBackground,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                chapter['chapterNumber'].toString(),
                                style: TextStyle(
                                  color: kDarkPurpleColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Chapter titles
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  chapter['chapterEnglish'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: kDarkPurpleColor,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  chapter['chapterUrdu'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: kTextSecondary,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                // Hadith count chip if available
                                if (chapter['hadiths_count'] != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: kBackgroundPurpleLight,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.format_quote,
                                          size: 14,
                                          color: kDarkPurpleColor,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "${chapter['hadiths_count']} Hadiths",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: kDarkPurpleColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          // Chevron icon
                          const SizedBox(width: 4),
                          Icon(
                            Icons.chevron_right,
                            color: kDarkPurpleColor,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}