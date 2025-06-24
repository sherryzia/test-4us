import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart'; // lib/view/screens/home/home.dart
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_images.dart';
import 'package:restaurant_finder/constants/app_sizes.dart';
import 'package:restaurant_finder/controller/global_controller.dart';
import 'package:restaurant_finder/controller/home_controller.dart';
import 'package:restaurant_finder/model/explore_model.dart';
import 'package:restaurant_finder/view/screens/home/restaurant_details.dart';
import 'package:restaurant_finder/view/screens/notifications/notifications.dart';
import 'package:restaurant_finder/view/widget/common_image_view_widget.dart';
import 'package:restaurant_finder/view/widget/custom_drop_down_widget.dart';
import 'package:restaurant_finder/view/widget/custom_slider_thumb_widget.dart';
import 'package:restaurant_finder/view/widget/custom_slider_tool_tip.dart';
import 'package:restaurant_finder/view/widget/my_button_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';
import 'package:restaurant_finder/view/widget/restaurant_card_widget.dart';
import 'package:restaurant_finder/controller/theme_controller.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
Widget build(BuildContext context) {
  final ThemeController themeController = Get.find<ThemeController>();
  final globalController = Get.find<GlobalController>();
  final HomeController controller = Get.put(HomeController());

  // Controller for the search field
  final TextEditingController searchController = TextEditingController();

  return Obx(() {
    final isDark = themeController.isDarkMode;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: isDark ? kBlackColor : Colors.white,
      body: Stack(
        children: [
          // Main content
          NestedScrollView(
            physics: BouncingScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  elevation: 1,
                  forceElevated: true,
                  pinned: true,
                  floating: false,
                  toolbarHeight: 90,
                  backgroundColor: kSecondaryColor,
                  expandedHeight: 155,
                  automaticallyImplyLeading: false,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MyText(
                        paddingLeft: 5,
                        text: 'hello'.tr,
                        size: 12,
                        weight: FontWeight.w600,
                        paddingBottom: 6,
                      ),
                      Obx(() => MyText(
                            paddingLeft: 5,
                            text: globalController.userName.value.isNotEmpty
                                ? globalController.userName.value
                                : 'Guest',
                            size: 16,
                            weight: FontWeight.w600,
                            paddingBottom: 4,
                          )),
                      globalController.isSubscribed.value
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                MyText(
                                  paddingLeft: 5,
                                  text: 'premium'.tr,
                                  size: 12,
                                  paddingRight: 6,
                                  weight: FontWeight.w600,
                                ),
                                Image.asset(
                                  Assets.imagesPremium,
                                  height: 20,
                                ),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                  actions: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 18),
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => Notifications());
                            },
                            child: Image.asset(
                              Assets.imagesNotifications,
                              height: 38,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Padding(
                      padding: AppSizes.DEFAULT,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 7,
                                child: TextFormField(
                                  controller: searchController,
                                  cursorColor: isDark ? kTertiaryColor : kPrimaryColor,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isDark ? kTertiaryColor : kPrimaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  onChanged: (value) {
                                    Future.delayed(Duration(milliseconds: 500),
                                        () {
                                      if (value == searchController.text) {
                                        controller.searchRestaurants(value);
                                      }
                                    });
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: isDark
                                        ? kDialogBlack
                                        : kPrimaryColor.withOpacity(0.1),
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    prefixIcon: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          Assets.imagesSearch,
                                          height: 20,
                                          color: isDark ? kTertiaryColor : kPrimaryColor,
                                        ),
                                      ],
                                    ),
                                    hintText: 'search'.tr,
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: isDark
                                          ? kDarkTextColor
                                          : kPrimaryColor.withOpacity(0.8),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    border: InputBorder.none,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: kBorderColor,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: kBorderColor,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    errorBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              // Country dropdown as a filter button next to search
                              Expanded(
                                flex: 3,
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: kSecondaryColor.withOpacity(0.9),
                                  ),
                                  child: Obx(() => DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          value:
                                              controller.selectedCountry.value,
                                          icon: Icon(Icons.keyboard_arrow_down,
                                              color: Colors.white, size: 18),
                                          dropdownColor: kSecondaryColor,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13),
                                          items: controller.countries
                                              .map<DropdownMenuItem<String>>(
                                                  (country) {
                                            final bool isPremium =
                                                country['is_premium'] ?? false;
                                            return DropdownMenuItem<String>(
                                              value: country['name'],
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.location_on,
                                                      size: 12,
                                                      color: Colors.white),
                                                  SizedBox(width: 4),
                                                  Expanded(
                                                    child: Text(
                                                      country['name'],
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  // Show premium icon if country is premium
                                                  if (isPremium) ...[
                                                    SizedBox(width: 4),
                                                    Image.asset(
                                                      Assets.imagesPremium,
                                                      height: 20,
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            if (value != null) {
                                              // Find the selected country data
                                              final selectedCountryData =
                                                  controller.countries
                                                      .firstWhere(
                                                (country) =>
                                                    country['name'] == value,
                                                orElse: () =>
                                                    {'is_premium': false},
                                              );
                                              final bool isPremium =
                                                  selectedCountryData[
                                                          'is_premium'] ??
                                                      false;

                                              // Handle selection with premium check
                                              controller.handleCountrySelection(
                                                  value, isPremium);
                                            }
                                          },
                                        ),
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: GestureDetector(
              onTap: () {
                // Hide search results when tapping elsewhere
                if (controller.showSearchResults.value) {
                  controller.showSearchResults.value = false;
                  FocusScope.of(context).unfocus(); // Dismiss keyboard
                }
              },
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                      child: CircularProgressIndicator(color: kSecondaryColor));
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: AppSizes.DEFAULT,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          MyText(
                            size: 16,
                            weight: FontWeight.w600,
                            text: 'chooseYourFavoriteRestaurant'.tr,
                            paddingBottom: 6,
                            color: isDark ? kTertiaryColor : null,
                          ),
                          MyText(
                            size: 12,
                            color: isDark ? kDarkTextColor : kGreyColor,
                            lineHeight: 1.5,
                            text:
                                'tapOnTheMapAndFindOutYourRestaurant'.tr,
                            paddingBottom:
                                globalController.isSubscribed.value ? 16 : 0,
                          ),
                          globalController.isSubscribed.value
                              ? CommonImageView(
                                  height: 90,
                                  width: Get.width,
                                  imagePath: Assets.imagesAd,
                                  fit: BoxFit.cover,
                                  radius: 12,
                                )
                              : Container(),
                          MyText(
                            paddingTop: 20,
                            size: 16,
                            weight: FontWeight.w600,
                            text:
                                'findAllPopularRestaurants'.tr,
                            color: isDark ? kTertiaryColor : null,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          GoogleMap(
                            gestureRecognizers: <Factory<
                                OneSequenceGestureRecognizer>>{
                              Factory<OneSequenceGestureRecognizer>(
                                  () => EagerGestureRecognizer()),
                            },
                            mapType: MapType.normal,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                controller.nearbyRestaurants.isNotEmpty &&
                                        controller.nearbyRestaurants[0]
                                                .latitude !=
                                            null
                                    ? controller.nearbyRestaurants[0].latitude!
                                    : 37.7749,
                                controller.nearbyRestaurants.isNotEmpty &&
                                        controller.nearbyRestaurants[0]
                                                .longitude !=
                                            null
                                    ? controller.nearbyRestaurants[0].longitude!
                                    : -122.4194,
                              ),
                              zoom: 13.0,
                            ),
                            markers:
                                controller.nearbyRestaurants.map((restaurant) {
                              return Marker(
                                markerId: MarkerId(restaurant.id),
                                position: LatLng(
                                  restaurant.latitude ?? 0.0,
                                  restaurant.longitude ?? 0.0,
                                ),
                                icon: controller.customMarker,
                                onTap: () {
                                  controller.zoomToRestaurant(restaurant);
                                  controller.selectRestaurant(restaurant);
                                  Get.bottomSheet(
                                    MarkerDetails(
                                      controller: controller,
                                      restaurant: restaurant,
                                    ),
                                    isScrollControlled: true,
                                  );
                                },
                              );
                            }).toSet(),
                            onMapCreated: (GoogleMapController mapController) {
                              controller.mapController = mapController;
                            },
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                            zoomControlsEnabled: true,
                          ),

                          // No data overlay
                          if (controller.nearbyRestaurants.isEmpty &&
                              !controller.isLoading.value)
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.black.withOpacity(0.4),
                              child: Center(
                                child: Container(
                                  width: Get.width * 0.8,
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: isDark ? kDialogBlack : kPrimaryColor,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 15,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        Assets.imagesRestaurantMarker,
                                        height: 60,
                                        width: 60,
                                        color: kSecondaryColor.withOpacity(0.5),
                                      ),
                                      SizedBox(height: 16),
                                      MyText(
                                        text: 'noRestaurantsFound'.tr,
                                        size: 20,
                                        weight: FontWeight.w600,
                                        paddingBottom: 8,
                                        color: isDark ? kTertiaryColor : null,
                                      ),
                                      MyText(
                                        text:
                                            'noRestaurantsAvailableIn'.tr + ' ${controller.selectedCountry.value}',
                                        size: 14,
                                        color: isDark ? kDarkTextColor : kGreyColor,
                                        textAlign: TextAlign.center,
                                        paddingBottom: 20,
                                      ),
                                      MyButton(
                                        buttonText: 'tryAnotherCountry'.tr,
                                        onTap: () {
                                          // Open country selection dialog
                                          Get.dialog(
                                            Dialog(
                                              backgroundColor: isDark ? kDialogBlack : kPrimaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.all(16),
                                                width: Get.width * 0.8,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    MyText(
                                                      text: 'selectCountry'.tr,
                                                      size: 18,
                                                      weight: FontWeight.w600,
                                                      paddingBottom: 16,
                                                      color: isDark ? kTertiaryColor : null,
                                                    ),
                                                    Container(
                                                      height: 300,
                                                      child: ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: controller
                                                            .countries.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final country =
                                                              controller
                                                                      .countries[
                                                                  index];
                                                          return ListTile(
                                                            title: MyText(
                                                              text: country[
                                                                  'name'],
                                                              size: 16,
                                                              color: controller
                                                                          .selectedCountry
                                                                          .value ==
                                                                      country[
                                                                          'name']
                                                                  ? kSecondaryColor
                                                                  : (isDark ? kTertiaryColor : kBlackColor),
                                                              weight: controller
                                                                          .selectedCountry
                                                                          .value ==
                                                                      country[
                                                                          'name']
                                                                  ? FontWeight
                                                                      .w600
                                                                  : FontWeight
                                                                      .normal,
                                                            ),
                                                            leading: controller
                                                                        .selectedCountry
                                                                        .value ==
                                                                    country[
                                                                        'name']
                                                                ? Icon(
                                                                    Icons
                                                                        .check_circle,
                                                                    color:
                                                                        kSecondaryColor)
                                                                : null,
                                                            onTap: () {
                                                              controller
                                                                  .changeCountry(
                                                                      country[
                                                                          'name']);
                                                              Get.back(); // Close dialog
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(height: 16),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Get.back(); // Close dialog
                                                          },
                                                          child: MyText(
                                                            text: 'cancel'.tr,
                                                            size: 16,
                                                            color:
                                                                kSecondaryColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),

          // Search results overlay (single, merged version)
          Positioned(
            top: 155 +
                MediaQuery.of(context)
                    .padding
                    .top, // Adjust for status bar height
            left: 0,
            right: 0,
            child: Obx(
              () => controller.showSearchResults.value &&
                      controller.searchResults.isNotEmpty
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity,
                      constraints: BoxConstraints(maxHeight: 300),
                      decoration: BoxDecoration(
                        color: isDark ? kDialogBlack : kPrimaryColor,
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(8)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: controller.isSearching.value
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(
                                    color: kSecondaryColor),
                              ),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(vertical: 8),
                              itemCount: controller.searchResults.length,
                              separatorBuilder: (context, index) =>
                                  Divider(height: 1),
                              itemBuilder: (context, index) {
                                final result = controller.searchResults[index];
                                final isRestaurant =
                                    result['type'] == 'restaurant';

                                if (isRestaurant) {
                                  // Restaurant result
                                  final restaurant =
                                      result['data'] as RestaurantModel;
                                  return ListTile(
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CommonImageView(
                                        width: 40,
                                        height: 40,
                                        url: restaurant.image.isNotEmpty
                                            ? restaurant.image
                                            : 'https://via.placeholder.com/40',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    title: MyText(
                                      text: restaurant.name,
                                      weight: FontWeight.w600,
                                      color: isDark ? kTertiaryColor : null,
                                    ),
                                    subtitle: Row(
                                      children: [
                                        MyText(
                                          text: restaurant.location,
                                          size: 12,
                                          color: isDark ? kDarkTextColor : kGreyColor,
                                        ),
                                        if (restaurant.country != null)
                                          MyText(
                                            text: ' (${restaurant.country})',
                                            size: 12,
                                            color: kSecondaryColor,
                                          ),
                                      ],
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.star,
                                            color: Colors.amber, size: 16),
                                        SizedBox(width: 2),
                                        MyText(
                                          text: '${restaurant.rating}',
                                          size: 12,
                                          weight: FontWeight.w600,
                                          color: isDark ? kTertiaryColor : null,
                                        ),
                                        SizedBox(width: 8),
                                        Icon(Icons.restaurant,
                                            size: 16, color: kSecondaryColor),
                                      ],
                                    ),
                                    onTap: () {
                                      // Close search results
                                      controller.showSearchResults.value =
                                          false;
                                      searchController.clear();

                                      // Navigate to restaurant details
                                      Get.to(() => RestaurantDetails(
                                          restaurantId: restaurant.id));
                                    },
                                  );
                                } else {
                                  // Dish result
                                  final dish = result['data'];
                                  final restaurant =
                                      result['restaurant'] as RestaurantModel?;

                                  return ListTile(
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CommonImageView(
                                        width: 40,
                                        height: 40,
                                        url: dish['image'] ??
                                            'https://via.placeholder.com/40',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    title: MyText(
                                      text: dish['name'] ?? 'Unknown dish',
                                      weight: FontWeight.w600,
                                      color: isDark ? kTertiaryColor : null,
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Icon(Icons.attach_money,
                                            size: 14, color: kSecondaryColor),
                                        MyText(
                                          text: '${dish['price'] ?? 0.0}',
                                          size: 12,
                                          color: isDark ? kDarkTextColor : kGreyColor,
                                        ),
                                        SizedBox(width: 4),
                                        Expanded(
                                          child: MyText(
                                            text: restaurant?.name ??
                                                'Unknown restaurant',
                                            size: 12,
                                            color: isDark ? kDarkTextColor : kGreyColor,
                                            maxLines: 1,
                                            textOverflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (restaurant?.country != null)
                                          MyText(
                                            text: ' (${restaurant!.country})',
                                            size: 10,
                                            color: kSecondaryColor,
                                            maxLines: 1,
                                            textOverflow: TextOverflow.ellipsis,
                                          ),
                                      ],
                                    ),
                                    trailing: Icon(Icons.fastfood,
                                        size: 16, color: kSecondaryColor),
                                    onTap: () {
                                      // Close search results
                                      controller.showSearchResults.value =
                                          false;
                                      searchController.clear();

                                      // Navigate to restaurant details if we have the restaurant
                                      if (restaurant != null) {
                                        Get.to(() => RestaurantDetails(
                                            restaurantId: restaurant.id));
                                      }
                                    },
                                  );
                                }
                              },
                            ),
                    )
                  : SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  });
}
}

class MarkerDetails extends StatelessWidget {
  final HomeController controller;
  final dynamic restaurant;

  const MarkerDetails({
    Key? key,
    required this.controller,
    required this.restaurant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode;
    return Container(
      height: Get.height * 0.5,
      decoration: BoxDecoration(
        color: isDark ? kBlackColor : kPrimaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              height: 5,
              width: 40,
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: kSecondaryColor,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: RestaurantCard(
              restaurant: restaurant,
              onFavoriteToggle: () => controller.toggleFavorite(restaurant.id),
            ),
          ),
          Spacer(),
          Padding(
            padding: AppSizes.DEFAULT,
            child: MyButton(
              buttonText: 'viewDetails'.tr,
              onTap: () {
                Get.to(() => RestaurantDetails(restaurantId: restaurant.id));
              },
            ),
          ),
        ],
      ),
    );
  }
}
class FilterBottomSheet extends StatelessWidget {
  final HomeController controller;

  const FilterBottomSheet({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode;
    return Container(
      height: Get.height * 0.9,
      decoration: BoxDecoration(
        color: isDark ? kDialogBlack : kPrimaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              height: 5,
              width: 40,
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: kSecondaryColor,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: MyText(
                    text: 'cancel'.tr,
                    size: 14,
                    weight: FontWeight.w600,
                    color: kSecondaryColor,
                  ),
                ),
                MyText(
                  text: 'filter'.tr,
                  size: 18,
                  weight: FontWeight.w600,
                  color: isDark ? kTertiaryColor : null,
                ),
                GestureDetector(
                  onTap: () {
                    controller.resetFilters();
                  },
                  child: MyText(
                    color: kSecondaryColor,
                    text: 'reset'.tr,
                    size: 14,
                    weight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: AppSizes.DEFAULT,
              physics: BouncingScrollPhysics(),
              children: [
                MyText(
                  text: 'prizeRange'.tr,
                  size: 16,
                  weight: FontWeight.w600,
                  paddingBottom: 8,
                  color: isDark ? kTertiaryColor : null,
                ),
                Obx(() {
                  return FlutterSlider(
                    values: [
                      controller.minPrice.value,
                      controller.maxPrice.value
                    ],
                    rangeSlider: true,
                    min: 50,
                    max: 500,
                    handlerWidth: 20,
                    handlerHeight: 20,
                    tooltip: CustomSliderToolTip(),
                    handler: FlutterSliderHandler(
                      decoration: BoxDecoration(),
                      child: CustomSliderThumb(),
                    ),
                    rightHandler: FlutterSliderHandler(
                      decoration: BoxDecoration(),
                      child: CustomSliderThumb(),
                    ),
                    trackBar: FlutterSliderTrackBar(
                      activeTrackBarHeight: 7,
                      inactiveTrackBarHeight: 7,
                      activeTrackBar: BoxDecoration(
                        color: kSecondaryColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      inactiveTrackBar: BoxDecoration(
                        color: kLightGreyColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onDragging: (handlerIndex, lowerValue, upperValue) {
                      controller.updatePriceRange(lowerValue, upperValue);
                    },
                  );
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      paddingLeft: 10,
                      text: '\$50',
                      size: 12.34,
                      weight: FontWeight.w600,
                      color: kGreyColor,
                    ),
                    MyText(
                      paddingRight: 10,
                      text: '\$500',
                      weight: FontWeight.w600,
                      size: 12.34,
                      color: kGreyColor,
                    ),
                  ],
                ),
                MyText(
                  paddingTop: 20,
                  text: 'category'.tr,
                  size: 16,
                  weight: FontWeight.w600,
                  paddingBottom: 8,
                  color: isDark ? kTertiaryColor : null,
                ),
                Obx(() {
                  final List<String> categories = [
                    'halalFood'.tr,
                    'pizza'.tr,
                    'sandwiches'.tr,
                  ];

                  return Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    children: categories.map((category) {
                      final isSelected = controller.selectedCategories.contains(category);

                      return GestureDetector(
                        onTap: () => controller.toggleCategory(category),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: isSelected ? kSecondaryColor : Colors.transparent,
                            border: Border.all(
                              width: 1.0,
                              color: isSelected ? kSecondaryColor : kBorderColor,
                            ),
                          ),
                          child: MyText(
                            text: category,
                            size: 14,
                            weight: FontWeight.w500,
                            color: isSelected
                                ? kPrimaryColor
                                : (isDark ? kDarkTextColor : kBlackColor),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
                MyText(
                  paddingTop: 20,
                  text: 'restaurants'.tr,
                  size: 16,
                  weight: FontWeight.w600,
                  paddingBottom: 8,
                  color: isDark ? kTertiaryColor : null,
                ),
                Obx(() {
                  final List<String> restaurants = [
                    'flavorHaven'.tr,
                    'culinaryCanvas'.tr,
                    'gourmetGrove'.tr,
                    'spiceSymphony'.tr,
                  ];

                  return Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    children: restaurants.map((restaurant) {
                      final isSelected =
                          controller.selectedRestaurantNames.contains(restaurant);

                      return GestureDetector(
                        onTap: () => controller.toggleRestaurantName(restaurant),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: isSelected ? kSecondaryColor : Colors.transparent,
                            border: Border.all(
                              width: 1.0,
                              color: isSelected ? kSecondaryColor : kBorderColor,
                            ),
                          ),
                          child: MyText(
                            text: restaurant,
                            size: 14,
                            weight: FontWeight.w500,
                            color: isSelected
                                ? kPrimaryColor
                                : (isDark ? kDarkTextColor : kBlackColor),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
                MyText(
                  paddingTop: 20,
                  paddingBottom: 8,
                  text: 'distanceRange'.tr,
                  size: 16,
                  weight: FontWeight.w600,
                  color: isDark ? kTertiaryColor : null,
                ),
                Obx(() {
                  return CustomDropDown(
                    hint: 'minDistance'.tr,
                    items: [
                      'minDistance'.tr,
                      '5mint'.tr,
                      '10mint'.tr,
                      '15mint'.tr,
                      '20mint'.tr,
                      '25mint'.tr,
                    ],
                    onChanged: (v) {
                      if (v != null) {
                        controller.minDistance.value = v;
                      }
                    },
                    selectedValue: controller.minDistance.value,
                  );
                }),
              ],
            ),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: MyButton(
              buttonText: 'applyFilter'.tr,
              onTap: () => controller.applyFilters(),
            ),
          ),
        ],
      ),
    );
  }
}