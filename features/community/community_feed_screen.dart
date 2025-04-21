import 'package:flutter/material.dart';

class CommunityFeedScreen extends StatefulWidget {
  final String img;
  final String tag;
  final String name;
  final String members;
  const CommunityFeedScreen({
    super.key,
    required this.tag,
    required this.members,
    required this.img,
    required this.name,
  });

  @override
  State<CommunityFeedScreen> createState() => _GreenCommunityFeedState();
}

class _GreenCommunityFeedState extends State<CommunityFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Banner
              Hero(
                tag: widget.tag,
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.img),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // Community Info
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(widget.img),
                  backgroundColor: Colors.green,
                  radius: 30,
                ),
                title: Text(
                  widget.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  widget.members,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),

              // Create Post Box
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Create a post',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      suffixIcon: const CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1657306607237-3eab445c4a84?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                        radius: 15,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
              ),

              // Posts Feed
              ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: const [
                  PostCard(
                    avatar:
                        'https://images.unsplash.com/photo-1657638855015-80fde41a9dfc?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fHNleHklMjBnaXJsfGVufDB8fDB8fHww',
                    name: 'Mash Abey',
                    time: '25 minutes ago',
                    content:
                        'Just completed my first #EcoChallenge! Switched to reusable bags and gave away my single-use plastic by 50%. It\'s the little steps that make a big impact...',
                    image:
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTitWTYFuqnKJH8_7fauLJWXZf-SdUmMWiI2g&s',
                  ),
                  PostCard(
                    avatar:
                        'https://images.unsplash.com/photo-1646375053164-2053f8115cbd?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NDN8fHNleHklMjBnaXJsfGVufDB8fDB8fHww',
                    name: 'Clara Ocean',
                    time: '45 minutes ago',
                    content:
                        'Small wins: switched to a bamboo toothbrush and reusable produce bags at the farmers market!',
                    image:
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTD6rWFpbfEaUfdrQ4kxs5B9I_GZmKCYaI4FDuqlj9cJQzAA6owC4i4J51P4yqAukYF8Z4&usqp=CAU',
                  ),
                  PostCard(
                    avatar:
                        'https://images.unsplash.com/photo-1657640536270-e7321346d744?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8ODB8fHNleHklMjBnaXJsfGVufDB8fDB8fHww',
                    name: 'Ava Sunhill',
                    time: '1 hour ago',
                    content:
                        'Water challenge success! Started your shower by just 2 minutes, and you can save hundreds or even thousands of gallons of water...',
                    image:
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQF9_eX0udsvn_l3W0Bma49FqFj8qTPOZMWJWAeEEt3rkR3K2JHYWm7GHVorFd57xP0bpg&usqp=CAU',
                  ),
                  PostCard(
                    avatar:
                        'https://images.unsplash.com/photo-1539697808415-0873e6eb16dd?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTM0fHxzZXh5JTIwZ2lybHxlbnwwfHwwfHx8MA%3D%3D',
                    name: 'Mia Bloom',
                    time: '2 hours ago',
                    content: 'This month, I\'m focused on',
                    image:
                        'https://media.licdn.com/dms/image/v2/D5610AQHpqX4kbur2ww/image-shrink_800/image-shrink_800/0/1728326860935/Awareness-TailorECPplpng?e=2147483647&v=beta&t=2_p6wBSR-aEa1tIMJJ3JDIuM85r68qFffv-wsdDSUTU',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final String avatar;
  final String name;
  final String time;
  final String content;
  final String image;

  const PostCard({
    super.key,
    required this.avatar,
    required this.name,
    required this.time,
    required this.content,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(avatar),
            ),
            title: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            subtitle: Text(
              time,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ),

          // Post Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(content),
          ),

          // Post Image
          if (image.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: double.infinity,
              height: 200,
              child: Image.network(
                image,
                fit: BoxFit.cover,
              ),
            ),

          // Interaction Buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
