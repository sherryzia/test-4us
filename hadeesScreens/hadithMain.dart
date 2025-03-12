import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/constants/app_colors.dart';
import 'package:quran_app/controllers/HadithController.dart';
import 'package:quran_app/view/widgets/appBar.dart';

class HadithMain extends StatelessWidget {
  HadithMain({Key? key}) : super(key: key);
  
  final HadithController hadithController = Get.put(HadithController());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: simpleAppBar2(
        title: "Ahadith", 
        haveBackButton: true, 
        centerTitle: true
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (hadithController.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: kPurpleColor,
              ),
            );
          }
          
          if (hadithController.hadithBooks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.auto_stories_outlined,
                    size: 64,
                    color: kDarkPurpleColor.withOpacity(0.7),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No Hadith books available",
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
            itemCount: hadithController.hadithBooks.length,
            itemBuilder: (context, index) {
  var book = hadithController.hadithBooks[index];

  // ✅ Skip if hadith count is 0
  if (book['hadiths_count'] == "0") return SizedBox.shrink();

  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: kPrimaryColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: kShadowColor.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
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
                                    hadithController.fetchChapters(book['bookSlug']); // Fetch chapters on tap

                },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: kChipBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "${index + 1}",
                    style: TextStyle(
                      color: kDarkPurpleColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book['bookName'],
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: kDarkPurpleColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "By ${book['writerName']} (${book['writerDeath']})",
                      style: TextStyle(
                        fontSize: 12,
                        color: kTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: kBackgroundPurpleLight,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.menu_book_outlined,
                                size: 14,
                                color: kDarkPurpleColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "${book['hadiths_count']} Hadiths",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: kDarkPurpleColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: kChipBackground,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.format_list_numbered,
                                size: 14,
                                color: kPurpleColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "${book['chapters_count']} Chapters",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: kPurpleColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: kDarkPurpleColor,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

          );
        }),
      ),
    );
  }
}