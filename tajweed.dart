// TajweedController.dart - The controller responsible for the logic
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as dom;

class TajweedController extends GetxController with GetSingleTickerProviderStateMixin {
  // Observable values
  var verses = <Map<String, dynamic>>[].obs;
  var audioUrls = <String, String>{}.obs;
  var isLoading = true.obs;
  var selectedChapter = 1.obs;
  var selectedReciter = 1.obs; // Default to Abdul Basit
  var errorMessage = ''.obs;
  var currentlyPlayingVerse = Rx<String?>(null);
  var showTajweed = true.obs;
  
  // Non-observable values
  late TabController tabController;
  final AudioPlayer audioPlayer = AudioPlayer();
  final ScrollController scrollController = ScrollController();

  // Define tajweed rule colors
  final Map<String, Color> tajweedColors = {
    'ham_wasl': const Color(0xFF2196F3),         // Light Blue
    'laam_shamsiyah': const Color(0xFF4CAF50),   // Green
    'madda_normal': const Color(0xFFFF9800),     // Orange
    'madda_permissible': const Color(0xFF9C27B0),// Purple
    'madda_necessary': const Color(0xFFF44336),  // Red
    'idgham_wo_ghunnah': const Color(0xFF673AB7),// Deep Purple
    'ghunnah': const Color(0xFFE91E63),          // Pink
    'ikhfa': const Color(0xFF009688),            // Teal
    'iqlab': const Color(0xFF3F51B5),            // Indigo
    'idgham_with_ghunnah': const Color(0xFF00BCD4), // Cyan
    'idgham_mutajanisayn': const Color(0xFFFFC107), // Amber
    'idgham_mutaqaribayn': const Color(0xFFFF5722), // Deep Orange
    'ikhfa_shafawi': const Color(0xFF795548),    // Brown
  };

  // List of available reciters
  final List<Map<String, dynamic>> reciters = [
    {'id': 1, 'name': 'Abdul Basit', 'style': 'Mujawwad'},
    {'id': 7, 'name': 'Mahmoud Khalil Al-Husary', 'style': 'Murattal'},
    {'id': 3, 'name': 'Abdur-Rahman as-Sudais', 'style': 'Murattal'},
    {'id': 128, 'name': 'Mishary Rashid Alafasy', 'style': 'Murattal'},
  ];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    fetchTajweedVerses(selectedChapter.value);
    fetchAudioUrls(selectedChapter.value);
    
    // Setup audio player listener
    audioPlayer.onPlayerComplete.listen((event) {
      currentlyPlayingVerse.value = null;
    });
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    tabController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  Future<void> fetchTajweedVerses(int chapterNumber) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await http.get(
        Uri.parse('https://api.quran.com/api/v4/quran/verses/uthmani_tajweed?chapter_number=$chapterNumber'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        verses.value = List<Map<String, dynamic>>.from(data['verses']);
        isLoading.value = false;
      } else {
        errorMessage.value = 'Failed to load data: ${response.statusCode}';
        isLoading.value = false;
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      isLoading.value = false;
    }
  }

  Future<void> fetchAudioUrls(int chapterNumber) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.quran.com/api/v4/recitations/${selectedReciter.value}/by_chapter/$chapterNumber'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final audioFiles = List<Map<String, dynamic>>.from(data['audio_files']);
        
        Map<String, String> newAudioUrls = {};
        for (var file in audioFiles) {
          newAudioUrls[file['verse_key']] = 'https://verses.quran.com/${file['url']}';
        }
        
        audioUrls.value = newAudioUrls;
      }
    } catch (e) {
      print('Error fetching audio URLs: $e');
    }
  }

  Future<void> playAudio(String verseKey) async {
    // Stop current audio if any
    await audioPlayer.stop();
    
    if (currentlyPlayingVerse.value == verseKey) {
      // If clicking the same verse, just stop
      currentlyPlayingVerse.value = null;
      return;
    }
    
    // Get the audio URL for this verse
    final url = audioUrls[verseKey];
    if (url == null) {
      Get.snackbar(
        'Audio Unavailable',
        'Audio not available for this verse',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    try {
      await audioPlayer.play(UrlSource(url));
      currentlyPlayingVerse.value = verseKey;
    } catch (e) {
      Get.snackbar(
        'Playback Error',
        'Error playing audio: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      currentlyPlayingVerse.value = null;
    }
  }

  void toggleTajweed() {
    showTajweed.value = !showTajweed.value;
  }

  void changeChapter(int chapter) {
    if (chapter != selectedChapter.value) {
      selectedChapter.value = chapter;
      fetchTajweedVerses(chapter);
      fetchAudioUrls(chapter);
      audioPlayer.stop();
      currentlyPlayingVerse.value = null;
      
      // Navigate to the READ tab
      tabController.animateTo(0);
    }
  }

  void changeReciter(int reciterId) {
    if (reciterId != selectedReciter.value) {
      selectedReciter.value = reciterId;
      fetchAudioUrls(selectedChapter.value);
      audioPlayer.stop();
      currentlyPlayingVerse.value = null;
    }
  }

  // Create a custom widget to render the tajweed text
  Widget buildTajweedText(String htmlText, {bool? showTajweedLocal}) {
    bool useTajweed = showTajweedLocal ?? showTajweed.value;
    
    // Remove verse numbers (spans with class="end")
    final cleanedText = htmlText.replaceAll(RegExp(r'<span class=end>.*?</span>'), '');
    
    if (!useTajweed) {
      // If tajweed is disabled, just show plain text without color highlighting
      // Parse the HTML to extract just the text
      final document = htmlparser.parse(cleanedText);
      final plainText = document.body!.text;
      
      return Text(
        plainText,
        textAlign: TextAlign.right,
        style: const TextStyle(
          fontFamily: 'UthmanicHafs',
          fontSize: 28,
          height: 1.5,
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
      );
    }
    
    // Parse the HTML
    final document = htmlparser.parse(cleanedText);
    
    // Create rich text spans for the tajweed text
    List<InlineSpan> buildSpansFromNodes(List<dom.Node> nodes) {
      List<InlineSpan> spans = [];
      
      for (var node in nodes) {
        if (node is dom.Element) {
          if (node.localName == 'tajweed') {
            // Get the tajweed class
            final tajweedClass = node.attributes['class'] ?? '';
            
            // Get the color for this tajweed rule
            final color = tajweedColors[tajweedClass] ?? Colors.black;
            
            // Create a TextSpan with the appropriate color
            spans.add(
              TextSpan(
                text: node.text,
                style: TextStyle(
                  color: color,
                  backgroundColor: color.withOpacity(0.1),
                ),
              ),
            );
          } else {
            // Recursively handle other elements
            spans.addAll(buildSpansFromNodes(node.nodes));
          }
        } else if (node is dom.Text) {
          // Add regular text
          spans.add(TextSpan(text: node.text));
        }
      }
      
      return spans;
    }
    
    // Build spans from the root element
    final spans = buildSpansFromNodes(document.body!.nodes);
    
    // Return a RichText widget with all the spans
    return RichText(
      textAlign: TextAlign.right,
      text: TextSpan(
        style: const TextStyle(
          fontFamily: 'UthmanicHafs',
          fontSize: 28,
          height: 1.5,
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
        children: spans,
      ),
    );
  }

  String getExampleForRule(String rule) {
    // Sample examples for each tajweed rule
    final examples = {
      'ham_wasl': 'بِسْمِ ٱللَّهِ',
      'laam_shamsiyah': 'وَٱلشَّمْسِ',
      'madda_normal': 'ٱلرَّحْمٰنِ',
      'madda_permissible': 'ٱلرَّحِيمِ',
      'madda_necessary': 'ءَامَنُوا',
      'idgham_wo_ghunnah': 'مِن رَّبِّهِمْ',
      'ghunnah': 'مِن نِّعْمَةٍ',
      'ikhfa': 'مِن كُلِّ',
      'iqlab': 'مِنۢ بَعْدِ',
      'idgham_with_ghunnah': 'مَن يَقُولُ',
    };
    
    return examples[rule] ?? rule;
  }

  // Helper function to get surah names
  String getSurahName(int index) {
    final surahNames = [
      'Al-Fatihah', 'Al-Baqarah', 'Ali-Imran', 'An-Nisa', 'Al-Ma\'idah',
      'Al-An\'am', 'Al-A\'raf', 'Al-Anfal', 'At-Tawbah', 'Yunus',
      'Hud', 'Yusuf', 'Ar-Ra\'d', 'Ibrahim', 'Al-Hijr',
      'An-Nahl', 'Al-Isra', 'Al-Kahf', 'Maryam', 'Ta-Ha',
      'Al-Anbiya', 'Al-Hajj', 'Al-Mu\'minun', 'An-Nur', 'Al-Furqan',
      'Ash-Shu\'ara', 'An-Naml', 'Al-Qasas', 'Al-Ankabut', 'Ar-Rum',
      'Luqman', 'As-Sajdah', 'Al-Ahzab', 'Saba', 'Fatir',
      'Ya-Sin', 'As-Saffat', 'Sad', 'Az-Zumar', 'Ghafir',
      'Fussilat', 'Ash-Shura', 'Az-Zukhruf', 'Ad-Dukhan', 'Al-Jathiyah',
      'Al-Ahqaf', 'Muhammad', 'Al-Fath', 'Al-Hujurat', 'Qaf',
      'Adh-Dhariyat', 'At-Tur', 'An-Najm', 'Al-Qamar', 'Ar-Rahman',
      'Al-Waqi\'ah', 'Al-Hadid', 'Al-Mujadilah', 'Al-Hashr', 'Al-Mumtahanah',
      'As-Saff', 'Al-Jumu\'ah', 'Al-Munafiqun', 'At-Taghabun', 'At-Talaq',
      'At-Tahrim', 'Al-Mulk', 'Al-Qalam', 'Al-Haqqah', 'Al-Ma\'arij',
      'Nuh', 'Al-Jinn', 'Al-Muzzammil', 'Al-Muddaththir', 'Al-Qiyamah',
      'Al-Insan', 'Al-Mursalat', 'An-Naba', 'An-Nazi\'at', 'Abasa',
      'At-Takwir', 'Al-Infitar', 'Al-Mutaffifin', 'Al-Inshiqaq', 'Al-Buruj',
      'At-Tariq', 'Al-A\'la', 'Al-Ghashiyah', 'Al-Fajr', 'Al-Balad',
      'Ash-Shams', 'Al-Lail', 'Ad-Duha', 'Ash-Sharh', 'At-Tin',
      'Al-Alaq', 'Al-Qadr', 'Al-Bayyinah', 'Az-Zalzalah', 'Al-Adiyat',
      'Al-Qari\'ah', 'At-Takathur', 'Al-Asr', 'Al-Humazah', 'Al-Fil',
      'Quraish', 'Al-Ma\'un', 'Al-Kawthar', 'Al-Kafirun', 'An-Nasr',
      'Al-Masad', 'Al-Ikhlas', 'Al-Falaq', 'An-Nas'
    ];
    
    if (index >= 1 && index <= surahNames.length) {
      return surahNames[index - 1];
    }
    return 'Unknown Surah';
  }
}

// This extension is needed for older Flutter versions - you can remove it if using a newer Flutter version
extension HtmlNodeExtension on dom.Node {
  String get text {
    if (this is dom.Text) {
      return (this as dom.Text).data;
    } else if (this is dom.Element) {
      final element = this as dom.Element;
      final buffer = StringBuffer();
      for (var node in element.nodes) {
        buffer.write(node.text);
      }
      return buffer.toString();
    }
    return '';
  }
}

class TajweedScreen extends StatelessWidget {
  const TajweedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize and register the controller
    final TajweedController controller = Get.put(TajweedController());

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.purple,
              flexibleSpace: FlexibleSpaceBar(
                title: Obx(() => Text(
                  controller.getSurahName(controller.selectedChapter.value),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Decorative background
                    CachedNetworkImage(
                      imageUrl: 'https://images.unsplash.com/photo-1542816417-0983c9c9ad53?q=80&w=1000',
                      fit: BoxFit.cover,
                      color: Colors.purple.withOpacity(0.7),
                      colorBlendMode: BlendMode.multiply,
                      placeholder: (context, url) => Container(color: Colors.purple.shade700),
                      errorWidget: (context, url, error) => Container(color: Colors.purple.shade700),
                    ),
                    // Overlay gradient
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.2),
                            Colors.black.withOpacity(0.6),
                          ],
                        ),
                      ),
                    ),
                    // Surah info
                    Positioned(
                      bottom: 60,
                      left: 16,
                      right: 16,
                      child: Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chapter ${controller.selectedChapter.value.toString()}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (controller.verses.isNotEmpty)
                            Text(
                              '${controller.verses.length} Verses',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                        ],
                      )),
                    ),
                  ],
                ),
              ),
              actions: [
                // Toggle Tajweed coloring
                Obx(() => IconButton(
                  icon: Icon(
                    controller.showTajweed.value ? Icons.palette : Icons.palette_outlined,
                    color: Colors.white,
                  ),
                  tooltip: 'Toggle Tajweed Colors',
                  onPressed: controller.toggleTajweed,
                )),
                IconButton(
                  icon: const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ),
                  onPressed: () => _showTajweedLegend(context, controller),
                ),
              ],
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: controller.tabController,
                  indicatorColor: Colors.purple,
                  labelColor: Colors.purple,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(text: 'READ'),
                    Tab(text: 'SETTINGS'),
                  ],
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
          controller: controller.tabController,
          children: [
            // READ TAB
            _buildVersesList(controller),
            
            // SETTINGS TAB
            _buildSettingsTab(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTab(TajweedController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Surah Selection',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(() => DropdownButtonFormField<int>(
                    value: controller.selectedChapter.value,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.purple.withOpacity(0.3)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.purple.withOpacity(0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.purple),
                      ),
                      hintText: 'Select Surah',
                      prefixIcon: const Icon(Icons.menu_book),
                    ),
                    items: List.generate(114, (index) {
                      return DropdownMenuItem<int>(
                        value: index + 1,
                        child: Text('${index + 1}. ${controller.getSurahName(index + 1)}'),
                      );
                    }),
                    onChanged: (value) {
                      if (value != null) {
                        controller.changeChapter(value);
                      }
                    },
                  )),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Reciter Selection',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(() => DropdownButtonFormField<int>(
                    value: controller.selectedReciter.value,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.purple.withOpacity(0.3)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.purple.withOpacity(0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.purple),
                      ),
                      hintText: 'Select Reciter',
                      prefixIcon: const Icon(Icons.record_voice_over),
                    ),
                    items: controller.reciters.map((reciter) {
                      return DropdownMenuItem<int>(
                        value: reciter['id'],
                        child: Text('${reciter['name']} (${reciter['style']})'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.changeReciter(value);
                      }
                    },
                  )),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tajweed Display',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(() => SwitchListTile(
                    title: const Text('Show Tajweed Colors'),
                    subtitle: const Text('Highlight tajweed rules with colors'),
                    value: controller.showTajweed.value,
                    activeColor: Colors.purple,
                    onChanged: (bool value) {
                      controller.showTajweed.value = value;
                    },
                  )),
                  const SizedBox(height: 8),
                  ListTile(
                    title: const Text('Tajweed Legend'),
                    subtitle: const Text('Learn about tajweed rules'),
                    trailing: const Icon(Icons.info_outline),
                    onTap: () => _showTajweedLegend(Get.context!, controller),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersesList(TajweedController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
              ),
              const SizedBox(height: 16),
              Text(
                'Loading Surah ${controller.selectedChapter.value}...',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => controller.fetchTajweedVerses(controller.selectedChapter.value),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      if (controller.verses.isEmpty) {
        return const Center(
          child: Text('No verses found for this surah.'),
        );
      }

      return ListView.builder(
        controller: controller.scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: controller.verses.length,
        itemBuilder: (context, index) {
          final verse = controller.verses[index];
          final verseKey = verse['verse_key'];
          final tajweedText = verse['text_uthmani_tajweed'];

          return Obx(() {
            final isPlaying = controller.currentlyPlayingVerse.value == verseKey;
            
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  // Verse header with number and audio controls
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.05),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            color: isPlaying ? Colors.purple : Colors.purple.shade400,
                          ),
                          onPressed: () => controller.playAudio(verseKey),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.purple.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.bookmark_border,
                                size: 16,
                                color: Colors.purple,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                verseKey,
                                style: TextStyle(
                                  color: Colors.purple.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Verse content

                  // Verse content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Tajweed text
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: controller.buildTajweedText(tajweedText),
                          ),
                        ),
                        // Add here: Translation if needed
                      ],
                    ),
                  ),
                  // Verse actions
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.share, size: 20),
                          color: Colors.grey.shade700,
                          onPressed: () {
                            // Share functionality can be implemented in the controller
                            Get.snackbar(
                              'Share',
                              'Sharing verse $verseKey',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.bookmark_border, size: 20),
                          color: Colors.grey.shade700,
                          onPressed: () {
                            // Bookmark functionality can be implemented in the controller
                            Get.snackbar(
                              'Bookmark',
                              'Bookmarked verse $verseKey',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        },
      );
    });
  }

  void _showTajweedLegend(BuildContext context, TajweedController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Legend header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(
                      Icons.menu_book,
                      color: Colors.purple.shade700,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Tajweed Rules Legend',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey.shade300),
              // Search input for rules
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search tajweed rules',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  ),
                ),
              ),
              // Legend content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildLegendItem(controller, 'ham_wasl', 'Hamzat Wasl', controller.tajweedColors['ham_wasl']!, 'When the hamza is dropped at the beginning of pronunciation'),
                    _buildLegendItem(controller, 'laam_shamsiyah', 'Lam Shamsiyyah', controller.tajweedColors['laam_shamsiyah']!, 'When lam (ل) is not pronounced and the letter after it has shaddah'),
                    _buildLegendItem(controller, 'madda_normal', 'Normal Madd', controller.tajweedColors['madda_normal']!, 'Normal prolongation of 2 counts'),
                    _buildLegendItem(controller, 'madda_permissible', 'Madd Jaiz', controller.tajweedColors['madda_permissible']!, 'Permissible prolongation of 2, 4 or 6 counts'),
                    _buildLegendItem(controller, 'madda_necessary', 'Madd Wajib', controller.tajweedColors['madda_necessary']!, 'Necessary prolongation of 6 counts'),
                    _buildLegendItem(controller, 'idgham_wo_ghunnah', 'Idgham without Ghunnah', controller.tajweedColors['idgham_wo_ghunnah']!, 'Merging without nasalization'),
                    _buildLegendItem(controller, 'ghunnah', 'Ghunnah', controller.tajweedColors['ghunnah']!, 'Nasalization with 2 counts'),
                    _buildLegendItem(controller, 'ikhfa', 'Ikhfa', controller.tajweedColors['ikhfa']!, 'Hidden pronunciation between clear and merged'),
                    _buildLegendItem(controller, 'iqlab', 'Iqlab', controller.tajweedColors['iqlab']!, 'Changing noon to meem sound'),
                    _buildLegendItem(controller, 'idgham_with_ghunnah', 'Idgham with Ghunnah', controller.tajweedColors['idgham_with_ghunnah']!, 'Merging with nasalization'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLegendItem(TajweedController controller, String rule, String title, Color color, String description) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Example text with the rule applied
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: color.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.format_quote,
                          size: 16,
                          color: color.withOpacity(0.7),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            controller.getExampleForRule(rule),
                            style: const TextStyle(
                              fontFamily: 'UthmanicHafs',
                              fontSize: 18,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverAppBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class TajweedBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TajweedController>(() => TajweedController());
  }
}

class AppRoutes {
  static const String tajweed = '/tajweed';
  
  static final routes = [
    GetPage(
      name: tajweed,
      page: () => const TajweedScreen(),
      binding: TajweedBindings(),
    ),
  ];
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Quran App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      getPages: AppRoutes.routes,
    );
  }
}