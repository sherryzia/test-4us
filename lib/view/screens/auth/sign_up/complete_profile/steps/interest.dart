import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/utils/global_instances.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Interest extends StatefulWidget {
  const Interest({super.key});

  @override
  State<Interest> createState() => _InterestState();
}

class _InterestState extends State<Interest> {
  // Map of interests with their IDs (you'll need to replace these with actual API IDs)
  final List<Map<String, dynamic>> _items = [
    {'id': 1, 'icon': Assets.imagesPhotography, 'title': 'Photography'},
    {'id': 2, 'icon': Assets.imagesShoppingIcon, 'title': 'Shopping'},
    {'id': 3, 'icon': Assets.imagesKaraoke, 'title': 'Karaoke'},
    {'id': 4, 'icon': Assets.imagesYoga, 'title': 'Yoga'},
    {'id': 5, 'icon': Assets.imagesCook, 'title': 'Cooking'},
    {'id': 6, 'icon': Assets.imagesTennis, 'title': 'Tennis'},
    {'id': 7, 'icon': Assets.imagesSport, 'title': 'Run'},
    {'id': 8, 'icon': Assets.imagesRipple, 'title': 'Swimming'},
    {'id': 9, 'icon': Assets.imagesPlatte, 'title': 'Art'},
    {'id': 10, 'icon': Assets.imagesTravelling, 'title': 'Traveling'},
    {'id': 11, 'icon': Assets.imagesParachute, 'title': 'Extreme'},
    {'id': 12, 'icon': Assets.imagesVideoGames, 'title': 'Video Games'},
    {'id': 13, 'icon': Assets.imagesRipple, 'title': 'Drink'},
    {'id': 14, 'icon': Assets.imagesMusicIcon, 'title': 'Music'},
  ];

  bool _isSelected(int interestId) {
    return profileController.interests.contains(interestId);
  }

  void _toggleInterest(int interestId) {
    profileController.toggleInterest(interestId);
    setState(() {}); // Refresh UI
    
    print('Interests updated: ${profileController.interests.toList()}');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            shrinkWrap: true,
            padding: AppSizes.DEFAULT,
            physics: BouncingScrollPhysics(),
            itemCount: _items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 48,
              crossAxisSpacing: 15,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              final item = _items[index];
              final isSelected = _isSelected(item['id']);
              
              return GestureDetector(
                onTap: () => _toggleInterest(item['id']),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: isSelected ? kSecondaryColor : kPrimaryColor,
                    border: Border.all(
                      color: isSelected ? kSecondaryColor : Colors.grey[300]!,
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: kSecondaryColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ]
                        : [],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        item['icon'],
                        height: 20,
                        color: isSelected ? kPrimaryColor : kSecondaryColor,
                      ),
                      Expanded(
                        child: MyText(
                          paddingLeft: 10,
                          text: item['title'],
                          size: 14,
                          color: isSelected ? kPrimaryColor : kBlackColor,
                          weight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // Selection info and debug
        Container(
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: profileController.interests.isNotEmpty 
                ? kSecondaryColor.withOpacity(0.1)
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: profileController.interests.isNotEmpty 
                  ? kSecondaryColor
                  : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Obx(() => Column(
            children: [
              Text(
                '${profileController.interests.length} interest${profileController.interests.length == 1 ? '' : 's'} selected',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: profileController.interests.isNotEmpty 
                      ? kSecondaryColor
                      : Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              if (profileController.interests.isEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    'Select at least one interest to continue',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              // Debug info (remove in production)
              if (profileController.interests.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'IDs: ${profileController.interests.toList()}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          )),
        ),
      ],
    );
  }
}