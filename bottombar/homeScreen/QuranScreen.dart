import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/constants/app_colors.dart';
import 'package:quran_app/controllers/GlobalController.dart';
import 'package:quran_app/controllers/QuranController.dart';
import 'package:quran_app/utilities/shared_preferences_util.dart';
import 'package:quran_app/view/bottombar/homeScreen/HizbDetailPage.dart';
import 'package:quran_app/view/bottombar/homeScreen/JuzDetailScreen.dart';
import 'package:quran_app/view/bottombar/homeScreen/surahDetail.dart';
import 'package:quran_app/view/widgets/appBar.dart';
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

  var lastReadSurah = "Al-Fatiha".obs;
  var lastReadSurahNumber = "1".obs;
  int _selectedTabIndex = 0;
  
  // View mode preferences (true = grid view, false = list view)
  final RxBool _surahGridView = true.obs;
  final RxBool _paraGridView = true.obs;
  final RxBool _hizbGridView = true.obs;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });

    loadLastRead();
    _loadViewPreferences();
  }
  
  Future<void> _loadViewPreferences() async {
    // Load saved view preferences
    bool? surahGrid = await SharedPreferencesUtil.getData<bool>("surah_grid_view");
    bool? paraGrid = await SharedPreferencesUtil.getData<bool>("para_grid_view");
    bool? hizbGrid = await SharedPreferencesUtil.getData<bool>("hizb_grid_view");
    
    // Apply preferences if they exist, otherwise keep defaults
    if (surahGrid != null) _surahGridView.value = surahGrid;
    if (paraGrid != null) _paraGridView.value = paraGrid;
    if (hizbGrid != null) _hizbGridView.value = hizbGrid;
  }
  
  Future<void> _saveViewPreference(String key, bool value) async {
    await SharedPreferencesUtil.saveData(key, value);
  }

  Future<void> loadLastRead() async {
    String? savedSurah =
        await SharedPreferencesUtil.getData<String>("last_read_surah");
    String? savedSurahNum =
        await SharedPreferencesUtil.getData<String>("last_read_surah_number");

    if (savedSurah != null && savedSurahNum != null) {
      lastReadSurah.value = savedSurah;
      lastReadSurahNumber.value = savedSurahNum;
    }
  }

  Future<void> saveLastRead(String surahName, String surahNumber,
      String surahSubtitle, String type, String versesCount) async {
    await SharedPreferencesUtil.saveData("last_read_surah", surahName);
    await SharedPreferencesUtil.saveData("last_read_surah_number", surahNumber);
    await SharedPreferencesUtil.saveData(
        "last_read_surah_subtitle", surahSubtitle);
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
      appBar: simpleAppBar2(centerTitle: true, title: 'Quran'),
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
                    labelColor: kDarkPurpleColor,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: kDarkPurpleColor,
                    indicatorWeight: 3,
                    labelStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
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
          body: Column(
            children: [
              _buildViewToggle(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Obx(() => _surahGridView.value ? _buildSurahGrid() : _buildSurahList()),
                    Obx(() => _paraGridView.value ? _buildParaGrid() : _buildParaList()),
                    Obx(() => _hizbGridView.value ? _buildHizbGrid() : _buildHizbList()),
                  ],
                ),
              ),
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
          const SizedBox(height: 16),
          Obx(() => LastReadCard(
                surahName: lastReadSurah.value,
                surahNumber: lastReadSurahNumber.value,
              )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
  
  Widget _buildViewToggle() {
    RxBool currentViewMode;
    String preferenceKey;
    
    // Determine which tab is active to get the right view mode
    switch (_selectedTabIndex) {
      case 0:
        currentViewMode = _surahGridView;
        preferenceKey = "surah_grid_view";
        break;
      case 1:
        currentViewMode = _paraGridView;
        preferenceKey = "para_grid_view";
        break;
      case 2:
        currentViewMode = _hizbGridView;
        preferenceKey = "hizb_grid_view";
        break;
      default:
        currentViewMode = _surahGridView;
        preferenceKey = "surah_grid_view";
    }
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Obx(() => Container(
            decoration: BoxDecoration(
              color: kLightPurpleColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: kLightPurpleColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // List View Button
                InkWell(
                  onTap: () {
                    currentViewMode.value = false;
                    _saveViewPreference(preferenceKey, false);
                  },
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: !currentViewMode.value 
                          ? kDarkPurpleColor
                          : Colors.transparent,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(11),
                        bottomLeft: Radius.circular(11),
                      ),
                    ),
                    child: Icon(
                      Icons.view_list,
                      size: 20,
                      color: !currentViewMode.value 
                          ? Colors.white
                          : kDarkPurpleColor,
                    ),
                  ),
                ),
                
                // Grid View Button
                InkWell(
                  onTap: () {
                    currentViewMode.value = true;
                    _saveViewPreference(preferenceKey, true);
                  },
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: currentViewMode.value 
                          ? kDarkPurpleColor
                          : Colors.transparent,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(11),
                        bottomRight: Radius.circular(11),
                      ),
                    ),
                    child: Icon(
                      Icons.grid_view,
                      size: 20,
                      color: currentViewMode.value 
                          ? Colors.white
                          : kDarkPurpleColor,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  // SURAH VIEWS
  Widget _buildSurahGrid() {
  return Obx(() {
    if (quranController.isLoading.value) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.purple));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,  // Adjusted for more height
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: quranController.surahList.length,
      itemBuilder: (context, index) {
        final surah = quranController.surahList[index];
        return Card(
          elevation: 2,  // Subtle elevation
          shadowColor: kDarkPurpleColor.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () async {
              await saveLastRead(
                  surah['name_simple'],
                  surah['id'].toString(),
                  surah['translated_name']['name'],
                  surah['revelation_place'],
                  surah['verses_count'].toString());

              quranController.ayahList.clear();
              Get.to(() => SurahDetailPage(
                    surahId: surah['id'],
                    surahName: surah['name_simple'],
                    surahSubtitle: surah['translated_name']['name'],
                    type: surah['revelation_place'],
                    versesCount: surah['verses_count'].toString(),
                  ));
            },
            child: Column(
              children: [
                // Top section with surah number
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: kDarkPurpleColor.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: kDarkPurpleColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            surah['id'].toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        surah['revelation_place'].toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: kDarkPurpleColor,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Middle section with Arabic name
                Expanded(
                  child: Center(
                    child: Text(
                      surah['name_arabic'],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: kDarkPurpleColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                
                // Bottom section with English name and verses count
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 2,
                        offset: const Offset(0, -1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        surah['name_simple'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${surah['verses_count']} VERSES",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  });
}
  
  Widget _buildSurahList() {
    return Obx(() {
      if (quranController.isLoading.value) {
        return const Center(
            child: CircularProgressIndicator(color: Colors.purple));
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: quranController.surahList.length,
        itemBuilder: (context, index) {
          final surah = quranController.surahList[index];
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: kDarkPurpleColor.withOpacity(0.1), width: 1),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () async {
                await saveLastRead(
                    surah['name_simple'],
                    surah['id'].toString(),
                    surah['translated_name']['name'],
                    surah['revelation_place'],
                    surah['verses_count'].toString());

                quranController.ayahList.clear();
                Get.to(() => SurahDetailPage(
                      surahId: surah['id'],
                      surahName: surah['name_simple'],
                      surahSubtitle: surah['translated_name']['name'],
                      type: surah['revelation_place'],
                      versesCount: surah['verses_count'].toString(),
                    ));
              },
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, 
                  vertical: 8
                ),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: kDarkPurpleColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      surah['id'].toString(),
                      style: TextStyle(
                        color: kDarkPurpleColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  surah['name_simple'],
                  style: const TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold
                  ),
                ),
                subtitle: Text(
                  "${surah['revelation_place'].toUpperCase()} • ${surah['verses_count']} VERSES",
                  style: const TextStyle(
                    fontSize: 12, 
                    color: Colors.grey
                  ),
                ),
                trailing: Text(
                  surah['name_arabic'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kDarkPurpleColor,
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  // PARA/JUZ VIEWS
 Widget _buildParaGrid() {
  return Obx(() {
    if (quranController.isLoading.value) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.purple));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.9,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: quranController.juzList.length,
      itemBuilder: (context, index) {
        final juz = quranController.juzList[index];
        return Card(
          elevation: 2,
          shadowColor: Colors.blue.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
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
            child: Column(
              children: [
                // Top section
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            juz['juz_number'].toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Middle section with Arabic decorative element
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.auto_stories,
                          size: 36,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Juz ${juz['juz_number']}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Bottom section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 2,
                        offset: const Offset(0, -1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Text(
                      //   "Surah ${juz['first_surah']}",
                      //   style: const TextStyle(
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                      // const SizedBox(height: 2),
                      Text(
                        "${juz['verses_count']} Verses",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
        return const Center(
            child: CircularProgressIndicator(color: Colors.purple));
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: quranController.juzList.length,
        itemBuilder: (context, index) {
          final juz = quranController.juzList[index];
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 8),
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
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, 
                  vertical: 8
                ),
                leading: Container(
                  width: 40,
                  height: 40,
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
                  style: const TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold
                  ),
                ),
                subtitle: Text(
                  "Starts from Surah ${juz['first_surah']} | ${juz['verses_count']} Verses",
                  style: const TextStyle(
                    fontSize: 12, 
                    color: Colors.grey
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          );
        },
      );
    });
  }

  // HIZB VIEWS
  Widget _buildHizbGrid() {
  return Obx(() {
    if (quranController.isLoading.value) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.purple));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.9,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: quranController.hizbList.length,
      itemBuilder: (context, index) {
        final hizb = quranController.hizbList[index];
        return Card(
          elevation: 2,
          shadowColor: Colors.orange.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
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
            child: Column(
              children: [
                // Top section
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            hizb['id'].toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Middle section with decorative element
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.menu_book,
                          size: 36,
                          color: Colors.orange,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Hizb ${hizb['hizb_number']}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Bottom section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 2,
                        offset: const Offset(0, -1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Text(
                      //   "Surah ${hizb['first_surah']}",
                      //   style: const TextStyle(
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                      // const SizedBox(height: 2),
                      Text(
                        "${hizb['verses_count']} Verses",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  });
}
  
  Widget _buildHizbList() {
    return Obx(() {
      if (quranController.isLoading.value) {
        return const Center(
            child: CircularProgressIndicator(color: Colors.purple));
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: quranController.hizbList.length,
        itemBuilder: (context, index) {
          final hizb = quranController.hizbList[index];
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 8),
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
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, 
                  vertical: 8
                ),
                leading: Container(
                  width: 40,
                  height: 40,
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
                  style: const TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold
                  ),
                ),
                subtitle: Text(
                  "Starts from Surah ${hizb['first_surah']} | ${hizb['verses_count']} Verses",
                  style: const TextStyle(
                    fontSize: 12, 
                    color: Colors.grey
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
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
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
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