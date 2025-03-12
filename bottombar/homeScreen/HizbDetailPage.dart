import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/controllers/QuranController.dart';
import 'package:quran_app/view/bottombar/homeScreen/homeScreen.dart';
import 'package:quran_app/view/bottombar/homeScreen/surahDetail.dart';
import 'package:quran_app/view/widgets/appBar.dart';
import 'package:quran_app/view/widgets/cards.dart';

class HizbDetailPage extends StatelessWidget {
  final int hizbId;
  final int hizbNumber;
  final int firstSurah;
  final String versesCount;

  HizbDetailPage({
    Key? key,
    required this.hizbId,
    required this.hizbNumber,
    required this.firstSurah,
    required this.versesCount,
  }) : super(key: key);

  final QuranController quranController = Get.find<QuranController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar2(title: "Hizb ${hizbNumber}", centerTitle: true),
      body: Obx(() {
        if (quranController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final hizbSurahs = quranController.surahList
            .where((surah) => int.parse(surah['id'].toString()) >= firstSurah)
            .toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: hizbSurahs.length,
          itemBuilder: (context, index) {
            final surah = hizbSurahs[index];

            return InkWell(
              onTap: () {
                quranController.ayahList.clear(); // ✅ Clear old Ayahs before navigating
                Get.to(() => SurahDetailPage(
                  surahId: surah['id'],
                  surahName: surah['name_simple'],
                  surahSubtitle: surah['translated_name']['name'],
                  type: surah['revelation_place'],
                  versesCount: surah['verses_count'].toString(),
                ));
              },
              child: SurahItem(
                surahNumber: surah['id'],
                name: surah['name_simple'],
                verses: "${surah['revelation_place'].toUpperCase()} • ${surah['verses_count']} VERSES",
                arabic: surah['name_arabic'],
              ),
            );
          },
        );
      }),
    );
  }
}
