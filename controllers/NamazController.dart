import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quran_app/controllers/GlobalController.dart';
import 'package:quran_app/utilities/dio_util.dart';

class NamazController extends GetxController {
  var prayerTimes = {}.obs;
  var isLoading = true.obs;
  var changeCountry = false.obs;
  var selectedCity = ''.obs; // City selection
  var selectedCountry = ''.obs; // Country selection
  final GlobalController globalController = Get.find();

  @override
  void onInit() {
    selectedCity.value = globalController.userCity.value; // Default: User's city
    selectedCountry.value = globalController.userCountry.value; // Default: User's country
    fetchPrayerTimes();
    super.onInit();
  }

  Future<void> fetchPrayerTimes() async {
    try {
      isLoading(true);
      final response = await DioUtil.dio.get(
        'https://api.aladhan.com/v1/timingsByCity',
        queryParameters: {
          'city': selectedCity.value,
          'country': selectedCountry.value,
          'method': 2, // ISNA Calculation Method
        },
      );

      if (response.statusCode == 200) {
        prayerTimes.value = response.data['data']['timings'];
      } else {
        Get.snackbar('Error', 'Failed to fetch prayer times');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch prayer times');
      print('Error fetching prayer times: $e');
    } finally {
      isLoading(false);
    }
  }

  void updateLocation(String city, String country) {
    selectedCity.value = city;
    selectedCountry.value = country;
    fetchPrayerTimes(); // Refresh prayer times
  }



  // Helper to get the next prayer (mock implementation)
  MapEntry<String, String>? getNextPrayer(Map<String, String> prayerTimes) {
  if (prayerTimes.isEmpty) return null;

  final now = DateTime.now();
  final format = DateFormat("HH:mm");

  MapEntry<String, String>? nextPrayer;

  for (var entry in prayerTimes.entries) {
    final prayerDateTime = format.parse(entry.value);
    final prayerTimeToday = DateTime(
      now.year,
      now.month,
      now.day,
      prayerDateTime.hour,
      prayerDateTime.minute,
    );

    if (prayerTimeToday.isAfter(now)) {
      nextPrayer = entry;
      break;
    }
  }

  // If all prayers have passed, set next prayer to Fajr of the next day
  nextPrayer ??= prayerTimes.entries.firstWhere(
    (entry) => entry.key.toLowerCase() == "fajr",
    orElse: () => prayerTimes.entries.first,
  );

  return nextPrayer;
}


  // Helper to check if this is the next prayer
  bool isNextPrayer(String prayerName, Map<String, String> prayerTimes) {
    final nextPrayer = getNextPrayer(prayerTimes);
    return nextPrayer != null && nextPrayer.key == prayerName;
  }

  // Helper to generate time until message (mock implementation)
  
String getTimeUntil(String prayerTime) {
  try {
    // Get current time
    final now = DateTime.now();

    // Parse the prayer time (assumes HH:mm format)
    final format = DateFormat("HH:mm");
    final prayerDateTime = format.parse(prayerTime);

    // Convert parsed time to today's date with correct time
    final nextPrayerTime = DateTime(
      now.year,
      now.month,
      now.day,
      prayerDateTime.hour,
      prayerDateTime.minute,
    );

    // If the next prayer time has already passed today, assume it's for tomorrow
    if (nextPrayerTime.isBefore(now)) {
      return "Prayer time has passed";
    }

    // Calculate time difference
    final difference = nextPrayerTime.difference(now);
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);

    // Return formatted remaining time
    return "Coming up in ${hours > 0 ? '$hours hr ' : ''}$minutes min";
  } catch (e) {
    print("Error parsing time: $e");
    return "Time unavailable";
  }
}


}
