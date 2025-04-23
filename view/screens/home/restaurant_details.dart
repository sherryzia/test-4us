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

class RestaurantDetails extends StatefulWidget {
  final String restaurantId;

  const RestaurantDetails({super.key, required this.restaurantId});

  @override
  State<RestaurantDetails> createState() => _RestaurantDetailsState();
}

class _RestaurantDetailsState extends State<RestaurantDetails> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late RestaurantDetailsController _detailsController;
  late RestaurantMenuController _menuController;
  late ReviewsController _reviewsController;

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers
_detailsController = Get.put(
  RestaurantDetailsController(restaurantId: widget.restaurantId),
  permanent: true
);    _menuController = Get.put(RestaurantMenuController(widget.restaurantId));
    _reviewsController = Get.put(ReviewsController(widget.restaurantId));
    
    // Initialize tab controller
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // Dispose controllers
    _tabController.dispose();
    
    // Remove controllers
    Get.delete<RestaurantDetailsController>();
    Get.delete<RestaurantMenuController>();
    Get.delete<ReviewsController>();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> _items = [
      'Menu',
      'Reviews',
    ];

      SliverAppBar _buildSliverAppBar(
    BuildContext context,
    RestaurantModel restaurant,
    RestaurantDetailsController controller,
    List<String> tabs
  ) {
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
        text: 'Details',
        size: 16,
        weight: FontWeight.w600,
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: kPrimaryColor,
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
                        url: restaurant.image.isNotEmpty
                            ? restaurant.image
                            : 'https://via.placeholder.com/400x300',
                      ),
                    ),
                    // Add favorite button
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
                                  ? Assets.imagesHeart  // Assuming you have this asset
                                  : Assets.imagesHeart,
                              height: 20,
                              color: controller.isFavorite.value ? Colors.red : kSecondaryColor,
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
                            text: restaurant.name,
                            size: 20,
                            weight: FontWeight.w600,
                          ),
                        ),
                        Icon(
                          Icons.star,
                          color: Color(0xffF5BD4F),
                          size: 17,
                        ),
                        MyText(
                          paddingLeft: 4,
                          text: '${restaurant.rating} Ratings',
                          size: 14,
                          weight: FontWeight.w500,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          Assets.imagesLocationPin,
                          height: 16,
                          color: kGreyColor,
                        ),
                        MyText(
                          paddingLeft: 6,
                          text: restaurant.location,
                          size: 14,
                          weight: FontWeight.w500,
                          color: kGreyColor,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Image.asset(
                          Assets.imagesTime,
                          height: 16,
                          color: kGreyColor,
                        ),
                        MyText(
                          paddingLeft: 6,
                          text: 'Opens at 11:00am',
                          size: 14,
                          weight: FontWeight.w500,
                          color: kGreyColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size(0, 55),
        child: Container(
          color: kPrimaryColor,
          height: 50,
          child: TabBar(
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
              return Tab(
                text: e,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
    
    return DefaultTabController(
      length: _items.length,
      initialIndex: 0,
      child: Scaffold(
        body: Obx(() {
          if (_detailsController.isLoading.value) {
            return Center(child: CircularProgressIndicator(color: kSecondaryColor));
          }
          
          if (_detailsController.restaurant.value == null) {
            return Center(child: Text('Restaurant not found'));
          }
          
          final restaurant = _detailsController.restaurant.value!;
          
          return NestedScrollView(
            physics: BouncingScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                _buildSliverAppBar(context, restaurant, _detailsController, _items),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              physics: BouncingScrollPhysics(),
              children: [
                _Menu(restaurantId: widget.restaurantId),
                _Reviews(restaurantId: widget.restaurantId),
              ],
            ),
          );
        }),
      ),
    );
  }

  // Rest of the code remains the same as previous implementation
  // ... (SliverAppBar method would be identical to previous version)
}

class _Menu extends StatelessWidget {
  final String restaurantId;
  
  const _Menu({required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantMenuController>(
      builder: (controller) {
        if (controller.isLoading) {
          return Center(child: CircularProgressIndicator(color: kSecondaryColor));
        }
        
        if (controller.menuItems.isEmpty) {
          return Center(child: Text('No menu items available'));
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
                        : 'https://via.placeholder.com/100',
                  ),
                ),
                MyText(
                  paddingTop: 8,
                  textAlign: TextAlign.center,
                  text: menuItem.name,
                  size: 14,
                  weight: FontWeight.w600,
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _Reviews extends StatelessWidget {
  final String restaurantId;
  
  const _Reviews({required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReviewsController>(
      builder: (controller) {
        if (controller.isLoading) {
          return Center(child: CircularProgressIndicator(color: kSecondaryColor));
        }
        
        if (controller.reviews.isEmpty) {
          return Center(child: Text('No reviews available'));
        }
        
        return ListView.separated(
          separatorBuilder: (context, index) {
            return Container(
              height: 1,
              color: kBorderColor,
              margin: EdgeInsets.symmetric(vertical: 15),
            );
          },
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
                      : 'https://via.placeholder.com/50',
                ),
                SizedBox(
                  width: 10,
                ),
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
                                  text: review.userName,
                                  size: 16,
                                  paddingBottom: 8,
                                  weight: FontWeight.w600,
                                ),
                                Row(
                                  children: [
                                    RatingBarIndicator(
                                      rating: review.rating.toDouble(),
                                      unratedColor: kGreyColor.withOpacity(0.4),
                                      itemPadding: EdgeInsets.only(right: 1),
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
          shrinkWrap: true,
          padding: AppSizes.DEFAULT,
          physics: BouncingScrollPhysics(),
        );
      },
    );
  }
  
  String _formatDate(DateTime date) {
    final months = ['January', 'February', 'March', 'April', 'May', 'June', 
                   'July', 'August', 'September', 'October', 'November', 'December'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}