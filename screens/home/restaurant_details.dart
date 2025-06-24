import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:restaurant_finder/constants/app_colors.dart';
import 'package:restaurant_finder/constants/app_fonts.dart';
import 'package:restaurant_finder/constants/app_images.dart';
import 'package:restaurant_finder/constants/app_sizes.dart';
import 'package:restaurant_finder/controller/menu_controller.dart';
import 'package:restaurant_finder/controller/restaurant_details_controller.dart';
import 'package:restaurant_finder/controller/reviews_controller.dart';
import 'package:restaurant_finder/model/explore_model.dart';
import 'package:restaurant_finder/view/widget/common_image_view_widget.dart';
import 'package:restaurant_finder/view/widget/my_text_widget.dart';
import 'package:restaurant_finder/controller/theme_controller.dart';

class RestaurantDetails extends StatefulWidget {
  final String? restaurantId;

  const RestaurantDetails({super.key, this.restaurantId});

  @override
  State<RestaurantDetails> createState() => _RestaurantDetailsState();
}

class _RestaurantDetailsState extends State<RestaurantDetails>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  RestaurantDetailsController? _detailsController;
  RestaurantMenuController? _menuController;
  ReviewsController? _reviewsController;

  String _getRestaurantStatus(RestaurantModel? restaurant) {
    if (restaurant?.hasHours != true || restaurant?.hours == null) {
      return 'Hours not available';
    }

    final isOpen = restaurant!.isOpenNow();
    final currentHours = restaurant.getCurrentDayHours();

    if (currentHours == 'Closed today') {
      return 'Closed today';
    }

    return isOpen ? 'Open now • $currentHours' : currentHours;
  }

  @override
  void initState() {
    super.initState();

    // Initialize controllers only if restaurantId is provided
    if (widget.restaurantId != null && widget.restaurantId!.isNotEmpty) {
      try {
        _detailsController = Get.put(
            RestaurantDetailsController(restaurantId: widget.restaurantId!),
            tag: widget.restaurantId);
        _menuController = Get.put(
            RestaurantMenuController(widget.restaurantId!),
            tag: widget.restaurantId);
        _reviewsController = Get.put(ReviewsController(widget.restaurantId!),
            tag: widget.restaurantId);
      } catch (e) {
        print("Error initializing controllers: $e");
      }
    }

    // Initialize tab controller
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // Dispose controllers
    _tabController.dispose();

    // Remove controllers only if they were created
    if (widget.restaurantId != null && widget.restaurantId!.isNotEmpty) {
      try {
        Get.delete<RestaurantDetailsController>(tag: widget.restaurantId);
        Get.delete<RestaurantMenuController>(tag: widget.restaurantId);
        Get.delete<ReviewsController>(tag: widget.restaurantId);
      } catch (e) {
        print("Error disposing controllers: $e");
      }
    }

    super.dispose();
  }

  SliverAppBar _buildSliverAppBar(
    BuildContext context,
    RestaurantModel? restaurant,
    RestaurantDetailsController? controller,
    List<String> tabs,
    bool isDark) {
  return SliverAppBar(
    elevation: 1,
    forceElevated: true,
    pinned: true,
    floating: false,
    backgroundColor: kSecondaryColor,
    expandedHeight: 300,
    automaticallyImplyLeading: false,
    centerTitle: true,
    leading: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => Get.back(),
          child: Image.asset(
            Assets.imagesArrowBack,
            height: 16,
            color: kPrimaryColor,
          ),
        ),
      ],
    ),
    title: MyText(
      text: 'details'.tr,
      size: 16,
      weight: FontWeight.w600,
      color: kPrimaryColor,
    ),
    flexibleSpace: FlexibleSpaceBar(
      background: Container(
        color: isDark ? kBlackColor : kPrimaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                    child: CommonImageView(
                      height: Get.height,
                      radius: 0.0,
                      width: Get.width,
                      url: restaurant?.image?.isNotEmpty == true
                          ? restaurant!.image
                          : 'https://picsum.photos/400/300',
                    ),
                  ),
                  if (controller != null)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () => controller.toggleFavorite(),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: kPrimaryColor,
                          ),
                          child: Center(
                            child: Obx(() => Image.asset(
                              controller.isFavorite.value
                                  ? Assets.imagesHeart
                                  : Assets.imagesHeart,
                              height: 20,
                              color: controller.isFavorite.value 
                                  ? Colors.red 
                                  : kSecondaryColor,
                            )),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: AppSizes.DEFAULT,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: MyText(
                          text: restaurant?.name ?? 'Restaurant Name',
                          size: 20,
                          weight: FontWeight.w600,
                          color: isDark ? kTertiaryColor : null,
                        ),
                      ),
                      Icon(
                        Icons.star,
                        color: Color(0xffF5BD4F),
                        size: 17,
                      ),
                      MyText(
                        paddingLeft: 4,
                        text: restaurant != null 
                            ? '${restaurant.rating} Ratings'
                            : 'No ratings',
                        size: 14,
                        weight: FontWeight.w500,
                        color: isDark ? kDarkTextColor : null,
                      ),
                    ],
                  ),
                  SizedBox(height: 14),
                  Row(
                    children: [
                      Image.asset(
                        Assets.imagesLocationPin,
                        height: 16,
                        color: kGreyColor,
                      ),
                      MyText(
                        paddingLeft: 6,
                        text: restaurant?.location ?? 'Location',
                        size: 14,
                        weight: FontWeight.w500,
                        color: kGreyColor,
                      ),
                      SizedBox(width: 20),
                      Image.asset(
                        Assets.imagesTime,
                        height: 16,
                        color: restaurant?.isOpenNow() == true 
                            ? Colors.green 
                            : kGreyColor,
                      ),
                      Expanded(
                        child: MyText(
                          paddingLeft: 6,
                          text: _getRestaurantStatus(restaurant),
                          size: 14,
                          weight: FontWeight.w500,
                          color: restaurant?.isOpenNow() == true 
                              ? Colors.green 
                              : kGreyColor,
                          maxLines: 2,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  // Add hours widget if hours available
                  if (restaurant?.hasHours == true && restaurant?.hours != null)
                    GestureDetector(
                      onTap: () {
                        Get.bottomSheet(
                          RestaurantHoursWidget(
                            restaurant: restaurant!,
                            isDark: isDark,
                          ),
                          isScrollControlled: true,
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 12),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDark ? kDialogBlack.withOpacity(0.8) : kSecondaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: kSecondaryColor.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 16,
                              color: kSecondaryColor,
                            ),
                            SizedBox(width: 6),
                            MyText(
                              text: 'View all hours',
                              size: 12,
                              color: kSecondaryColor,
                              weight: FontWeight.w500,
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.keyboard_arrow_up,
                              size: 16,
                              color: kSecondaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    ),
    bottom: PreferredSize(
      preferredSize: Size(0, 55),
      child: Container(
        color: isDark ? kBlackColor : kPrimaryColor,
        height: 50,
        child: TabBar(
          controller: _tabController,
          labelColor: kSecondaryColor,
          unselectedLabelColor: kGreyColor,
          indicatorColor: kSecondaryColor,
          indicatorWeight: 2,
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.URBANIST,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: AppFonts.URBANIST,
          ),
          automaticIndicatorColorAdjustment: false,
          tabs: tabs.map((e) {
            return Tab(text: e);
          }).toList(),
        ),
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final bool isDark = themeController.isDarkMode;
    final List<String> _items = ['menu'.tr, 'reviews'.tr];

    return Scaffold(
      backgroundColor: isDark ? kBlackColor : Colors.white,
      body: widget.restaurantId != null &&
              widget.restaurantId!.isNotEmpty &&
              _detailsController != null
          ? Obx(() {
              if (_detailsController!.isLoading.value) {
                return Center(
                    child: CircularProgressIndicator(color: kSecondaryColor));
              }

              if (_detailsController!.restaurant.value == null) {
                return Center(
                  child: MyText(
                    text: 'Restaurant not found',
                    color: isDark ? kTertiaryColor : null,
                  ),
                );
              }

              final restaurant = _detailsController!.restaurant.value!;

              return NestedScrollView(
                physics: BouncingScrollPhysics(),
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    _buildSliverAppBar(context, restaurant, _detailsController,
                        _items, isDark),
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  physics: BouncingScrollPhysics(),
                  children: [
                    _Menu(
                      restaurantId: widget.restaurantId!,
                      isDark: isDark,
                    ),
                    _Reviews(
                      restaurantId: widget.restaurantId!,
                      isDark: isDark,
                    ),
                  ],
                ),
              );
            })
          : NestedScrollView(
              physics: BouncingScrollPhysics(),
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  _buildSliverAppBar(context, null, null, _items, isDark),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                physics: BouncingScrollPhysics(),
                children: [
                  _Menu(isDark: isDark),
                  _Reviews(isDark: isDark),
                ],
              ),
            ),
    );
  }
}

class _Menu extends StatelessWidget {
  final String? restaurantId;
  final bool isDark;

  const _Menu({this.restaurantId, required this.isDark});

  @override
  Widget build(BuildContext context) {
    if (restaurantId != null && restaurantId!.isNotEmpty) {
      try {
        // Try to get or put the controller
        RestaurantMenuController controller;
        try {
          controller = Get.find<RestaurantMenuController>(tag: restaurantId);
        } catch (e) {
          // If controller doesn't exist, create it
          controller = Get.put(RestaurantMenuController(restaurantId!),
              tag: restaurantId);
        }

        return GetBuilder<RestaurantMenuController>(
          tag: restaurantId,
          init: controller, // Ensure the controller is initialized
          builder: (controller) {
            if (controller.isLoading) {
              return Center(
                  child: CircularProgressIndicator(color: kSecondaryColor));
            }

            if (controller.menuItems.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      size: 64,
                      color: kGreyColor.withOpacity(0.5),
                    ),
                    SizedBox(height: 16),
                    MyText(
                      text: 'No menu items available',
                      color: isDark ? kTertiaryColor : kGreyColor,
                      size: 16,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
              );
            }

            return GridView.builder(
              shrinkWrap: true,
              padding: AppSizes.DEFAULT,
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisExtent: 95,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: controller.menuItems.length,
              itemBuilder: (context, index) {
                final menuItem = controller.menuItems[index];
                return Column(
                  children: [
                    Expanded(
                      child: CommonImageView(
                        height: Get.height,
                        width: Get.width,
                        radius: 8,
                        url: menuItem.image.isNotEmpty
                            ? menuItem.image
                            : 'https://picsum.photos/100',
                      ),
                    ),
                    MyText(
                      paddingTop: 8,
                      textAlign: TextAlign.center,
                      text: menuItem.name,
                      size: 14,
                      weight: FontWeight.w600,
                      color: isDark ? kTertiaryColor : null,
                      maxLines: 2,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                  ],
                );
              },
            );
          },
        );
      } catch (e) {
        print("Error in _Menu widget: $e");
        return Center(
          child: MyText(
            text: 'Error loading menu',
            color: isDark ? kTertiaryColor : null,
          ),
        );
      }
    } else {
      // Fallback UI with dummy data
      return GridView.builder(
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisExtent: 95,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Expanded(
                child: CommonImageView(
                  height: Get.height,
                  width: Get.width,
                  radius: 8,
                  url: 'https://picsum.photos/100',
                ),
              ),
              MyText(
                paddingTop: 8,
                textAlign: TextAlign.center,
                text: 'Menu Item ${index + 1}',
                size: 14,
                weight: FontWeight.w600,
                color: isDark ? kTertiaryColor : null,
              ),
            ],
          );
        },
      );
    }
  }
}

class _Reviews extends StatelessWidget {
  final String? restaurantId;
  final bool isDark;

  const _Reviews({this.restaurantId, required this.isDark});

  @override
  Widget build(BuildContext context) {
    if (restaurantId != null && restaurantId!.isNotEmpty) {
      try {
        // Try to get or put the controller
        ReviewsController controller;
        try {
          controller = Get.find<ReviewsController>(tag: restaurantId);
        } catch (e) {
          // If controller doesn't exist, create it
          controller =
              Get.put(ReviewsController(restaurantId!), tag: restaurantId);
        }

        return GetBuilder<ReviewsController>(
          tag: restaurantId,
          init: controller, // Ensure the controller is initialized
          builder: (controller) {
            if (controller.isLoading) {
              return Center(
                  child: CircularProgressIndicator(color: kSecondaryColor));
            }

            if (controller.reviews.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.rate_review_outlined,
                      size: 64,
                      color: kGreyColor.withOpacity(0.5),
                    ),
                    SizedBox(height: 16),
                    MyText(
                      text: 'No reviews available',
                      color: isDark ? kTertiaryColor : kGreyColor,
                      size: 16,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              separatorBuilder: (context, index) {
                return Container(
                  height: 1,
                  color: kBorderColor,
                  margin: EdgeInsets.symmetric(vertical: 15),
                );
              },
              shrinkWrap: true,
              padding: AppSizes.DEFAULT,
              physics: BouncingScrollPhysics(),
              itemCount: controller.reviews.length,
              itemBuilder: (context, index) {
                final review = controller.reviews[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonImageView(
                      height: 50,
                      width: 50,
                      radius: 100.0,
                      url: review.userProfileImage.isNotEmpty
                          ? review.userProfileImage
                          : 'https://picsum.photos/50',
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    MyText(
                                      text: review.userName,
                                      size: 16,
                                      paddingBottom: 8,
                                      weight: FontWeight.w600,
                                      color: isDark ? kTertiaryColor : null,
                                    ),
                                    Row(
                                      children: [
                                        RatingBarIndicator(
                                          rating: review.rating.toDouble(),
                                          unratedColor:
                                              kGreyColor.withOpacity(0.4),
                                          itemPadding:
                                              EdgeInsets.only(right: 1),
                                          itemBuilder: (context, index) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          itemCount: 5,
                                          itemSize: 16.0,
                                        ),
                                        MyText(
                                          paddingLeft: 10,
                                          text: _formatDate(review.createdAt),
                                          size: 12,
                                          weight: FontWeight.w500,
                                          color: kGreyColor,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          MyText(
                            paddingTop: 6,
                            text: review.comment,
                            size: 14,
                            lineHeight: 1.5,
                            color: kGreyColor,
                            weight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      } catch (e) {
        print("Error in _Reviews widget: $e");
        return Center(
          child: MyText(
            text: 'Error loading reviews',
            color: isDark ? kTertiaryColor : null,
          ),
        );
      }
    } else {
      // Fallback UI with dummy data
      return ListView.separated(
        separatorBuilder: (context, index) {
          return Container(
            height: 1,
            color: kBorderColor,
            margin: EdgeInsets.symmetric(vertical: 15),
          );
        },
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        itemCount: 3, // Show fewer dummy reviews
        itemBuilder: (context, index) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonImageView(
                height: 50,
                width: 50,
                radius: 100.0,
                url: 'https://picsum.photos/50',
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              MyText(
                                text: 'Sample User ${index + 1}',
                                size: 16,
                                paddingBottom: 8,
                                weight: FontWeight.w600,
                                color: isDark ? kTertiaryColor : null,
                              ),
                              Row(
                                children: [
                                  RatingBarIndicator(
                                    rating: 4 + (index * 0.5),
                                    unratedColor: kGreyColor.withOpacity(0.4),
                                    itemPadding: EdgeInsets.only(right: 1),
                                    itemBuilder: (context, index) =>
                                        Icon(Icons.star, color: Colors.amber),
                                    itemCount: 5,
                                    itemSize: 16.0,
                                  ),
                                  MyText(
                                    paddingLeft: 10,
                                    text: '1 day ago',
                                    size: 12,
                                    weight: FontWeight.w500,
                                    color: kGreyColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    MyText(
                      paddingTop: 6,
                      text:
                          'Great food and excellent service! Would definitely recommend this place.',
                      size: 14,
                      lineHeight: 1.5,
                      color: kGreyColor,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
// New widget for showing detailed hours
class RestaurantHoursWidget extends StatelessWidget {
  final RestaurantModel restaurant;
  final bool isDark;

  const RestaurantHoursWidget({
    Key? key,
    required this.restaurant,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (restaurant.hasHours != true || restaurant.hours == null) {
      return Container(
        height: 200,
        child: Center(
          child: MyText(
            text: 'Hours not available',
            color: isDark ? kTertiaryColor : null,
          ),
        ),
      );
    }

    final dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final hours = restaurant.hours!;
    final now = DateTime.now();
    final currentDay = dayNames[now.weekday - 1];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? kBlackColor : kPrimaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: 'Opening Hours',
                      size: 20,
                      weight: FontWeight.w600,
                      color: isDark ? kTertiaryColor : null,
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(
                        Icons.close,
                        color: kGreyColor,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ...dayNames.map((day) {
                  final dayHours = hours[day];
                  String hoursText = 'Closed';
                  bool isToday = day == currentDay;
                  
                  if (dayHours is List && dayHours.isNotEmpty) {
                    hoursText = dayHours.join(', ');
                  }
                  
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    margin: EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(
                      color: isToday 
                          ? kSecondaryColor.withOpacity(0.1) 
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            MyText(
                              text: day,
                              size: 16,
                              weight: isToday ? FontWeight.w600 : FontWeight.w500,
                              color: isToday 
                                  ? kSecondaryColor 
                                  : (isDark ? kTertiaryColor : kBlackColor),
                            ),
                            if (isToday) ...[
                              SizedBox(width: 8),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: restaurant.isOpenNow() 
                                      ? Colors.green 
                                      : Colors.orange,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: MyText(
                                  text: restaurant.isOpenNow() ? 'Open' : 'Closed',
                                  size: 10,
                                  color: Colors.white,
                                  weight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                        MyText(
                          text: hoursText,
                          size: 14,
                          weight: isToday ? FontWeight.w600 : FontWeight.normal,
                          color: hoursText == 'Closed' 
                              ? Colors.red 
                              : (isDark ? kDarkTextColor : kGreyColor),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}