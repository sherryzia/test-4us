// lib/view/screens/explore/explore.dart
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_images.dart';
import 'package:restaurant_finder/constants/app_sizes.dart';
import 'package:restaurant_finder/controller/explore_controller.dart';
import 'package:restaurant_finder/view/screens/home/restaurant_details.dart';
import 'package:restaurant_finder/view/screens/settings/top_profiles.dart';
import 'package:restaurant_finder/view/widget/common_image_view_widget.dart';
import 'package:restaurant_finder/view/widget/custom_app_bar_widget.dart';
import 'package:restaurant_finder/view/widget/custom_drop_down_widget.dart';
import 'package:restaurant_finder/view/widget/custom_slider_thumb_widget.dart';
import 'package:restaurant_finder/view/widget/custom_slider_tool_tip.dart';
import 'package:restaurant_finder/view/widget/my_button_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';
import 'package:restaurant_finder/view/widget/restaurant_card_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:restaurant_finder/controller/theme_controller.dart';

class Explore extends StatelessWidget {
  final ExploreController controller = Get.put(ExploreController());
  final TextEditingController searchController = TextEditingController();
  final PageController pageController = PageController(
    viewportFraction: 0.85,
    initialPage: 0,
  );

  Explore({super.key});

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode;
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: isDark ? kBlackColor : Colors.white,
        appBar: simpleAppBar(
          title: 'explore'.tr,
          haveLeading: false,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fixed top content (search bar and profiles)
            buildSearchBar(isDark),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 18, color: kSecondaryColor),
                      SizedBox(width: 8),
                      MyText(
                        text: 'country'.tr + ': ',
                        size: 14,
                        weight: FontWeight.w600,
                        color: isDark ? kTertiaryColor : null,
                      ),
                      Expanded(
                        child: Obx(() => Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: kSecondaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                    isExpanded: true,
                                    isDense: true,
                                    value: controller.selectedCountry.value,
                                    icon: Icon(Icons.arrow_drop_down,
                                        color: kSecondaryColor),
                                    style: TextStyle(
                                        color: kSecondaryColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                    items: controller.countries
                                        .map<DropdownMenuItem<String>>((country) {
                                      final bool isPremium =
                                          country['is_premium'] ?? false;
                                      return DropdownMenuItem<String>(
                                        value: country['name'],
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                country['name'],
                                                style: TextStyle(
                                                    color: kSecondaryColor,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                            // Show premium icon if country is premium
                                            if (isPremium) ...[
                                              SizedBox(width: 8),
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
                                            controller.countries.firstWhere(
                                          (country) => country['name'] == value,
                                          orElse: () => {'is_premium': false},
                                        );
                                        final bool isPremium =
                                            selectedCountryData['is_premium'] ??
                                                false;

                                        // Handle selection with premium check
                                        controller.handleCountrySelection(
                                            value, isPremium);
                                      }
                                    }),
                              ),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),
            buildTopProfiles(isDark),
            SizedBox(height: 10),

            // Expandable content area with restaurants lists
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: kSecondaryColor),
                        SizedBox(height: 16),
                        MyText(
                          text: 'loadingRestaurants'.tr,
                          size: 14,
                          color: kSecondaryColor,
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    controller.isLoading.value = true;
                    await controller.fetchRecommendedRestaurants();
                    await controller.fetchTrendingRestaurants();
                    controller.isLoading.value = false;
                  },
                  color: kSecondaryColor,
                  child: ListView(
                    shrinkWrap: true,
                    padding: AppSizes.VERTICAL,
                    physics: AlwaysScrollableScrollPhysics(),
                    children: [
                      buildRecommendedRestaurants(isDark),
                      buildTrendingRestaurants(isDark),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      );
    });
  }

  Widget buildSearchBar(bool isDark) {
    return Padding(
      padding: AppSizes.HORIZONTAL,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: searchController,
              cursorColor: isDark ? kTertiaryColor : kBlackColor,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? kTertiaryColor : kBlackColor,
                fontWeight: FontWeight.w500,
              ),
              onChanged: (value) {
                // Debounce search to avoid excessive API calls
                if (value == searchController.text) {
                  controller.searchRestaurants(value);
                }
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: isDark ? kDialogBlack : kGreyColor.withOpacity(0.1),
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                prefixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      Assets.imagesSearch,
                      height: 20,
                      color: kSecondaryColor,
                    ),
                  ],
                ),
                hintText: 'searchRestaurants'.tr,
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? kDarkTextColor
                      : kBlackColor.withOpacity(0.8),
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
                color: isDark ? kDialogBlack : kPrimaryColor,
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
    );
  }

  Widget buildTopProfiles(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              paddingBottom: 16,
              paddingLeft: 20,
              paddingRight: 20,
              text: 'topProfiles'.tr,
              size: 16,
              weight: FontWeight.w600,
              color: isDark ? kTertiaryColor : null,
            ),
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => TopProfiles());
                },
                child: MyText(
                  paddingBottom: 16,
                  text: 'seeAll'.tr,
                  size: 14,
                  weight: FontWeight.w500,
                  color: kSecondaryColor,
                ),
              ),
            ),
          ],
        ),
        Obx(() {
          return SizedBox(
            height: 80,
            child: controller.topProfiles.isEmpty
                ? Center(
                    child: MyText(
                      text: 'noProfilesFound'.tr,
                      color: isDark ? kTertiaryColor : null,
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    padding: AppSizes.HORIZONTAL,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final profile = controller.topProfiles[index];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Navigate to profile details (you can implement this later)
                              // Get.to(() => ProfileDetails(profileId: profile.id));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 2,
                                  color: kSecondaryColor,
                                ),
                              ),
                              child: CommonImageView(
                                height: 55,
                                width: 55,
                                radius: 100,
                                url: profile.profileImage.isNotEmpty
                                    ? profile.profileImage
                                    : 'https://via.placeholder.com/100',
                              ),
                            ),
                          ),
                          MyText(
                            text: profile.name,
                            size: 12,
                            weight: FontWeight.w600,
                            color: isDark ? kDarkTextColor : null,
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(width: 12);
                    },
                    itemCount: controller.topProfiles.length,
                  ),
          );
        }),
      ],
    );
  }

  Widget buildRecommendedRestaurants(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          paddingTop: 20,
          paddingBottom: 16,
          paddingLeft: 20,
          paddingRight: 20,
          text: 'recommendations'.tr,
          size: 16,
          weight: FontWeight.w600,
          color: isDark ? kTertiaryColor : null,
        ),
        Obx(() {
          return controller.recommendedRestaurants.isEmpty
              ? Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark 
                          ? kDialogBlack.withOpacity(0.5)
                          : kGreyColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.restaurant_outlined,
                          size: 48,
                          color: kSecondaryColor.withOpacity(0.7),
                        ),
                        SizedBox(height: 16),
                        MyText(
                          text: 'noRecommendationsFound'.tr,
                          size: 16,
                          weight: FontWeight.w600,
                          textAlign: TextAlign.center,
                          color: isDark ? kTertiaryColor : null,
                        ),
                        SizedBox(height: 8),
                        MyText(
                          text: 'noRecommendedRestaurantsAvailable'.tr + 
                              ' ${controller.selectedCountry.value}',
                          size: 14,
                          textAlign: TextAlign.center,
                          color: isDark ? kDarkTextColor : kGreyColor,
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: 180,
                      child: PageView.builder(
                        itemCount: controller.recommendedRestaurants.length,
                        controller: pageController,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final restaurant =
                              controller.recommendedRestaurants[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: GestureDetector(
                              onTap: () => Get.to(() => RestaurantDetails(
                                  restaurantId: restaurant.id)),
                              child: Stack(
                                children: [
                                  CommonImageView(
                                    height: Get.height,
                                    width: Get.width,
                                    url: restaurant.image.isNotEmpty
                                        ? restaurant.image
                                        : 'https://via.placeholder.com/400x200',
                                    radius: 10.0,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: Get.width,
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: kSecondaryColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  MyText(
                                                    text: restaurant.name,
                                                    size: 16,
                                                    color: kPrimaryColor,
                                                    weight: FontWeight.w600,
                                                  ),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                        Assets
                                                            .imagesLocationPin,
                                                        height: 16,
                                                        color: kPrimaryColor,
                                                      ),
                                                      MyText(
                                                        paddingLeft: 6,
                                                        text:
                                                            restaurant.location,
                                                        size: 14,
                                                        weight: FontWeight.w500,
                                                        color: kPrimaryColor,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                GestureDetector(
                                                  onTap: () =>
                                                      controller.toggleFavorite(
                                                          restaurant.id),
                                                  child: Image.asset(
                                                    restaurant.isFavorite
                                                        ? Assets.imagesHeart
                                                        : Assets.imagesHeart,
                                                    height: 20,
                                                    color: restaurant.isFavorite
                                                        ? Colors.red
                                                        : kPrimaryColor,
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      color: Color(0xffF5BD4F),
                                                      size: 17,
                                                    ),
                                                    MyText(
                                                      paddingLeft: 4,
                                                      text:
                                                          '${restaurant.rating} ' +
                                                          'ratings'.tr,
                                                      size: 12,
                                                      color: kPrimaryColor,
                                                      weight: FontWeight.w500,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 12),
                    Center(
                      child: SmoothPageIndicator(
                        controller: pageController,
                        count: controller.recommendedRestaurants.length > 3
                            ? 3
                            : controller.recommendedRestaurants.length,
                        effect: ExpandingDotsEffect(
                          dotHeight: 5,
                          dotWidth: 5,
                          spacing: 3,
                          expansionFactor: 4.0,
                          activeDotColor: kSecondaryColor,
                          dotColor: kSecondaryColor.withOpacity(0.4),
                        ),
                        onDotClicked: (index) {
                          pageController.animateToPage(
                            index,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        },
                      ),
                    ),
                  ],
                );
        }),
      ],
    );
  }

  Widget buildTrendingRestaurants(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 25),
        Row(
          children: [
            MyText(
              paddingLeft: 20,
              paddingRight: 5,
              text: 'trending'.tr,
              size: 16,
              weight: FontWeight.w600,
              color: isDark ? kTertiaryColor : null,
            ),
            Image.asset(
              Assets.imagesFlame,
              height: 26,
            ),
          ],
        ),
        Obx(() {
          return controller.trendingRestaurants.isEmpty
              ? Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark 
                          ? kDialogBlack.withOpacity(0.5)
                          : kGreyColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          size: 48,
                          color: kSecondaryColor.withOpacity(0.7),
                        ),
                        SizedBox(height: 16),
                        MyText(
                          text: 'noTrendingRestaurants'.tr,
                          size: 16,
                          weight: FontWeight.w600,
                          textAlign: TextAlign.center,
                          color: isDark ? kTertiaryColor : null,
                        ),
                        SizedBox(height: 8),
                        MyText(
                          text: 'noTrendingRestaurantsAvailable'.tr + 
                              ' ${controller.selectedCountry.value}',
                          size: 14,
                          textAlign: TextAlign.center,
                          color: isDark ? kDarkTextColor : kGreyColor,
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  padding: AppSizes.DEFAULT,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.trendingRestaurants.length,
                  itemBuilder: (context, index) {
                    final restaurant = controller.trendingRestaurants[index];
                    return GestureDetector(
                      onTap: () => Get.to(
                          () => RestaurantDetails(restaurantId: restaurant.id)),
                      child: RestaurantCard(
                        restaurant: restaurant,
                        onFavoriteToggle: () =>
                            controller.toggleFavorite(restaurant.id),
                      ),
                    );
                  },
                );
        }),
      ],
    );
  }
}

// Filter Bottom Sheet
class FilterBottomSheet extends StatelessWidget {
  final ExploreController controller;

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
                  // Use available categories from controller, or fallback to localized list
                  final List<String> categories =
                      controller.availableCategories.isEmpty
                          ? ['halalFood'.tr, 'pizza'.tr, 'sandwiches'.tr]
                          : controller.availableCategories;

                  return Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    children: categories.map((category) {
                      final isSelected =
                          controller.selectedCategories.contains(category);

                      return GestureDetector(
                        onTap: () => controller.toggleCategory(category),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: isSelected
                                ? kSecondaryColor
                                : Colors.transparent,
                            border: Border.all(
                              width: 1.0,
                              color:
                                  isSelected ? kSecondaryColor : kBorderColor,
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
                      final isSelected = controller.selectedRestaurantNames
                          .contains(restaurant);

                      return GestureDetector(
                        onTap: () =>
                            controller.toggleRestaurantName(restaurant),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: isSelected
                                ? kSecondaryColor
                                : Colors.transparent,
                            border: Border.all(
                              width: 1.0,color:
                                  isSelected ? kSecondaryColor : kBorderColor,
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