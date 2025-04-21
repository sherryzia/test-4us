import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecomanga/common/app_colors.dart';
import 'package:ecomanga/common/buttons/scale_button.dart';
import 'package:ecomanga/common/widgets/news_datails_page.dart';
import 'package:ecomanga/common/widgets/product_detail_page.dart';
import 'package:ecomanga/controllers/controllers.dart';
import 'package:ecomanga/features/home/SocialPostScreen.dart';
import 'package:ecomanga/features/home/create_post_screen.dart';
import 'package:ecomanga/features/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Variables
  int _currentIndex = 0;
  bool _isMarketplaceTab = false;

  // Carousel Images
  final List<String> _carouselImages = [
    'https://static.vecteezy.com/system/resources/previews/023/603/663/non_2x/flooding-on-the-city-street-generative-ai-photo.jpg',
    "https://virtualandco.net/wp-content/uploads/2022/04/0369_637599432108866601.jpg",
    'https://www.baaa-acro.com/sites/default/files/import/Photos-43/ER-AZT-1.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    // Screen Height
    final screenHeight = MediaQuery.of(context).size.height;
    Controllers.postController.getPosts();
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: screenHeight -
                (AppBar().preferredSize.height +
                    MediaQuery.of(context).padding.top),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTabSection(),
              const SizedBox(height: 16),
              if (!_isMarketplaceTab) ...[
                _buildNewsFeedContent(screenHeight),
              ] else ...[
                _buildMarketplaceContent(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // AppBar
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      title: const Text(
        'Home',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  // Tab Section
  Widget _buildTabSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.lightBlue.shade50,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isMarketplaceTab = false),
              child: Column(
                children: [
                  Text(
                    'News Feed',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: !_isMarketplaceTab ? Colors.green : Colors.black54,
                    ),
                  ),
                  if (!_isMarketplaceTab) const SizedBox(height: 4),
                  if (!_isMarketplaceTab)
                    Container(height: 2, color: Colors.green),
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isMarketplaceTab = true),
              child: Column(
                children: [
                  Text(
                    'Marketplace',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _isMarketplaceTab ? Colors.green : Colors.black54,
                    ),
                  ),
                  if (_isMarketplaceTab) const SizedBox(height: 4),
                  if (_isMarketplaceTab)
                    Container(height: 2, color: Colors.green),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // News Feed Content
  Widget _buildNewsFeedContent(double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Breaking news',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        _buildCarousel(screenHeight),
        const SizedBox(height: 8),
        _buildCarouselIndicator(),
        const SizedBox(height: 16),
        _buildCreatePostSection(),
        const SizedBox(height: 16),
        _buildPosts(),
      ],
    );
  }

  // Carousel
  Widget _buildCarousel(double screenHeight) {
    return CarouselSlider(
      items: _carouselImages.map((image) {
        return ScaleButton(
          onTap: () {
            Utils.go(
              context: context,
              screen: NewsDatailsPage(
                img: image,
                imagetag: image,
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.buttonColor.withOpacity(0.7),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: image,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                      height: 120,
                      width: 300,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Lorem ipsum dolor sit amet, putate libero et velit",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                  "28 October, 2024",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      }).toList(),
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: false,
        height: screenHeight * 0.26,
        onPageChanged: (index, reason) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }

  // Carousel Indicator
  Widget _buildCarouselIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _carouselImages.asMap().entries.map((entry) {
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentIndex == entry.key
                ? Colors.green
                : Colors.grey.shade300,
          ),
        );
      }).toList(),
    );
  }

  // Create Post Section
  Widget _buildCreatePostSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ScaleButton(
        onTap: () {
          Utils.go(
            context: context,
            screen: const CreatePostPage(),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade100,
          ),
          child: Row(
            children: [
              const Text(
                'Create a post',
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
              const Spacer(),
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1657306607237-3eab445c4a84?w=400',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Posts Section
  Widget _buildPosts() {
    // Controllers.profileController.getUser();
    if (Controllers.postController.posts.isEmpty) {
      return Center(
        child: SizedBox(
          height: 36,
          width: 36,
          child: Text("No Posts"),
        ),
      );
    } else
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: Controllers.postController.posts.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 6,
                    spreadRadius: 2,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1657306607237-3eab445c4a84?w=400',
                      ),
                    ),
                    title: Text(
                      Controllers.profileController
                                  .isLoading[keys.getProfile] ??
                              false
                          ? "--"
                          : Controllers
                              .postController.posts[index].author.capitalize!,
                    ),
                    subtitle: Text(
                      Controllers.profileController
                                  .isLoading[keys.getProfile] ??
                              false
                          ? "--"
                          : DateFormat('y-MM-dd HH:mm').format(
                              Controllers.postController.posts[index].createdAt,
                            ),
                      // 3 days ago
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      Controllers.profileController
                                  .isLoading[keys.getProfile] ??
                              false
                          ? "--"
                          : Controllers.postController.posts[index].description,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 200,
                    child: ScaleButton(
                      onTap: () {
                        Controllers.postController.getPostById(
                          Controllers.postController.posts[index].id,
                        );
                        Controllers.postController.getCommentsById(
                          Controllers.postController.posts[index].id,
                        );
                        Utils.go(
                          context: context,
                          screen: SocialPostScreen(
                            tag: "post_image_$index.tostrig",
                            image:
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCqwlRGS6Xd1cSAO0KqutnKKCpEaU_YPEpsPaZWAPgMBI8cUYJS7IgQiS82Aou65rTm2Q",
                            profileImg:
                                "https://images.unsplash.com/photo-1657306607237-3eab445c4a84?w=400",
                          ),
                        );
                      },
                      child: Hero(
                        tag: 'post_image_$index',
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                          child: Image.network(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCqwlRGS6Xd1cSAO0KqutnKKCpEaU_YPEpsPaZWAPgMBI8cUYJS7IgQiS82Aou65rTm2Q',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.favorite_border_outlined)),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                          onPressed: () {}, icon: Icon(Icons.comment_outlined)),
                      const SizedBox(
                        width: 10,
                      ),
                      ScaleButton(
                        onTap: () {},
                        child: Image.asset(
                          "assets/icons/send.png",
                          height: 40,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );
  }

  // Marketplace Content Placeholder
  Widget _buildMarketplaceContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.green),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.green),
                      ),
                    ),
                  ),
                  Icon(Icons.tune, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Recommended for you',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _buildHorizontalProductList(
              [
                ProductItem('8 billion trees', '\$35',
                    'https://shop.8billiontrees.com/cdn/shop/products/world-map-t-shirt-front_900x900.jpg?v=1666315204'),
                ProductItem('Loofah sponge', '\$45',
                    'https://images-cdn.ubuy.co.in/635e4f8d0f9e4d1b11333764-frtim-natural-loofah-sponge-shower.jpg'),
                ProductItem('Simple chair', '\$34',
                    'https://m.media-amazon.com/images/I/81EtcNAflUL._AA360_AC_QL70_.jpg'),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Recently viewed',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _buildHorizontalProductList([
              ProductItem('Set of 8 Chair', '\$15',
                  'https://img.freepik.com/free-photo/elegant-leather-armchair-sitting-modern-office-studio-generated-by-ai_188544-10881.jpg?semt=ais_hybrid'),
              ProductItem('Classic Chair', '\$85',
                  'https://juliettesinteriors.co.uk/wp-content/uploads/2019/09/Classic-Designer-Italian-Antique-Silver-Occasional-Armchair-1-1.jpg'),
              ProductItem('Sitting Chair', '\$45',
                  'https://www.estre.in/cdn/shop/files/2-min-1_0035c655-d0e7-4c27-a0c4-0d70b67551cf.jpg?v=1710413752'),
            ]),
            const SizedBox(height: 24),
            const Text(
              'Popular',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _buildHorizontalProductList([
              ProductItem('Product 1', '\$25',
                  'https://thebetterbath.in/cdn/shop/products/DSC_1560_SPONGELOOFAH_PURPLE_TAG_BOP_480x480.jpg?v=1665684371g'),
              ProductItem('Product 2', '\$40',
                  'https://wgassets.duravit.cloud/photomanager-duravit/file/8a8a818d826854c4018282628ca956da/duratsyle_whirlpool.jpg?derivate=width~1920'),
              ProductItem('Product 3', '\$30',
                  'https://images.woodenstreet.de/image/data/kp-lamps-store/lot-2/study-desk-office-reading-curved-table-lamp-with-adjustable-head-shade/1.jpg'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalProductList(List<ProductItem> products) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Container(
            width: 150,
            margin: const EdgeInsets.only(right: 12),
            child: _buildProductCard(products[index]),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(ProductItem product) {
    return ScaleButton(
      onTap: () {
        Utils.go(
          context: context,
          screen: ProductDetailPage(
            image: product.image,
            name: product.name,
            price: product.price,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.blue.shade100.withOpacity(0.4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: product.image,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(product.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.name,
              style: const TextStyle(fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              children: [
                Text(
                  product.price,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Icon(Icons.add, size: 20, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProductItem {
  final String name;
  final String price;
  final String image;

  ProductItem(this.name, this.price, this.image);
}
