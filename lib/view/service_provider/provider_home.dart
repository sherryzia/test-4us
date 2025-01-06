import 'package:flutter/material.dart';
import 'package:forus_app/controllers/GlobalController.dart';
import 'package:forus_app/controllers/service_provider/ListingManagement/GetBusinessListingController.dart';
import 'package:forus_app/utils/rest_endpoints.dart';
import 'package:forus_app/view/service_provider/ListingManagement/provider_create_business_listing.dart';
import 'package:forus_app/view/widget/my_text_field.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/constants/app_fonts.dart';
import 'package:forus_app/constants/app_sizes.dart';
import 'package:forus_app/generated/assets.dart';
import 'package:forus_app/view/service_provider/ListingManagement/get_business_listing.dart';
import 'package:forus_app/view/service_provider/provider_notification.dart';
import 'package:forus_app/view/widget/common_image_view_widget.dart';
import 'package:forus_app/view/widget/dasheddivider.dart';
import 'package:forus_app/view/widget/my_button_widget.dart';
import 'package:forus_app/view/widget/my_text_widget.dart';

class ProviderHomeScreen extends StatefulWidget {
  final bool data;
  const ProviderHomeScreen({super.key, this.data = false});

  @override
  State<ProviderHomeScreen> createState() => _ProviderHomeScreenState();
}

class _ProviderHomeScreenState extends State<ProviderHomeScreen> {
  final globalController = Get.find<GlobalController>();
  final businessListingController = Get.put(GetBusinessListingController());

  final PageController _pageController = PageController(viewportFraction: 0.8);
  late String name;
  late String location;
  int _currentPage = 0;

  final Map<int, bool> expandedState = {}; // State to track expanded cards
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  List<dynamic> filteredServices = []; // To store filtered services

  @override
  void initState() {
    super.initState();
    businessListingController.fetchBusinessListings();

    print("AuthToken: ${globalController.authToken.value}");
    name = globalController.name.value ?? 'Grant';
    location = 'Panorama, Riyadh'; // to be changed to the actual location
    // Initialize filtered services to show all initially
    filteredServices = businessListingController.businessListings;
    searchController.addListener(_filterServices);
    Future.delayed(const Duration(seconds: 2), _autoScroll);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterServices() {
    setState(() {
      searchQuery = searchController.text.toLowerCase();
      filteredServices =
          businessListingController.businessListings.where((service) {
        final serviceName = service['name']?.toLowerCase() ?? '';
        return serviceName.contains(searchQuery);
      }).toList();
    });
  }

  void _autoScroll() {
    if (_pageController.hasClients) {
      _currentPage =
          (_currentPage + 1) % businessListingController.bannerCount.value;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      Future.delayed(const Duration(seconds: 3), _autoScroll);
    }
  }

Future<void> _onRefresh() async {
  await businessListingController.fetchBusinessListings(); // Re-fetch data
  setState(() {
    filteredServices = businessListingController.businessListings; // Update the filtered list
  });
}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        floatingActionButton: widget.data == false
            ? CustomFloatingButton(
                onPressed: () {
                  Get.to(() => CreateBusinessListingScreen());
                },
              )
            : null,
        appBar: AppBar(
          backgroundColor: AppThemeColors.getTertiary(context),
          title: Row(
            children: [
              CommonImageView(
                imagePath: Assets.imagesAvatar,
                height: 36,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        MyText(
                          text: 'Hello,',
                          size: 18,
                          paddingLeft: 5,
                          textAlign: TextAlign.center,
                          fontFamily: AppFonts.NUNITO_SANS,
                          weight: FontWeight.w300,
                        ),
                        MyText(
                          text: globalController.name.value.isNotEmpty
                              ? name
                              : 'Grant',
                          size: 18,
                          paddingLeft: 5,
                          textAlign: TextAlign.center,
                          fontFamily: AppFonts.NUNITO_SANS,
                          weight: FontWeight.w600,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CommonImageView(
                          imagePath: Assets.imagesLocation,
                          height: 16,
                        ),
                        MyText(
                          text: location,
                          size: 13,
                          paddingLeft: 5,
                          textAlign: TextAlign.center,
                          fontFamily: AppFonts.NUNITO_SANS,
                          weight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            InkWell(
              onTap: () {
                Get.to(() => ProviderNotificationsScreens());
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: CommonImageView(
                  imagePath: Assets.imagesNotification,
                  height: 42,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppThemeColors.getTertiary(context),
        body: Padding(
          padding: AppSizes.DEFAULT2,
          child: Column(
            children: [
              SizedBox(
                height: 140,
                child: PageView(
                  padEnds: false,
                  allowImplicitScrolling: true,
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: businessListingController.buildBanners(),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  businessListingController.bannerCount.value,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: DotIndicator(
                      isActive: index == _currentPage,
                    ),
                  ),
                ),
              ),
              Gap(10),
              // Add the Search Bar
              MyTextField(
                controller: searchController,
                hint: 'Search Services',
                prefix: Container(
                  padding: const EdgeInsets.all(14),
                  child: CommonImageView(
                    imagePath: Assets.imagesSearchNormal,
                    height: 1,
                    width: 1,
                  ),
                ),
                kBorderColor: kborder.withOpacity(0.2),
              ),
              Gap(10),
              if (widget.data == true)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CommonImageView(
                        imagePath: Assets.imagesNodataHome,
                        height: 285,
                      ),
                      MyText(
                        text:
                            "Thank you for showing your interest to be a service provider! Your profile is under verification so we'll notify you once it has been approved.",
                        size: 18,
                        paddingLeft: 5,
                        paddingRight: 5,
                        textAlign: TextAlign.center,
                        fontFamily: AppFonts.NUNITO_SANS,
                        weight: FontWeight.w300,
                      ),
                    ],
                  ),
                )
              else
                Expanded(
  child: RefreshIndicator(
    onRefresh: _onRefresh, // Pull-to-refresh callback
    child: Obx(() {
      if (businessListingController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }
      if (filteredServices.isEmpty) {
        return Center(
          child: MyText(
            text: "No services found",
            size: 16,
          ),
        );
      }
      return ListView.builder(
        itemCount: filteredServices.length,
        itemBuilder: (context, index) {
          final service = filteredServices[index];
          return homeContainer(service, index);
        },
      );
    }),
  ),
),

            ],
          ),
        ),
      ),
    );
  }

  Widget homeContainer(dynamic service, int index) {
    final isExpanded = expandedState[index] ?? false;

    // Determine open/close status
    final now = DateTime.now();
    bool isOpen = false;

    for (var availability in service['availabilities']) {
      final startTime = _parseTime(availability['start_time']);
      final endTime = _parseTime(availability['end_time']);
      if (now.isAfter(startTime) && now.isBefore(endTime)) {
        isOpen = true;
        break;
      }
    }

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kborder.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(20), // Adjust radius as needed

                child: CommonImageView(
                  url: "${RestConstants.storageBaseUrl}${service['image']}",
                  height: 70,
                  width: 70,
                ),
              ),
              Gap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: service['name'],
                      size: 18,
                      fontFamily: AppFonts.NUNITO_SANS,
                      weight: FontWeight.w700,
                    ),
                    Gap(8),
                    Row(
                      children: [
                        CommonImageView(
                          imagePath: Assets.imagesLocationPin,
                          height: 14,
                          width: 12,
                        ),
                        Gap(4),
                        Expanded(
                          child: MyText(
                            text: service['address'],
                            size: 11,
                            color: kTextGrey,
                            fontFamily: AppFonts.NUNITO_SANS,
                            weight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Gap(10),
                    // Add Open/Close Chip
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                          decoration: BoxDecoration(
                            color: isOpen
                                ? kContainerColorGreen.withOpacity(0.2)
                                : kredColor.withOpacity(0.13),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: MyText(
                            text: isOpen ? 'Open' : 'Closed',
                            size: 10,
                            color: isOpen ? kContainerColorGreen : kredColor,
                            fontFamily: AppFonts.NUNITO_SANS,
                            weight: FontWeight.w700,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              expandedState[index] = !isExpanded;
                            });
                          },
                          child: Row(
                            children: [
                              MyText(
                                text: isExpanded ? "Collapse" : "Availability",
                                size: 11,
                                color: kTextGrey,
                                fontFamily: AppFonts.NUNITO_SANS,
                                weight: FontWeight.w800,
                              ),
                              Gap(8),
                              Icon(
                                isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (isExpanded)
                      Column(
                        children: service['availabilities']
                            .map<Widget>((availability) {
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
                                  text:
                                      "${availability['start_time']} - ${availability['end_time']}",
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
              ),
            ],
          ),
          Gap(10),
          DashedDivider(
            color: kDividerGrey,
            height: 1,
            dashWidth: 6,
            dashSpace: 2,
          ),
          Gap(14),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MyButton2(
                buttonText: '',
                customChild: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyText(
                      text: "View All",
                      size: 12,
                      paddingRight: 5,
                      color: kWhite,
                      weight: FontWeight.w700,
                    ),
                    CommonImageView(
                      imagePath: Assets.imagesArrowRight,
                      height: 12,
                    ),
                  ],
                ),
                radius: 14,
                height: 31,
                width: 102,
                onTap: () {
                  print("Service: ${service['id']}");
                  Get.to(() => GetBusinessListingScreen(), arguments: {
                    "serviceId": service['id'],
                    "availabilities": service['availabilities'], // Pass availabilities here
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Helper to map API weekday string to Flutter's weekday integers
int _dayToWeekday(String day) {
  switch (day) {
    case "Monday":
      return 1;
    case "Tuesday":
      return 2;
    case "Wednesday":
      return 3;
    case "Thursday":
      return 4;
    case "Friday":
      return 5;
    case "Saturday":
      return 6;
    case "Sunday":
      return 7;
    default:
      return -1;
  }
}

// Helper to parse time from API response
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

// Helper to convert weekday to string
String _weekdayToString(int weekday) {
  switch (weekday) {
    case 1:
      return "Monday";
    case 2:
      return "Tuesday";
    case 3:
      return "Wednesday";
    case 4:
      return "Thursday";
    case 5:
      return "Friday";
    case 6:
      return "Saturday";
    case 7:
      return "Sunday";
    default:
      return "Unknown";
  }
}

class DotIndicator extends StatelessWidget {
  final bool isActive;
  const DotIndicator({super.key, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      height: 5,
      width: isActive ? 12 : 6,
      decoration: BoxDecoration(
        color: isActive ? kTextDarkorange2 : kborderOrange,
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }
}

class CustomFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomFloatingButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kWhite, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Color(0xFFE7AF74),
              Color(0xFFA76B2C),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: CommonImageView(
            imagePath: Assets.imagesFloatingIcon,
            height: 24,
          ),
        ),
      ),
    );
  }
}
