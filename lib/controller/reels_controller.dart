import 'dart:async';
import 'dart:isolate';
import 'package:candid/constants/filter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:candid/services/reels_service.dart';
import 'package:candid/services/reel_categories_service.dart';
import 'package:candid/controller/GlobalController.dart';
import 'package:flutter/services.dart';

class ReelModel {
  final int id;
  final int category;
  final String caption;
  final String videoUrl;
  final String filterId;
  final int createdBy;
  final List<dynamic> likes;
  final List<dynamic> views;
  final DateTime createdAt;
  final DateTime updatedAt;

  // User information
  String? userName;
  String? userProfilePicture;
  int? userAge;
  bool? isOnline;

  // Category information
  String? categoryName;
  String? categoryIcon;

  ReelModel({
    required this.id,
    required this.category,
    required this.caption,
    required this.videoUrl,
    required this.filterId,
    required this.createdBy,
    required this.likes,
    required this.views,
    required this.createdAt,
    required this.updatedAt,
    this.userName,
    this.userProfilePicture,
    this.userAge,
    this.isOnline,
    this.categoryName,
    this.categoryIcon,
  });

  factory ReelModel.fromJson(Map<String, dynamic> json) {
    return ReelModel(
      id: json['id'] ?? 0,
      category: json['category'] ?? 0,
      caption: json['caption'] ?? '',
      videoUrl: json['video'] ?? '',
      filterId: json['filter_id'] ?? '0',
      createdBy: json['created_by'] ?? 0,
      likes: json['likes'] ?? [],
      views: json['views'] ?? [],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  bool get isLiked => likes.isNotEmpty;
  int get likesCount => likes.length;
  int get viewsCount => views.length;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'caption': caption,
      'video': videoUrl,
      'filter_id': filterId,
      'created_by': createdBy,
      'likes': likes,
      'views': views,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'userName': userName,
      'userProfilePicture': userProfilePicture,
      'userAge': userAge,
      'isOnline': isOnline,
      'categoryName': categoryName,
      'categoryIcon': categoryIcon,
    };
  }
}

class VideoControllerState {
  final VideoPlayerController? controller;
  final bool isInitialized;
  final bool isLoading;
  final bool hasError;

  VideoControllerState({
    this.controller,
    this.isInitialized = false,
    this.isLoading = false,
    this.hasError = false,
  });
}

class ReelsController extends GetxController {
  final ReelsService _reelsService = ReelsService();
  final ReelCategoriesService _categoriesService = ReelCategoriesService();
  final GlobalController _globalController = Get.find<GlobalController>();

  // State variables
  final RxList<ReelModel> reels = <ReelModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreData = true.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentPage = 1.obs;
  final RxInt currentIndex = 0.obs;

  // Video controllers with state tracking
  final Map<int, VideoControllerState> _videoControllers = {};
  final RxInt currentVideoIndex = (-1).obs;
  
  // Background loading management for videos only
  final Map<int, Completer<VideoPlayerController?>> _loadingCompleters = {};
  final Set<int> _preloadingIndexes = {};
  
  // Isolate for video processing only
  Isolate? _videoIsolate;
  ReceivePort? _videoReceivePort;
  SendPort? _videoSendPort;

  // Categories and user data
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  final RxMap<int, Map<String, dynamic>> usersCache = <int, Map<String, dynamic>>{}.obs;

  // Pagination settings
  static const int pageSize = 10;
  static const int preloadRange = 2;

  @override
  void onInit() {
    super.onInit();
    _initializeVideoIsolate();
    loadCategories();
    loadInitialReels();
  }

  @override
  void onClose() {
    _disposeVideoIsolate();
    disposeAllVideoControllers();
    super.onClose();
  }

  // Initialize isolate only for video processing
  Future<void> _initializeVideoIsolate() async {
    try {
      _videoReceivePort = ReceivePort();
      _videoIsolate = await Isolate.spawn(
        _videoIsolateEntryPoint,
        _videoReceivePort!.sendPort,
      );
      
      _videoReceivePort!.listen((message) {
        if (message is SendPort) {
          _videoSendPort = message;
        }
      });
    } catch (e) {
      print('Error initializing video isolate: $e');
    }
  }

  static void _videoIsolateEntryPoint(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    
    receivePort.listen((message) {
      // Only handle video-related background tasks
      if (message is Map) {
        switch (message['type']) {
          case 'preloadVideo':
            // Handle video preloading if needed
            break;
        }
      }
    });
  }

  void _disposeVideoIsolate() {
    _videoIsolate?.kill(priority: Isolate.immediate);
    _videoReceivePort?.close();
    _videoIsolate = null;
    _videoReceivePort = null;
    _videoSendPort = null;
  }

  // Load categories (keep this synchronous and on main thread)
  Future<void> loadCategories() async {
    try {
      // First try to sync from GlobalController
      if (_globalController.hasReelCategories) {
        categories.value = _globalController.getReelCategories;
        print('Synced ${categories.length} categories from GlobalController');
        
        // Debug categories
        for (var category in categories) {
          print('Category: ID=${category['id']}, Name=${category['name']}');
        }
        return;
      }

      // If not available, fetch from API
      final response = await _categoriesService.getReelCategories();
      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data is List) {
          categories.value = List<Map<String, dynamic>>.from(data);
        } else if (data is Map && data['results'] != null) {
          categories.value = List<Map<String, dynamic>>.from(data['results']);
        }
        
        print('Loaded ${categories.length} categories from API');
        
        // Debug categories
        for (var category in categories) {
          print('Category: ID=${category['id']}, Name=${category['name']}');
        }
      }
    } catch (e) {
      print('Error loading categories: $e');
      // Try to sync from GlobalController as fallback
      syncCategoriesFromGlobal();
    }
  }

  void syncCategoriesFromGlobal() {
    if (categories.isEmpty && _globalController.hasReelCategories) {
      categories.value = _globalController.getReelCategories;
      print('Synced ${categories.length} categories from GlobalController as fallback');
    }
  }

  // Load initial reels
  Future<void> loadInitialReels() async {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = '';
    currentPage.value = 1;
    hasMoreData.value = true;

    try {
      final response = await _reelsService.getReels(
        page: currentPage.value,
        size: pageSize,
        ordering: '-created_at',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final reelsList = data['results'] as List;
        
        reels.clear();
        disposeAllVideoControllers();

        if (reelsList.isNotEmpty) {
          final newReels = reelsList.map((json) => ReelModel.fromJson(json)).toList();
          reels.addAll(newReels);
          
          // Load additional data immediately on main thread
          await loadAdditionalReelData(newReels);
          
          hasMoreData.value = data['next'] != null;
          
          // Initialize first video and preload next ones
          if (reels.isNotEmpty) {
            currentIndex.value = 0;
            await _initializeVideoWithPreload(0);
          }
        } else {
          hasMoreData.value = false;
        }
      }
    } catch (e) {
      print('Error loading initial reels: $e');
      errorMessage.value = 'Failed to load reels. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  // Load more reels for infinite scrolling
  Future<void> loadMoreReels() async {
    if (isLoadingMore.value || !hasMoreData.value) return;

    isLoadingMore.value = true;

    try {
      final response = await _reelsService.getReels(
        page: currentPage.value + 1,
        size: pageSize,
        ordering: '-created_at',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final reelsList = data['results'] as List;
        
        if (reelsList.isNotEmpty) {
          final newReels = reelsList.map((json) => ReelModel.fromJson(json)).toList();
          reels.addAll(newReels);
          
          // Load additional data immediately on main thread
          await loadAdditionalReelData(newReels);
          
          currentPage.value++;
          hasMoreData.value = data['next'] != null;
        } else {
          hasMoreData.value = false;
        }
      }
    } catch (e) {
      print('Error loading more reels: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  // Load additional data for reels (back on main thread for API calls)
  Future<void> loadAdditionalReelData(List<ReelModel> newReels) async {
    try {
      print('Loading additional data for ${newReels.length} reels');
      
      // Ensure categories are loaded
      if (categories.isEmpty) {
        await loadCategories();
      }

      // Get unique user IDs that we don't have cached
      final userIds = newReels
          .map((reel) => reel.createdBy)
          .where((id) => !usersCache.containsKey(id))
          .toSet()
          .toList();

      print('Need to fetch user data for IDs: $userIds');

      // Fetch users data in batches to avoid overwhelming the API
      for (int userId in userIds) {
        try {
          print('Fetching user data for ID: $userId');
          final userResponse = await _reelsService.getUserById(userId);
          
          if (userResponse.statusCode == 200 && userResponse.data != null) {
            usersCache[userId] = userResponse.data;
            print('Successfully cached user data for ID $userId: ${userResponse.data['name'] ?? userResponse.data['username']}');
          } else {
            print('Failed to fetch user $userId: ${userResponse.statusCode}');
          }
        } catch (e) {
          print('Error fetching user $userId: $e');
          // Continue with other users even if one fails
        }
      }

      // Update reels with user and category information
      for (var reel in newReels) {
        // Add category information
        final category = categories.firstWhereOrNull((cat) => cat['id'] == reel.category);
        if (category != null) {
          reel.categoryName = category['name'];
          reel.categoryIcon = category['icon'];
          print('Updated reel ${reel.id} with category: ${reel.categoryName} (ID: ${reel.category})');
        } else {
          print('No category found for category ID: ${reel.category}');
          print('Available categories: ${categories.map((c) => '${c['id']}: ${c['name']}').join(', ')}');
        }

        // Add user information
        final user = usersCache[reel.createdBy];
        if (user != null) {
          reel.userName = _getUserDisplayName(user);
          reel.userProfilePicture = user['profile_picture'];
          reel.userAge = _calculateAge(user['date_of_birth']);
          reel.isOnline = user['is_active'] ?? false;
          
          print('Updated reel ${reel.id} with user: ${reel.userName}, age: ${reel.userAge}');
        } else {
          print('No user data found for user ID: ${reel.createdBy}');
          reel.userName = 'User ${reel.createdBy}'; // Fallback name
        }
      }

      // Trigger UI update
      reels.refresh();
      print('Completed loading additional data for ${newReels.length} reels');
      
    } catch (e) {
      print('Error loading additional reel data: $e');
    }
  }

  // Helper to get user display name
  String _getUserDisplayName(Map<String, dynamic> user) {
    // Try to get name first
    final name = user['name']?.toString().trim() ?? '';
    if (name.isNotEmpty) {
      return name;
    }

    // Fallback to constructing from first_name and last_name
    final firstName = user['first_name']?.toString().trim() ?? '';
    final lastName = user['last_name']?.toString().trim() ?? '';
    
    if (firstName.isNotEmpty) {
      return firstName + (lastName.isNotEmpty ? ' ${lastName[0]}.' : '');
    }

    // Fallback to username
    final username = user['username']?.toString().trim() ?? '';
    if (username.isNotEmpty) {
      return username;
    }

    // Last fallback
    return 'User ${user['id'] ?? 'Unknown'}';
  }

  // Helper to calculate age from date of birth
  int? _calculateAge(String? dateOfBirth) {
    if (dateOfBirth == null || dateOfBirth.isEmpty) return null;
    
    try {
      final birthDate = DateTime.parse(dateOfBirth);
      final now = DateTime.now();
      int age = now.year - birthDate.year;
      if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (e) {
      print('Error calculating age from date: $dateOfBirth, error: $e');
      return null;
    }
  }

  // Initialize video controller with background loading (videos only)
  Future<void> _initializeVideoWithPreload(int index) async {
    // Initialize current video immediately
    await _initializeVideoController(index);
    
    // Preload next videos in background
    _preloadNextVideos(index);
  }

  // Preload videos in background
  void _preloadNextVideos(int currentIndex) {
    for (int i = currentIndex + 1; i <= currentIndex + preloadRange && i < reels.length; i++) {
      if (!_videoControllers.containsKey(i) && !_preloadingIndexes.contains(i)) {
        _preloadingIndexes.add(i);
        _initializeVideoControllerInBackground(i);
      }
    }
  }

  // Initialize video controller in background
  Future<void> _initializeVideoControllerInBackground(int index) async {
    if (index < 0 || index >= reels.length) return;

    final reel = reels[index];
    
    try {
      // Create completer for this loading operation
      final completer = Completer<VideoPlayerController?>();
      _loadingCompleters[index] = completer;
      
      // Update state to loading
      _videoControllers[index] = VideoControllerState(isLoading: true);
      
      // Initialize controller asynchronously
      _initializeControllerAsync(index, reel.videoUrl, completer);
      
    } catch (e) {
      print('Error starting background video initialization for index $index: $e');
      _videoControllers[index] = VideoControllerState(hasError: true);
      _preloadingIndexes.remove(index);
    }
  }

  // Async controller initialization
  Future<void> _initializeControllerAsync(int index, String videoUrl, Completer<VideoPlayerController?> completer) async {
    VideoPlayerController? controller;
    
    try {
      // Use a separate thread for network operations
      await Future.delayed(Duration.zero); // Yield to prevent blocking
      
      controller = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
        httpHeaders: {
          'User-Agent': 'ReelsApp/1.0',
        },
      );
      
      // Initialize with timeout to prevent hanging
      await controller.initialize().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Video initialization timeout', const Duration(seconds: 30));
        },
      );
      
      controller.setLooping(true);
      
      // Update state on main thread
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_videoControllers.containsKey(index)) {
          _videoControllers[index] = VideoControllerState(
            controller: controller,
            isInitialized: true,
          );
          
          completer.complete(controller);
          _preloadingIndexes.remove(index);
          
          print('Successfully preloaded video for index $index');
        }
      });
      
    } catch (e) {
      print('Error initializing video controller for index $index: $e');
      
      // Clean up on error
      controller?.dispose();
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _videoControllers[index] = VideoControllerState(hasError: true);
        completer.complete(null);
        _preloadingIndexes.remove(index);
      });
    }
  }

  // Immediate video controller initialization (for current video)
  Future<void> _initializeVideoController(int index) async {
    if (index < 0 || index >= reels.length) return;

    final reel = reels[index];
    
    // Dispose previous controller if exists
    if (_videoControllers.containsKey(index)) {
      await _videoControllers[index]?.controller?.dispose();
    }

    try {
      _videoControllers[index] = VideoControllerState(isLoading: true);
      
      final controller = VideoPlayerController.networkUrl(Uri.parse(reel.videoUrl));
      await controller.initialize();
      controller.setLooping(true);
      
      _videoControllers[index] = VideoControllerState(
        controller: controller,
        isInitialized: true,
      );
      
      // Auto-play current video
      if (index == currentIndex.value) {
        await controller.play();
        currentVideoIndex.value = index;
        
        // Track view in background
        _trackReelViewInBackground(reel.id);
      }
    } catch (e) {
      print('Error initializing video controller for index $index: $e');
      _videoControllers[index] = VideoControllerState(hasError: true);
    }
  }

  // Get video controller for index
  VideoPlayerController? getVideoController(int index) {
    return _videoControllers[index]?.controller;
  }

  // Check if video is loading
  bool isVideoLoading(int index) {
    return _videoControllers[index]?.isLoading ?? false;
  }

  // Check if video has error
  bool hasVideoError(int index) {
    return _videoControllers[index]?.hasError ?? false;
  }

  FilterOption getFilterById(String filterId) {
    final id = int.tryParse(filterId) ?? 0;
    return availableFilters.firstWhere(
      (filter) => filter.id == id,
      orElse: () => availableFilters[0],
    );
  }

  // Change current video with optimized loading
  Future<void> changeVideo(int newIndex) async {
    if (newIndex == currentIndex.value) return;

    // Pause current video
    final currentController = _videoControllers[currentIndex.value]?.controller;
    await currentController?.pause();

    currentIndex.value = newIndex;
    currentVideoIndex.value = newIndex;

    // Initialize new video if not ready
    if (!_videoControllers.containsKey(newIndex) || !(_videoControllers[newIndex]?.isInitialized ?? false)) {
      await _initializeVideoController(newIndex);
    } else {
      // Play the new video
      final newController = _videoControllers[newIndex]?.controller;
      await newController?.play();
      
      // Track view in background
      if (newIndex < reels.length) {
        _trackReelViewInBackground(reels[newIndex].id);
      }
    }

    // Preload next videos
    _preloadNextVideos(newIndex);

    // Dispose old controllers to free memory
    _disposeOldControllers(newIndex);

    // Load more reels if near the end
    if (newIndex >= reels.length - 3) {
      loadMoreReels();
    }
  }

  // Dispose controllers that are far from current position to save memory
  void _disposeOldControllers(int currentIndex) {
    final keysToRemove = <int>[];
    
    for (var index in _videoControllers.keys) {
      if ((index < currentIndex - preloadRange) || (index > currentIndex + preloadRange * 2)) {
        keysToRemove.add(index);
      }
    }
    
    for (var index in keysToRemove) {
      _videoControllers[index]?.controller?.dispose();
      _videoControllers.remove(index);
      _loadingCompleters.remove(index);
    }
  }

  // Toggle play/pause for current video
  void togglePlayPause() {
    final controller = _videoControllers[currentIndex.value]?.controller;
    if (controller != null) {
      if (controller.value.isPlaying) {
        controller.pause();
      } else {
        controller.play();
      }
    }
  }

  // Like/unlike reel (run in background to avoid UI blocking)
  Future<void> toggleLike(int reelIndex) async {
    if (reelIndex < 0 || reelIndex >= reels.length) return;

    final reel = reels[reelIndex];
    
    // Update UI immediately for better UX
    final wasLiked = reel.isLiked;
    if (wasLiked) {
      reel.likes.clear();
    } else {
      reel.likes.add({});
    }
    reels.refresh();
    
    // Perform API call in background
    try {
      if (wasLiked) {
        await _reelsService.unlikeReel(reel.id);
      } else {
        await _reelsService.likeReel(reel.id);
      }
    } catch (e) {
      print('Error toggling like for reel ${reel.id}: $e');
      // Revert UI change on error
      if (wasLiked) {
        reel.likes.add({});
      } else {
        reel.likes.clear();
      }
      reels.refresh();
    }
  }

  // Track reel view in background
  void _trackReelViewInBackground(int reelId) {
    // Don't await this to avoid blocking UI
    _reelsService.viewReel(reelId).catchError((e) {
      print('Error tracking view for reel $reelId: $e');
    });
  }

  // Dispose all video controllers
  void disposeAllVideoControllers() {
    for (var state in _videoControllers.values) {
      state.controller?.dispose();
    }
    _videoControllers.clear();
    _loadingCompleters.clear();
    _preloadingIndexes.clear();
  }

  // Dispose specific video controller
  void disposeVideoController(int index) {
    if (_videoControllers.containsKey(index)) {
      _videoControllers[index]?.controller?.dispose();
      _videoControllers.remove(index);
      _loadingCompleters.remove(index);
      _preloadingIndexes.remove(index);
    }
  }

  // Refresh reels
  Future<void> refreshReels() async {
    await loadInitialReels();
  }

  // Get current reel
  ReelModel? get currentReel {
    if (currentIndex.value >= 0 && currentIndex.value < reels.length) {
      return reels[currentIndex.value];
    }
    return null;
  }

  // Force reload user data for a specific reel (useful for debugging)
  Future<void> reloadUserData(int reelIndex) async {
    if (reelIndex < 0 || reelIndex >= reels.length) return;

    final reel = reels[reelIndex];
    try {
      print('Reloading user data for user ID: ${reel.createdBy}');
      final userResponse = await _reelsService.getUserById(reel.createdBy);
      
      if (userResponse.statusCode == 200 && userResponse.data != null) {
        usersCache[reel.createdBy] = userResponse.data;
        
        // Update reel with fresh user data
        final user = userResponse.data;
        reel.userName = _getUserDisplayName(user);
        reel.userProfilePicture = user['profile_picture'];
        reel.userAge = _calculateAge(user['date_of_birth']);
        reel.isOnline = user['is_active'] ?? false;
        
        print('Reloaded user data: ${reel.userName}, age: ${reel.userAge}');
        
        // Trigger UI update
        reels.refresh();
      }
    } catch (e) {
      print('Error reloading user data: $e');
    }
  }
}