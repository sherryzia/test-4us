import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quran_app/controllers/QuranController.dart';
import 'package:quran_app/view/widgets/appBar.dart';
import 'package:quran_app/view/widgets/cards.dart';
import 'package:share_plus/share_plus.dart';

class JuzDetailPage extends StatefulWidget {
  final int juzId;
  final int juzNumber;
  final int firstSurah;
  final String versesCount;

  const JuzDetailPage({
    Key? key,
    required this.juzId,
    required this.juzNumber,
    required this.firstSurah,
    required this.versesCount,
  }) : super(key: key);

  @override
  _JuzDetailPageState createState() => _JuzDetailPageState();
}

class _JuzDetailPageState extends State<JuzDetailPage> {
  final QuranController quranController = Get.find();
  final AudioPlayer audioPlayer = AudioPlayer();
  RxInt playingAyah = (-1).obs; // Store currently playing ayah
  final ScrollController _scrollController = ScrollController();

  final RxList<bool> isLoadingAudio = <bool>[].obs;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => quranController.fetchJuzAyahs(widget.juzId));
    
    // Add scroll listener for pagination
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  // Scroll listener for infinite loading
  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 500 &&
        !quranController.isLoadingMore.value &&
        quranController.hasMoreData.value) {
      quranController.fetchMoreJuzAyahs(widget.juzId);
    }
  }

  void toggleAudio(int index, String audioUrl) async {
    if (playingAyah.value == index) {
      await audioPlayer.pause();
      playingAyah.value = -1; // Stop playing
    } else {
      await audioPlayer.stop(); // Stop any previous playing audio
      await audioPlayer.play(UrlSource("https://verses.quran.com/$audioUrl")); // Full URL
      playingAyah.value = index; // Set playing ayah
    }
  }

void _updateLoadingAudioList() {
  if (quranController.ayahList.length != isLoadingAudio.length) {
    isLoadingAudio.value = List.generate(quranController.ayahList.length, (index) {
      return index < isLoadingAudio.length ? isLoadingAudio[index] : false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar2(title: "Juz ${widget.juzNumber}", centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SurahDetailCard(
              surahName: "Juz ${widget.juzNumber}",
              surahSubtitle: "Starts from Surah ${widget.firstSurah}",
              type: "Juz",
              verses: widget.versesCount,
              bismillahSvgPath: 'assets/images/bismillah.svg',
            ),
            const SizedBox(height: 20),
            Expanded(
  child: Obx(() {
    if (quranController.isLoading.value && quranController.ayahList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (quranController.ayahList.isEmpty) {
      return const Center(child: Text("No Ayahs found."));
    }

    // ✅ Update loading states when ayahs list changes
    _updateLoadingAudioList();

    return ListView.builder(
      controller: _scrollController,
      itemCount: quranController.ayahList.length + (quranController.isLoadingMore.value ? 1 : 0),
      itemBuilder: (context, index) {
        // ✅ Show loading indicator at the bottom
        if (index == quranController.ayahList.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final ayah = quranController.ayahList[index];
        return Obx(() {
          bool isLoading = index < isLoadingAudio.length ? isLoadingAudio[index] : false;

          return AyahCard(
            ayahNumber: ayah['verse_number'],
            surahName: "${ayah['surah_name']}",
            arabicText: ayah['text_uthmani'],
            translation: ayah['translation'],
            isPlaying: playingAyah.value == index,
            isLoading: isLoading,
            onPlayPressed: () => toggleAudio(index, ayah['audio_url']),
onSharePressed: () {
  String shareText = """
*Surah:* ${ayah['surah_name']}
*Ayah:* ${ayah['verse_number']}
*Arabic Verse:* 
${ayah['text_uthmani']}
*Translation:* 
"${ayah['translation']}"

Read more on *Quran App*
  """;

  // ✅ Copy to clipboard
  Clipboard.setData(ClipboardData(text: shareText));

  // ✅ Show confirmation message
  Get.snackbar(
    "Copied to Clipboard",
    "Ayah details copied successfully! ✅",
    snackPosition: SnackPosition.BOTTOM,
    duration: Duration(seconds: 2),
  );

  // ✅ Share text via Share Plugin
  Share.share(shareText);
},
         );
        });
      },
    );
  }),
)

          ],
        ),
      ),
    );
  }
}