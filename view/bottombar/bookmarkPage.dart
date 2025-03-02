import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/constants/app_colors.dart';
import 'package:quran_app/controllers/QuranController.dart';
import 'package:quran_app/view/widgets/my_text_widget.dart';

class BookmarkPage extends StatelessWidget {
  BookmarkPage({super.key});

  final QuranController quranController = Get.find<QuranController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundPurpleLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.2, vertical: 24),
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: kShadowColor.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyText(
                    text: 'Your Bookmarks',
                    color: kDarkPurpleColor,
                    size: 28,
                    weight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),
                  Obx(() => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: kChipBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${quranController.bookmarks.length} saved items',
                          style: const TextStyle(
                            color: kPurpleColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // Bookmarks List
            Expanded(
              child: Obx(() {
                if (quranController.bookmarks.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: quranController.bookmarks.length,
                  itemBuilder: (context, index) {
                    final bookmark = quranController.bookmarks[index];
                    return _buildBookmarkCard(bookmark, index);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // Empty state UI
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border,
            size: 64,
            color: kPurpleColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            "No bookmarks added yet!",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kDarkPurpleColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Start adding your favorite verses and surahs",
            style: TextStyle(
              color: kTextSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // Bookmark Card UI
  Widget _buildBookmarkCard(Map<String, dynamic> bookmark, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kShadowColor.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Handle bookmark tap (navigate to Surah/Ayah details)
          // quranController.openBookmark(bookmark);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Icon Container
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: kChipBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  bookmark['type'] == 'Surah'
                      ? Icons.menu_book_rounded
                      : Icons.format_quote_rounded,
                  color: kPurpleColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bookmark['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: kTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bookmark['subtitle'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: kTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 2),
              // Type Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: bookmark['type'] == 'Surah'
                      ? kChipBackground
                      : kHighlightColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  bookmark['type'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: bookmark['type'] == 'Surah'
                        ? kPurpleColor
                        : kDarkPurpleColor,
                  ),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
