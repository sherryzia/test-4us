import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:quran_app/MainScreen.dart';
import 'package:quran_app/constants/app_colors.dart';
import 'package:quran_app/controllers/GlobalController.dart';
import 'package:quran_app/controllers/QuranController.dart';
import 'package:quran_app/controllers/NamazController.dart';
import 'package:quran_app/controllers/navController.dart';
import 'package:quran_app/utilities/shared_preferences_util.dart';
import 'package:quran_app/view/AsmaUlHusna/AsmaAlHusnaScreen.dart';
import 'package:quran_app/view/AsmaUlNabi/AsmaUlNabi.dart';
import 'package:quran_app/view/bottombar/NamazTimePage.dart';
import 'package:quran_app/view/bottombar/QiblaPage.dart';
import 'package:quran_app/view/bottombar/bookmarkPage.dart';
import 'package:quran_app/view/bottombar/homeScreen/QuranScreen.dart';
import 'package:quran_app/view/hadeesScreens/hadithMain.dart';
import 'package:quran_app/view/widgets/cards.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalController globalController = Get.find<GlobalController>();
  final QuranController quranController = Get.find<QuranController>();
  final NamazController namazController = Get.put(NamazController());
      final NavController navController = Get.find<NavController>();

  final ScrollController _scrollController = ScrollController();

  // For last read surah
  var lastReadSurah = "Al-Fatiha".obs;
  var lastReadSurahNumber = "1".obs;

  @override
  void initState() {
    super.initState();
    loadLastRead();
    namazController.fetchPrayerTimes();
  }

  Future<void> loadLastRead() async {
    String? savedSurah = await SharedPreferencesUtil.getData<String>("last_read_surah");
    String? savedSurahNum = await SharedPreferencesUtil.getData<String>("last_read_surah_number");

    if (savedSurah != null && savedSurahNum != null) {
      lastReadSurah.value = savedSurah;
      lastReadSurahNumber.value = savedSurahNum;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              
              _buildLastReadSection(), // Surah card at top
              _buildNextPrayerSection(),
              _buildFeaturesGrid(),

              SizedBox(height: 80)
            ],
          ),
        ),
      ),
    );
  }





// Prayer time card between last read section and features
Widget _buildNextPrayerSection() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Next Prayer",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black87)),
            TextButton.icon(
              onPressed: () => Get.to(() => NamazTimePage()),
              icon: Icon(Icons.schedule, size: 18, color: Colors.blueGrey),
              label: Text("All Times", style: TextStyle(fontSize: 14, color: Colors.blueGrey)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Obx(() {
          if (!namazController.isLoading.value && namazController.prayerTimes.isNotEmpty) {
            final nextPrayer = namazController.getNextPrayer();
            if (nextPrayer != null) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 6)],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blueGrey.shade100,
                      child: Icon(_getPrayerIcon(nextPrayer.key), color: Colors.blueGrey.shade700),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_formatPrayerName(nextPrayer.key),
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87)),
                          const SizedBox(height: 2),
                          Text(namazController.getTimeUntil(nextPrayer.value),
                              style: TextStyle(fontSize: 13, color: Colors.black54)),
                        ],
                      ),
                    ),
                    Text(nextPrayer.value,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
                  ],
                ),
              );
            }
          }
          return _buildPrayerPlaceholder();
        }),
      ],
    ),
  );
}




  

  String _formatPrayerName(String name) {
    switch (name.toLowerCase()) {
      case 'fajr':
        return 'Fajr';
      case 'dhuhr':
        return 'Dhuhr';
      case 'asr':
        return 'Asr';
      case 'maghrib':
        return 'Maghrib';
      case 'isha':
        return 'Isha';
      case 'shurooq':
        return 'Sunrise';
      default:
        return name.capitalize ?? name;
    }
  }

  IconData _getPrayerIcon(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'fajr':
        return Icons.brightness_3;
      case 'dhuhr':
        return Icons.wb_sunny;
      case 'asr':
        return Icons.sunny;
      case 'maghrib':
        return Icons.nightlight_round;
      case 'isha':
        return Icons.nights_stay;
      case 'shurooq':
        return Icons.wb_sunny_outlined;
      default:
        return Icons.access_time;
    }
  }

// / Placeholder for prayer time when loading or no data available
Widget _buildPrayerPlaceholder() {
  return Container(
    width: double.infinity,
    height: 82,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: Colors.grey.shade300,
        width: 1,
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 20, 
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(kDarkPurpleColor),
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          "Loading prayer times...",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  );
}

  // Surah card at the top
  Widget _buildLastReadSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Continue Reading",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kTextPrimary,
                ),
              ),
              TextButton.icon(
                onPressed: () => Get.to(()=> BookmarkPage()),
                icon: Icon(Icons.bookmarks, size: 18, color: kDarkPurpleColor),
                label: Text(
                  "View All",
                  style: TextStyle(
                    fontSize: 14,
                    color: kDarkPurpleColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() => LastReadCard(
            surahName: lastReadSurah.value,
            surahNumber: lastReadSurahNumber.value,
          )),
        ],
      ),
    );
  }

   void _navigateToMainScreen(int index, NavController navController) {
    navController.changeIndex(index);
    Get.off(() => MainScreen());
  }

  Widget _buildFeaturesGrid() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Features",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kTextPrimary,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 0.85,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            children: [
              _buildFeatureItem(
                                svgPath: 'assets/images/b1.svg',
                                height: 30,

                iconFallback: Icons.menu_book,
                label: 'Quran',
                onTap: () => Get.to(() => QuranPage()),
                color: Colors.purple,
              ),
              _buildFeatureItem(
                iconFallback: Icons.explore,
                label: 'Qibla',
                onTap: () => _navigateToMainScreen(1, navController),
                color: Colors.blue,
              ),
              _buildFeatureItem(
                svgPath: 'assets/images/b3.svg',
                height: 30,
                iconFallback: Icons.waving_hand,
                label: 'Prayer',
                onTap: () => _navigateToMainScreen(2, navController),
                color: Colors.green,
              ),
              _buildFeatureItem(
                svgPath: 'assets/images/b4.svg',
                height: 30,
                iconFallback: Icons.format_quote,
                label: 'Duas',
                onTap: () => _navigateToMainScreen(3, navController),
                color: Colors.orange,
              ),
              _buildFeatureItem(
                iconFallback: Icons.access_time_filled,
                label: 'Namaz',
                onTap: () => Get.to(()=> NamazTimePage()),
                color: Colors.red,
              ),
              _buildFeatureItem(
                iconFallback: Icons.menu_book_outlined,
                label: 'Hadith',
                onTap: () => Get.to(()=> HadithMain()),
                color: Colors.teal,
              ),
              _buildFeatureItem(
                iconFallback: Icons.star,
                label: 'Asma ul Husna',
                onTap: () => Get.to(()=> AsmaAlHusnaScreen()),
                color: Colors.indigo,
              ),
              _buildFeatureItem(
                iconFallback: Icons.star,
                label: 'Asma ul Nabi',
                onTap: () => Get.to(()=>AsmaUlNabiScreen()),
                color: Colors.amber,
              ),
              _buildFeatureItem(
                iconFallback: Icons.bookmark,
                label: 'Bookmarks\n',
                onTap: () => Get.to(()=> BookmarkPage()),
                color: Colors.lightBlue,
              ),
              
            ],
          ),
        ],
      ),
    );
  }

Widget _buildFeatureItem({
  required IconData iconFallback,
  required String label,
  required VoidCallback onTap,
  required Color color,
  String? imagePath,  // Optional image path
  String? svgPath,    // Optional SVG path
  double? width,      // Optional width for image/SVG
  double? height,     // Optional height for image/SVG
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: _buildIconOrImage(iconFallback, imagePath, svgPath, color, width, height),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color.darken(),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Handles dynamic loading of an icon, an image, or an SVG
Widget _buildIconOrImage(
    IconData icon, String? imagePath, String? svgPath, Color color, double? width, double? height) {
  final double defaultSize = 40; // Fallback size

  if (imagePath != null && imagePath.isNotEmpty) {
    return Image.asset(
      imagePath,
      width: width ?? defaultSize,
      height: height ?? defaultSize,
      fit: BoxFit.contain,
    );
  } else if (svgPath != null && svgPath.isNotEmpty) {
    return SvgPicture.asset(
      svgPath,
      width: width ?? defaultSize,
      height: height ?? defaultSize,
      color: color,
    );
  } else {
    return Icon(
      icon,
      size: width ?? 30, // Slightly smaller fallback size for icons
      color: color,
    );
  }
}


}

// Extension method to darken a color
extension ColorExtension on Color {
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}


class SurahItem extends StatelessWidget {
  final int surahNumber;
  final String name;
  final String verses;
  final String arabic;

  const SurahItem({
    super.key,
    required this.surahNumber,
    required this.name,
    required this.verses,
    required this.arabic,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.purple.shade50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            surahNumber.toString(),
            style: TextStyle(
              color: Colors.purple.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        verses,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      trailing: Text(
        arabic,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.purple.shade700,
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:quran_app/constants/app_colors.dart';
// import 'package:quran_app/controllers/GlobalController.dart';
// import 'package:quran_app/controllers/QuranController.dart';
// import 'package:quran_app/utilities/shared_preferences_util.dart';
// import 'package:quran_app/view/bottombar/homeScreen/HizbDetailPage.dart';
// import 'package:quran_app/view/bottombar/homeScreen/JuzDetailScreen.dart';
// import 'package:quran_app/view/bottombar/homeScreen/surahDetail.dart';
// import 'package:quran_app/view/widgets/cards.dart';
// import 'package:quran_app/view/widgets/my_text_widget.dart';
// import 'package:quran_app/view/widgets/search_bar.dart';

// class QuranPage extends StatefulWidget {
//   const QuranPage({super.key});

//   @override
//   _QuranPageState createState() => _QuranPageState();
// }

// class _QuranPageState extends State<QuranPage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final QuranController quranController = Get.put(QuranController());
//   final GlobalController globalController = Get.find<GlobalController>();
//   final ScrollController _scrollController = ScrollController();
//   bool isSearchBarVisible = false; // 🔹 State variable to manage visibility

//   // State variables for Last Read Surah
//   var lastReadSurah = "Al-Fatiha".obs;
//   var lastReadSurahNumber = "1".obs;
//   int _selectedTabIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     _tabController.addListener(() {
//       setState(() {
//         _selectedTabIndex = _tabController.index;
//       });
//     });

//     // Fetch Last Read Surah & Surah Number from SharedPreferences
//     loadLastRead();
//   }

//   Future<void> loadLastRead() async {
//     String? savedSurah =
//         await SharedPreferencesUtil.getData<String>("last_read_surah");
//     String? savedSurahNum =
//         await SharedPreferencesUtil.getData<String>("last_read_surah_number");
//     String? savedSurahSubtitle =
//         await SharedPreferencesUtil.getData<String>("last_read_surah_subtitle");
//     String? savedSurahType =
//         await SharedPreferencesUtil.getData<String>("last_read_surah_type");
//     String? savedSurahVerses =
//         await SharedPreferencesUtil.getData<String>("last_read_surah_verses");

//     if (savedSurah != null && savedSurahNum != null) {
//       lastReadSurah.value = savedSurah;
//       lastReadSurahNumber.value = savedSurahNum;
//     }
//   }

//   Future<void> saveLastRead(String surahName, String surahNumber,
//       String surahSubtitle, String type, String versesCount) async {
//     await SharedPreferencesUtil.saveData("last_read_surah", surahName);
//     await SharedPreferencesUtil.saveData("last_read_surah_number", surahNumber);
//     await SharedPreferencesUtil.saveData(
//         "last_read_surah_subtitle", surahSubtitle);
//     await SharedPreferencesUtil.saveData("last_read_surah_type", type);
//     await SharedPreferencesUtil.saveData("last_read_surah_verses", versesCount);

//     lastReadSurah.value = surahName;
//     lastReadSurahNumber.value = surahNumber;
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: NestedScrollView(
//           controller: _scrollController,
//           headerSliverBuilder: (context, innerBoxIsScrolled) {
//             return [
//               SliverToBoxAdapter(
//                 child: _buildHeader(),
//               ),
//               SliverPersistentHeader(
//                 delegate: _SliverAppBarDelegate(
//                   TabBar(
//                     controller: _tabController,
//                     labelColor: Colors.purple,
//                     unselectedLabelColor: Colors.grey,
//                     indicatorColor: Colors.purple,
//                     indicatorWeight: 3,
//                     labelStyle: const TextStyle(
//                         fontSize: 16, fontWeight: FontWeight.bold),
//                     unselectedLabelStyle: const TextStyle(fontSize: 14),
//                     tabs: const [
//                       Tab(text: "Surah"),
//                       Tab(text: "Para"),
//                       Tab(text: "Hizb"),
//                     ],
//                   ),
//                 ),
//                 pinned: true,
//               ),
//             ];
//           },
//           body: TabBarView(
//             controller: _tabController,
//             children: [
//               _buildSurahList(),
//               _buildParaList(),
//               _buildHijbList(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

  

//   Widget _buildHeader() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   MyText(
//                     text: 'Assalamualaikum',
//                     size: 18,
//                     weight: FontWeight.w500,
//                     color: kTextGrey,
//                   ),
//                   const SizedBox(height: 6),
//                   MyText(
//                     text: globalController.userName.value,
//                     size: 24,
//                     weight: FontWeight.w700,
//                     color: kBlack,
//                   ),
//                 ],
//               ),
//               // Search icon button to toggle visibility
//               InkWell(
//                 onTap: () {
//                   setState(() {
//                     isSearchBarVisible = !isSearchBarVisible; // 🔹 Toggle SearchBar visibility
//                   });
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.purple.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   padding: const EdgeInsets.all(10),
//                   child: const Icon(
//                     Icons.search,
//                     color: Colors.purple,
//                     size: 28,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),

//           // 🔹 Show SearchBar only when isSearchBarVisible is true
//           if (isSearchBarVisible) const EnhancedSearchBar(),

//           const SizedBox(height: 16),

//           // Last Read Card with elegant design
//           Obx(() => LastReadCard(
//                 surahName: lastReadSurah.value,
//                 surahNumber: lastReadSurahNumber.value,
//               )),

//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }



//   Widget _buildSurahList() {
//     return Obx(() {
//       if (quranController.isLoading.value) {
//         return const Center(
//             child: CircularProgressIndicator(color: Colors.purple));
//       }

//       return ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: quranController.surahList.length,
//         itemBuilder: (context, index) {
//           final surah = quranController.surahList[index];
//           return Card(
//             elevation: 0,
//             margin: const EdgeInsets.only(bottom: 12),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//               side: BorderSide(color: Colors.purple.withOpacity(0.1), width: 1),
//             ),
//             child: InkWell(
//               borderRadius: BorderRadius.circular(16),
//               onTap: () async {
//                 await saveLastRead(
//                     surah['name_simple'],
//                     surah['id'].toString(),
//                     surah['translated_name']['name'],
//                     surah['revelation_place'],
//                     surah['verses_count'].toString());

//                 quranController.ayahList.clear();
//                 Get.to(() => SurahDetailPage(
//                       surahId: surah['id'],
//                       surahName: surah['name_simple'],
//                       surahSubtitle: surah['translated_name']['name'],
//                       type: surah['revelation_place'],
//                       versesCount: surah['verses_count'].toString(),
//                     ));
//               },
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 child: SurahItem(
//                   surahNumber: surah['id'],
//                   name: surah['name_simple'],
//                   verses:
//                       "${surah['revelation_place'].toUpperCase()} • ${surah['verses_count']} VERSES",
//                   arabic: surah['name_arabic'],
//                 ),
//               ),
//             ),
//           );
//         },
//       );
//     });
//   }

//   Widget _buildParaList() {
//     return Obx(() {
//       if (quranController.isLoading.value) {
//         return const Center(
//             child: CircularProgressIndicator(color: Colors.purple));
//       }

//       return ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: quranController.juzList.length,
//         itemBuilder: (context, index) {
//           final juz = quranController.juzList[index];
//           return Card(
//             elevation: 0,
//             margin: const EdgeInsets.only(bottom: 12),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//               side: BorderSide(color: Colors.blue.withOpacity(0.1), width: 1),
//             ),
//             child: InkWell(
//               borderRadius: BorderRadius.circular(16),
//               onTap: () {
//                 Get.to(() => JuzDetailPage(
//                       juzId: juz['id'],
//                       juzNumber: juz['juz_number'],
//                       firstSurah: int.tryParse(juz['first_surah']) ?? 0,
//                       versesCount: juz['verses_count'].toString(),
//                     ));
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(4),
//                 child: ListTile(
//                   leading: Container(
//                     width: 44,
//                     height: 44,
//                     decoration: BoxDecoration(
//                       color: Colors.blue.shade100,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Center(
//                       child: Text(
//                         juz['juz_number'].toString(),
//                         style: const TextStyle(
//                           color: Colors.blue,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                   title: Text(
//                     "Juz ${juz['juz_number']}",
//                     style: const TextStyle(
//                         fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text(
//                     "Starts from Surah ${juz['first_surah']} | ${juz['verses_count']} Verses",
//                     style: const TextStyle(fontSize: 14, color: Colors.grey),
//                   ),
//                   trailing: const Icon(Icons.arrow_forward_ios,
//                       size: 16, color: Colors.grey),
//                 ),
//               ),
//             ),
//           );
//         },
//       );
//     });
//   }

//   Widget _buildHijbList() {
//     return Obx(() {
//       if (quranController.isLoading.value) {
//         return const Center(
//             child: CircularProgressIndicator(color: Colors.purple));
//       }

//       return ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: quranController.hizbList.length,
//         itemBuilder: (context, index) {
//           final hizb = quranController.hizbList[index];
//           return Card(
//             elevation: 0,
//             margin: const EdgeInsets.only(bottom: 12),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//               side: BorderSide(color: Colors.orange.withOpacity(0.1), width: 1),
//             ),
//             child: InkWell(
//               borderRadius: BorderRadius.circular(16),
//               onTap: () {
//                 Get.to(() => HizbDetailPage(
//                       hizbId: hizb['id'],
//                       hizbNumber: hizb['hizb_number'],
//                       firstSurah: int.tryParse(hizb['first_surah']) ?? 0,
//                       versesCount: hizb['verses_count'].toString(),
//                     ));
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(4),
//                 child: ListTile(
//                   leading: Container(
//                     width: 44,
//                     height: 44,
//                     decoration: BoxDecoration(
//                       color: Colors.orange.shade100,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Center(
//                       child: Text(
//                         hizb['id'].toString(),
//                         style: const TextStyle(
//                           color: Colors.orange,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                   title: Text(
//                     "Hizb ${hizb['hizb_number']}",
//                     style: const TextStyle(
//                         fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text(
//                     "Starts from Surah ${hizb['first_surah']} | ${hizb['verses_count']} Verses",
//                     style: const TextStyle(fontSize: 14, color: Colors.grey),
//                   ),
//                   trailing: const Icon(Icons.arrow_forward_ios,
//                       size: 16, color: Colors.grey),
//                 ),
//               ),
//             ),
//           );
//         },
//       );
//     });
//   }
// }

// class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
//   final TabBar tabBar;

//   _SliverAppBarDelegate(this.tabBar);

//   @override
//   double get minExtent => tabBar.preferredSize.height;

//   @override
//   double get maxExtent => tabBar.preferredSize.height;

//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(
//       color: Colors.white,
//       child: tabBar,
//     );
//   }

//   @override
//   bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
//     return false;
//   }
// }

// class SurahItem extends StatelessWidget {
//   final int surahNumber;
//   final String name;
//   final String verses;
//   final String arabic;

//   const SurahItem({
//     super.key,
//     required this.surahNumber,
//     required this.name,
//     required this.verses,
//     required this.arabic,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: Container(
//         width: 44,
//         height: 44,
//         decoration: BoxDecoration(
//           color: Colors.purple.shade50,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Center(
//           child: Text(
//             surahNumber.toString(),
//             style: TextStyle(
//               color: Colors.purple.shade700,
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//             ),
//           ),
//         ),
//       ),
//       title: Text(
//         name,
//         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//       ),
//       subtitle: Text(
//         verses,
//         style: const TextStyle(fontSize: 12, color: Colors.grey),
//       ),
//       trailing: Text(
//         arabic,
//         style: TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//           color: Colors.purple.shade700,
//         ),
//       ),
//     );
//   }
// }
