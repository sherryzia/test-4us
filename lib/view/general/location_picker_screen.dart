import 'package:flutter/material.dart';
import 'package:forus_app/view/widget/my_text_field.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';
import 'package:forus_app/view/widget/common_image_view_widget.dart';
import 'package:forus_app/view/widget/my_button_widget.dart';
import 'package:forus_app/view/widget/my_text_widget.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/constants/app_fonts.dart';
import 'package:forus_app/generated/assets.dart';
import 'package:get/get.dart';

import '../../constants/app_sizes.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  String selectedAddress = "";
  LatLng _initialPosition = LatLng(37.7749, -122.4194); // Default to San Francisco
  LatLng? _selectedPosition;
  loc.Location _location = loc.Location();
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;

    // Check if location services are enabled
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    // Check for location permissions
    permissionGranted = await _location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) return;
    }

    // Get the current location
    final currentPosition = await _location.getLocation();
    setState(() {
      _initialPosition = LatLng(
        currentPosition.latitude ?? _initialPosition.latitude,
        currentPosition.longitude ?? _initialPosition.longitude,
      );
    });

    // Debug logs for initial location
    print("Initial Latitude: ${_initialPosition.latitude}, Longitude: ${_initialPosition.longitude}");
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks[0];
      setState(() {
        selectedAddress =
        "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        _selectedPosition = position;
      });

      // Debug logs for selected location
      print("Selected Latitude: ${position.latitude}, Longitude: ${position.longitude}");
      print("Selected Address: $selectedAddress");
    } catch (e) {
      print("Error fetching address: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemeColors.getTertiary(context),
        leading: InkWell(
          onTap: () {
            Get.back();
          },

          child: Padding(
            padding: const EdgeInsets.all(14),
            child: CommonImageView(
              imagePath: Assets.imagesArrowLeft,
              height: 24,
            ),
          ),
        ),
        title: MyText(
          text: "Confirm Business Location",
          size: 18,
          weight: FontWeight.w800,
          fontFamily: AppFonts.NUNITO_SANS,
        ),
        centerTitle: true,

      ),
      body: InkWell(
        onTap: () {
          showMapBottomSheet();
        },
        child: Container(
          padding: AppSizes.DEFAULT,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.imagesMap),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              MyTextField(
                hint: 'Search location ',
                hintColor: kTextGrey,
                labelColor: kWhite,
                radius: 8,
                prefix: Padding(
                  padding: const EdgeInsets.all(12),
                  child: CommonImageView(
                    imagePath: Assets.imagesSearchNormal,
                    height: 20,
                  ),
                ),
                filledColor: kTransperentColor,
                kBorderColor: kBorderGrey,
                kFocusBorderColor: KColor1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showMapBottomSheet() {
  Get.bottomSheet(
    isScrollControlled: false,
    Container(
      height: 200,
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        children: [
          Padding(
              padding: AppSizes.DEFAULT,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(24),
                  Row(
                    children: [
                      CommonImageView(
                        imagePath: Assets.imagesLocationPin,
                        height: 21,
                        width: 16,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MyText(
                            text: "Brooklyn Westernmost",
                            size: 16,
                            paddingRight: 8,
                            weight: FontWeight.w600,
                            fontFamily: AppFonts.NUNITO_SANS,
                          ),
                          MyText(
                            text: "Atlantic AveBay Shore, New York",
                            size: 13,
                            paddingLeft: 18,
                            color: kTextGrey,
                            weight: FontWeight.w500,
                            fontFamily: AppFonts.NUNITO_SANS,
                          ),
                        ],
                      )
                    ],
                  ),
                  Gap(20),
                  MyButton(
                      buttonText: "Confirm Address",
                      radius: 14,
                      textSize: 20,
                      weight: FontWeight.w800,
                      onTap: () {
                        // Get.to(() => ProviderAvailabiltyScreen());
                      }),
                ],
              )),
        ],
      ),
    ),
  );
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       backgroundColor: AppThemeColors.getTertiary(context),
  //       leading: InkWell(
  //         onTap: () {
  //           Get.back();
  //         },
  //         child: Padding(
  //           padding: const EdgeInsets.all(14),
  //           child: CommonImageView(
  //             imagePath: Assets.imagesArrowLeft,
  //             height: 24,
  //           ),
  //         ),
  //       ),
  //       title: MyText(
  //         text: "Confirm Business Location",
  //         size: 18,
  //         weight: FontWeight.w800,
  //         fontFamily: AppFonts.NUNITO_SANS,
  //       ),
  //     ),
  //     body: Stack(
  //       children: [
  //         GoogleMap(
  //           initialCameraPosition: CameraPosition(
  //             target: _initialPosition,
  //             zoom: 14,
  //           ),
  //           onMapCreated: (GoogleMapController controller) {
  //             _mapController = controller;
  //           },
  //           myLocationEnabled: true,
  //           myLocationButtonEnabled: true,
  //           onTap: (LatLng position) {
  //             _getAddressFromLatLng(position);
  //           },
  //           markers: _selectedPosition != null
  //               ? {
  //             Marker(
  //               markerId: MarkerId('selectedLocation'),
  //               position: _selectedPosition!,
  //             ),
  //           }
  //               : {},
  //         ),
  //         Positioned(
  //           top: 10,
  //           left: 15,
  //           right: 15,
  //           child: MyTextField(
  //             hint: 'Search location',
  //             hintColor: kTextGrey,
  //             labelColor: kWhite,
  //             radius: 8,
  //             prefix: Padding(
  //               padding: const EdgeInsets.all(12),
  //               child: CommonImageView(
  //                 imagePath: Assets.imagesSearchNormal,
  //                 height: 20,
  //               ),
  //             ),
  //             filledColor: kTransperentColor,
  //             kBorderColor: kBorderGrey,
  //             kFocusBorderColor: KColor1,
  //           ),
  //         ),
  //         if (_selectedPosition != null)
  //           Align(
  //             alignment: Alignment.bottomCenter,
  //             child: GestureDetector(
  //               onTap: () => showMapBottomSheet(),
  //               child: Container(
  //                 padding: EdgeInsets.all(16),
  //                 color: Colors.white,
  //                 child: Row(
  //                   children: [
  //                     Icon(Icons.location_on, color: kTextGrey),
  //                     SizedBox(width: 10),
  //                     Expanded(
  //                       child: MyText(
  //                         text: selectedAddress.isEmpty
  //                             ? "Fetching selected location details..."
  //                             : selectedAddress,
  //                         size: 14,
  //                         color: kTextGrey,
  //                       ),
  //                     ),
  //                     Icon(Icons.keyboard_arrow_up, color: kTextGrey),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //       ],
  //     ),
  //   );
  // }

  // void showMapBottomSheet() {
  //   Get.bottomSheet(
  //     isScrollControlled: false,
  //     Container(
  //       height: 250,
  //       decoration: BoxDecoration(
  //         color: kWhite,
  //         borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
  //       ),
  //       child: Column(
  //         children: [
  //           Padding(
  //             padding: AppSizes.DEFAULT,
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Gap(24),
  //                 Row(
  //                   children: [
  //                     CommonImageView(
  //                       imagePath: Assets.imagesLocationPin,
  //                       height: 21,
  //                       width: 16,
  //                     ),
  //                     SizedBox(width: 8),
  //                     Expanded(
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           MyText(
  //                             text: selectedAddress.isEmpty
  //                                 ? "Address not available"
  //                                 : selectedAddress,
  //                             size: 16,
  //                             weight: FontWeight.w600,
  //                             fontFamily: AppFonts.NUNITO_SANS,
  //                           ),
  //                         ],
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //                 Gap(20),
  //                 MyButton(
  //                   buttonText: "Confirm Address",
  //                   radius: 14,
  //                   textSize: 20,
  //                   weight: FontWeight.w800,
  //                   onTap: () {
  //
  //                     Get.back();
  //
  //                     Get.back(result: {
  //                       'lat': _selectedPosition!.latitude,
  //                       'lng': _selectedPosition!.longitude,
  //                       'address': selectedAddress,
  //                     });
  //
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}



