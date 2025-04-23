// lib/view/screens/home/home.dart
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_images.dart';
import 'package:restaurant_finder/constants/app_sizes.dart';
import 'package:restaurant_finder/controller/global_controller.dart';
import 'package:restaurant_finder/controller/home_controller.dart';
import 'package:restaurant_finder/view/screens/home/restaurant_details.dart';
import 'package:restaurant_finder/view/screens/notifications/notifications.dart';
import 'package:restaurant_finder/view/widget/common_image_view_widget.dart';
import 'package:restaurant_finder/view/widget/custom_drop_down_widget.dart';
import 'package:restaurant_finder/view/widget/custom_slider_thumb_widget.dart';
import 'package:restaurant_finder/view/widget/custom_slider_tool_tip.dart';
import 'package:restaurant_finder/view/widget/my_button_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';
import 'package:restaurant_finder/view/widget/restaurant_card_widget.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final globalController = Get.find<GlobalController>();
    final HomeController controller = Get.put(HomeController());
    
    // Controller for the search field
    final TextEditingController searchController = TextEditingController();
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: NestedScrollView(
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
                    text: '👋🏻 Hello,',
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MyText(
                        paddingLeft: 5,
                        text: 'Premium',
                        size: 12,
                        paddingRight: 6,
                        weight: FontWeight.w600,
                      ),
                      Image.asset(
                        Assets.imagesPremium,
                        height: 20,
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                Center(
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
                SizedBox(
                  width: 20,
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
                            child: TextFormField(
                              controller: searchController,
                              cursorColor: kPrimaryColor,
                              style: TextStyle(
                                fontSize: 16,
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                              onChanged: (value) {
                                // Debounce search to avoid excessive API calls
                                Future.delayed(Duration(milliseconds: 500), () {
                                  if (value == searchController.text) {
                                    controller.searchRestaurants(value);
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: kPrimaryColor.withOpacity(0.1),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 15),
                                prefixIcon: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      Assets.imagesSearch,
                                      height: 20,
                                      color: kPrimaryColor,
                                    ),
                                  ],
                                ),
                                hintText: 'Search...',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: kPrimaryColor.withOpacity(0.8),
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
                          SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.bottomSheet(
                                FilterBottomSheet(controller: controller),
                                isScrollControlled: true,
                              );
                            },
                            child: Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: kPrimaryColor,
                              ),
                              child: Center(
                                child: Image.asset(
                                  Assets.imagesFilter,
                                  color: kSecondaryColor,
                                  height: 20,
                                ),
                              ),
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
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator(color: kSecondaryColor));
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
                      text: 'Choose your favorite restaurant',
                      paddingBottom: 6,
                    ),
                    MyText(
                      size: 12,
                      color: kGreyColor,
                      lineHeight: 1.5,
                      text:
                          'Tap on the map and find out your restaurant within the country',
                      paddingBottom: 16,
                    ),
                    CommonImageView(
                      height: 90,
                      width: Get.width,
                      imagePath: Assets.imagesAd,
                      fit: BoxFit.cover,
                      radius: 12,
                    ),
                    MyText(
                      paddingTop: 20,
                      size: 16,
                      weight: FontWeight.w600,
                      text: 'Find all popular restaurants',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Image.asset(
                      Assets.imagesDummyMap,
                      height: Get.height,
                      width: Get.width,
                      fit: BoxFit.cover,
                    ),
                    
                    // Show markers for each restaurant
                    ...controller.nearbyRestaurants.map((restaurant) {
                      // This is a simplified positioning - in a real app, you would use proper coordinates
                      // Just for demonstration, we're placing markers randomly-ish
                      final idx = controller.nearbyRestaurants.indexOf(restaurant);
                      final offset = idx * 50; // spread them out a bit
                      
                      return Positioned(
                        top: Get.height * 0.3 + (offset % 100),
                        left: Get.width * 0.3 + (offset % 150),
                        child: GestureDetector(
                          onTap: () {
                            controller.selectRestaurant(restaurant);
                            Get.bottomSheet(
                              MarkerDetails(
                                controller: controller,
                                restaurant: restaurant,
                              ),
                              isScrollControlled: true,
                            );
                          },
                          child: Image.asset(
                            Assets.imagesRestaurantMarker,
                            height: 32,
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
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
    return Container(
      height: Get.height * 0.5,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
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
              buttonText: 'View details',
              onTap: () {
                Get.back(); // Close the bottom sheet
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
    return Container(
      height: Get.height * 0.9,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
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
                    text: 'Cancel',
                    size: 14,
                    weight: FontWeight.w600,
                    color: kSecondaryColor,
                  ),
                ),
                MyText(
                  text: 'Filter',
                  size: 18,
                  weight: FontWeight.w600,
                ),
                GestureDetector(
                  onTap: () {
                    controller.resetFilters();
                  },
                  child: MyText(
                    color: kSecondaryColor,
                    text: 'Reset',
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
                  text: 'Prize Range',
                  size: 16,
                  weight: FontWeight.w600,
                  paddingBottom: 8,
                ),
                Obx(() {
                  return FlutterSlider(
                    values: [controller.minPrice.value, controller.maxPrice.value],
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
                  text: 'Category',
                  size: 16,
                  weight: FontWeight.w600,
                  paddingBottom: 8,
                ),
                Obx(() {
                  final List<String> categories = [
                    'Halal food',
                    'Pizza',
                    'Sandwiches',
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
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
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
                            color: isSelected ? kPrimaryColor : kBlackColor,
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
                MyText(
                  paddingTop: 20,
                  text: 'Restaurants',
                  size: 16,
                  weight: FontWeight.w600,
                  paddingBottom: 8,
                ),
                Obx(() {
                  final List<String> restaurants = [
                    'Flavor Haven',
                    'Culinary Canvas',
                    'Gourmet Grove',
                    'Spice Symphony',
                  ];
                  
                  return Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    children: restaurants.map((restaurant) {
                      final isSelected = controller.selectedRestaurantNames.contains(restaurant);
                      
                      return GestureDetector(
                        onTap: () => controller.toggleRestaurantName(restaurant),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
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
                            color: isSelected ? kPrimaryColor : kBlackColor,
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
                MyText(
                  paddingTop: 20,
                  paddingBottom: 8,
                  text: 'Distance Range',
                  size: 16,
                  weight: FontWeight.w600,
                ),
                Obx(() {
                  return CustomDropDown(
                    hint: 'Min Distance',
                    items: [
                      'Min Distance',
                      '5mint',
                      '10mint',
                      '15mint',
                      '20mint',
                      '25mint',
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
              buttonText: 'Apply filter',
              onTap: () => controller.applyFilters(),
            ),
          ),
        ],
      ),
    );
  }
}