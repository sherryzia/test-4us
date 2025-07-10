import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/controller/GlobalController.dart';
import 'package:candid/controller/reels_controller.dart';
import 'package:candid/controller/profile_video_controller.dart';
import 'package:candid/main.dart';
import 'package:candid/view/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:candid/view/screens/profile/edit_profile.dart';
import 'package:candid/view/screens/profile/settings.dart';
import 'package:candid/view/screens/profile/tiktok_style_video_viewer.dart';
import 'package:candid/view/screens/subscription/pop_corns.dart';
import 'package:candid/view/screens/subscription/subscription.dart';
import 'package:candid/view/widget/common_image_view_widget.dart';
import 'package:candid/view/widget/my_button_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:candid/view/widget/profile_card_widget.dart';
import 'package:candid/view/widget/simple_app_bar_widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:video_player/video_player.dart';

// ProfileLifecycleWrapper - add this class to the same file or import it
class ProfileLifecycleWrapper extends StatefulWidget {
  final Widget child;
  
  const ProfileLifecycleWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<ProfileLifecycleWrapper> createState() => _ProfileLifecycleWrapperState();
}

class _ProfileLifecycleWrapperState extends State<ProfileLifecycleWrapper> 
    with WidgetsBindingObserver {
  
  ProfileVideoController? _videoController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Initialize video controller if not already done
    if (!Get.isRegistered<ProfileVideoController>()) {
      Get.put(ProfileVideoController(), permanent: true);
    }
    _videoController = Get.find<ProfileVideoController>();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    
    // Clean up video controllers when widget is disposed
    _videoController?.onNavigateAway();
    
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _videoController?.onAppLifecycleChanged(state);
    
    // Additional cleanup for memory pressure
    if (state == AppLifecycleState.paused) {
      print('App paused - cleaning up video memory');
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class Profile extends StatelessWidget {
  const Profile({super.key});

  // Initialize the video controller
  ProfileVideoController get _videoController => Get.find<ProfileVideoController>();

  void _openVideoViewer(dynamic video, List<dynamic> allVideos, int index) {
    _videoController.onNavigateAway(); // Dispose videos before navigation
    Get.to(
      () => TikTokStyleVideoViewer(
        video: video,
        allVideos: allVideos,
        initialIndex: index,
      ),
      transition: Transition.fadeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Initialize the video controller if not already done
    Get.put(ProfileVideoController(), permanent: true);
    
    final globalController = Get.find<GlobalController>();
    final reelsController = Get.find<ReelsController>();
    
    return ProfileLifecycleWrapper(
      child: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 5),
          child: GestureDetector(
            onTap: () {
              _videoController.onNavigateAway(); // Dispose videos before navigation
              Get.offAll(
                () => BottomNavBar(
                  currentIndex: 2,
                ),
              );
            },
            child: Image.asset(
              Assets.imagesUploadIconNew,
              height: 55,
            ),
          ),
        ),
        appBar: simpleAppBar(
          onLeading: () {
            _videoController.onNavigateAway(); // Dispose videos before navigation
            Get.offAll(() => BottomNavBar());
          },
          title: '',
          actions: [
            Center(
              child: GestureDetector(
                onTap: () {
                  _videoController.onNavigateAway(); // Dispose videos before navigation
                  Get.to(() => EditProfile());
                },
                child: Image.asset(
                  Assets.imagesEditNew,
                  height: 24,
                ),
              ),
            ),
            SizedBox(width: 12),
            Center(
              child: GestureDetector(
                onTap: () {
                  _videoController.onNavigateAway(); // Dispose videos before navigation
                  Get.to(() => Settings());
                },
                child: Image.asset(
                  Assets.imagesGear,
                  height: 24,
                ),
              ),
            ),
            SizedBox(width: 20),
          ],
        ),
        body: ListView(
          shrinkWrap: true,
          padding: AppSizes.HORIZONTAL,
          physics: BouncingScrollPhysics(),
          children: [
            ProfileCard(),
            SizedBox(height: 30),
            // Crushes and Popcorn sections
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.to(() => PopCorns()),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: kPrimaryColor,
                        border: GradientBoxBorder(
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [kSecondaryColor, kPurpleColor],
                          ),
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Image.asset(Assets.imagesCandidCrushes, height: 32),
                          SizedBox(width: 4),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                MyText(
                                  text: '2 x Crushes',
                                  size: 12,
                                  weight: FontWeight.w600,
                                  paddingBottom: 2,
                                ),
                                MyGradientText(text: 'Buy More', size: 12),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.to(() => PopCorns()),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: kPrimaryColor,
                        border: GradientBoxBorder(
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [kSecondaryColor, kPurpleColor],
                          ),
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Image.asset(Assets.imagesCandidPopcorn, height: 32),
                          SizedBox(width: 4),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                MyText(
                                  text: '10 x Popcorn Tubs',
                                  size: 12,
                                  weight: FontWeight.w600,
                                  paddingBottom: 2,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                MyGradientText(text: 'Buy More', size: 12),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Premium section
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Color(0xffF0C6E4)),
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xffF6E9F7), Color(0xffEEE1FE)],
                ),
              ),
              child: Row(
                children: [
                  Image.asset(Assets.imagesCPremium, height: 32),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MyText(
                          text: 'Candid Premium',
                          size: 10,
                          weight: FontWeight.w600,
                          paddingBottom: 4,
                        ),
                        MyText(
                          text: 'Unlock all the features of Candid for a Premium Experience.',
                          size: 8,
                          color: kBlackColor2,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 65,
                    child: MyButton(
                      height: 30,
                      textSize: 10,
                      weight: FontWeight.w400,
                      buttonText: 'Upgrade',
                      onTap: () => Get.to(() => Subscription()),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            // Videos Grid with optimized GetX observer
            GetX<ReelsController>(
              builder: (controller) {
                return _buildVideosGrid(controller, globalController);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideosGrid(ReelsController reelsController, GlobalController globalController) {
    final userVideos = reelsController.reels.take(20).toList(); // Limit to 20 videos max
    final videoCount = userVideos.length;
    final isPremium = globalController.isPremium.value;
    
    int gridItemCount;
    if (videoCount < 3) {
      gridItemCount = 3;
    } else if (videoCount >= 3 && !isPremium) {
      gridItemCount = 9;
    } else {
      gridItemCount = videoCount.clamp(0, 20); // Cap at 20 videos
    }

    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(), // Prevent nested scrolling
      itemCount: gridItemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 147,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        return _buildGridItem(index, userVideos, isPremium);
      },
    );
  }

  Widget _buildGridItem(int index, List userVideos, bool isPremium) {
    final videoCount = userVideos.length;
    
    if (videoCount < 3) {
      if (index < videoCount) {
        return _buildVideoCard(userVideos[index], index, userVideos);
      } else if (index == 2) {
        return _buildAddVideoCard();
      } else {
        return Container();
      }
    } else if (videoCount >= 3 && !isPremium) {
      if (index < 3) {
        return _buildVideoCard(userVideos[index], index, userVideos);
      } else {
        return _buildPremiumVideoCard();
      }
    } else {
      if (index < videoCount) {
        return _buildVideoCard(userVideos[index], index, userVideos);
      } else {
        return Container();
      }
    }
  }

  Widget _buildVideoCard(dynamic video, int index, List<dynamic> allVideos) {
    final videoId = video.id;
    final videoUrl = video.videoUrl;
    
    return GestureDetector(
      onTap: () {
        _openVideoViewer(video, allVideos, index);
      },
      onLongPress: () {
        // Initialize and toggle playback only on long press
        if (!_videoController.videoControllers.containsKey(videoId)) {
          _videoController.initializeVideoController(videoId, videoUrl);
        } else {
          _videoController.toggleVideoPlayback(videoId);
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 147,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: GetBuilder<ProfileVideoController>(
            builder: (controller) {
              return Stack(
                children: [
                  // Video Player - only show if initialized
                  if (controller.isVideoControllerInitialized(videoId) && 
                      controller.getVideoController(videoId) != null)
                    Positioned.fill(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: controller.getVideoController(videoId)!.value.size.width,
                          height: controller.getVideoController(videoId)!.value.size.height,
                          child: VideoPlayer(controller.getVideoController(videoId)!),
                        ),
                      ),
                    )
                  else
                    // Thumbnail placeholder
                    Positioned.fill(
                      child: Container(
                        color: Colors.grey[800],
                        child: controller.isVideoInitialized[videoId] == false
                            ? Icon(Icons.error_outline, color: Colors.white, size: 24)
                            : null,
                      ),
                    ),

                  // Play button overlay - always visible for uninitialized videos
                  if (!controller.isVideoControllerInitialized(videoId) || 
                      !controller.isVideoCurrentlyPlaying(videoId))
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Video info overlay
                  Positioned(
                    bottom: 8,
                    left: 8,
                    right: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (video.caption != null && video.caption.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: MyText(
                              text: video.caption,
                              size: 8,
                              color: kPrimaryColor,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    Assets.imagesPlaySmall,
                                    height: 8,
                                    color: kPrimaryColor,
                                  ),
                                  SizedBox(width: 2),
                                  MyText(
                                    text: '${video.viewsCount ?? 0}',
                                    size: 8,
                                    color: kPrimaryColor,
                                    weight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                            if (video.likesCount > 0) ...[
                              SizedBox(width: 4),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.favorite, color: Colors.red, size: 8),
                                    SizedBox(width: 2),
                                    MyText(
                                      text: '${video.likesCount}',
                                      size: 8,
                                      color: kPrimaryColor,
                                      weight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Tap indicator
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.fullscreen,
                        color: Colors.white70,
                        size: 12,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAddVideoCard() {
    return GestureDetector(
      onTap: () {
        _videoController.onNavigateAway(); // Dispose videos before navigation
        Get.offAll(() => BottomNavBar(currentIndex: 2));
      },
      child: DottedBorder(
        color: kSecondaryColor,
        dashPattern: [5, 3],
        strokeWidth: 2,
        borderType: BorderType.RRect,
        radius: Radius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: kPrimaryColor.withOpacity(0.1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: kSecondaryColor, size: 32),
              SizedBox(height: 8),
              MyText(
                text: 'Add Video',
                size: 12,
                textAlign: TextAlign.center,
                weight: FontWeight.w600,
                color: kSecondaryColor,
              ),
              MyText(
                text: 'Share your story',
                size: 8,
                textAlign: TextAlign.center,
                color: kBlackColor.withOpacity(0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumVideoCard() {
    return GestureDetector(
      onTap: () => Get.to(() => Subscription()),
      child: DottedBorder(
        color: kBorderColor,
        dashPattern: [5, 3],
        borderType: BorderType.RRect,
        radius: Radius.circular(8),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(Assets.imagesCandidPro, height: 22),
              MyText(
                paddingTop: 4,
                text: 'Upgrade for more videos',
                size: 10,
                textAlign: TextAlign.center,
                weight: FontWeight.w500,
                color: kBlackColor.withOpacity(0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}