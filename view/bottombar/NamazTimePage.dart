import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/constants/app_colors.dart';
import 'package:quran_app/controllers/NamazController.dart';
import 'package:intl/intl.dart'; 

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

                // const SizedBox(height: 10),

                //change country and city container
                // 🔹 Location Display & Change Button
                Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    // 🔹 Location Icon + Country - City
    Row(
      children: [
        Icon(
          Icons.location_on_rounded,
          size: 18,
          color: kDarkPurpleColor,
        ),
        const SizedBox(width: 8),
        Text(
          "${namazController.selectedCountry} - ${namazController.selectedCity}",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: kDarkPurpleColor,
          ),
        ),
      ],
    ),

    // 🔹 Change Location Button
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


                // 🔹 **CSC Picker Plus for Dynamic City & Country Selection**

                Obx(() => namazController.changeCountry.value
                    ? Column(
                      children: [
                        _buildLocationSelector(),
                        const SizedBox(height: 16),
                      ],
                    )
                    : Container()),

                // const SizedBox(height: 24),
                // Date display box
                // Container(
                //   width: double.infinity,
                //   padding:
                //       const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                //   decoration: BoxDecoration(
                //     color: kDarkPurpleColor.withOpacity(0.05),
                //     borderRadius: BorderRadius.circular(12),
                //     border: Border.all(
                //       color: kDarkPurpleColor.withOpacity(0.1),
                //       width: 1,
                //     ),
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Row(
                //         children: [
                //           Icon(
                //             Icons.calendar_today_rounded,
                //             size: 18,
                //             color: kDarkPurpleColor,
                //           ),
                //           const SizedBox(width: 10),
                //           Text(
                //             "Today",
                //             style: TextStyle(
                //               fontSize: 16,
                //               fontWeight: FontWeight.w500,
                //               color: kDarkPurpleColor,
                //             ),
                //           ),
                //         ],
                //       ),
                //       Text(
                //         _getCurrentDate(),
                //         style: TextStyle(
                //           fontSize: 14,
                //           fontWeight: FontWeight.w500,
                //           color: kDarkPurpleColor,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                // const SizedBox(height: 24),

                // Next prayer highlight
                Obx(() {
                  if (!namazController.isLoading.value &&
                      namazController.prayerTimes.isNotEmpty) {
                    final nextPrayer = namazController.getNextPrayer(
                        namazController.prayerTimes.cast<String, String>());
                    if (nextPrayer != null) {
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 24),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF563C6A), // Dark Purple
                              Color(0xFF9D69A3), // Light Purple
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
                                      nextPrayer.key,
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
                    "All Prayer Times",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: kTextPrimary,
                    ),
                  ),
                ),

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

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: namazController.prayerTimes.length,
                    itemBuilder: (context, index) {
                      final entry =
                          namazController.prayerTimes.entries.elementAt(index);
                      final isNextPrayer = namazController.isNextPrayer(entry.key,
                          namazController.prayerTimes.cast<String, String>());

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
                            entry.key,
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
              ],
            ),
          ),
        ),
      ),
    );
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
      default:
        return Icons.access_time;
    }
  }

  Widget _buildLocationSelector() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: kLightPurpleColor.withOpacity(0.2), width: 1.5),
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
              namazController.selectedCity.value = "";
              namazController.fetchPrayerTimes();
            },
            onStateChanged: (value) {
              // Optional state selection
            },
            onCityChanged: (value) {
              if (value != null) {
                namazController.selectedCity.value = value;
                namazController.fetchPrayerTimes();
                namazController.changeCountry.value =
                    false; // 🔹 Hide selector after selection
              }
            },
          ),
        ],
      ),
    );
  }

}
