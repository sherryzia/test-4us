// lib/view/screens/explore/explore.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_images.dart';
import 'package:restaurant_finder/constants/app_sizes.dart';
import 'package:restaurant_finder/controller/explore_controller.dart';
import 'package:restaurant_finder/view/screens/home/restaurant_details.dart';
import 'package:restaurant_finder/view/widget/common_image_view_widget.dart';
import 'package:restaurant_finder/view/widget/custom_app_bar_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';
import 'package:restaurant_finder/view/widget/restaurant_card_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Explore extends StatelessWidget {
  final ExploreController controller = Get.put(ExploreController());
  final TextEditingController searchController = TextEditingController();
  final PageController pageController = PageController(
    viewportFraction: 0.85,
    initialPage: 0,
  );

  Explore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: simpleAppBar(
        title: 'Explore',
        haveLeading: false,
      ),
      body: Obx(() {
        return controller.isLoading.value
            ? Center(child: CircularProgressIndicator(color: kSecondaryColor))
            : buildContent();
      }),
    );
  }

  Widget buildContent() {
    return Column(
      children: [
        buildSearchBar(),
        SizedBox(height: 10),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            padding: AppSizes.VERTICAL,
            physics: BouncingScrollPhysics(),
            children: [
              buildTopProfiles(),
              buildRecommendedRestaurants(),
              buildTrendingRestaurants(),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSearchBar() {
    return Padding(
      padding: AppSizes.HORIZONTAL,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: searchController,
              cursorColor: kBlackColor,
              style: TextStyle(
                fontSize: 14,
                color: kBlackColor,
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
                fillColor: kGreyColor.withOpacity(0.1),
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
                hintText: 'Search restaurants',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: kBlackColor.withOpacity(0.8),
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
              // Filter functionality would go here
            },
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: kSecondaryColor,
              ),
              child: Center(
                child: Image.asset(
                  Assets.imagesFilter,
                  color: kPrimaryColor,
                  height: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTopProfiles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          paddingBottom: 16,
          paddingLeft: 20,
          paddingRight: 20,
          text: 'Top Profiles',
          size: 16,
          weight: FontWeight.w600,
        ),
        Obx(() {
          return SizedBox(
            height: 80,
            child: controller.topProfiles.isEmpty
                ? Center(child: Text('No profiles found'))
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
                          Container(
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
                          MyText(
                            text: profile.name,
                            size: 12,
                            weight: FontWeight.w600,
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

  Widget buildRecommendedRestaurants() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          paddingTop: 20,
          paddingBottom: 16,
          paddingLeft: 20,
          paddingRight: 20,
          text: 'Recommendations',
          size: 16,
          weight: FontWeight.w600,
        ),
        Obx(() {
          return controller.recommendedRestaurants.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('No recommendations found'),
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
                          final restaurant = controller.recommendedRestaurants[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: GestureDetector(
                              onTap: () => Get.to(() => RestaurantDetails(restaurantId: restaurant.id)),
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
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                                        Assets.imagesLocationPin,
                                                        height: 16,
                                                        color: kPrimaryColor,
                                                      ),
                                                      MyText(
                                                        paddingLeft: 6,
                                                        text: restaurant.location,
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
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                GestureDetector(
                                                  onTap: () => controller.toggleFavorite(restaurant.id),
                                                  child: Image.asset(
                                                    restaurant.isFavorite
                                                        ? Assets.imagesHeart // Assuming you have this asset
                                                        : Assets.imagesHeart,
                                                    height: 20,
                                                    color: restaurant.isFavorite ? Colors.red : kPrimaryColor,
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
                                                      text: '${restaurant.rating} Ratings',
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

  Widget buildTrendingRestaurants() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 25),
        Row(
          children: [
            MyText(
              paddingLeft: 20,
              paddingRight: 5,
              text: 'Trending',
              size: 16,
              weight: FontWeight.w600,
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
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('No trending restaurants found'),
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
                                              onTap: () => Get.to(() => RestaurantDetails(restaurantId: restaurant.id)),

                      child: RestaurantCard(
                        restaurant: restaurant,
                        onFavoriteToggle: () => controller.toggleFavorite(restaurant.id),
                      ),
                    );
                  },
                );
        }),
      ],
    );
  }
}