import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/constants/app_colors.dart';
import 'package:quran_app/controllers/QuranController.dart';
import 'package:quran_app/view/widgets/my_text_widget.dart';
import 'package:quran_app/view/widgets/appBar.dart';

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
            // Enhanced Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                  // Visual element
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: kChipBackground,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.bookmark_rounded,
                      size: 32,
                      color: kDarkPurpleColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  MyText(
                    text: 'Your Saved Collection',
                    color: kDarkPurpleColor,
                    size: 22,
                    weight: FontWeight.bold,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Obx(() => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.purple.withOpacity(0.7), Colors.deepPurple.withOpacity(0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: kDarkPurpleColor.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '${quranController.bookmarks.length} saved items',
                      style: const TextStyle(
                        color: kWhite,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  )),
                ],
              ),
            ),

            // Small spacing between header and content
            const SizedBox(height: 16),

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

  // Enhanced Empty state UI
  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: kShadowColor.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kChipBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.bookmark_border_rounded,
                size: 48,
                color: kDarkPurpleColor,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "No bookmarks added yet!",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kDarkPurpleColor,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Bookmark your favorite verses and surahs to access them quickly later",
              style: TextStyle(
                color: kTextSecondary,
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.purple, Colors.deepPurple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: kDarkPurpleColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Navigate to Quran page
                    Get.back();
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      "Explore Quran",
                      style: TextStyle(
                        color: kWhite,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Enhanced Bookmark Card UI
  Widget _buildBookmarkCard(Map<String, dynamic> bookmark, int index) {
    // Determine the accent color based on type
    final Color accentColor = bookmark['type'] == 'Surah' 
        ? kPurpleColor 
        : Colors.orange.shade700;
        
    // Determine the background colors
    final List<Color> gradientColors = bookmark['type'] == 'Surah'
        ? [kChipBackground, kChipBackground.withOpacity(0.4)]
        : [kHighlightColor.withOpacity(0.7), kHighlightColor.withOpacity(0.3)];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [kWhite, kWhite.withOpacity(0.97)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kShadowColor.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: accentColor.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Handle bookmark tap (navigate to Surah/Ayah details)
            // quranController.openBookmark(bookmark);
          },
          borderRadius: BorderRadius.circular(16),
          splashColor: accentColor.withOpacity(0.1),
          highlightColor: accentColor.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Enhanced Icon Container with gradient
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    bookmark['type'] == 'Surah'
                        ? Icons.menu_book_rounded
                        : Icons.format_quote_rounded,
                    color: accentColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Text Content with enhanced styling
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bookmark['title'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: kTextPrimary,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        bookmark['subtitle'],
                        style: TextStyle(
                          fontSize: 14,
                          color: kTextSecondary,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      
                      // Time or date added (optional enhancement)
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: kTextSecondary.withOpacity(0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Added recently",
                            style: TextStyle(
                              fontSize: 12,
                              color: kTextSecondary.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // Actions Column
                Column(
                  children: [
                    // Enhanced Type Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: bookmark['type'] == 'Surah'
                            ? kChipBackground
                            : kHighlightColor,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: kShadowColor.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        bookmark['type'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: accentColor,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                   
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}