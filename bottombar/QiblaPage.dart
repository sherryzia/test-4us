import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/constants/app_colors.dart';
import 'package:quran_app/controllers/QiblaController.dart';
import 'dart:math' as math;

class QiblaPage extends StatelessWidget {
  QiblaPage({super.key});

  final QiblaController qiblaController = Get.put(QiblaController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundWhite, // White Background
      
      body: SafeArea(
        child: Center(
          child: Obx(() {
            if (qiblaController.isLoading.value) {
              // Check if loading has been happening for too long
              if (qiblaController.isLocationTimeout.value) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_disabled,
                        size: 64,
                        color: Colors.amber.shade700, // Warning color
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Location service timed out.\nPlease turn on location service then try again.",
                        style: TextStyle(
                          color: kTextPrimary,
                          fontSize: 16,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => qiblaController.retryLocationRequest(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kDarkPurpleColor, // Main App Purple
                          foregroundColor: kWhite, // White Text
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Try Again",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                );
              }
              
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: kDarkPurpleColor, // Replaced Blue with App Purple
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Finding Qibla direction...\nPlease make sure your location is enabled",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kTextSecondary, // Gray Text Color
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              );
            }

            if (qiblaController.errorMessage.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_off,
                      size: 64,
                      color: Colors.red.shade300, // Keeping red for error
                    ),
                    const SizedBox(height: 16),
                    Text(
                      qiblaController.errorMessage.value,
                      style: TextStyle(
                        color: Colors.red.shade400, // Keeping red for error
                        fontSize: 16,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => qiblaController.requestLocationPermission(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kDarkPurpleColor, // Main App Purple
                        foregroundColor: kWhite, // White Text
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Try Again",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: kLightPurpleColor.withOpacity(0.3), // Soft Purple Background
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.compass_calibration,
                              color: kDarkPurpleColor, // Dark Purple Icon
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Align the Needle with the Kaaba",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: kDarkPurpleColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: kDarkPurpleColor.withOpacity(0.7),
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  "Keep your phone flat and parallel to the ground",
                                  style: TextStyle(
                                    color: kDarkPurpleColor.withOpacity(0.9),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Compass Container 
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kBackgroundWhite,
                      border: Border.all(
                        color: kLightGray, // Light Gray Border
                        width: 1,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background Compass Image
                        Image.asset(
                          'assets/images/compass.png',
                          width: 280,
                          height: 280,
                        ),

                        // Fixed Qibla Indicator
                        Positioned(
                          top: 20,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: kPurpleColor, // Main App Purple
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              'assets/images/kaaba.png',
                              width: 28,
                              height: 28,
                            ),
                          ),
                        ),

                        // Rotating Needle
                        Transform.rotate(
                          angle: (qiblaController.deviceHeading.value -
                                  qiblaController.qiblaDirection.value) *
                              (math.pi / 180),
                          child: Image.asset(
                            'assets/images/needle.png',
                            width: 200,
                            height: 200,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                  
                  // Direction Display
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: kLightPurpleColor.withOpacity(0.3), // Soft Purple Background
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.navigation,
                          color: kDarkPurpleColor, // Dark Purple Icon
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${qiblaController.qiblaDirection.value.toStringAsFixed(1)}°",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kDarkPurpleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}