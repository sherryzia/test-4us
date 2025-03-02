import 'package:get/get.dart';

class SalahController extends GetxController {
  var isLoading = true.obs;
  var salahSteps = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadSalahGuide();
  }

  void loadSalahGuide() async {
    isLoading.value = true;
    salahSteps.value = [
      {
        'title': 'Niyyah (Intention)',
        'description': 'Before you begin Salah, make your intention clear in your heart.',
        'dua': '',
        'translation': '',
      },
      {
        'title': 'Takbiratul Ihram (Allahu Akbar)',
        'description': 'Raise your hands and say "Allahu Akbar" (Allah is the Greatest).',
        'dua': 'اللهُ أَكْبَرُ',
        'translation': 'Allah is the Greatest.',
      },
      {
        'title': 'Opening Dua (Subhanaka)',
        'description': 'Recite the opening supplication silently in the first Rak\'ah.',
        'dua': '''
          سبحانك اللهم و بحمدك، و تبارك اسمك، و تعالى جدك، ولا إله غيرك
        ''',
        'translation': '''
          O Allah, how perfect You are and praise be to You. Blessed is Your name, and exalted is Your majesty. There is no god but You.
        ''',
      },
      {
        'title': 'Ta’awwudh & Tasmiyah',
        'description': 'Seek refuge from Shaytan and begin in the name of Allah.',
        'dua': '''
          أعوذ بالله من الشيطان الرجيم
          بسم الله الرحمن الرحيم
        ''',
        'translation': '''
          I seek refuge in Allah from the rejected Satan.
          In the name of Allah, the Most Gracious, the Most Merciful.
        ''',
      },
      {
        'title': 'Surah Al-Fatiha',
        'description': 'Recite Surah Al-Fatiha, the opening chapter of the Quran.',
        'dua': '''
          ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَـٰلَمِينَ
          ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ
          مَـٰلِكِ يَوْمِ ٱلدِّينِ
          إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ
          ٱهْدِنَا ٱلصِّرَٰطَ ٱلْمُسْتَقِيمَ
          صِرَٰطَ ٱلَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ ٱلْمَغْضُوبِ عَلَيْهِمْ وَلَا ٱلضَّآلِّينَ
        ''',
        'translation': '''
          Praise be to Allah, the Lord of all the worlds.
          The Most Gracious, the Most Merciful.
          Master of the Day of Judgment.
          You alone we worship, and You alone we ask for help.
          Guide us on the Straight Path.
          The path of those who have received Your grace;
          Not the path of those who have brought down wrath upon themselves, nor of those who have gone astray.
        ''',
      },
      {
        'title': 'Recite a Short Surah',
        'description': 'After Al-Fatiha, recite another short Surah, such as Surah Al-Ikhlas.',
        'dua': '''
          بسم الله الرحمن الرحيم
          قل هوا لله أحد، الله الصمد، لم يلد و لم يولد، و لم يكن له كفوا أحد
        ''',
        'translation': '''
          In the name of Allah, the Most Gracious, the Most Merciful.
          Say, He is Allah, the One. Allah is Eternal and Absolute.
          He begets not, nor was He begotten. And there is none co-equal unto Him.
        ''',
      },
      {
        'title': 'Ruku (Bowing)',
        'description': 'Bow down and say "Subhana Rabbiyal Azim" three times.',
        'dua': 'سُبْحَانَ رَبِّيَ الْعَظِيمِ',
        'translation': 'Glory is to my Lord, the Most Great.',
      },
      {
        'title': 'Rising from Ruku',
        'description': 'Stand up from the bowing position and say:',
        'dua': '''
          سمع الله لمن حمده
          ربنا لك الحمد
        ''',
        'translation': '''
          Allah hears those who praise Him.
          Our Lord, praise be to You.
        ''',
      },
      {
        'title': 'Sujood (Prostration)',
        'description': 'Prostrate on the ground and say "Subhana Rabbiyal A’la" three times.',
        'dua': 'سُبْحَانَ رَبِّيَ الأَعْلَى',
        'translation': 'Glory is to my Lord, the Most High.',
      },
      {
        'title': 'Sitting between Sujood',
        'description': 'Sit upright and say:',
        'dua': 'رب اغفر لي',
        'translation': 'O my Lord! Forgive me.',
      },
      {
        'title': 'Second Sujood',
        'description': 'Repeat Sujood as before, saying "Subhana Rabbiyal A’la" three times.',
        'dua': 'سُبْحَانَ رَبِّيَ الأَعْلَى',
        'translation': 'Glory is to my Lord, the Most High.',
      },
      {
        'title': 'Tashahhud (Sitting Position)',
        'description': 'Recite the Tashahhud in the sitting position.',
        'dua': '''
          التحيات لله و الصلوات و الطيبات، السلام عليك أيها النبي ورحمة الله
          وبركاته، السلام علينا و على عباد الله الصالحين، أشهد أن لا إله إلا الله،
          وأشهد أن محمدا عبده و رسوله.
        ''',
        'translation': '''
          All greetings, prayers, and pure words are for Allah.
          Peace be on you, O Prophet, and the mercy of Allah and His blessings.
          Peace be on us and upon the righteous servants of Allah.
          I bear witness that there is no deity but Allah, and I bear witness that Muhammad is His servant and messenger.
        ''',
      },
      {
        'title': 'Salat Ibrahimiyyah',
        'description': 'In the last sitting of Salah, recite Salat Ibrahimiyyah.',
        'dua': '''
          اللهم صل على محمد وعلى آل محمد، كما صليت على إبراهيم وعلى آل إبراهيم،
          وبارك على محمد وعلى آل محمد، كما باركت على إبراهيم وعلى آل إبراهيم.
        ''',
        'translation': '''
          O Allah, let Your mercy come upon Muhammad and the family of Muhammad,
          as You let it come upon Ibrahim and the family of Ibrahim.
          O Allah, bless Muhammad and the family of Muhammad,
          as You blessed Ibrahim and the family of Ibrahim.
        ''',
      },
      {
        'title': 'Tasleem (Ending the Prayer)',
        'description': 'Turn your head to the right and say "Assalamu Alaikum wa Rahmatullah", then to the left and repeat.',
        'dua': '''
          السلام عليكم ورحمة الله
        ''',
        'translation': '''
          Peace and the mercy of Allah be upon you.
        ''',
      },
    ];
    isLoading.value = false;
  }
}
