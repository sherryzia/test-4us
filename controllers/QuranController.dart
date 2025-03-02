import 'package:get/get.dart';
import 'package:quran_app/utilities/dio_util.dart';
import 'package:quran_app/utilities/rest_endpoints.dart';
import 'package:quran_app/utilities/shared_preferences_util.dart';

class QuranController extends GetxController {
  var surahList = [].obs;
  var juzList = [].obs;
  var ayahList = [].obs; // ✅ New list to store Ayahs

  var hizbList = [].obs; // ✅ Hizb List
  var isLoading = true.obs;
  var selectedSurahId = 0; // ✅ Store selected Surah ID
  var bookmarks = <Map<String, dynamic>>[].obs;
  
  // ✅ Pagination variables
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var isLoadingMore = false.obs;
  var hasMoreData = true.obs;

  String removeHtmlTags(String htmlText) {
    final RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: false);
    return htmlText.replaceAll(exp, '');
  }

  @override
  void onInit() {
    fetchSurahs();
    fetchJuzs();
    fetchHizbs();
    loadBookmarks(); // ✅ Load bookmarks on init

    super.onInit();
  }

  // ✅ Fetch Bookmarks from SharedPreferences
  Future<void> loadBookmarks() async {
    List<Map<String, dynamic>>? savedBookmarks =
        await SharedPreferencesUtil.getData<List<Map<String, dynamic>>>("bookmarks");

    if (savedBookmarks != null) {
      bookmarks.assignAll(savedBookmarks);
    }
  }

  // ✅ Toggle Bookmark (Add or Remove)
  Future<void> toggleBookmark(Map<String, dynamic> bookmark) async {
    bool exists = bookmarks.any((b) =>
        b['title'] == bookmark['title'] &&
        b['type'] == bookmark['type']);

    if (exists) {
      bookmarks.removeWhere((b) =>
          b['title'] == bookmark['title'] &&
          b['type'] == bookmark['type']);
    } else {
      bookmarks.add(bookmark);
    }

    await SharedPreferencesUtil.saveData("bookmarks", bookmarks);
    bookmarks.refresh(); // ✅ Refresh UI
  }

  // ✅ Check if Ayah or Surah is Bookmarked
  bool isBookmarked(Map<String, dynamic> bookmark) {
    return bookmarks.any((b) =>
        b['title'] == bookmark['title'] &&
        b['type'] == bookmark['type']);
  }

  // ✅ Fetch Surah List
  Future<void> fetchSurahs() async {
    try {
      isLoading(true);
      final response = await DioUtil.dio.get(RestConstants.surahs);
      if (response.statusCode == 200) {
        surahList.value = response.data['chapters'];
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch Surahs');
    } finally {
      isLoading(false);
    }
  }

  // ✅ Reset pagination state
  void resetPagination() {
    currentPage.value = 1;
    hasMoreData.value = true;
  }

  // ✅ Fetch initial Ayahs for a Surah with pagination
  Future<void> fetchAyahs(int surahId) async {
    try {
      isLoading.value = true;
      resetPagination();
      ayahList.clear();
      selectedSurahId = surahId;

      await _fetchAyahsPage(surahId, 1);
    } catch (e) {
      print("❌ Error fetching Ayahs: $e");
      Get.snackbar('Error', 'Failed to fetch Ayahs');
      ayahList.value = [];
    } finally {
      isLoading.value = false;
      update(); // ✅ Force UI update
    }
  }

  // ✅ Fetch more Ayahs as user scrolls
  Future<void> fetchMoreAyahs() async {
    if (isLoadingMore.value || !hasMoreData.value) return;
    
    try {
      isLoadingMore.value = true;
      await _fetchAyahsPage(selectedSurahId, currentPage.value + 1);
    } catch (e) {
      print("❌ Error fetching more Ayahs: $e");
      Get.snackbar('Error', 'Failed to load more Ayahs');
    } finally {
      isLoadingMore.value = false;
    }
  }

  // ✅ Internal method to fetch ayahs for a specific page
  Future<void> _fetchAyahsPage(int surahId, int page) async {
    print("🔍 Fetching Arabic text...");
    final arabicResponse = await DioUtil.dio.get(
      'https://api.quran.com/api/v4/quran/verses/uthmani'
    );

    print("🔍 Fetching Translations & Audio for Surah $surahId (Page $page)...");
    final translationResponse = await DioUtil.dio.get(
      'https://api.quran.com/api/v4/verses/by_chapter/$surahId',
      queryParameters: {
        'translations': '131', // Saheeh International Translation
        'audio': '1', // Audio recitation
        'page': page,
        'per_page': 10, // Number of ayahs per page
      },
    );

    if (arabicResponse.statusCode == 200 && translationResponse.statusCode == 200) {
      final arabicVerses = arabicResponse.data['verses'];
      final List<Map<String, dynamic>> translatedVerses =
          List<Map<String, dynamic>>.from(translationResponse.data['verses']);

      print("✅ Arabic Verses Count: ${arabicVerses.length}");
      print("✅ Translated Verses Count: ${translatedVerses.length}");

      // Update pagination info
      final pagination = translationResponse.data['pagination'];
      totalPages.value = pagination['total_pages'] ?? 1;
      currentPage.value = page;
      hasMoreData.value = currentPage.value < totalPages.value;

      print("📄 Page $currentPage of $totalPages | Has more: $hasMoreData");

      if (translatedVerses.isEmpty) {
        print("🚨 No translated ayahs found for Surah $surahId on page $page.");
        if (page == 1) {
          ayahList.value = [];
        }
        return;
      }

      // ✅ Filter Arabic text for only the selected Surah
      final filteredArabicVerses = arabicVerses.where((a) {
        bool isMatching = a['verse_key'] != null &&
                          a['verse_key'].toString().startsWith('$surahId:');
        return isMatching;
      }).toList();

      print("✅ Filtered Arabic Verses Count: ${filteredArabicVerses.length}");

      if (filteredArabicVerses.isEmpty) {
        print("🚨 No matching Arabic verses found for Surah $surahId.");
      }

      // Combine Arabic, translation, and audio
      final newAyahs = translatedVerses.map((verse) {
        // Find matching Arabic verse
        final arabicVerse = filteredArabicVerses.firstWhere(
          (a) => a['verse_key'] == verse['verse_key'],
          orElse: () => null,
        );

        return {
          'verse_number': verse['verse_number'],
          'verse_key': verse['verse_key'],
          'text_uthmani': arabicVerse?['text_uthmani'] ?? 'N/A', // Arabic text
          'translation': (verse['translations']?.isNotEmpty ?? false)
              ? removeHtmlTags(verse['translations'][0]['text'])
              : 'No translation available',
          'audio_url': verse['audio']?['url'] ?? '', // Audio URL
        };
      }).toList();

      // Add new ayahs to existing list
      if (page == 1) {
        ayahList.value = newAyahs;
      } else {
        ayahList.addAll(newAyahs);
      }

      print("✅ Total Ayah List Count after page $page: ${ayahList.length}");
    } else {
      print("🚨 API Error: Status codes - Arabic: ${arabicResponse.statusCode}, Translations: ${translationResponse.statusCode}");
      if (page == 1) {
        ayahList.value = [];
      }
    }
  }

  // ✅ Fetch Para (Juz) List
  Future<void> fetchJuzs() async {
    try {
      isLoading(true);
      final response = await DioUtil.dio.get(RestConstants.juzs);

      if (response.statusCode == 200) {
        var juzsData = response.data['juzs'];

        // ✅ Ensure 'id' exists & filter Juzs with id ≤ 30
        juzList.value = juzsData
            .where((juz) => juz['id'] != null && juz['id'] is int && juz['id'] <= 30)
            .map((juz) {
          String firstSurah = juz['verse_mapping'].keys.first; // ✅ Extract first Surah number safely
          return {
            "id": juz['id'],
            "juz_number": juz['juz_number'],
            "first_surah": firstSurah,
            "verses_count": juz['verses_count'],
          };
        }).toList();
        
        print("✅ Successfully fetched Juzs: ${juzList.length}");
      } else {
        print("🚨 API Error: Status code ${response.statusCode}");
        juzList.value = [];
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch Juzs');
      print("❌ Error fetching Juzs: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchJuzAyahs(int juzId) async {
    try {
      isLoading.value = true;
      ayahList.clear();
      resetPagination();

      print("🔍 Fetching verses for Juz $juzId...");

      // Ensure surahList is populated before using it
      if (surahList.isEmpty) {
        await fetchSurahs();
      }

      // Get Juz Data
      final response = await DioUtil.dio.get(RestConstants.juzs);
      if (response.statusCode != 200) {
        print("🚨 Failed to fetch Juz data");
        return;
      }

      final juzData = response.data['juzs'].firstWhere(
        (juz) => juz['id'] == juzId,
        orElse: () => null,
      );

      if (juzData == null) {
        print("🚨 Juz $juzId not found in response");
        return;
      }

      Map<String, String> verseMapping = Map<String, String>.from(juzData['verse_mapping']);
      List<Map<String, dynamic>> allAyahs = [];

      // Fetch verses for each Surah in Juz - first page only
      for (var surahId in verseMapping.keys) {
        print("🔍 Fetching verses for Surah $surahId...");

        // Get Arabic text
        final arabicResponse = await DioUtil.dio.get(
            'https://api.quran.com/api/v4/quran/verses/uthmani');

        // Get Translations & Audio (first page only)
        final translationResponse = await DioUtil.dio.get(
          'https://api.quran.com/api/v4/verses/by_chapter/$surahId',
          queryParameters: {
            'translations': '131',
            'audio': '1',
            'page': 1,
            'per_page': 10 // Start with 10 per page
          },
        );

        if (arabicResponse.statusCode == 200 && translationResponse.statusCode == 200) {
          final arabicVerses = arabicResponse.data['verses'];
          final List<Map<String, dynamic>> translatedVerses =
              List<Map<String, dynamic>>.from(translationResponse.data['verses']);

          // Filter Arabic text for this Surah
          final filteredArabicVerses = arabicVerses.where((a) =>
              a['verse_key'] != null &&
              a['verse_key'].toString().startsWith('$surahId:')).toList();

          // Ensure Surah Name Mapping Works Properly
          final surah = surahList.firstWhere(
            (s) => s['id'].toString() == surahId.toString(),
            orElse: () => {'name_simple': 'Unknown Surah'},
          );

          String surahName = surah['name_simple'] ?? 'Unknown Surah';

          // Combine Arabic, translation, and audio
          final formattedVerses = translatedVerses.map((verse) {
            final arabicVerse = filteredArabicVerses.firstWhere(
              (a) => a['verse_key'] == verse['verse_key'],
              orElse: () => null,
            );

            return {
              'verse_number': verse['verse_number'],
              'verse_key': verse['verse_key'],
              'text_uthmani': arabicVerse?['text_uthmani'] ?? 'N/A',
              'translation': (verse['translations']?.isNotEmpty ?? false)
                  ? removeHtmlTags(verse['translations'][0]['text'])
                  : 'No translation available',
              'audio_url': verse['audio']?['url'] ?? '',
              'surah_name': surahName,
              'surah_id': surahId,
            };
          }).toList();

          allAyahs.addAll(formattedVerses);
        }
      }

      ayahList.assignAll(allAyahs);
      print("✅ Initial Ayah List Count for Juz $juzId: ${ayahList.length}");
      
      // Set hasMoreData to true if we have any surahs in this juz
      hasMoreData.value = verseMapping.isNotEmpty;
      
    } catch (e) {
      print("❌ Error fetching Juz Ayahs: $e");
      Get.snackbar('Error', 'Failed to fetch Juz Ayahs');
      ayahList.clear();
    } finally {
      isLoading.value = false;
      update();
    }
  }
  
  // ✅ Fetch more Juz Ayahs as user scrolls
  // ✅ Fetch more Juz Ayahs as user scrolls
Future<void> fetchMoreJuzAyahs(int juzId) async {
  if (isLoadingMore.value || !hasMoreData.value) return;
  
  try {
    isLoadingMore.value = true;
    currentPage.value++;
    
    print("🔍 Loading more ayahs for Juz $juzId (Page: $currentPage)...");
    
    // Get Juz Data to access verse mapping
    final juzResponse = await DioUtil.dio.get(RestConstants.juzs);
    if (juzResponse.statusCode != 200) {
      print("🚨 Failed to fetch Juz data");
      return;
    }

    final juzData = juzResponse.data['juzs'].firstWhere(
      (juz) => juz['id'] == juzId,
      orElse: () => null,
    );

    if (juzData == null) {
      print("🚨 Juz $juzId not found in response");
      hasMoreData.value = false;
      return;
    }

    Map<String, String> verseMapping = Map<String, String>.from(juzData['verse_mapping']);
    List<Map<String, dynamic>> newAyahs = [];

    // Track if we found any data in this page
    bool foundNewData = false;

    // Fetch verses for each Surah in Juz for the current page
    for (var surahId in verseMapping.keys) {
      print("🔍 Fetching more verses for Surah $surahId (Page: $currentPage)...");

      // Get Arabic text - we need all verses as reference
      final arabicResponse = await DioUtil.dio.get(
          'https://api.quran.com/api/v4/quran/verses/uthmani');

      // Get Translations & Audio for current page
      final translationResponse = await DioUtil.dio.get(
        'https://api.quran.com/api/v4/verses/by_chapter/$surahId',
        queryParameters: {
          'translations': '131',
          'audio': '1',
          'page': currentPage.value,
          'per_page': 10 // 10 per page
        },
      );

      if (arabicResponse.statusCode == 200 && translationResponse.statusCode == 200) {
        final arabicVerses = arabicResponse.data['verses'];
        final List<Map<String, dynamic>> translatedVerses =
            List<Map<String, dynamic>>.from(translationResponse.data['verses']);

        // Skip if no translated verses found for this page
        if (translatedVerses.isEmpty) {
          print("⚠️ No translated ayahs found for Surah $surahId on page $currentPage");
          continue;
        }

        foundNewData = true;

        // Filter Arabic text for this Surah
        final filteredArabicVerses = arabicVerses.where((a) =>
            a['verse_key'] != null &&
            a['verse_key'].toString().startsWith('$surahId:')).toList();

        // Ensure Surah Name Mapping
        final surah = surahList.firstWhere(
          (s) => s['id'].toString() == surahId.toString(),
          orElse: () => {'name_simple': 'Unknown Surah'},
        );

        String surahName = surah['name_simple'] ?? 'Unknown Surah';

        // Check if these verses are already in our list
        final existingKeys = ayahList.map((a) => a['verse_key']).toSet();

        // Combine Arabic, translation, and audio
        final formattedVerses = translatedVerses.map((verse) {
          // Skip if we already have this verse
          if (existingKeys.contains(verse['verse_key'])) {
            return null;
          }

          final arabicVerse = filteredArabicVerses.firstWhere(
            (a) => a['verse_key'] == verse['verse_key'],
            orElse: () => null,
          );

          return {
            'verse_number': verse['verse_number'],
            'verse_key': verse['verse_key'],
            'text_uthmani': arabicVerse?['text_uthmani'] ?? 'N/A',
            'translation': (verse['translations']?.isNotEmpty ?? false)
                ? removeHtmlTags(verse['translations'][0]['text'])
                : 'No translation available',
            'audio_url': verse['audio']?['url'] ?? '',
            'surah_name': surahName,
            'surah_id': surahId,
          };
        }).where((v) => v != null).toList();

        newAyahs.addAll(formattedVerses.cast<Map<String, dynamic>>());
      }
    }

    // Add new unique ayahs to the list
    if (newAyahs.isNotEmpty) {
      ayahList.addAll(newAyahs);
      print("✅ Added ${newAyahs.length} new ayahs. Total: ${ayahList.length}");
    } else {
      print("ℹ️ No new ayahs found for this page");
    }

    // Determine if we have more data to load
    hasMoreData.value = foundNewData && newAyahs.isNotEmpty;
    
    if (!hasMoreData.value) {
      print("🏁 No more ayahs to load for Juz $juzId");
    }
    
  } catch (e) {
    print("❌ Error fetching more Juz Ayahs: $e");
    Get.snackbar('Error', 'Failed to load more Ayahs');
  } finally {
    isLoadingMore.value = false;
    update(); // Refresh UI
  }
}

  // ✅ Fetch Hizb List
  Future<void> fetchHizbs() async {
    try {
      isLoading(true);
      final response = await DioUtil.dio.get(RestConstants.hizbs);
      if (response.statusCode == 200) {
        var hizbsData = response.data['hizbs'];
        hizbList.value = hizbsData.map((hizb) {
          String firstSurah = hizb['verse_mapping'].keys.first; // ✅ Extract first Surah number
          return {
            "id": hizb['id'],
            "hizb_number": hizb['hizb_number'],
            "first_surah": firstSurah,
            "verses_count": hizb['verses_count'],
          };
        }).toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch Hizbs');
    } finally {
      isLoading(false);
    }
  }
}