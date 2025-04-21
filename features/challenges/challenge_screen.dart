import 'package:ecomanga/common/buttons/scale_button.dart';
import 'package:ecomanga/features/challenges/challenge_progress_screen.dart';
import 'package:ecomanga/features/home/home_screen.dart';
import 'package:ecomanga/features/utils/utils.dart';
import 'package:flutter/material.dart';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({super.key});

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  final List<String> filterOptions = [
    'Daily',
    'Weekly',
    'Monthly',
    'Seasonal',
    'Special'
  ];
  String selectedFilter = 'Monthly';

  final List<Map<String, dynamic>> challenges = [
    {
      'title': '30 DAYS\n3-KM WALK\nCHALLENGE',
      'image': 'assets/walk_challenge.jpg',
      'color': Colors.orange,
      'featured': true,
    },
    {
      'title': 'Energy saving\nMonth',
      'image': 'assets/energy_saving.jpg',
      'color': Colors.green,
    },
    {
      'title': 'Recycle 45\nplastic bottles',
      'image': 'assets/recycle.jpg',
      'color': Colors.green,
    },
    {
      'title': '30 days waste\nreduction',
      'image': 'assets/waste_reduction.jpg',
      'color': Colors.green,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Challenges',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_sharp),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Featured Challenge
              Container(
                height: 160,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                        image: AssetImage('assets/images/challengeimg.png'),
                        fit: BoxFit.cover)),
              ),

              const SizedBox(height: 10),

              // Filter Options
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: filterOptions.map((filter) {
                    final isSelected = filter == selectedFilter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedFilter = filter;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: Text(
                            filter,
                            style: TextStyle(
                                color: isSelected ? Colors.black : Colors.grey,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 10),

              // Challenge Grid

              const SizedBox(height: 24),
              _buildHorizontalProductList(
                [
                  ProductItem('Enery Saving Month', '50',
                      'https://suncommon.com/wp-content/uploads/2024/02/0929.USABlog-October1-780x389-cropped.jpg'),
                  ProductItem('Recycle Plastic bottles', '45',
                      'https://images.stockcake.com/public/6/8/3/68358d8f-934a-4a1d-bc62-3fc92358209b_large/recycling-plastic-bottles-stockcake.jpg'),
                  ProductItem('30 Dats wasted food challenge', '34',
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQSyuIYTSUmH0ygctLckJ-Ht6rn9mV8luE0hw&s'),
                ],
              ),

              // Badges Section
              const Text(
                'Badges',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.eco,
                      color: Colors.grey[400],
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Leaderboards Section
              const Text(
                'Leaderboards',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 150,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "User's fullname",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('@username',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // User Score
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Text('4'),
                ),
                title: const Text('Manuel Riggs'),
                trailing: const Text(
                  '3406',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // IconData _getIconForChallenge(String title) {
  //   if (title.contains('Energy')) return Icons.bolt;
  //   if (title.contains('Recycle')) return Icons.recycling;
  //   if (title.contains('waste')) return Icons.delete_outline;
  //   return Icons.eco;
  // }

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
          screen: ChallengeProgressScreen(
            imagePath: product.image,
            name: product.name,
            progress: product.price,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(7),
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
            // Row(
            //   children: [
            //     Text(
            //       product.price,
            //       style: const TextStyle(
            //         fontSize: 16,
            //         fontWeight: FontWeight.w600,
            //       ),
            //     ),
            //     const Spacer(),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
