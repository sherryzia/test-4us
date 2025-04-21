import 'package:ecomanga/common/buttons/dynamic_button.dart';
import 'package:ecomanga/features/community/community_feed_screen.dart';
import 'package:ecomanga/features/community/create_communitu_screen.dart';
import 'package:ecomanga/features/utils/utils.dart';
import 'package:flutter/material.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community', style: TextStyle(color: Colors.black)),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DynamicButton.fromText(
              text: "Create a Community",
              onPressed: () {
                Utils.go(
                  context: context,
                  screen: const CreateCommunityPage(),
                );
              },
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('Your communities'),
            _buildCommunityList([
              CommunityItem(
                'Green Gathering',
                '3K Members',
                'https://images.twinkl.co.uk/tr/image/upload/t_illustration/illustation/community-cohesion.png',
              ),
              CommunityItem(
                'Nature Nexus',
                '7K Members',
                'https://thumbs.dreamstime.com/z/diverse-people-circle-community-concept-43888196.jpg',
              ),
              CommunityItem('The Big Green Room', '1K Members',
                  'https://media.istockphoto.com/id/891187194/photo/group-of-people-holding-hand-together-in-the-park.jpg?s=612x612&w=0&k=20&c=KIGXrdriCrbc4iOo8h5ILGuHHdVrJL7snylDbAE2C2I='),
            ]),
            const SizedBox(height: 24),
            _buildSectionHeader('Top communities'),
            _buildCommunityList([
              CommunityItem('Planet Pioneers', '4M Members',
                  'https://cdn.pixabay.com/photo/2014/07/08/10/47/team-386673_1280.jpg'),
              CommunityItem('Sustainability Society', '3.1M Members',
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRR1Iol94sU9dRDagZgI3C3j5tJwfLF3wjrEw&s'),
              CommunityItem('Impact Hive', '3.1M Members',
                  'https://upload.wikimedia.org/wikipedia/en/e/e9/Eco-Challenge_Fiji_title.jpg'),
              CommunityItem('EcoSphere', '3M Members',
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS4slzRwAHNNWjibcoHAmOEauablSRH87Ljqg&s'),
              CommunityItem('Impact Hive', '3.1M Members',
                  'https://media.licdn.com/dms/image/sync/v2/D5627AQGOcN6ZD3fM3g/articleshare-shrink_800/articleshare-shrink_800/0/1712237745904?e=2147483647&v=beta&t=2cdNcsAnugSaC5Cb9enxnXWN-H3cBhdiUYYs3HpZ6Bw'),
            ]),
            SizedBox(height: 24),
            _buildSectionHeader('Recommended'),
            _buildCommunityList([
              CommunityItem('The Green Pact', '1.4M Members',
                  'https://cylburn.org/wp-content/uploads/Plastic_Free_July_807x538.jpg'),
              CommunityItem('Earth Keepers', '1.1M Members',
                  'https://dev1.gpsen.org/wp-content/uploads/2019/03/Drawdown-EcoChallenge.jpg'),
              CommunityItem('Impact Collective', '1.1M Members',
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWPWywKV3jlolJePVL6Uk3wPih0peyLR1LQA&s'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (title != 'Recommended')
            TextButton(
              onPressed: () {},
              child: const Text(
                'See all',
                style: TextStyle(color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCommunityList(List<CommunityItem> items) {
    return Column(
      children: items.map((item) => _buildCommunityTile(item)).toList(),
    );
  }

  Widget _buildCommunityTile(CommunityItem item) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 4),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Hero(
          tag: item.image,
          child: Image.network(
            item.image,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        item.name,
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        item.members,
        style: TextStyle(color: Colors.grey),
      ),
      onTap: () {
        Utils.go(
            context: context,
            screen: CommunityFeedScreen(
              tag: item.image,
              img: item.image,
              name: item.name,
              members: item.members,
            ));
      },
    );
  }
}

class CommunityItem {
  final String name;
  final String members;
  final String image;

  CommunityItem(this.name, this.members, this.image);
}
