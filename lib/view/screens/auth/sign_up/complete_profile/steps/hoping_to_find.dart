import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/utils/global_instances.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class HopingToFind extends StatefulWidget {
  HopingToFind({super.key});

  @override
  State<HopingToFind> createState() => _HopingToFindState();
}

class _HopingToFindState extends State<HopingToFind> {
  int currentIndex = 0;
  
  final List<String> items = [
    'A relationship',
    'Something Casual',
    'I am not sure yet',
    'Prefer not to say',
  ];

  // Map UI options to API values
  final List<String> apiValues = [
    'Long-term relationship', // Maps to 'REL'
    'Casual dating',         // Maps to 'CAS'
    'Not sure',             // Maps to 'UNS'
    'Friendship',           // Maps to 'FRI'
  ];

  final List<String> images = [
    Assets.imagesS1,
    Assets.imagesS2,
    Assets.imagesS3,
    Assets.imagesS4,
  ];

  @override
  void initState() {
    super.initState();
    // Set initial selection and update controller
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSelection(0); // Default to first option
    });
  }

  void _updateSelection(int index) {
    setState(() {
      currentIndex = index;
    });
    
    // Update ProfileController with the API-compatible value
    profileController.setRelationshipExpectationByIndex(index);
    
    print('Relationship expectation selected: ${items[index]} -> ${profileController.relationshipExpectation.value}');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            padding: AppSizes.DEFAULT,
            children: List.generate(
              items.length,
              (index) {
                return _SwitchTile(
                  image: images[index],
                  title: items[index],
                  isSelected: currentIndex == index,
                  onTap: () {
                    _updateSelection(index);
                  },
                );
              },
            ),
          ),
        ),
        // Debug display (remove in production)
        Obx(() => Container(
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              Text(
                'Selected: ${items[currentIndex]}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              Text(
                'Controller: "${profileController.relationshipExpectation.value}"',
                style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )),
      ],
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String title;
  final String image;
  final bool isSelected;
  final VoidCallback onTap;
  
  const _SwitchTile({
    super.key,
    required this.title,
    required this.image,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: 88,
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          border: GradientBoxBorder(
            gradient: !isSelected
                ? LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                    ],
                  )
                : LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      kSecondaryColor,
                      kPurpleColor,
                    ],
                  ),
            width: 2,
          ),
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
            colorFilter: isSelected 
                ? null
                : ColorFilter.mode(
                    Colors.black.withOpacity(0.3),
                    BlendMode.darken,
                  ),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isSelected 
                ? Colors.transparent
                : Colors.black.withOpacity(0.2),
          ),
          child: Center(
            child: MyText(
              text: title,
              size: isSelected ? 16 : 14,
              weight: FontWeight.w600,
              color: kPrimaryColor,
            ),
          ),
        ),
      ),
    );
  }
}