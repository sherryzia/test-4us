import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:quran_app/constants/app_colors.dart';
import 'package:quran_app/controllers/QuranController.dart';

class LastReadCard extends StatelessWidget {
  final String surahName;
  final String surahNumber;

  const LastReadCard({
    super.key,
    required this.surahName,
    required this.surahNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // Allows image to overflow the card
      children: [
        // Background Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 25),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFD1A1FF), // Light Purple
                Color(0xFF744AB7), // Dark Purple
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Last Read icon and text
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.menu_book,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Last Read',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Surah name
              Text(
                surahName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 6),

              // Surah number with indicator line
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 2,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Surah No: $surahNumber',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Quran Image positioned behind & outside the card
        Positioned(
          right: -10,
          bottom: -15,
          child: Image.asset(
            'assets/images/quran_illustration.png',
            height: 100,
            filterQuality: FilterQuality.high,
          ),
        ),
        
        // Decorative elements
        Positioned(
          left: 15,
          bottom: 15,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
          ),
        ),
        
        Positioned(
          left: 40,
          top: 15,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
class SurahDetailCard extends StatelessWidget {
  final String surahName;
  final String surahSubtitle;
  final String type;
  final String verses;
  final String bismillahSvgPath;

  const SurahDetailCard({
    Key? key,
    required this.surahName,
    required this.surahSubtitle,
    required this.type,
    required this.verses,
    required this.bismillahSvgPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.purple, Colors.deepPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Bismillah SVG at the top
            SvgPicture.asset(
              bismillahSvgPath,
              width: 200,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            const SizedBox(height: 16),
            
            // Surah Name
            Text(
              surahName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 6),
            
            // Surah Subtitle
            Text(
              surahSubtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Type & Verse Count
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildInfoChip(type.toUpperCase()),
                const SizedBox(width: 10),
                _buildInfoChip("$verses VERSES"),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Surah Opening Phrase
            const Text(
              "In the name of Allah, the Entirely Merciful, the Especially Merciful",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class AyahCard extends StatelessWidget {
  final int ayahNumber;
  final String surahName;
  final String arabicText;
  final String translation;
  final bool isPlaying;
  final bool isLoading;
  final VoidCallback onPlayPressed;
  final VoidCallback onSharePressed;

  const AyahCard({
    Key? key,
    required this.ayahNumber,
    required this.surahName,
    required this.arabicText,
    required this.translation,
    required this.isPlaying,
    required this.isLoading,
    required this.onPlayPressed,
    required this.onSharePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final QuranController quranController = Get.find<QuranController>();

    // ✅ Correctly formatted bookmark title
    final bookmark = {
      'type': 'Ayah',
      'title': 'Ayah $ayahNumber - $surahName',
      'subtitle': translation,
    };

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Ayah Number & Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Ayah number with decorative background
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: kDarkPurpleColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Ayah $ayahNumber",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: kDarkPurpleColor,
                    ),
                  ),
                ),
                
                // Action Buttons in attractive container
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // Play button
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: onPlayPressed,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: kDarkPurpleColor,
                                    ),
                                  )
                                : Icon(
                                    isPlaying ? Icons.pause_circle : Icons.play_circle,
                                    color: kDarkPurpleColor,
                                    size: 30,
                                  ),
                          ),
                        ),
                      ),

                      // ✅ Bookmark Button with improved appearance
                      Obx(() => Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30),
                              onTap: () => quranController.toggleBookmark(bookmark),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  quranController.isBookmarked(bookmark)
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color: kDarkPurpleColor,
                                  size: 26,
                                ),
                              ),
                            ),
                          )),

                      // Share button
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: onSharePressed,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.share,
                              color: kDarkPurpleColor,
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 🔹 Arabic Text with decorative frame
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: kDarkPurpleColor.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Text(
                arabicText,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 24,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Uthmani',
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 🔹 Translation with subtle styling
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.03),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                translation,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}