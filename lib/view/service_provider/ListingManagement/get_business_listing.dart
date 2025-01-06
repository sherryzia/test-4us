import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:forus_app/controllers/service_provider/BusinessManagement/BusinessController.dart';
import 'package:forus_app/controllers/service_provider/ListingManagement/BusinessListingController.dart';
import 'package:forus_app/controllers/service_provider/ListingManagement/ListingDetailController.dart';
import 'package:forus_app/utils/rest_endpoints.dart';
import 'package:forus_app/view/service_provider/ProviderBottomBarNav.dart';
import 'package:forus_app/view/widget/my_button_widget.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/constants/app_fonts.dart';
import 'package:forus_app/constants/app_sizes.dart';
import 'package:forus_app/generated/assets.dart';
import 'package:forus_app/view/widget/common_image_view_widget.dart';
import 'package:forus_app/view/widget/my_text_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'provider_edit_business_details.dart';

class GetBusinessListingScreen extends StatefulWidget {
  const GetBusinessListingScreen({super.key});

  @override
  State<GetBusinessListingScreen> createState() => _GetBusinessListingScreenState();
}

class _GetBusinessListingScreenState extends State<GetBusinessListingScreen> {
  final serviceId = Get.arguments['serviceId'];
  final List<dynamic> availabilities = Get.arguments['availabilities'] ?? [];
  final Map<int, bool> expandedState = {};
  final RxBool isDeleting = false.obs;

  final BusinessListingController controller = Get.put(BusinessListingController());
  final ListingDetailController listingDetailsController = Get.put(ListingDetailController());

  void _deleteService(String serviceId) async {
    // Show a confirmation dialog before deleting
    bool confirmDelete = await showDialog(
      context: context,
      barrierDismissible: false, // Prevent accidental dismiss
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icon and Title
              Column(
                children: [
                  Icon(
                    Icons.warning_rounded,
                    color: kTextDarkorange2,
                    size: 48,
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Delete Service?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Are you sure you want to delete this service? This action cannot be undone.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: MyButton(
                      buttonText: "Cancel",
                      bgColor: Colors.grey[300],
                      textColor: Colors.black87,
                      radius: 14,
                      textSize: 16,
                      weight: FontWeight.w600,
                      onTap: () => Navigator.of(context).pop(false),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: MyButton(
                      buttonText: "Delete",
                      bgColor: kTextDarkorange2,
                      textColor: Colors.white,
                      radius: 14,
                      textSize: 16,
                      weight: FontWeight.w600,
                      onTap: () => Navigator.of(context).pop(true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmDelete) {
      // Proceed with deletion
      if (isDeleting.value) return; // Prevent multiple taps
      isDeleting.value = true; // Set deleting state

      try {
        await controller.deleteBusinessListing(serviceId);

        // Close any dialogs and refresh the app
        Get.back(); // Close dialog
        Get.snackbar(
          "Success",
          "Your listing has been deleted successfully.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Refresh the app or specific page
        Get.offAll(() => ProviderBottomBarNav()); // Navigate to a fresh state of the app
      }

      catch (e) {
        Get.snackbar(
          "Error",
          "Failed to delete service. Please try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isDeleting.value = false; // Reset deleting state
      }
    }
  }

  void _updateService() {

    // Navigate to the update service screen or show a form
    Get.to(() => EditBusinessListingScreen(), arguments: {
      'servicePhoto': listingDetailsController.businessDetail['image'],
      'serviceName': listingDetailsController.businessDetail['name'],
      'serviceAbout': listingDetailsController.businessDetail['about'],
      'serviceIncludes': List<String>.from(listingDetailsController.businessDetail['includes']),
      'serviceAddress': listingDetailsController.businessDetail['address'],
      'serviceCountryCode': listingDetailsController.businessDetail['country_code'],
      'servicePhoneNumber': listingDetailsController.businessDetail['phone_number'],
      'serviceLatitude': listingDetailsController.businessDetail['lat'],
      'serviceLongitude': listingDetailsController.businessDetail['lng'],
      'serviceId': serviceId,
    });

  }


  @override
  void initState() {
    super.initState();
    listingDetailsController.fetchBusinessDetail(serviceId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemeColors.getTertiary(context),
        leading: InkWell(
          onTap: () => Get.back(),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: CommonImageView(
              imagePath: Assets.imagesArrowLeft,
              height: 24,
            ),
          ),
        ),
        actions: [
  Padding(
    padding: const EdgeInsets.all(12),
    child: Row(
      spacing: 11,
      children: [
        // InkWell(
        //   onTap: () {},
        //   child: CommonImageView(
        //     imagePath: Assets.imagesHeart,
        //     height: 24,
        //   ),
        // ),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == "Delete") {
              // Handle delete service
              _deleteService("$serviceId");
            } else if (value == "Update") {
              // Handle update service
              _updateService();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: "Delete",
              child: MyText(
                text: "Delete Service",
                size: 14,
                weight: FontWeight.w500,
              ),
            ),
            PopupMenuItem(
              value: "Update",
              child: MyText(
                text: "Update Service",
                size: 14,
                weight: FontWeight.w500,
              ),
            ),
          ],
          icon: CommonImageView(
            imagePath: Assets.imagesOptions,
            height: 24,
          ),
        ),
      ],
    ),
  ),
],

      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final data = listingDetailsController.businessDetail;
        if (data.isEmpty) {
          return Center(child: MyText(text: "No details available.", size: 16));
        }

        return ListView(
          padding: AppSizes.DEFAULT2,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 98,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(Assets.imagesBlurbg),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Container(
                        height: 98,
                        width: 98,
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: kWhite,
                          border: Border.all(color: kWhite),
                        ),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              "${RestConstants.storageBaseUrl}${data['image']}"),
                        ),
                      ),
                    ),
                  ],
                ),
                MyText(
                  text: data['name'] ?? 'Clinic name',
                  size: 18,
                  paddingTop: 10,
                  textAlign: TextAlign.center,
                  weight: FontWeight.w700,
                ),
                Gap(17),
                _businessHours(data),
                Gap(11),
                _sectionDivider(),
                Gap(11),
                _aboutSection(data['about']),
                Gap(11),
                _sectionDivider(),
                Gap(11),
_serviceIncludes(List<String>.from(data['includes'])),
                Gap(11),
                _contactDetails(data),
                Gap(11),
                _mapSection(data['address'], data['lat'], data['lng']),
              ],
            ),
          ],
        );
      }),
    );
  }

Widget _businessHours(Map<String, dynamic> data) {
  final int serviceKey = data['id']; // Use a consistent key from `data`
  final now = DateTime.now();
  bool isOpen = false;

  // Check if the business is currently open
  for (var availability in availabilities) {
    final startTime = _parseTime(availability['start_time']);
    final endTime = _parseTime(availability['end_time']);
    if (now.isAfter(startTime) && now.isBefore(endTime)) {
      isOpen = true;
      break;
    }
  }

  return Container(
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(8, 10),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: "Business Hours",
          size: 12,
          color: kTextGrey,
          weight: FontWeight.w500,
        ),
        Gap(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Open/Closed Chip
            Container(
              height: 26,
              width: 60,
              decoration: BoxDecoration(
                color: isOpen
                    ? kContainerColorGreen.withOpacity(0.2)
                    : kredColor.withOpacity(0.13),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: MyText(
                  text: isOpen ? 'Open' : 'Closed',
                  size: 11,
                  color: isOpen ? kContainerColorGreen : kredColor,
                  weight: FontWeight.w500,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  expandedState[serviceKey] = !(expandedState[serviceKey] ?? false);
                });
              },
              child: Row(
                children: [
                  MyText(
                    text: expandedState[serviceKey] == true ? "Collapse" : "Availability",
                    size: 11,
                    color: kTextGrey,
                    fontFamily: AppFonts.NUNITO_SANS,
                    weight: FontWeight.w800,
                  ),
                  Gap(8),
                  Icon(
                    expandedState[serviceKey] == true
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
        if (expandedState[serviceKey] == true)
          Column(
            children: availabilities.map<Widget>((availability) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: availability['day'],
                      size: 12,
                      color: kTextGrey,
                      fontFamily: AppFonts.NUNITO_SANS,
                      weight: FontWeight.w600,
                    ),
                    MyText(
                      text: "${availability['start_time']} - ${availability['end_time']}",
                      size: 12,
                      color: kTextGrey,
                      fontFamily: AppFonts.NUNITO_SANS,
                      weight: FontWeight.w400,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    ),
  );
}



DateTime _parseTime(String time) {
  final timeParts = time.split(':');
  return DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    int.parse(timeParts[0]),
    int.parse(timeParts[1]),
  );
}
  Widget _sectionDivider() => Divider(thickness: 1, color: kBlack.withOpacity(0.2));

  Widget _aboutSection(String about) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: "About",
          size: 15,
          weight: FontWeight.w800,
        ),
        MyText(
          text: about,
          size: 13,
          maxLines: 7,
          paddingTop: 5,
          color: kTextGrey,
          weight: FontWeight.w500,
        ),
      ],
    );
  }

  Widget _serviceIncludes(List<String> includes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: "Service Includes",
          size: 15,
          weight: FontWeight.w800,
        ),
        ...includes.map((include) => MyText(
              text: "-  $include",
              size: 13,
              paddingTop: 4,
              weight: FontWeight.w500,
            )),
      ],
    );
  }

  Widget _contactDetails(Map<String, dynamic> data) {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(8, 10),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(
              text: "Contact Details",
              size: 12,
              color: kTextGrey,
              weight: FontWeight.w800,
            ),
            MyText(
              text: "${data['country_code']} ${data['phone_number']}",
              size: 11,
              weight: FontWeight.w800,
            ),
          ],
        ),
        InkWell(
          onTap: () async {
            final phoneNumber = "${data['country_code']}${data['phone_number']}";
            final url = "tel:$phoneNumber";
            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(Uri.parse(url));
            } else {
              throw 'Could not launch $url';
            }
          },
          child: CommonImageView(
            imagePath: Assets.imagesCallOrange,
            height: 32,
          ),
        )
      ],
    ),
  );
}

  Widget _mapSection(String address, String lat, String lng) {
  return Stack(
    alignment: Alignment.topCenter,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.imagesMap),
              fit: BoxFit.cover,
            ),
            border: Border.all(
              color: kborderGrey2,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 120),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 22, vertical: 22),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(8, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CommonImageView(
                imagePath: Assets.imagesLocationGrey,
                height: 32,
              ),
              Expanded( // Wrap the address to prevent overflow
                child: MyText(
                  text: address,
                  size: 13,
                  weight: FontWeight.w500,
                  maxLines: 2, // Optional: Set max lines to ensure wrapping
                ),
              ),
              InkWell(
                onTap: () async {
                  final url = "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: CommonImageView(
                  imagePath: Assets.imagesDirection,
                  height: 32,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

}

