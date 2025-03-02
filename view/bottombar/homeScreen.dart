import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/constants/app_colors.dart';
import 'package:quran_app/controllers/GlobalController.dart';
import 'package:quran_app/controllers/QuranController.dart';
import 'package:quran_app/utilities/shared_preferences_util.dart';
import 'package:quran_app/view/HizbDetailPage.dart';
import 'package:quran_app/view/JuzDetailScreen.dart';
import 'package:quran_app/view/surahDetail.dart';
import 'package:quran_app/view/widgets/cards.dart';
import 'package:quran_app/view/widgets/my_text_widget.dart';

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  _QuranPageState createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final QuranController quranController = Get.put(QuranController());
  final GlobalController globalController = Get.find<GlobalController>();
  final ScrollController _scrollController = ScrollController();

  // State variables for Last Read Surah
  var lastReadSurah = "Al-Fatiha".obs;
  var lastReadSurahNumber = "1".obs;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
    
    // Fetch Last Read Surah & Surah Number from SharedPreferences
    loadLastRead();
  }

Future<void> loadLastRead() async {
  String? savedSurah = await SharedPreferencesUtil.getData<String>("last_read_surah");
  String? savedSurahNum = await SharedPreferencesUtil.getData<String>("last_read_surah_number");
  String? savedSurahSubtitle = await SharedPreferencesUtil.getData<String>("last_read_surah_subtitle");
  String? savedSurahType = await SharedPreferencesUtil.getData<String>("last_read_surah_type");
  String? savedSurahVerses = await SharedPreferencesUtil.getData<String>("last_read_surah_verses");

  if (savedSurah != null && savedSurahNum != null) {
    lastReadSurah.value = savedSurah;
    lastReadSurahNumber.value = savedSurahNum;
  }
}



  Future<void> saveLastRead(
  String surahName, 
  String surahNumber, 
  String surahSubtitle, 
  String type, 
  String versesCount
) async {
  await SharedPreferencesUtil.saveData("last_read_surah", surahName);
  await SharedPreferencesUtil.saveData("last_read_surah_number", surahNumber);
  await SharedPreferencesUtil.saveData("last_read_surah_subtitle", surahSubtitle);
  await SharedPreferencesUtil.saveData("last_read_surah_type", type);
  await SharedPreferencesUtil.saveData("last_read_surah_verses", versesCount);

  lastReadSurah.value = surahName;
  lastReadSurahNumber.value = surahNumber;
}

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: _buildHeader(),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.purple,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.purple,
                    indicatorWeight: 3,
                    labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    unselectedLabelStyle: const TextStyle(fontSize: 14),
                    tabs: const [
                      Tab(text: "Surah"),
                      Tab(text: "Para"),
                      Tab(text: "Hizb"),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildSurahList(),
              _buildParaList(),
              _buildHijbList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: 'Assalamualaikum',
                    size: 18,
                    weight: FontWeight.w500,
                    color: kTextGrey,
                  ),
                  const SizedBox(height: 6),
                  MyText(
                    text: globalController.userName.value,
                    size: 24,
                    weight: FontWeight.w700,
                    color: kBlack,
                  ),
                ],
              ),
              // Container(
              //   decoration: BoxDecoration(
              //     color: Colors.purple.withOpacity(0.1),
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   padding: const EdgeInsets.all(10),
              //   child: const Icon(
              //     Icons.search,
              //     color: Colors.purple,
              //     size: 28,
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Last Read Card with elegant design
          Obx(() => _buildLastReadCard(
            surahName: lastReadSurah.value,
            surahNumber: lastReadSurahNumber.value,
          )),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLastReadCard({required String surahName, required String surahNumber}) {
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
         onTap: () async {
  // Retrieve additional details
  String? savedSurahSubtitle = await SharedPreferencesUtil.getData<String>("last_read_surah_subtitle");
  String? savedSurahType = await SharedPreferencesUtil.getData<String>("last_read_surah_type");
  String? savedSurahVerses = await SharedPreferencesUtil.getData<String>("last_read_surah_verses");

  quranController.ayahList.clear();
  Get.to(() => SurahDetailPage(
        surahId: int.parse(surahNumber),
        surahName: surahName,
        surahSubtitle: savedSurahSubtitle ?? "",
        type: savedSurahType ?? "",
        versesCount: savedSurahVerses ?? "",
      ));
},
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.bookmark,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Last Read",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Surah $surahName",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Surah $surahNumber",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Icon(
                      Icons.play_circle_filled,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "Continue Reading",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSurahList() {
    return Obx(() {
      if (quranController.isLoading.value) {
        return const Center(child: CircularProgressIndicator(color: Colors.purple));
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: quranController.surahList.length,
        itemBuilder: (context, index) {
          final surah = quranController.surahList[index];
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.purple.withOpacity(0.1), width: 1),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () async {
               await saveLastRead(
  surah['name_simple'], 
  surah['id'].toString(), 
  surah['translated_name']['name'], 
  surah['revelation_place'], 
  surah['verses_count'].toString()
);

                quranController.ayahList.clear();
                Get.to(() => SurahDetailPage(
                      surahId: surah['id'],
                      surahName: surah['name_simple'],
                      surahSubtitle: surah['translated_name']['name'],
                      type: surah['revelation_place'],
                      versesCount: surah['verses_count'].toString(),
                    ));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SurahItem(
                  surahNumber: surah['id'],
                  name: surah['name_simple'],
                  verses: "${surah['revelation_place'].toUpperCase()} • ${surah['verses_count']} VERSES",
                  arabic: surah['name_arabic'],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildParaList() {
    return Obx(() {
      if (quranController.isLoading.value) {
        return const Center(child: CircularProgressIndicator(color: Colors.purple));
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: quranController.juzList.length,
        itemBuilder: (context, index) {
          final juz = quranController.juzList[index];
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.blue.withOpacity(0.1), width: 1),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Get.to(() => JuzDetailPage(
                      juzId: juz['id'],
                      juzNumber: juz['juz_number'],
                      firstSurah: int.tryParse(juz['first_surah']) ?? 0,
                      versesCount: juz['verses_count'].toString(),
                    ));
              },
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: ListTile(
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        juz['juz_number'].toString(),
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    "Juz ${juz['juz_number']}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Starts from Surah ${juz['first_surah']} | ${juz['verses_count']} Verses",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildHijbList() {
    return Obx(() {
      if (quranController.isLoading.value) {
        return const Center(child: CircularProgressIndicator(color: Colors.purple));
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: quranController.hizbList.length,
        itemBuilder: (context, index) {
          final hizb = quranController.hizbList[index];
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.orange.withOpacity(0.1), width: 1),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Get.to(() => HizbDetailPage(
                      hizbId: hizb['id'],
                      hizbNumber: hizb['hizb_number'],
                      firstSurah: int.tryParse(hizb['first_surah']) ?? 0,
                      versesCount: hizb['verses_count'].toString(),
                    ));
              },
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: ListTile(
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        hizb['id'].toString(),
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    "Hizb ${hizb['hizb_number']}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Starts from Surah ${hizb['first_surah']} | ${hizb['verses_count']} Verses",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ),
              ),
            ),
          );
        },
      );
    });
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
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
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