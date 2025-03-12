import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/constants/app_colors.dart';
import 'package:quran_app/controllers/NamazController.dart';

class NamazTimePage extends StatelessWidget {
  NamazTimePage({super.key});

  final NamazController namazController = Get.put(NamazController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundWhite, // White Background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 18),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enhanced Header
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: kLightPurpleColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: kChipBackground,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.access_time_rounded,
                              color: kDarkPurpleColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Today's Prayer Times",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: kDarkPurpleColor,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Keep track of your daily prayers",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: kTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Location Display & Change Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Location Icon + City - Country
                    Obx(() => Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 18,
                              color: kDarkPurpleColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "${namazController.selectedCity} - ${namazController.selectedCountry}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: kDarkPurpleColor,
                              ),
                            ),
                          ],
                        )),

                    // Change Location Button
                    TextButton.icon(
                      onPressed: () {
                        namazController.changeCountry.toggle();
                      },
                      icon: Icon(
                        Icons.edit_location_alt_rounded,
                        size: 18,
                        color: kDarkPurpleColor,
                      ),
                      label: Text(
                        "Change",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: kDarkPurpleColor,
                        ),
                      ),
                    ),
                  ],
                ),

                // CSC Picker for Location Selection
                Obx(() => namazController.changeCountry.value
                    ? Column(
                        children: [
                          _buildLocationSelector(),
                          const SizedBox(height: 16),
                        ],
                      )
                    : Container()),

                // Prayer Method Display
                
                // Next prayer highlight
                Obx(() {
                  if (!namazController.isLoading.value &&
                      namazController.prayerTimes.isNotEmpty) {
                    final nextPrayer = namazController.getNextPrayer();
                    if (nextPrayer != null) {
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 24),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Colors.purple,
                              Colors.deepPurple
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: kDarkPurpleColor.withOpacity(0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.notifications_active_rounded,
                                    color: kWhite,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "Next Prayer",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: kWhite.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      _getPrayerIcon(nextPrayer.key),
                                      color: kWhite,
                                      size: 32,
                                    ),
                                    const SizedBox(width: 14),
                                    Text(
                                      _formatPrayerName(nextPrayer.key),
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: kWhite,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: kWhite.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    nextPrayer.value,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: kWhite,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              namazController.getTimeUntil(nextPrayer.value),
                              style: TextStyle(
                                fontSize: 14,
                                color: kWhite.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                  return const SizedBox.shrink();
                }),

                // Section title for all prayer times
                Padding(
                  padding: const EdgeInsets.only(bottom: 16, left: 4),
                  child: Text(
                    "Upcoming Prayer Schedule",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: kTextPrimary,
                    ),
                  ),
                ),

                // // Date display for today
                // Obx(() => !namazController.isLoading.value && 
                //     namazController.todayDate.value.isNotEmpty
                //     ? Container(
                //         width: double.infinity,
                //         padding: const EdgeInsets.symmetric(
                //             vertical: 10, horizontal: 16),
                //         margin: const EdgeInsets.only(bottom: 16),
                //         decoration: BoxDecoration(
                //           color: kDarkPurpleColor.withOpacity(0.05),
                //           borderRadius: BorderRadius.circular(12),
                //           border: Border.all(
                //             color: kDarkPurpleColor.withOpacity(0.1),
                //             width: 1,
                //           ),
                //         ),
                //         child: Row(
                //           children: [
                //             Icon(
                //               Icons.calendar_today_rounded,
                //               size: 18,
                //               color: kDarkPurpleColor,
                //             ),
                //             const SizedBox(width: 12),
                //             Text(
                //               namazController.todayDate.value,
                //               style: TextStyle(
                //                 fontSize: 14,
                //                 fontWeight: FontWeight.w500,
                //                 color: kDarkPurpleColor,
                //               ),
                //             ),
                //           ],
                //         ),
                //       )
                //     : const SizedBox.shrink()),

                // Prayer Times List
                Obx(() {
                  if (namazController.isLoading.value) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: CircularProgressIndicator(
                          color: kDarkPurpleColor,
                        ),
                      ),
                    );
                  }

                  if (namazController.prayerTimes.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.warning_rounded,
                                size: 36,
                                color: Colors.amber.shade700,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No prayer times available",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: kTextSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Please check your location settings",
                              style: TextStyle(
                                fontSize: 14,
                                color: kTextSecondary.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Filter prayer times to display only what we need
                  final displayTimes = {
                    'fajr': namazController.prayerTimes['fajr'],
                    'dhuhr': namazController.prayerTimes['dhuhr'],
                    'asr': namazController.prayerTimes['asr'],
                    'maghrib': namazController.prayerTimes['maghrib'],
                    'isha': namazController.prayerTimes['isha'],
                  };

                  // Add sunrise time if available
                  if (namazController.prayerTimes.containsKey('shurooq')) {
                    displayTimes['shurooq'] = namazController.prayerTimes['shurooq'];
                  }

                  // Sort the prayer times in chronological order
                  final orderedKeys = ['fajr', 'shurooq', 'dhuhr', 'asr', 'maghrib', 'isha'];
                  final sortedEntries = orderedKeys
                      .where((key) => displayTimes.containsKey(key))
                      .map((key) => MapEntry(key, displayTimes[key]!))
                      .toList();

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sortedEntries.length,
                    itemBuilder: (context, index) {
                      final entry = sortedEntries[index];
                      final isNextPrayer = namazController.isNextPrayer(entry.key);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: isNextPrayer
                              ? kChipBackground.withOpacity(0.7)
                              : kBackgroundWhite,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: kShadowColor.withOpacity(0.07),
                              blurRadius: 8,
                              spreadRadius: 0,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border: Border.all(
                            color: isNextPrayer
                                ? kDarkPurpleColor.withOpacity(0.2)
                                : kLightGray.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          leading: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isNextPrayer
                                  ? kDarkPurpleColor.withOpacity(0.1)
                                  : kLightGray.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getPrayerIcon(entry.key),
                              color: isNextPrayer
                                  ? kDarkPurpleColor
                                  : kTextSecondary,
                              size: 24,
                            ),
                          ),
                          title: Text(
                            _formatPrayerName(entry.key),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isNextPrayer
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: isNextPrayer
                                  ? kDarkPurpleColor
                                  : kTextPrimary,
                            ),
                          ),
                          subtitle: isNextPrayer
                              ? Text(
                                  "Coming up next",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: kDarkPurpleColor.withOpacity(0.7),
                                  ),
                                )
                              : null,
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isNextPrayer
                                  ? kDarkPurpleColor
                                  : kLightPurpleColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              entry.value,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isNextPrayer ? kWhite : kDarkPurpleColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),


                // Additional location info if available
                // Additional location info if available
Obx(() => namazController.locationInfo.isNotEmpty
    ? Container(
        margin: const EdgeInsets.only(top: 16, bottom: 24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: kBackgroundWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: kShadowColor.withOpacity(0.07),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: kLightGray.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: kDarkPurpleColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.map_rounded,
                    size: 20,
                    color: kDarkPurpleColor,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Location Information",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: kDarkPurpleColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Responsive grid layout
            LayoutBuilder(
              builder: (context, constraints) {
                // Calculate the optimal width for the info items
                final availableWidth = constraints.maxWidth;
                final itemCount = [
                  namazController.locationInfo.containsKey('qibla_direction'),
                  namazController.locationInfo.containsKey('timezone'),
                  namazController.locationInfo.containsKey('today_weather') && 
                      namazController.locationInfo['today_weather'] is Map,
                ].where((check) => check).length;
                
                // If screen is narrow or has many items, use a vertical layout
                final isNarrow = availableWidth < 300;
                final shouldStack = isNarrow || itemCount > 2;
                
                if (shouldStack) {
                  // Stack items vertically with full width
                  return Column(
                    children: [
                      if (namazController.locationInfo.containsKey('qibla_direction'))
                        _buildInfoItemResponsive(
                          Icons.compass_calibration_rounded,
                          "Qibla Direction",
                          "${namazController.locationInfo['qibla_direction']}°",
                          double.infinity,
                        ),
                      if (namazController.locationInfo.containsKey('timezone'))
                        _buildInfoItemResponsive(
                          Icons.access_time_rounded,
                          "Timezone",
                          "GMT+${namazController.locationInfo['timezone']}",
                          double.infinity,
                        ),
                      if (namazController.locationInfo.containsKey('today_weather') &&
                          namazController.locationInfo['today_weather'] is Map)
                        _buildInfoItemResponsive(
                          Icons.thermostat_rounded,
                          "Temperature",
                          "${namazController.locationInfo['today_weather']['temperature']}°C",
                          double.infinity,
                        ),
                    ].expand((widget) => [widget, const SizedBox(height: 10)]).toList()..removeLast(),
                  );
                } else {
                  // Arrange items in a responsive grid
                  final width = (availableWidth - 10) / 2;
                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      if (namazController.locationInfo.containsKey('qibla_direction'))
                        _buildInfoItemResponsive(
                          Icons.compass_calibration_rounded,
                          "Qibla Direction",
                          "${namazController.locationInfo['qibla_direction']}°",
                          width,
                        ),
                      if (namazController.locationInfo.containsKey('timezone'))
                        _buildInfoItemResponsive(
                          Icons.access_time_rounded,
                          "Timezone",
                          "GMT+${namazController.locationInfo['timezone']}",
                          width,
                        ),
                      if (namazController.locationInfo.containsKey('today_weather') &&
                          namazController.locationInfo['today_weather'] is Map)
                        _buildInfoItemResponsive(
                          Icons.thermostat_rounded,
                          "Temperature",
                          "${namazController.locationInfo['today_weather']['temperature']}°C",
                          width,
                        ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      )
    : const SizedBox.shrink()),


                    Obx(() => namazController.prayerMethodName.value.isNotEmpty
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        margin: const EdgeInsets.only(top: 8, bottom: 16),
                        decoration: BoxDecoration(
                          color: kLightPurpleColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: kLightPurpleColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 20,
                              color: kDarkPurpleColor,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "Method: ${namazController.prayerMethodName.value}",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: kDarkPurpleColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink()),

              ],
            ),
          ),
        ),
      ),
    );
  }


//Helper Widgets 


// Responsive info item with customizable width
Widget _buildInfoItemResponsive(IconData icon, String label, String value, double width) {
  // Create different shades of purple based on the icon type for subtle variation
  Color accentColor;
  List<Color> gradientColors;
  
  // Assign different purple shades based on icon type for subtle visual variety
  if (icon == Icons.compass_calibration_rounded) {
    accentColor = const Color(0xFF6A35CE); // Deep purple
    gradientColors = [const Color(0xFFF0EBFF), const Color(0xFFEAE0FF)];
  } else if (icon == Icons.access_time_rounded) {
    accentColor = const Color(0xFF8652E5); // Medium purple
    gradientColors = [const Color(0xFFF5EDFF), const Color(0xFFEEE3FF)];
  } else if (icon == Icons.thermostat_rounded) {
    accentColor = const Color(0xFF9C6AE5); // Light purple
    gradientColors = [const Color(0xFFF8F2FF), const Color(0xFFF3E8FF)];
  } else {
    accentColor = kDarkPurpleColor;
    gradientColors = [kLightPurpleColor.withOpacity(0.08), kLightPurpleColor.withOpacity(0.2)];
  }

  return Container(
    width: width,
    margin: const EdgeInsets.symmetric(vertical: 4),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: gradientColors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: accentColor.withOpacity(0.1),
          blurRadius: 12,
          spreadRadius: 0,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Stack(
      children: [
        // Decorative elements using purple shades
        Positioned(
          right: -15,
          top: -15,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          right: 20,
          bottom: -20,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
          ),
        ),
        
        // Main content
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            children: [
              // Stylized icon container
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: accentColor.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: accentColor,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Text content with purple theming
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: accentColor.withOpacity(0.7),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
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

  Widget _buildLocationSelector() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kLightPurpleColor.withOpacity(0.2), width: 1.5),
        color: kBackgroundWhite,
        boxShadow: [
          BoxShadow(
            color: kShadowColor.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                color: kDarkPurpleColor,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                "Select Location",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: kDarkPurpleColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CSCPickerPlus(
            layout: Layout.vertical,
            dropdownDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE4E4E4)),
            ),
            showStates: true,
            showCities: true,
            flagState: CountryFlag.ENABLE,
            countrySearchPlaceholder: "Search Country",
            stateSearchPlaceholder: "Search State",
            citySearchPlaceholder: "Search City",
            selectedItemStyle: const TextStyle(
              color: Color(0xFF672CBC),
              fontWeight: FontWeight.w500,
            ),
            dropdownHeadingStyle: TextStyle(
              color: kDarkPurpleColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            onCountryChanged: (value) {
              namazController.selectedCountry.value =
                  value.replaceAll(RegExp(r'[^A-Za-z ]'), '').trim();
            },
            onStateChanged: (value) {
              // Optional state selection
            },
            onCityChanged: (value) {
              if (value != null) {
                namazController.selectedCity.value = value;
                namazController.fetchPrayerTimes();
                namazController.changeCountry.value = false; // Hide selector after selection
              }
            },
          ),
        ],
      ),
    );
  }
}