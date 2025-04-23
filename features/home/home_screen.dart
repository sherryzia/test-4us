import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:timeago/timeago.dart' as timeago;
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Variables
final RxInt _currentIndex = 0.obs;
  bool _isMarketplaceTab = false;

  @override
  void initState() {
    super.initState();
    // Initialize the post controller
    Controllers.posts.getPosts();
    Controllers.posts.getBreakingNews();
  }

  @override
  Widget build(BuildContext context) {
    // Screen Height
    final screenHeight = MediaQuery.of(context).size.height;
    
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
        // _buildBreakingNewsCarousel(screenHeight),
        const SizedBox(height: 8),
        _buildCarouselIndicator(),
        const SizedBox(height: 16),
        _buildCreatePostSection(),
        const SizedBox(height: 16),
        _buildPosts(),
      ],
    );
  }

  // Breaking News Carousel
  Widget _buildBreakingNewsCarousel(double screenHeight) {
     return Obx(() {
    final breakingNews = Controllers.posts.breakingNews;
    final isLoading = Controllers.posts.isLoading[FirebasePostController.GET_POSTS] ?? false;
    
    if (isLoading || breakingNews.isEmpty) {
      return Center(
        child: SizedBox(
          height: screenHeight * 0.26,
          child: const CircularProgressIndicator(),
        ),
      );
    }
      return CarouselSlider(
        items: breakingNews.map((news) {
          return ScaleButton(
            onTap: () {
              Utils.go(
                context: context,
                screen: NewsDatailsPage(
                  img: news['imageUrl'] ?? '',
                  imagetag: news['id'],
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
                    tag: news['id'],
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: news['imageUrl'] ?? '',
                        fit: BoxFit.cover,
                        height: 120,
                        width: 300,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    news['title'] ?? "No title",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    news['publishedAt'] != null 
                        ? _formatNewsDate(news['publishedAt'])
                        : "Recent",
                    style: const TextStyle(color: Colors.grey),
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
            setState(() => _currentIndex.value = index);
          },
        ),
      );
    });
  }

  // Carousel Indicator
  // Replace this method in HomeScreen
Widget _buildCarouselIndicator() {
  return Obx(() {
    final breakingNews = Controllers.posts.breakingNews;
    
    if (breakingNews.isEmpty) return Container();
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(breakingNews.length, (index) {
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentIndex.value == index
                ? Colors.green
                : Colors.grey.shade300,
          ),
        );
      }),
    );
  });
}

  // Create Post Section
  Widget _buildCreatePostSection() {
  final currentUser = Controllers.auth.currentUser;

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
                image: DecorationImage(
                  image: NetworkImage(
                    currentUser?.photoURL ?? 'https://via.placeholder.com/150',
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
    return Obx(() {
      final posts = Controllers.posts.posts;
      final isLoading = Controllers.posts.isLoading[FirebasePostController.GET_POSTS] ?? false;
      
      if (isLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      
      if (posts.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "No posts yet. Be the first to share something!",
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
      
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return _buildPostItem(post, index);
        },
      );
    });
  }

  // Individual Post Item
  Widget _buildPostItem(Map<String, dynamic> post, int index) {
    final hasImage = post.containsKey('imageUrl') && post['imageUrl'] != null;
    
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
                  post['authorPhotoURL'] ?? 'https://via.placeholder.com/150',
                ),
              ),
              title: Text(
                post['authorName'] ?? 'Unknown',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                post['createdAt'] != null 
                    ? _formatPostDate(post['createdAt'])
                    : "Recent",
              ),
              trailing: _buildPostMenu(post),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                post['description'] ?? '',
                style: const TextStyle(fontSize: 14),
              ),
            ),
            if (hasImage) ...[
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: ScaleButton(
                  onTap: () {
                    Controllers.posts.getPostById(post['id']);
                    Controllers.posts.getCommentsByPostId(post['id']);
                    Utils.go(
                      context: context,
                      screen: SocialPostScreen(
                        postId: post['id'],
                        tag: "post_image_${post['id']}",
                        image: post['imageUrl'],
                        profileImg: post['authorPhotoURL'] ?? 'https://via.placeholder.com/150',
                      ),
                    );
                  },
                  child: Hero(
                    tag: 'post_image_${post['id']}',
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: post['imageUrl'],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
            _buildPostActions(post),
          ],
        ),
      ),
    );
  }

  // Post Actions (Like, Comment, Share)
  Widget _buildPostActions(Map<String, dynamic> post) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          _buildLikeButton(post),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {
              Controllers.posts.getPostById(post['id']);
              Controllers.posts.getCommentsByPostId(post['id']);
              Utils.go(
                context: context,
                screen: SocialPostScreen(
                  postId: post['id'],
                  tag: "post_image_${post['id']}",
                  image: post['imageUrl'] ?? '',
                  profileImg: post['authorPhotoURL'] ?? 'https://via.placeholder.com/150',
                ),
              );
            },
            icon: const Icon(Icons.comment_outlined),
          ),
          Text(
            '${post['comments'] ?? 0}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 10),
          ScaleButton(
            onTap: () {
              _sharePost(post);
            },
            child: Image.asset(
              "assets/icons/send.png",
              height: 40,
            ),
          ),
        ],
      ),
    );
  }

  // Like Button
  Widget _buildLikeButton(Map<String, dynamic> post) {
    return FutureBuilder<bool>(
      future: Controllers.posts.checkIfLiked(post['id']),
      builder: (context, snapshot) {
        final bool isLiked = snapshot.data ?? false;
        
        return Row(
          children: [
            IconButton(
              onPressed: () {
                Controllers.posts.toggleLike(post['id']);
              },
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border_outlined,
                color: isLiked ? Colors.red : null,
              ),
            ),
            Text(
              '${post['likes'] ?? 0}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        );
      },
    );
  }

  // Post Options Menu
  Widget _buildPostMenu(Map<String, dynamic> post) {
    final currentUser = Controllers.auth.currentUser;
    final isAuthor = currentUser != null && post['authorId'] == currentUser.uid;
    
    if (!isAuthor) return Container();
    
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        if (value == 'delete') {
          _showDeleteConfirmation(post);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem<String>(
          value: 'delete',
          child: Text('Delete'),
        ),
      ],
    );
  }

  // Show Delete Confirmation Dialog
  void _showDeleteConfirmation(Map<String, dynamic> post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Controllers.posts.deletePost(post['id']);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Share Post
  void _sharePost(Map<String, dynamic> post) {
    // Implementation for sharing post
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing not implemented yet')),
    );
  }

  // Format News Date
  String _formatNewsDate(dynamic timestamp) {
    if (timestamp is! Timestamp) return "Recent";
    
    final date = timestamp.toDate();
    final now = DateTime.now();
    
    if (now.difference(date).inDays < 1) {
      return DateFormat('h:mm a').format(date);
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }

  // Format Post Date with Timeago
  String _formatPostDate(dynamic timestamp) {
    if (timestamp is! Timestamp) return "Recent";
    
    final date = timestamp.toDate();
    return timeago.format(date, locale: 'en_short');
  }

  // Marketplace Content
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