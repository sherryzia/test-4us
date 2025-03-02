import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:quran_app/utilities/dio_util.dart';
import 'dart:async'; // Added for Timer

class QiblaController extends GetxController {
  var qiblaDirection = 0.0.obs; // Stores Qibla direction in degrees
  var deviceHeading = 0.0.obs; // Stores device heading in degrees
  var isLoading = true.obs;
  var errorMessage = "".obs; // Store errors if any
  var isLocationTimeout = false.obs;
  Timer? _locationTimeoutTimer; // Timer for tracking location timeout

  @override
  void onInit() {
    super.onInit();
    requestLocationPermission(); // 🔹 Ask for permission on startup
  }

  // 🔹 Request Location Permission from User
  Future<void> requestLocationPermission() async {
    isLoading.value = true;
    errorMessage.value = "";
    isLocationTimeout.value = false;
    
    // Start timeout timer - if location isn't fetched within 10 seconds, show timeout message
    _startLocationTimeoutTimer();
    
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _cancelTimeoutTimer();
      errorMessage.value = "Location services are disabled! Please turn on location service then try again.";
      isLoading.value = false;
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _cancelTimeoutTimer();
        errorMessage.value = "⚠️ Location permission is required!";
        isLoading.value = false;
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _cancelTimeoutTimer();
      errorMessage.value = "⚠️ Location permission permanently denied. Enable it from settings!";
      isLoading.value = false;
      return;
    }

    // If permission granted, fetch Qibla direction
    _fetchQiblaDirection();
    _startCompassListener();
  }

  // New method to retry after timeout
  void retryLocationRequest() {
    requestLocationPermission();
  }

  // Start the 10-second timeout timer
  void _startLocationTimeoutTimer() {
    // Cancel any existing timer first
    _cancelTimeoutTimer();
    
    _locationTimeoutTimer = Timer(const Duration(seconds: 10), () {
      if (isLoading.value) {
        isLocationTimeout.value = true;
        print("⏱️ Location request timed out after 10 seconds");
      }
    });
  }

  // Cancel the timeout timer
  void _cancelTimeoutTimer() {
    _locationTimeoutTimer?.cancel();
    _locationTimeoutTimer = null;
  }

  // 🔹 Fetch Qibla Direction using API
  Future<void> _fetchQiblaDirection() async {
    try {
      Position position = await Geolocator.getCurrentPosition(); // Get user location
      print("📍 User Location: ${position.latitude}, ${position.longitude}");

      final response = await DioUtil.dio.get(
          "https://api.aladhan.com/v1/qibla/${position.latitude}/${position.longitude}");

      if (response.statusCode == 200) {
        double direction = response.data['data']['direction'];
        qiblaDirection.value = direction;
        print("✅ Qibla Direction: $direction°");
      } else {
        errorMessage.value = "❌ Failed to get Qibla direction (API Error)";
      }
      
      // Cancel timeout timer as we got a response
      _cancelTimeoutTimer();
      
    } catch (e) {
      // Only set error if it's not a timeout (timeout is handled separately)
      if (!isLocationTimeout.value) {
        errorMessage.value = "❌ Error fetching Qibla direction: $e";
        print("❌ Error: $e");
      }
      
      _cancelTimeoutTimer();
    } finally {
      isLoading.value = false;
    }
  }

  // 🔹 Start listening to Compass Sensor
  void _startCompassListener() {
    FlutterCompass.events?.listen((CompassEvent event) {
      if (event.heading != null) {
        deviceHeading.value = event.heading!;
        print("📍 Device Heading: ${event.heading}°");
      } else {
        errorMessage.value = "⚠️ Compass sensor not available on this device!";
      }
    });
  }
  
  @override
  void onClose() {
    _cancelTimeoutTimer();
    super.onClose();
  }
}