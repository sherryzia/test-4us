import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_fonts.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/constants/app_styling.dart';
import 'package:candid/controller/GlobalController.dart';
import 'package:candid/controller/camera_controller.dart';
import 'package:candid/view/screens/upload_video/start_recording.dart';
import 'package:candid/view/widget/common_image_view_widget.dart';
import 'package:candid/view/widget/my_button_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class UploadVideo extends StatelessWidget {
  const UploadVideo({super.key});

  void _navigateToRecording(Map<String, dynamic> category) {
    print('=== Navigation Debug ===');
    print('Category: ${category['name']}');
    print('Category ID: ${category['id']}');
    print('Category Type: ${category['id'].runtimeType}');
    
    // Ensure we have a valid category ID
    if (category['id'] == null) {
      Get.snackbar(
        'Error',
        'Invalid category selected. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      // Create controller and set category info
      final controller = Get.put(CameraRecordingController());
      controller.setCategoryInfo(category, category['id']);
      
      Get.to(() => StartRecording(
        category: category,
        categoryId: category['id'],
      ));
    } catch (e) {
      print('Error navigating to recording: $e');
      Get.snackbar(
        'Error',
        'Failed to open camera. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final PageController _controller = PageController();
    final GlobalController globalController = Get.find<GlobalController>();

    final List<Map<String, dynamic>> _sliderItems = [
      {
        'title': 'Lights, camera, ',
        'targetedText': 'Candid!',
        'trailing':
            ' Be authentic and find true love. Your perfect match awaits the unfiltered you!',
        'image': Assets.imagesUs1,
      },
      {
        'title': 'More videos = ',
        'targetedText': 'More matches',
        'trailing':
            ' Each upload is a new opportunity to catch someone\'s eye and heart.',
        'image': Assets.imagesUs2,
      },
      {
        'title': 'Spontaneity is sexy! Grab your phone, hit ',
        'targetedText': 'Freestyle',
        'trailing':
            ', and let your authentic charm captivate potential matches.',
        'image': Assets.imagesUs3,
      },
    ];

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              titleSpacing: 20.0,
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      MyText(
                        text: 'Upload Video',
                        size: 20,
                        weight: FontWeight.w600,
                      ),
                      Positioned(
                        top: -24,
                        left: -10,
                        child: Image.asset(
                          Assets.imagesTitleHearts,
                          height: 41.68,
                        ),
                      ),
                      Positioned(
                        top: -3,
                        right: -10,
                        child: Image.asset(
                          Assets.imagesTitleHeartsFilled,
                          height: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              expandedHeight: 71,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: AppSizes.HORIZONTAL,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MyText(
                        paddingBottom: 10,
                        text:
                            'Share your story with the world by uploading your video.',
                        color: kGreyColor,
                        lineHeight: 1.5,
                        size: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: ListView(
          shrinkWrap: true,
          padding: AppSizes.DEFAULT,
          physics: BouncingScrollPhysics(),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 105,
                child: PageView.builder(
                  controller: _controller,
                  physics: BouncingScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 10,
                            color: kBlackColor.withOpacity(0.16),
                          )
                        ],
                      ),
                      child: Stack(
                        children: [
                          CommonImageView(
                            imagePath: _sliderItems[index]['image'],
                            width: Get.width,
                            height: Get.height,
                            radius: 0,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: Get.width,
                            height: Get.height,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  kBlackColor.withOpacity(0.8),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            padding: EdgeInsets.all(14),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                  height: 1.5,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: kPrimaryColor.withOpacity(.9),
                                  fontFamily: AppFonts.URBANIST,
                                ),
                                children: [
                                  TextSpan(
                                    text: _sliderItems[index]['title'],
                                  ),
                                  TextSpan(
                                    text: _sliderItems[index]['targetedText'],
                                    style: TextStyle(
                                      color: kSecondaryColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: _sliderItems[index]['trailing'],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Center(
              child: SmoothPageIndicator(
                controller: _controller,
                axisDirection: Axis.horizontal,
                count: 3,
                effect: ExpandingDotsEffect(
                  dotHeight: 6,
                  dotWidth: 6,
                  spacing: 4,
                  expansionFactor: 5,
                  radius: 8,
                  activeDotColor: kSecondaryColor,
                  dotColor: kSecondaryColor.withOpacity(0.5),
                ),
                onDotClicked: (index) {},
              ),
            ),
            MyText(
              paddingTop: 10,
              weight: FontWeight.w600,
              text: 'Select Categories',
              paddingBottom: 8,
            ),
            // Use Obx to reactively rebuild when categories change
            Obx(() {
              final categories = globalController.getReelCategories;

              if (categories.isEmpty) {
                return Container(
                  height: 100,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 8),
                        MyText(
                          text: 'Loading categories...',
                          size: 14,
                          color: kGreyColor,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final bool hasAiQuestions =
                      category['has_ai_questions'] ?? false;

                  return GestureDetector(
                    onTap: hasAiQuestions
                        ? () {
                            Get.dialog(_AIQuestionsDialog(
                              category: category,
                              onNavigate: () => _navigateToRecording(category),
                            ));
                          }
                        : () => _navigateToRecording(category),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Stack(
                        children: [
                          CommonImageView(
                            url: category['banner'] ?? '',
                            width: Get.width,
                            height: 100,
                            radius: 12,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            width: Get.width,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: kBlackColor.withOpacity(0.4),
                              border: GradientBoxBorder(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: [
                                    kSecondaryColor,
                                    kPurpleColor,
                                  ],
                                ),
                                width: 1.5,
                              ),
                            ),
                            padding: EdgeInsets.all(14),
                            child: Row(
                              children: [
                                CommonImageView(
                                  url: category['icon'] ?? '',
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          MyText(
                                            text: category['name'] ?? 'Unknown',
                                            size: 16,
                                            weight: FontWeight.w600,
                                            color: kPrimaryColor,
                                            paddingRight: 5,
                                          ),
                                          Image.asset(
                                            Assets.imagesSmallHeartsIcon,
                                            height: 9.9,
                                          ),
                                        ],
                                      ),
                                      MyText(
                                        paddingTop: 6,
                                        text: category['description'] ??
                                            'Express yourself in this category',
                                        size: 12,
                                        color: kPrimaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Image.asset(
                              hasAiQuestions
                                  ? Assets.imagesAiRed
                                  : Assets.imagesAiNewIcon,
                              height: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}

class _AIQuestionsDialog extends StatelessWidget {
  final Map<String, dynamic> category;
  final VoidCallback onNavigate;

  const _AIQuestionsDialog({
    super.key, 
    required this.category,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          color: kPrimaryColor,
          margin: AppSizes.DEFAULT,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: AppSizes.DEFAULT,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.close,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  Assets.imagesCandidAi,
                  height: 140,
                ),
                MyText(
                  paddingTop: 10,
                  text:
                      'Candid uses Ai to create more interesting conversations for ${category['name'] ?? 'this category'}. Complete your profile for unique Matches and Questions.',
                  size: 15.5,
                  lineHeight: 1.5,
                  weight: FontWeight.w600,
                  textAlign: TextAlign.center,
                  paddingBottom: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: MyButton(
                        height: 40,
                        textSize: 14,
                        buttonText: 'Edit Profile',
                        onTap: () {
                          Get.back();
                          // Navigate to edit profile
                        },
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: MyButton(
                        height: 40,
                        textSize: 14,
                        buttonText: 'Random Question',
                        onTap: () {
                          Get.back(); // Close dialog first
                          onNavigate(); // Then navigate
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}