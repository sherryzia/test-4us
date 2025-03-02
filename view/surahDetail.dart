import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quran_app/controllers/QuranController.dart';
import 'package:quran_app/view/widgets/appBar.dart';
import 'package:quran_app/view/widgets/cards.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:share_plus/share_plus.dart';

class SurahDetailPage extends StatefulWidget {
  final int surahId;
  final String surahName;
  final String surahSubtitle;
  final String type;
  final String versesCount;

  const SurahDetailPage({
    Key? key,
    required this.surahId,
    required this.surahName,
    required this.surahSubtitle,
    required this.type,
    required this.versesCount,
  }) : super(key: key);

  @override
  _SurahDetailPageState createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends State<SurahDetailPage> {
  final QuranController quranController = Get.find<QuranController>();
  final AudioPlayer audioPlayer = AudioPlayer();
  final ScrollController _scrollController = ScrollController();
  
  final RxInt playingAyah = (-1).obs;
  final RxList<bool> isLoadingAudio = <bool>[].obs;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      quranController.fetchAyahs(widget.surahId).then((_) {
        isLoadingAudio.value = List.generate(quranController.ayahList.length, (_) => false);
      });
    });

    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        playingAyah.value = -1;
        final newLoadingList = List<bool>.filled(isLoadingAudio.length, false);
        isLoadingAudio.value = newLoadingList;
      }
    });

    // Add scroll listener for pagination
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    // Check if we're near the bottom of the scroll view
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      // Load more ayahs if we're not already loading and there's more to load
      if (!quranController.isLoadingMore.value && quranController.hasMoreData.value) {
        quranController.fetchMoreAyahs();
      }
    }
  }

  Future<void> toggleAudio(int index, String audioUrl) async {
    try {
      // If the same ayah is playing, pause it
      if (playingAyah.value == index) {
        await audioPlayer.pause();
        playingAyah.value = -1;
        return;
      }

      // Stop any currently playing audio
      await audioPlayer.stop();
      
      // Set loading state for this index only
      final newLoadingList = List<bool>.filled(isLoadingAudio.length, false);
      newLoadingList[index] = true;
      isLoadingAudio.value = newLoadingList;

      // Reset playing state
      playingAyah.value = -1;

      // Start playing new audio
      await audioPlayer.setSource(UrlSource("https://verses.quran.com/$audioUrl"));
      await audioPlayer.resume();
      
      // Update playing state
      playingAyah.value = index;
      
    } catch (e) {
      print("Error playing audio: $e");
      playingAyah.value = -1;
    } finally {
      // Reset loading state
      final newLoadingList = List<bool>.filled(isLoadingAudio.length, false);
      isLoadingAudio.value = newLoadingList;
    }
  }

  // Dynamically update the list of loading states when new ayahs are loaded
  void _updateLoadingAudioList() {
    if (quranController.ayahList.length != isLoadingAudio.length) {
      isLoadingAudio.value = List.generate(quranController.ayahList.length, (index) {
        // Preserve existing states if available
        return index < isLoadingAudio.length ? isLoadingAudio[index] : false;
      });
    }
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: simpleAppBar2(title: widget.surahName, centerTitle: true),
    body: SingleChildScrollView(
      controller: _scrollController,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SurahDetailCard(
              surahName: widget.surahName,
              surahSubtitle: widget.surahSubtitle,
              type: widget.type,
              verses: widget.versesCount,
              bismillahSvgPath: 'assets/images/bismillah.svg',
            ),
            const SizedBox(height: 20),
            Obx(() {
              if (quranController.isLoading.value && quranController.ayahList.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (quranController.ayahList.isEmpty) {
                return const Center(child: Text("No Ayahs found."));
              }

              // Update loading states when ayahs list changes
              _updateLoadingAudioList();

              return Column(
                children: List.generate(quranController.ayahList.length + 1, (index) {
                  if (index == quranController.ayahList.length) {
                    return Obx(() => quranController.isLoadingMore.value
                        ? Container(
                            padding: const EdgeInsets.all(16.0),
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(),
                          )
                        : quranController.hasMoreData.value
                            ? Container(
                                padding: const EdgeInsets.all(16.0),
                                alignment: Alignment.center,
                                child: const Text("Scroll to load more Ayahs..."),
                              )
                            : Container(
                                padding: const EdgeInsets.all(16.0),
                                alignment: Alignment.center,
                                child: const Text("End of Surah"),
                              ));
                  }

                  final ayah = quranController.ayahList[index];
                  bool isLoading = index < isLoadingAudio.length ? isLoadingAudio[index] : false;

                  return Obx(() => AyahCard(
                        ayahNumber: ayah['verse_number'],
                        surahName: widget.surahName,
                        arabicText: ayah['text_uthmani'],
                        translation: ayah['translation'],
                        isPlaying: playingAyah.value == index,
                        isLoading: isLoading,
                        onPlayPressed: () => toggleAudio(index, ayah['audio_url']),
                        onSharePressed: () {
                          String shareText = """
📖 *Surah:* ${widget.surahName}
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
                            duration: const Duration(seconds: 2),
                          );

                          // ✅ Share text via Share Plugin
                          Share.share(shareText);
                        },
                      ));
                }),
              );
            }),
          ],
        ),
      ),
    ),
  );
}


  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    audioPlayer.dispose();
    super.dispose();
  }
}