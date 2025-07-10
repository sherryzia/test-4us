import 'dart:ui';
import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/main.dart';
import 'package:candid/view/widget/common_image_view_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class TikTokStyleVideoViewer extends StatefulWidget {
  final dynamic video;
  final List<dynamic> allVideos;
  final int initialIndex;

  const TikTokStyleVideoViewer({
    super.key,
    required this.video,
    required this.allVideos,
    required this.initialIndex,
  });

  @override
  State<TikTokStyleVideoViewer> createState() => _TikTokStyleVideoViewerState();
}

class _TikTokStyleVideoViewerState extends State<TikTokStyleVideoViewer> {
  late PageController _pageController;
  Map<int, VideoPlayerController> _controllers = {};
  int _currentIndex = 0;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _initializeControllers();
  }

  @override
  void dispose() {
    _disposeControllers();
    _pageController.dispose();
    super.dispose();
  }

  void _initializeControllers() async {
    // Initialize current and nearby videos
    for (int i = 0; i < widget.allVideos.length; i++) {
      if ((_currentIndex - i).abs() <= 1) {
        await _initializeController(i);
      }
    }
  }

  Future<void> _initializeController(int index) async {
    if (_controllers.containsKey(index)) return;

    try {
      final video = widget.allVideos[index];
      final controller = VideoPlayerController.networkUrl(Uri.parse(video.videoUrl));
      await controller.initialize();
      controller.setLooping(true);
      
      _controllers[index] = controller;
      
      if (index == _currentIndex && _isPlaying) {
        controller.play();
      }
    } catch (e) {
      print('Error initializing video controller: $e');
    }
  }

  void _disposeControllers() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Pause all videos
    for (var controller in _controllers.values) {
      controller.pause();
    }

    // Play current video
    if (_controllers.containsKey(index)) {
      _controllers[index]!.play();
    } else {
      _initializeController(index).then((_) {
        if (_controllers.containsKey(index)) {
          _controllers[index]!.play();
        }
      });
    }

    // Initialize nearby videos
    for (int i = index - 1; i <= index + 1; i++) {
      if (i >= 0 && i < widget.allVideos.length && !_controllers.containsKey(i)) {
        _initializeController(i);
      }
    }

    // Dispose far videos
    _controllers.removeWhere((key, controller) {
      if ((key - index).abs() > 2) {
        controller.dispose();
        return true;
      }
      return false;
    });
  }

  void _togglePlayPause() {
    final controller = _controllers[_currentIndex];
    if (controller != null) {
      setState(() {
        if (controller.value.isPlaying) {
          controller.pause();
          _isPlaying = false;
        } else {
          controller.play();
          _isPlaying = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video PageView
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            onPageChanged: _onPageChanged,
            itemCount: widget.allVideos.length,
            itemBuilder: (context, index) {
              return _buildVideoPage(index);
            },
          ),

          // Top Bar
          _buildTopBar(),

          // Right Side Actions
          _buildRightSideActions(),
        ],
      ),
    );
  }

  Widget _buildVideoPage(int index) {
    final video = widget.allVideos[index];
    final controller = _controllers[index];

    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        children: [
          // Video Player
          Center(
            child: controller != null && controller.value.isInitialized
                ? SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                  child: VideoPlayer(controller))
                : Container(
                    color: Colors.black,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: kSecondaryColor,
                      ),
                    ),
                  ),
          ),

          // Play/Pause Overlay
          if (index == _currentIndex && !_isPlaying)
            Center(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),

          // Bottom Info
          _buildBottomInfo(video),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: MediaQuery.of(context).padding.top,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                '${_currentIndex + 1}/${widget.allVideos.length}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                // Show options menu
                _showOptionsBottomSheet();
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightSideActions() {
    final currentVideo = widget.allVideos[_currentIndex];
    
    return Positioned(
      right: 12,
      bottom: 100,
      child: Column(
        children: [
          // Profile Picture
          GestureDetector(
            onTap: () {
              // Navigate to user profile
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: CommonImageView(
                height: 50,
                width: 50,
                radius: 100,
                url: currentVideo.userProfilePicture ?? dummyImg,
              ),
            ),
          ),

          SizedBox(height: 20),

          // Like Button
          _buildActionButton(
            icon: currentVideo.isLiked ? Icons.favorite : Icons.favorite_border,
            count: currentVideo.likesCount.toString(),
            color: currentVideo.isLiked ? Colors.red : Colors.white,
            onTap: () {
              // Handle like
              setState(() {
                currentVideo.isLiked = !currentVideo.isLiked;
                if (currentVideo.isLiked) {
                  currentVideo.likesCount++;
                } else {
                  currentVideo.likesCount--;
                }
              });
            },
          ),

          SizedBox(height: 20),

          // Comment Button
          _buildActionButton(
            icon: Icons.chat_bubble_outline,
            count: '0', // Comments count (not implemented)
            onTap: () {
              // Show comments
              _showCommentsBottomSheet();
            },
          ),

          SizedBox(height: 20),

          // Share Button
          _buildActionButton(
            icon: Icons.share,
            count: '',
            onTap: () {
              // Handle share
              _showShareOptions();
            },
          ),

          SizedBox(height: 20),

          // More Options
          _buildActionButton(
            icon: Icons.more_horiz,
            count: '',
            onTap: () {
              _showOptionsBottomSheet();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String count,
    Color color = Colors.white,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black45,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          if (count.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                count,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomInfo(dynamic video) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 80, // Leave space for right side actions
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.transparent,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Username
            GestureDetector(
              onTap: () {
                // Navigate to user profile
              },
              child: Row(
                children: [
                  Text(
                    '@${video.userName ?? 'unknown'}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Follow',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 8),

            // Caption
            if (video.caption != null && video.caption.isNotEmpty)
              Text(
                video.caption,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

            SizedBox(height: 8),

            // Category/Music
            if (video.categoryName != null)
              Row(
                children: [
                  Icon(
                    Icons.music_note,
                    color: Colors.white,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      video.categoryName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _showOptionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            _buildBottomSheetOption(
              icon: Icons.bookmark_outline,
              title: 'Save Video',
              onTap: () {
                Get.back();
                // Handle save
              },
            ),
            _buildBottomSheetOption(
              icon: Icons.download,
              title: 'Download',
              onTap: () {
                Get.back();
                // Handle download
              },
            ),
            _buildBottomSheetOption(
              icon: Icons.delete_outline,
              title: 'Delete',
              color: Colors.red,
              onTap: () {
                Get.back();
                _showDeleteConfirmation();
              },
            ),
            _buildBottomSheetOption(
              icon: Icons.report_outlined,
              title: 'Report',
              onTap: () {
                Get.back();
                // Handle report
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showCommentsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Comments',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'No comments yet',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                border: Border(top: BorderSide(color: Colors.grey[700]!)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[700],
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      // Handle send comment
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: kSecondaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showShareOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Share to',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(Icons.copy, 'Copy Link'),
                _buildShareOption(Icons.message, 'Message'),
                _buildShareOption(Icons.email, 'Email'),
                _buildShareOption(Icons.more_horiz, 'More'),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        Get.back();
        // Handle share option
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[700],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Delete Video',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete this video? This action cannot be undone.',
          style: TextStyle(color: Colors.grey[300]),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[400]),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              // Handle delete (frontend only for now)
              _deleteVideo();
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteVideo() {
    // Frontend-only deletion for now
    setState(() {
      widget.allVideos.removeAt(_currentIndex);
    });
    
    if (widget.allVideos.isEmpty) {
      Get.back(); // Go back if no more videos
    } else if (_currentIndex >= widget.allVideos.length) {
      // If we deleted the last video, go to the previous one
      _currentIndex = widget.allVideos.length - 1;
      _pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
    
    // Show success message
    Get.snackbar(
      'Video Deleted',
      'The video has been removed from your profile',
      backgroundColor: Colors.grey[800],
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Widget _buildBottomSheetOption({
    required IconData icon,
    required String title,
    Color? color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: color ?? Colors.white,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Colors.white,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
    );
  }
}