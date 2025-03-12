import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/constants/app_colors.dart';
import 'package:quran_app/controllers/DuaController.dart';
import 'package:quran_app/view/widgets/appBar.dart';

class DuaDetailsPage extends StatefulWidget {
  final String category;
  final String duaId;

  const DuaDetailsPage({super.key, required this.category, required this.duaId});

  @override
  _DuaDetailsPageState createState() => _DuaDetailsPageState();
}

class _DuaDetailsPageState extends State<DuaDetailsPage> {
  final DuaController duaController = Get.find<DuaController>();
  Map<String, dynamic>? dua;
  bool isLoading = true;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    fetchDuaDetails();
  }

  Future<void> fetchDuaDetails() async {
    setState(() {
      isLoading = true;
    });
    
    final duaData = await duaController.fetchDuaDetails(widget.category, widget.duaId);
    
    setState(() {
      dua = duaData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundWhite,
      appBar: 

      simpleAppBar2(
        title: "Dua Details",
        size: 18,
        bgColor: kBackgroundWhite,
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.bookmark : Icons.bookmark_border,
                  color: kDarkPurpleColor,
                ),
                onPressed: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                  // TODO: Implement favorite functionality
                  Get.snackbar(
                    "Bookmarks", 
                    isFavorite ? "Added to bookmarks" : "Removed from bookmarks",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: kDarkPurpleColor.withOpacity(0.9),
                    colorText: kWhite,
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.share,
                  color: kDarkPurpleColor,
                ),
                onPressed: () {
                  // TODO: Implement share functionality
                  Get.snackbar(
                    "Share", 
                    "Dua shared successfully",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: kDarkPurpleColor.withOpacity(0.9),
                    colorText: kWhite,
                  );
                },
              ),
            ],
          ),
        ]
      ),
      
      // AppBar(
      //   title: Text(
      //     "Dua Details", 
      //     style: TextStyle(
      //       fontWeight: FontWeight.bold,
      //       color: kWhite,
      //     )
      //   ),
      //   centerTitle: true,
      //   backgroundColor: kDarkPurpleColor,
      //   elevation: 0,
      //   actions: [
      //     IconButton(
      //       icon: Icon(
      //         isFavorite ? Icons.bookmark : Icons.bookmark_border,
      //         color: kWhite,
      //       ),
      //       onPressed: () {
      //         setState(() {
      //           isFavorite = !isFavorite;
      //         });
      //         // TODO: Implement favorite functionality
      //         Get.snackbar(
      //           "Bookmarks", 
      //           isFavorite ? "Added to bookmarks" : "Removed from bookmarks",
      //           snackPosition: SnackPosition.BOTTOM,
      //           backgroundColor: kDarkPurpleColor.withOpacity(0.9),
      //           colorText: kWhite,
      //           margin: const EdgeInsets.all(10),
      //         );
      //       },
      //     ),
      //     IconButton(
      //       icon: const Icon(
      //         Icons.share_outlined,
      //         color: kWhite,
      //       ),
      //       onPressed: () {
      //         // TODO: Implement share functionality
      //         Get.snackbar(
      //           "Share", 
      //           "Sharing functionality coming soon",
      //           snackPosition: SnackPosition.BOTTOM,
      //           backgroundColor: kDarkPurpleColor.withOpacity(0.9),
      //           colorText: kWhite,
      //           margin: const EdgeInsets.all(10),
      //         );
      //       },
      //     ),
      //   ],
      // ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kPurpleColor),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Loading dua details...",
                    style: TextStyle(
                      color: kTextSecondary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : dua == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline, 
                        size: 64, 
                        color: kLightPurpleColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Dua details not found", 
                        style: TextStyle(
                          fontSize: 18,
                          color: kTextPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "We couldn't load this dua",
                        style: TextStyle(
                          fontSize: 14,
                          color: kTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: fetchDuaDetails,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kDarkPurpleColor,
                          foregroundColor: kWhite,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                )
              : SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category badge
                          // if (dua?['category'] != null)
                          //   Container(
                          //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          //     decoration: BoxDecoration(
                          //       color: kChipBackground,
                          //       borderRadius: BorderRadius.circular(20),
                          //     ),
                          //     child: Text(
                          //       dua?['category'] ?? "",
                          //       style: TextStyle(
                          //         color: kDarkPurpleColor,
                          //         fontWeight: FontWeight.w500,
                          //         fontSize: 12,
                          //       ),
                          //     ),
                          //   ),
                            
                          const SizedBox(height: 16),
                          
                          // Title
                          Text(
                            dua?['title'] ?? "No title available",
                            style: TextStyle(
                              fontSize: 24, 
                              fontWeight: FontWeight.bold,
                              color: kTextPrimary,
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Arabic text section
                          if (dua?['arabic'] != null) ...[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: kBackgroundPurpleLight,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: kShadowColor.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                dua?['arabic'] ?? "",
                                style: const TextStyle(
                                  fontSize: 26, 
                                  fontWeight: FontWeight.w500,
                                  height: 1.8,
                                ),
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                          
                          // Latin transliteration section
                          if (dua?['latin'] != null) ...[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: kCardBackground,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: kLightGray.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Transliteration",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: kTextPurple,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    dua?['latin'] ?? "",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic,
                                      color: kTextPrimary,
                                      height: 1.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                          
                          // Translation section
                          if (dua?['translation'] != null) ...[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: kWhite,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: kLightGray.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Translation",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: kTextPurple,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    dua?['translation'] ?? "",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: kTextPrimary,
                                      height: 1.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                          
                          // Notes section
                          if (dua?['notes'] != null) ...[
                            _buildInfoSection(
                              title: "Notes",
                              content: dua?['notes'] ?? "",
                              icon: Icons.note_alt_outlined,
                            ),
                            const SizedBox(height: 16),
                          ],
                          
                          // Fawaid (Virtues) section
                          if (dua?['fawaid'] != null) ...[
                            _buildInfoSection(
                              title: "Virtues",
                              content: dua?['fawaid'] ?? "",
                              icon: Icons.star_outline,
                            ),
                            const SizedBox(height: 16),
                          ],
                          
                          // Source section
                          if (dua?['source'] != null) ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: kCardBackground.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.menu_book_outlined,
                                    size: 18,
                                    color: kTextSecondary,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "Source: ${dua?['source']}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: kTextSecondary,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),
                          ],
                          
                          // Action buttons
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     _buildActionButton(
                          //       icon: Icons.play_circle_outline,
                          //       label: "Play",
                          //       onTap: () {
                          //         Get.snackbar(
                          //           "Audio", 
                          //           "Audio playback coming soon",
                          //           snackPosition: SnackPosition.BOTTOM,
                          //           backgroundColor: kDarkPurpleColor.withOpacity(0.9),
                          //           colorText: kWhite,
                          //           margin: const EdgeInsets.all(10),
                          //         );
                          //       },
                          //     ),
                          //     const SizedBox(width: 16),
                          //     _buildActionButton(
                          //       icon: Icons.copy_outlined,
                          //       label: "Copy",
                          //       onTap: () {
                          //         Get.snackbar(
                          //           "Copy", 
                          //           "Dua copied to clipboard",
                          //           snackPosition: SnackPosition.BOTTOM,
                          //           backgroundColor: kDarkPurpleColor.withOpacity(0.9),
                          //           colorText: kWhite,
                          //           margin: const EdgeInsets.all(10),
                          //         );
                          //       },
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
  
  Widget _buildInfoSection({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: kLightGray.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: kShadowColor.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: kPurpleColor,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: kTextPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 15,
              color: kTextPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: kChipBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: kDarkPurpleColor,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: kDarkPurpleColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 