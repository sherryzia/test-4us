import 'dart:async';
import 'dart:ui';
import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/view/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:candid/view/widget/my_button_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';

class ItsAMatch extends StatefulWidget {
  final String? userName;
  final String? userProfilePicture;
  final String? matchVideoPath;
  
  const ItsAMatch({
    super.key,
    this.userName,
    this.userProfilePicture,
    this.matchVideoPath,
  });

  @override
  State<ItsAMatch> createState() => _ItsAMatchState();
}

class _ItsAMatchState extends State<ItsAMatch>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  
  VideoPlayerController? _controller;
  late AnimationController _fadeAnimationController;
  late AnimationController _scaleAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  bool _isVideoReady = false;
  bool _hasVideoError = false;
  bool _isDisposed = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Initialize animations
    _initializeAnimations();
    
    // Initialize video controller in background
    _initializeVideoController();
    
    // Provide haptic feedback
    HapticFeedback.mediumImpact();
    
    // Start animations
    _startAnimations();
  }

  void _initializeAnimations() {
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _scaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleAnimationController,
      curve: Curves.elasticOut,
    ));
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!_isDisposed) {
        _fadeAnimationController.forward();
        _scaleAnimationController.forward();
      }
    });
  }

  Future<void> _initializeVideoController() async {
    try {
      // Check if video asset exists first
      final assetExists = await _checkAssetExists(Assets.imagesItsAMatchVideo);
      
      if (!assetExists) {
        _handleVideoError('Video asset not found');
        return;
      }

      // Initialize controller in background thread
      await Future.delayed(Duration.zero); // Yield to prevent blocking UI
      
      _controller = VideoPlayerController.asset(Assets.imagesItsAMatchVideo);
      
      // Initialize with timeout and error handling
      await _controller!.initialize().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Video initialization timeout', const Duration(seconds: 10));
        },
      );
      
      if (!_isDisposed && mounted) {
        setState(() {
          _isVideoReady = true;
          _hasVideoError = false;
        });
        
        // Configure video settings
        await _controller!.setLooping(true);
        await _controller!.play();
        
        print('Video initialized successfully');
      }
    } catch (e) {
      print('Error initializing video: $e');
      _handleVideoError(e.toString());
    }
  }

  Future<bool> _checkAssetExists(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (e) {
      print('Asset not found: $assetPath');
      return false;
    }
  }

  void _handleVideoError(String error) {
    if (!_isDisposed && mounted) {
      setState(() {
        _hasVideoError = true;
        _errorMessage = error;
        _isVideoReady = false;
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    if (_controller == null || !_isVideoReady) return;
    
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        _controller!.pause();
        break;
      case AppLifecycleState.resumed:
        if (mounted && !_hasVideoError) {
          _controller!.play();
        }
        break;
      case AppLifecycleState.detached:
        _controller!.pause();
        break;
      case AppLifecycleState.hidden:
        _controller!.pause();
        break;
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    WidgetsBinding.instance.removeObserver(this);
    
    // Dispose video controller safely
    _disposeVideoController();
    
    // Dispose animation controllers
    _fadeAnimationController.dispose();
    _scaleAnimationController.dispose();
    
    super.dispose();
  }

  void _disposeVideoController() {
    if (_controller != null) {
      _controller!.pause().catchError((e) {
        print('Error pausing video: $e');
      }).then((_) {
        _controller!.dispose().catchError((e) {
          print('Error disposing video controller: $e');
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          _navigateToHome();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            _buildVideoBackground(),
            _buildMatchContent(),
            _buildLottieAnimation(),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoBackground() {
    if (_hasVideoError) {
      return _buildVideoFallback();
    }

    if (!_isVideoReady || _controller == null) {
      return _buildVideoLoading();
    }

    return Transform.scale(
      alignment: Alignment.bottomCenter,
      scaleX: 1.23,
      scaleY: 1.0,
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _controller!.value.size.width,
          height: _controller!.value.size.height,
          child: VideoPlayer(_controller!),
        ),
      ),
    );
  }

  Widget _buildVideoFallback() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            kSecondaryColor.withOpacity(0.8),
            kPurpleColor.withOpacity(0.9),
            Colors.black,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite,
              size: 100,
              color: Colors.pink.withOpacity(0.3),
            ),
            const SizedBox(height: 20),
            Text(
              'It\'s a Match!',
              style: TextStyle(
                color: kPrimaryColor.withOpacity(0.7),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoLoading() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            kSecondaryColor.withOpacity(0.6),
            kPurpleColor.withOpacity(0.8),
            Colors.black,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Preparing celebration...',
              style: TextStyle(
                color: kPrimaryColor.withOpacity(0.8),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchContent() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: AppSizes.DEFAULT,
                child: AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: _buildMatchCard(),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMatchCard() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(16),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ),
        child: Container(
          constraints: BoxConstraints(
            minHeight: 350,
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          padding: AppSizes.DEFAULT,
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.5,
              color: kPrimaryColor.withOpacity(0.3),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                kBlackColor.withOpacity(0.1),
                kBlackColor.withOpacity(0.6),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMatchIcon(),
              _buildMatchText(),
              const SizedBox(height: 20),
              _buildSendMessageButton(),
              const SizedBox(height: 12),
              _buildVideoMessageButton(),
              const SizedBox(height: 24),
              _buildKeepSwipingButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatchIcon() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1500),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.5 + (value * 0.5),
          child: Transform.rotate(
            angle: value * 0.5,
            child: Image.asset(
              Assets.imagesItsMatchIcon,
              height: 116,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.favorite,
                  size: 116,
                  color: Colors.pink,
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildMatchText() {
    final userName = widget.userName ?? 'Someone';
    
    return MyText(
      paddingTop: 10,
      text: '$userName likes you too 💜',
      size: 18,
      color: kPrimaryColor,
      paddingBottom: 10,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSendMessageButton() {
    return MyButton(
      buttonText: '',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 32,
              width: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: kPrimaryColor,
              ),
              child: Center(
                child: Image.asset(
                  Assets.imagesSendMessage,
                  height: 18,
                  color: kSecondaryColor,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.message,
                      size: 18,
                      color: kSecondaryColor,
                    );
                  },
                ),
              ),
            ),
             MyText(
              text: 'Send Message',
              size: 16,
              weight: FontWeight.w600,
              color: kPrimaryColor,
            ),
            Image.asset(
              Assets.imagesMultipleArrow,
              height: 18,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.arrow_forward,
                  size: 18,
                  color: kPrimaryColor,
                );
              },
            ),
          ],
        ),
      ),
      onTap: _handleSendMessage,
    );
  }

  Widget _buildVideoMessageButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.0,
              color: kPrimaryColor.withOpacity(0.5),
            ),
            color: kPrimaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: _handleSendVideoMessage,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 32,
                      width: 32,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: kPrimaryColor,
                      ),
                      child: Center(
                        child: Image.asset(
                          Assets.imagesVideoMessage,
                          height: 18,
                          color: kSecondaryColor,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.videocam,
                              size: 18,
                              color: kSecondaryColor,
                            );
                          },
                        ),
                      ),
                    ),
                     MyText(
                      text: 'Send Video Message',
                      size: 16,
                      weight: FontWeight.w600,
                      color: kPrimaryColor,
                    ),
                    Image.asset(
                      Assets.imagesMultipleArrow,
                      height: 18,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.arrow_forward,
                          size: 18,
                          color: kPrimaryColor,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeepSwipingButton() {
    return GestureDetector(
      onTap: _navigateToHome,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child:  MyText(
          text: 'Keep Swiping',
          size: 14,
          color: kPrimaryColor,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _buildLottieAnimation() {
    return IgnorePointer(
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 2000),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Opacity(
            opacity: 1.0 - (value * 0.7), // Fade out over time
            child: Lottie.asset(
              Assets.imagesRatingStars,
              repeat: false,
              height: Get.height,
              width: Get.width,
              fit: BoxFit.cover,
              frameRate: FrameRate(60), // Reduced from 90 for better performance
              errorBuilder: (context, error, stackTrace) {
                print('Lottie animation error: $error');
                return const SizedBox.shrink(); // Hide on error
              },
            ),
          );
        },
      ),
    );
  }

  void _handleSendMessage() {
    HapticFeedback.lightImpact();
    // TODO: Implement send message functionality
    Get.snackbar(
      'Message',
      'Message feature coming soon!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: kSecondaryColor.withOpacity(0.8),
      colorText: kPrimaryColor,
    );
  }

  void _handleSendVideoMessage() {
    HapticFeedback.lightImpact();
    // TODO: Implement send video message functionality
    Get.snackbar(
      'Video Message',
      'Video message feature coming soon!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: kSecondaryColor.withOpacity(0.8),
      colorText: kPrimaryColor,
    );
  }

  void _navigateToHome() {
    HapticFeedback.selectionClick();
    
    // Pause video before navigation
    if (_controller != null && _isVideoReady) {
      _controller!.pause();
    }
    
    // Navigate with animation
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => BottomNavBar(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
      (route) => route.isFirst,
    ).catchError((e) {
      print('Navigation error: $e');
      // Fallback navigation
      Get.offAll(() => BottomNavBar());
    });
  }
}

// Extension to check if MyText widget supports textAlign
extension MyTextExtension on MyText {
  // This is just for reference - you might need to add textAlign parameter to MyText widget
}