import 'dart:ui';
import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/main.dart';
import 'package:candid/view/screens/home/crush_screen.dart';
import 'package:candid/view/screens/home/filter.dart';
import 'package:candid/view/screens/home/its_a_match.dart';
import 'package:candid/view/screens/home/other_user_profile_details.dart';
import 'package:candid/view/screens/home/out_of_swipe.dart';
import 'package:candid/view/screens/profile/profile.dart';
import 'package:candid/view/widget/common_image_view_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:candid/controller/reels_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:lottie/lottie.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'package:video_player/video_player.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final SwipableStackController controller = SwipableStackController();
  final PageController _pageController = PageController();
  late ReelsController reelsController;

  @override
  void initState() {
    super.initState();
    reelsController = Get.put(ReelsController());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  body: GetX<ReelsController>(
    builder: (controller) {
      if (controller.reels.isEmpty) return _buildLoadingScreen();

      return Stack(
        children: [
          SwipableStack(
            controller: this.controller,
            itemCount: controller.reels.length,
            detectableSwipeDirections: {
              SwipeDirection.right,
              SwipeDirection.left,
            },
            allowVerticalSwipe: false,
            builder: (context, properties) {
              return PageView.builder(
                scrollDirection: Axis.vertical,
                itemCount: controller.reels.length,
                onPageChanged: (index) async {
                  await controller.changeVideo(index);
                },
                itemBuilder: (context, index) {
                  return _buildVideoContent(index);
                },
              );
            },
            onSwipeCompleted: (index, direction) async {
              if (direction == SwipeDirection.right) {
                await controller.toggleLike(index);
                Get.to(() => ItsAMatch());
              }
            },
          ),
          _buildTopControls(),
        ],
      );
    },
  ),
);

  }

  Widget _buildVideoContent(int stackIndex) {
    return GetX<ReelsController>(
      builder: (controller) {
        if (stackIndex >= controller.reels.length) {
          return _buildLoadingScreen();
        }

        final reel = controller.reels[stackIndex];
        final videoController = controller.getVideoController(stackIndex);

        return Stack(
          children: [
            // Video Player
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                final newStackIndex = stackIndex + index;
                if (newStackIndex < controller.reels.length) {
                  controller.changeVideo(newStackIndex);
                }
              },
              itemCount: 1, // Only current video
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                if (videoController != null &&
                    videoController.value.isInitialized) {
                  final filter = controller.getFilterById(reel.filterId);

                  return Stack(
                    children: [
                      // Video Player
                      FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: Get.width,
                          height: Get.height ,
                          child: GestureDetector(
                            onTap: () {
                              controller.togglePlayPause();
                            },
                            child: VideoPlayer(videoController),
                          ),
                        ),
                      ),

                      // Filter Overlay
                      if (filter.overlayColor != Colors.transparent)
                        Positioned.fill(
                          child: Container(
                            color:
                                filter.overlayColor.withOpacity(filter.opacity),
                          ),
                        ),
                    ],
                  );
                } else {
                  return Container(
                    color: Colors.black,
                    child: const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: kPrimaryColor,
                        color: kSecondaryColor,
                      ),
                    ),
                  );
                }
              },
            ),

            // Hearts Animation (when liked) - Separate Obx for this specific reactive element
            Obx(() {
              if (stackIndex < reelsController.reels.length &&
                  reelsController.reels[stackIndex].isLiked) {
                return Positioned(
                  bottom: 80,
                  left: -20,
                  child: Lottie.asset(
                    Assets.imagesHeartsReaction,
                    height: 160,
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            // Video Information Overlay
            Padding(
              padding: AppSizes.DEFAULT,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.bottomSheet(
                            OtherUserProfileDetails(),
                            isScrollControlled: true,
                          );
                        },
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.white,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: CommonImageView(
                                height: 35,
                                width: 35,
                                radius: 100,
                                url: reel.userProfilePicture ?? dummyImg,
                              ),
                            ),
                            if (reel.isOnline == true)
                              Positioned(
                                bottom: 0,
                                right: 3.5,
                                child: Container(
                                  height: 8,
                                  width: 8,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 0.5,
                                      color: Colors.white,
                                    ),
                                    shape: BoxShape.circle,
                                    color: kGreenColor,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: MyText(
                          onTap: () {
                            Get.bottomSheet(
                              OtherUserProfileDetails(),
                              isScrollControlled: true,
                            );
                          },
                          paddingLeft: 8,
                          text: reel.userName != null && reel.userAge != null
                              ? '${reel.userName}, ${reel.userAge}'
                              : reel.userName ?? 'Unknown User',
                          size: 16,
                          weight: FontWeight.w600,
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                  MyText(
                    paddingTop: 10,
                    text: reel.caption.isNotEmpty ? reel.caption : 'No caption',
                    size: 14,
                    color: kPrimaryColor,
                    paddingBottom: 10,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        Assets.imagesMusicIcon,
                        height: 20,
                        color: kPrimaryColor,
                      ),
                      MyText(
                        paddingLeft: 10,
                        text: reel.categoryName ?? 'Unknown Category',
                        size: 14,
                        weight: FontWeight.w500,
                        color: kPrimaryColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildActionButtons(stackIndex),
                  const SizedBox(height: 70),
                ],
              ),
            ),

            // Loading more indicator - Separate Obx for this specific reactive element
            Obx(() {
              if (reelsController.isLoadingMore.value &&
                  stackIndex >= reelsController.reels.length - 2) {
                return const Positioned(
                  bottom: 150,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: kSecondaryColor,
                      strokeWidth: 2,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        );
      },
    );
  }

  Widget _buildActionButtons(int reelIndex) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Super Like Button (unchanged)
        GestureDetector(
          onTap: () {
            Get.dialog(OutOfSwipe());
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      kSecondaryColor,
                      kPurpleColor,
                    ],
                  ),
                  border: const GradientBoxBorder(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        kPrimaryColor,
                      ],
                    ),
                    width: 0.74,
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 4),
                      blurRadius: 12,
                      color: kBlackColor.withOpacity(0.26),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    Assets.imagesHomePop,
                    height: 18,
                  ),
                ),
              ),
              Image.asset(
                Assets.imagesHomeStars,
                height: 50,
              ),
            ],
          ),
        ),

        // Dislike Button (unchanged)
        GestureDetector(
          onTap: () {
            _handleDislike(reelIndex);
          },
          child: Container(
            height: 68,
            width: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  kSecondaryColor,
                  kPurpleColor,
                ],
              ),
              border: const GradientBoxBorder(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    kPrimaryColor,
                  ],
                ),
                width: 0.74,
              ),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 4),
                  blurRadius: 12,
                  color: kBlackColor.withOpacity(0.26),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                Assets.imagesBroken,
                height: 26,
                color: kPrimaryColor,
              ),
            ),
          ),
        ),

        // Like Button - Updated with proper navigation
        GetX<ReelsController>(
          builder: (controller) {
            if (reelIndex >= controller.reels.length) {
              return const SizedBox.shrink();
            }

            final reel = controller.reels[reelIndex];
            return GestureDetector(
              onTap: () async {
                await _handleLike(reelIndex, reel);
              },
              child: Container(
                height: 68,
                width: 68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: reel.isLiked
                        ? [Colors.red, Colors.pink]
                        : [kSecondaryColor, kPurpleColor],
                  ),
                  border: const GradientBoxBorder(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        kPrimaryColor,
                      ],
                    ),
                    width: 0.74,
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 4),
                      blurRadius: 12,
                      color: kBlackColor.withOpacity(0.26),
                    ),
                  ],
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        Assets.imagesLiked,
                        height: 26,
                        color: kPrimaryColor,
                      ),
                      if (reel.likesCount > 0)
                        Positioned(
                          top: -5,
                          right: -5,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '${reel.likesCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        // Crush Button (unchanged)
        GestureDetector(
          onTap: () {
            Get.to(
              () => CrushScreen(),
              transition: Transition.upToDown,
              duration: 620.milliseconds,
            );
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 48,
                width: 48,
                padding: const EdgeInsets.only(right: 2.2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      kSecondaryColor,
                      kPurpleColor,
                    ],
                  ),
                  border: const GradientBoxBorder(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        kPrimaryColor,
                      ],
                    ),
                    width: 0.74,
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 4),
                      blurRadius: 12,
                      color: kBlackColor.withOpacity(0.26),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    Assets.imagesHomeSuperLike,
                    height: 18,
                  ),
                ),
              ),
              Image.asset(
                Assets.imagesHomeStars,
                height: 50,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// Add these methods to your Home class:

Future<void> _handleLike(int reelIndex, dynamic reel) async {
  try {
    // Pause current video before navigation
    final currentController = reelsController
        .getVideoController(reelsController.currentIndex.value);
    await currentController?.pause();
    
    // Provide haptic feedback
    HapticFeedback.mediumImpact();
    
    // Toggle like in controller
    await reelsController.toggleLike(reelIndex);
    
    // Simulate match (you can add your own logic here)
    final isMatch = _shouldShowMatch(reel);
    
    if (isMatch) {
      // Navigate to match screen with user data
      await Get.to(
        () => ItsAMatch(
          userName: reel.userName,
          userProfilePicture: reel.userProfilePicture,
        ),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 500),
      );
    } else {
      // Just swipe to next reel
      controller.next(
        swipeDirection: SwipeDirection.right,
        duration: const Duration(milliseconds: 300),
      );
    }
  } catch (e) {
    print('Error handling like: $e');
    
    // Show error snackbar
    Get.snackbar(
      'Error',
      'Something went wrong. Please try again.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
    
    // Still proceed with swipe
    controller.next(
      swipeDirection: SwipeDirection.right,
      duration: const Duration(milliseconds: 300),
    );
  }
}

void _handleDislike(int reelIndex) {
  try {
    // Provide haptic feedback
    HapticFeedback.lightImpact();
    
    // Pause current video
    final currentController = reelsController
        .getVideoController(reelsController.currentIndex.value);
    currentController?.pause();
    
    // Swipe to next reel
    controller.next(
      swipeDirection: SwipeDirection.left,
      duration: const Duration(milliseconds: 300),
    );
  } catch (e) {
    print('Error handling dislike: $e');
  }
}

// Match logic - you can customize this based on your requirements
bool _shouldShowMatch(dynamic reel) {
  // For demo purposes, show match randomly (30% chance)
  // In a real app, this would be determined by your backend
  final random = DateTime.now().millisecondsSinceEpoch % 10;
  return random < 3; // 30% chance of match
  
  // Alternative logic examples:
  // return reel.userName?.toLowerCase().contains('a') ?? false; // Match if name contains 'a'
  // return reel.likesCount > 5; // Match if user has many likes
  // return true; // Always show match (for testing)
}

  Widget _buildTopControls() {
    return Padding(
      padding: AppSizes.DEFAULT,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
          Row(
            children: [
              GetX<ReelsController>(
                builder: (controller) {
                  final currentReel = controller.currentReel;
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: kBlackColor.withOpacity(0.16),
                          borderRadius: BorderRadius.circular(50),
                          border: const GradientBoxBorder(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [kPrimaryColor, Color(0xff999999)],
                            ),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: MyText(
                            text: currentReel != null
                                ? 'Current: ${currentReel.categoryName ?? 'Unknown'}'
                                : 'Loading...',
                            size: 12,
                            weight: FontWeight.w600,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Get.bottomSheet(
                    Filter(),
                    isScrollControlled: true,
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: kBlackColor.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(50),
                        border: const GradientBoxBorder(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [kPrimaryColor, Color(0xff999999)],
                          ),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Image.asset(
                          Assets.imagesFilter,
                          height: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  // Pause current video before navigating
                  final currentController = reelsController
                      .getVideoController(reelsController.currentIndex.value);
                  currentController?.pause();

                  Get.to(() => Profile());
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: kBlackColor.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(50),
                        border: const GradientBoxBorder(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [kPrimaryColor, Color(0xff999999)],
                          ),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Image.asset(
                          Assets.imagesUserIcon,
                          height: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              backgroundColor: kPrimaryColor,
              color: kSecondaryColor,
            ),
            SizedBox(height: 16),
            Text(
              'Loading amazing reels...',
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyScreen() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.imagesEffects,
              height: 80,
              color: kPrimaryColor.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            const Text(
              'No reels available',
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Be the first to share your story!',
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => reelsController.refreshReels(),
              style: ElevatedButton.styleFrom(
                backgroundColor: kSecondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Refresh',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.red,
              ),
              const SizedBox(height: 24),
              const Text(
                'Something went wrong',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Obx(() => Text(
                    reelsController.errorMessage.value,
                    style: const TextStyle(
                      color: kPrimaryColor,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  )),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => reelsController.refreshReels(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kSecondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Try Again',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardOverlay extends StatelessWidget {
  const _CardOverlay({
    required this.direction,
    required this.swipeProgress,
  });

  final SwipeDirection direction;
  final double swipeProgress;

  final List<String> _disLikeAnimations = const [
    Assets.imagesD1,
    Assets.imagesD2,
    Assets.imagesD3,
    Assets.imagesD4,
    Assets.imagesD5,
  ];

  final List<String> _likeAnimations = const [
    Assets.imagesL1,
    Assets.imagesL2,
    Assets.imagesL3,
    Assets.imagesL4,
    Assets.imagesL5,
    Assets.imagesL6,
    Assets.imagesL7,
    Assets.imagesL8,
    Assets.imagesL9,
    Assets.imagesL10,
    Assets.imagesL11,
  ];

  @override
  Widget build(BuildContext context) {
    final isRight = direction == SwipeDirection.right;
    final isLeft = direction == SwipeDirection.left;

    if (isLeft) {
      return Center(
        child: Lottie.asset(
          Assets.imagesD1New,
          height: Get.height,
          alignment: Alignment.bottomCenter,
          fit: BoxFit.fitHeight,
        ),
      );
    } else if (isRight) {
      return Transform.flip(
        flipX: true,
        child: Center(
          child: RotatedBox(
            quarterTurns: 4,
            child: Lottie.asset(
              _likeAnimations[0],
              height: Get.height,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
