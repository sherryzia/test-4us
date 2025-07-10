import 'dart:io';
import 'package:candid/constants/filter.dart';
import 'package:candid/controller/camera_controller.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';

// Your existing imports
import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:candid/controller/reel_upload_controller.dart';

enum PreviewSource {
  regularCamera,
  effectsCamera,
}

// // Filter model - same as in StartRecording
// class FilterOption {
//   final int id;
//   final String name;
//   final IconData icon;
//   final String description;
//   final Color overlayColor;
//   final BlendMode blendMode;
//   final double opacity;

//   FilterOption({
//     required this.id,
//     required this.name,
//     required this.icon,
//     required this.description,
//     required this.overlayColor,
//     this.blendMode = BlendMode.multiply,
//     this.opacity = 0.3,
//   });
// }

class UnifiedPreviewScreen extends StatefulWidget {
  final String filePath;
  final String fileType;
  final Map<String, dynamic>? category;
  final PreviewSource source;
  final VoidCallback onRetake;
  final Function(String filePath, String fileType) onSave;
  final int? duration; // For regular camera videos
  final int? filterId; // Filter ID for regular camera videos

  const UnifiedPreviewScreen({
    Key? key,
    required this.filePath,
    required this.fileType,
    this.category,
    required this.source,
    required this.onRetake,
    required this.onSave,
    this.duration,
    this.filterId,
  }) : super(key: key);

  @override
  State<UnifiedPreviewScreen> createState() => _UnifiedPreviewScreenState();
}

class _UnifiedPreviewScreenState extends State<UnifiedPreviewScreen> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  
  // Filter related
  int _currentFilterId = 0;
  FilterOption? _currentFilter;
  
  // Caption controller
  final TextEditingController _captionController = TextEditingController();
  
  // Upload controller
  late ReelUploadController _uploadController;

  // Available filters - same as in StartRecording
  final List<FilterOption> _availableFilters = [
    FilterOption(
      id: 0,
      name: 'None',
      icon: Icons.filter_none,
      description: 'Original camera view',
      overlayColor: Colors.transparent,
    ),
    FilterOption(
      id: 1,
      name: 'Vintage',
      icon: Icons.camera_alt,
      description: 'Classic sepia film look',
      overlayColor: const Color(0xFFD2B48C),
      blendMode: BlendMode.overlay,
      opacity: 0.35,
    ),
    FilterOption(
      id: 2,
      name: 'Cool Blue',
      icon: Icons.ac_unit,
      description: 'Cool blue cinema tone',
      overlayColor: const Color(0xFF4A90E2),
      blendMode: BlendMode.multiply,
      opacity: 0.25,
    ),
    FilterOption(
      id: 3,
      name: 'Warm Sunset',
      icon: Icons.wb_sunny,
      description: 'Warm golden hour',
      overlayColor: const Color(0xFFFF8C42),
      blendMode: BlendMode.overlay,
      opacity: 0.3,
    ),
    FilterOption(
      id: 4,
      name: 'Purple Dream',
      icon: Icons.color_lens,
      description: 'Dreamy purple atmosphere',
      overlayColor: const Color(0xFF9C27B0),
      blendMode: BlendMode.softLight,
      opacity: 0.28,
    ),
    FilterOption(
      id: 5,
      name: 'Forest Green',
      icon: Icons.nature,
      description: 'Natural forest vibes',
      overlayColor: const Color(0xFF4CAF50),
      blendMode: BlendMode.multiply,
      opacity: 0.22,
    ),
    FilterOption(
      id: 6,
      name: 'Rose Pink',
      icon: Icons.favorite,
      description: 'Romantic rose filter',
      overlayColor: const Color(0xFFE91E63),
      blendMode: BlendMode.softLight,
      opacity: 0.32,
    ),
    FilterOption(
      id: 7,
      name: 'Monochrome',
      icon: Icons.photo_filter,
      description: 'Black and white classic',
      overlayColor: const Color(0xFF757575),
      blendMode: BlendMode.saturation,
      opacity: 0.8,
    ),
    FilterOption(
      id: 8,
      name: 'Cyber Neon',
      icon: Icons.electrical_services,
      description: 'Futuristic cyan glow',
      overlayColor: const Color(0xFF00BCD4),
      blendMode: BlendMode.screen,
      opacity: 0.25,
    ),
    FilterOption(
      id: 9,
      name: 'Golden Hour',
      icon: Icons.wb_incandescent,
      description: 'Perfect golden hour lighting',
      overlayColor: const Color(0xFFFFB74D),
      blendMode: BlendMode.overlay,
      opacity: 0.3,
    ),
  ];

  @override
  void initState() {
    super.initState();
    
    // Initialize upload controller
    _uploadController = Get.put(ReelUploadController());
    
    // Set current filter based on passed filterId
    _currentFilterId = widget.filterId ?? 0;
    _currentFilter = _availableFilters.firstWhere(
      (filter) => filter.id == _currentFilterId,
      orElse: () => _availableFilters.first,
    );
    
    if (widget.fileType.toLowerCase() == 'video') {
      _initializeVideoPlayer();
    }
  }

  void _initializeVideoPlayer() {
    _videoController = VideoPlayerController.file(File(widget.filePath))
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
          _totalDuration = _videoController!.value.duration;
        });
        // Auto-play the video
        _videoController!.play();
        setState(() {
          _isPlaying = true;
        });
      });
      
    _videoController!.addListener(_videoListener);
  }

  void _videoListener() {
    if (_videoController!.value.isInitialized) {
      setState(() {
        _currentPosition = _videoController!.value.position;
        _isPlaying = _videoController!.value.isPlaying;
      });
      
      // Auto-loop the video
      if (_videoController!.value.position >= _videoController!.value.duration) {
        _videoController!.seekTo(Duration.zero);
        _videoController!.play();
      }
    }
  }

  void _togglePlayPause() {
    if (_videoController!.value.isPlaying) {
      _videoController!.pause();
    } else {
      _videoController!.play();
    }
  }

  void _seekTo(double value) {
    final position = Duration(milliseconds: (value * _totalDuration.inMilliseconds).round());
    _videoController!.seekTo(position);
  }

  void _handleBackButton() {
    print('Back button pressed from ${widget.source.name} preview - returning to StartRecording');
    if (widget.fileType.toLowerCase() == 'video') {
      _videoController?.dispose();
    }
    
    if (widget.source == PreviewSource.effectsCamera) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _handleRetake() {
    if (widget.source == PreviewSource.regularCamera) {
      if (widget.filePath.isNotEmpty) {
        File(widget.filePath).delete();
      }
    }
    widget.onRetake();
  }

  void _showCaptionDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kSecondaryColor, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Caption',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _captionController,
                maxLines: 4,
                maxLength: 200,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Write a caption for your reel...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: kSecondaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: kSecondaryColor, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: const Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _handleUpload();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [kSecondaryColor, kPurpleColor],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'Upload',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
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
        ),
      ),
    );
  }

  void _handleUpload() async {
    final videoFile = File(widget.filePath);
    
    // Debug file information
    print('=== Upload Debug Info ===');
    print('File path: ${widget.filePath}');
    print('File exists: ${videoFile.existsSync()}');
    
    try {
      final fileSize = await videoFile.length();
      print('File size: ${fileSize} bytes (${(fileSize / (1024 * 1024)).toStringAsFixed(2)} MB)');
    } catch (e) {
      print('Error getting file size: $e');
    }
    
    // Validate file
    if (!_uploadController.validateVideoFile(videoFile)) {
      return;
    }
    
    // Check file size
    if (!await _uploadController.isFileSizeValid(videoFile)) {
      Get.snackbar(
        'File Too Large',
        'Video file exceeds 100MB limit. Please select a smaller file.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Get category ID with fallback
    int categoryId = 0;
    if (widget.category != null && widget.category!['id'] != null) {
      categoryId = widget.category!['id'];
    } else {
      // Try to get from camera controller if available
      try {
        final cameraController = Get.find<CameraRecordingController>();
        if (cameraController.currentCategoryId != null) {
          categoryId = cameraController.currentCategoryId is int 
            ? cameraController.currentCategoryId 
            : int.tryParse(cameraController.currentCategoryId.toString()) ?? 0;
        }
      } catch (e) {
        print('Could not get category from camera controller: $e');
      }
    }
    
    final caption = _captionController.text.trim();
    final filterId = _currentFilterId;

    print('Upload parameters:');
    print('- Category ID: $categoryId');
    print('- Caption: "$caption"');
    print('- Filter ID: $filterId');

    if (categoryId == 0) {
      Get.snackbar(
        'Error',
        'Category information is missing. Please select a category and try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      await _uploadController.uploadReel(
        context: context,
        videoFile: videoFile,
        categoryId: categoryId,
        caption: caption.isEmpty ? 'New reel' : caption,
        filterId: filterId,
      );

      // If upload is successful, call the original onSave callback
      widget.onSave(widget.filePath, widget.fileType);
      
    } catch (e) {
      print('Upload failed: $e');
      // Error handling is done in the controller
    }
  }

  void _showFilterSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Change Filter',
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 18, 
                    fontWeight: FontWeight.bold
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Current filter info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _currentFilter!.overlayColor == Colors.transparent 
                  ? kSecondaryColor.withOpacity(0.2)
                  : _currentFilter!.overlayColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _currentFilter!.overlayColor == Colors.transparent 
                    ? kSecondaryColor
                    : _currentFilter!.overlayColor,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _currentFilter!.icon,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current: ${_currentFilter!.name}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Filter ID: ${_currentFilter!.id}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            const Text(
              'Available Filters:',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 8),
            
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _availableFilters.length,
                itemBuilder: (context, index) {
                  final filter = _availableFilters[index];
                  final isSelected = filter.id == _currentFilterId;
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentFilterId = filter.id;
                        _currentFilter = filter;
                      });
                      Navigator.pop(context);
                      
                      // Show confirmation
                      Get.snackbar(
                        'Filter Updated',
                        '${filter.name} filter applied to preview',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: filter.overlayColor == Colors.transparent 
                          ? kSecondaryColor 
                          : filter.overlayColor.withOpacity(0.8),
                        colorText: Colors.white,
                        duration: const Duration(seconds: 2),
                      );
                    },
                    child: Container(
                      width: 80,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: filter.overlayColor == Colors.transparent 
                                ? Colors.grey[800]
                                : filter.overlayColor.withOpacity(0.8),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Icon(
                                    filter.icon,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${filter.id}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            filter.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return "${text[0].toUpperCase()}${text.substring(1).toLowerCase()}";
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  void dispose() {
    if (widget.fileType.toLowerCase() == 'video') {
      _videoController?.removeListener(_videoListener);
      _videoController?.dispose();
    }
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          _handleBackButton();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Media content
            Positioned.fill(
              child: widget.filePath.isEmpty
                  ? const Center(
                      child: Text(
                        'No media to display',
                        style: TextStyle(color: kPrimaryColor, fontSize: 16),
                      ),
                    )
                  : _buildMediaContent(),
            ),
            
            // Top controls
            Positioned(
              top: 55,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _handleBackButton,
                    child: Image.asset(Assets.imagesClose, height: 20),
                  ),
                  if (widget.category != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: kSecondaryColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.category!['name'] ?? 'Category',
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  
                  // Filter indicator and controls
                  Row(
                    children: [
                      if (widget.source == PreviewSource.regularCamera)
                        GestureDetector(
                          onTap: _showFilterSelector,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _currentFilter!.overlayColor == Colors.transparent 
                                ? kSecondaryColor.withOpacity(0.8)
                                : _currentFilter!.overlayColor.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _currentFilter!.icon,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _currentFilter!.name,
                                  style: const TextStyle(
                                    color: Colors.white, 
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.tune,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: kSecondaryColor.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.source == PreviewSource.effectsCamera 
                                ? '${_capitalize(widget.fileType)} Preview'
                                : _formatDuration(_totalDuration),
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Video progress bar (only for regular camera videos)
            if (widget.source == PreviewSource.regularCamera && 
                widget.fileType.toLowerCase() == 'video' && 
                _isVideoInitialized)
              Positioned(
                bottom: 120,
                left: 20,
                right: 20,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      Slider(
                        value: _totalDuration.inMilliseconds > 0
                            ? _currentPosition.inMilliseconds / _totalDuration.inMilliseconds
                            : 0.0,
                        onChanged: _seekTo,
                        activeColor: _currentFilter!.overlayColor == Colors.transparent 
                          ? kSecondaryColor
                          : _currentFilter!.overlayColor,
                        inactiveColor: Colors.white30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(_currentPosition),
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            Text(
                              _formatDuration(_totalDuration),
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            // Bottom controls
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Retake button
                  GestureDetector(
                    onTap: _handleRetake,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: kPrimaryColor, width: 2),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.refresh, color: kPrimaryColor, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Retake',
                            style: TextStyle(
                              fontSize: 16,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Upload button - Updated to show caption dialog first
                  GestureDetector(
                    onTap: _showCaptionDialog,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _currentFilter!.overlayColor == Colors.transparent 
                            ? [kSecondaryColor, kPurpleColor]
                            : [_currentFilter!.overlayColor, _currentFilter!.overlayColor.withOpacity(0.7)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.cloud_upload, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Upload',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
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

  Widget _buildMediaContent() {
    if (widget.fileType.toLowerCase() == 'video') {
      if (!_isVideoInitialized) {
        return Center(
          child: CircularProgressIndicator(
            color: _currentFilter!.overlayColor == Colors.transparent 
              ? kSecondaryColor
              : _currentFilter!.overlayColor,
          ),
        );
      }
      
      return Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: widget.source == PreviewSource.regularCamera
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _videoController!.value.size.height,
                      height: _videoController!.value.size.width,
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..scale(-1.0, 1.0), // Flip for regular camera
                        child: Stack(
                          children: [
                            VideoPlayer(_videoController!),
                            // Apply filter overlay for regular camera
                            if (_currentFilter!.overlayColor != Colors.transparent)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _currentFilter!.overlayColor.withOpacity(_currentFilter!.opacity),
                                    backgroundBlendMode: _currentFilter!.blendMode,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  )
                : AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!), // No flip for effects camera
                  ),
          ),
          
          // Play/Pause overlay
          GestureDetector(
            onTap: _togglePlayPause,
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: AnimatedOpacity(
                  opacity: _isPlaying ? 0.0 : 0.8,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: (_currentFilter!.overlayColor == Colors.transparent 
                        ? kSecondaryColor 
                        : _currentFilter!.overlayColor).withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else if (widget.fileType.toLowerCase() == 'image') {
      return Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 4,
          child: Stack(
            children: [
              Image.file(
                File(widget.filePath),
                fit: BoxFit.contain,
              ),
              // Apply filter overlay for images too
              if (widget.source == PreviewSource.regularCamera && 
                  _currentFilter!.overlayColor != Colors.transparent)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: _currentFilter!.overlayColor.withOpacity(_currentFilter!.opacity),
                      backgroundBlendMode: _currentFilter!.blendMode,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    } else {
      return Center(
        child: Text(
          "Unsupported media type: ${widget.fileType}",
          style: const TextStyle(color: kPrimaryColor, fontSize: 16),
        ),
      );
    }
  }
}