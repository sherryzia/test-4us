// File: lib/view/screens/upload_video/start_recording.dart

import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/constants/filter.dart';
import 'package:candid/controller/camera_controller.dart';
import 'package:candid/view/screens/upload_video/themed_camerakit_integration.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:camera/camera.dart';
import 'package:draggable_float_widget/draggable_float_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class StartRecording extends StatelessWidget {
  final Map<String, dynamic>? category;
  final dynamic categoryId;

  const StartRecording({super.key, this.category, required this.categoryId});

  @override
@override
Widget build(BuildContext context) {
  // Just find the existing controller
  final CameraRecordingController controller = Get.find<CameraRecordingController>();
  
  return Scaffold(
    backgroundColor: Colors.black,
    body: GetBuilder<CameraRecordingController>(
      builder: (controller) {
          if (!controller.isInitialized) {
            return const InitializingScreen();
          }

          return Stack(
            children: [
              // Camera Preview with Filter Overlay (Full Screen Behind Everything)
              CameraPreviewWidget(controller: controller),

              // All UI Controls and Overlays
              Obx(() => controller.showFilters && !controller.isRecording
                  ? FiltersListWidget(controller: controller)
                  : FiltersListWidget(controller: controller)),

              // Recording duration overlay
              if (controller.isRecording)
                RecordingIndicatorWidget(controller: controller),

              // Countdown overlay
              if (controller.isCountingDown)
                CountdownOverlayWidget(controller: controller),

              // Main Controls Layout
              MainControlsWidget(
                controller: controller,
                category: category,
                categoryId: categoryId,
              ),

              // Draggable AI Question
              if (category != null && (category!['has_ai_questions'] ?? false))
                DraggableAIQuestionWidget(
                  controller: controller,
                  category: category!,
                ),
            ],
          );
        },
      ),
    );
  }
}

class InitializingScreen extends StatelessWidget {
  const InitializingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: kSecondaryColor),
          SizedBox(height: 16),
          Text(
            'Initializing Camera...',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class CameraPreviewWidget extends StatelessWidget {
  final CameraRecordingController controller;

  const CameraPreviewWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          // Camera Preview - Full Screen
          if (controller.cameraController != null)
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: controller.cameraController!.value.previewSize!.height,
                  height: controller.cameraController!.value.previewSize!.width,
                  child: CameraPreview(controller.cameraController!),
                ),
              ),
            ),

          // Filter Overlay - Full Screen
          GetBuilder<CameraRecordingController>(
            id: 'filter',
            builder: (controller) {
              if (controller.currentFilter.overlayColor != Colors.transparent) {
                return Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: controller.currentFilter.overlayColor
                          .withOpacity(controller.currentFilter.opacity),
                      backgroundBlendMode: controller.currentFilter.blendMode,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

class FiltersListWidget extends StatelessWidget {
  final CameraRecordingController controller;

  const FiltersListWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: controller.showFilters ? 250 : 0,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black26,
                Colors.black87,
              ],
              stops: [0.0, 0.3, 1.0],
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: availableFilters.length,
                  itemBuilder: (context, index) {
                    final filter = availableFilters[index];
                    return GetBuilder<CameraRecordingController>(
                      id: 'filter_selection',
                      builder: (controller) {
                        final isSelected =
                            filter.id == controller.currentFilter.id;

                        return GestureDetector(
                          onTap: () => controller.selectFilter(filter),
                          child: FilterItemWidget(
                            filter: filter,
                            isSelected: isSelected,
                            controller: controller,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }
}

class FilterItemWidget extends StatelessWidget {
  final FilterOption filter;
  final bool isSelected;
  final CameraRecordingController controller;

  const FilterItemWidget({
    super.key,
    required this.filter,
    required this.isSelected,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? controller.getFilterDisplayColor()
              : Colors.transparent,
          width: 2,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: controller.getFilterDisplayColor().withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
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
                    size: 18,
                  ),
                ),
                Positioned(
                  top: 2,
                  right: 2,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${filter.id}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            filter.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class RecordingIndicatorWidget extends StatelessWidget {
  final CameraRecordingController controller;

  const RecordingIndicatorWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 100,
      left: 20,
      right: 20, // Add right constraint
      child: GetBuilder<CameraRecordingController>(
        id: 'recording',
        builder: (controller) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.circle, color: Colors.white, size: 8),
                const SizedBox(width: 4),
                Flexible(
                  // Wrap with Flexible to prevent overflow
                  child: Text(
                    'REC ${controller.formatDuration(controller.recordingDuration)} • ${controller.currentFilter.name}',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CountdownOverlayWidget extends StatelessWidget {
  final CameraRecordingController controller;

  const CountdownOverlayWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black54,
        child: Center(
          child: GetBuilder<CameraRecordingController>(
            id: 'countdown',
            builder: (controller) {
              return Text(
                controller.timerCountdown.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class MainControlsWidget extends StatelessWidget {
  final CameraRecordingController controller;
  final Map<String, dynamic>? category;
  final dynamic categoryId;

  const MainControlsWidget({
    super.key,
    required this.controller,
    this.category,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: SafeArea(
        // Add SafeArea to prevent overflow
        child: Padding(
          padding:
              const EdgeInsets.fromLTRB(20, 10, 20, 20), // Reduce top padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top controls
              TopControlsWidget(category: category),

              // Main content area with right controls
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(), // Push right controls to the right
                    // Right side controls
                    RightSideControlsWidget(controller: controller),
                  ],
                ),
              ),

              // Bottom controls
              BottomControlsWidget(
                controller: controller,
                categoryId: categoryId,
                category: category,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopControlsWidget extends StatelessWidget {
  final Map<String, dynamic>? category;

  const TopControlsWidget({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Get.back(),
          child: Image.asset(Assets.imagesClose, height: 20),
        ),
        if (category != null)
          Flexible(
            // Wrap with Flexible
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: kSecondaryColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                category!['name'] ?? 'Category',
                style: const TextStyle(color: Colors.white, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        Flexible(
          // Wrap with Flexible
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(Assets.imagesSounds, height: 16),
              const SizedBox(width: 8), // Use SizedBox instead of padding
              const Text(
                'Sounds',
                style: TextStyle(
                  fontSize: 16,
                  color: kPrimaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RightSideControlsWidget extends StatelessWidget {
  final CameraRecordingController controller;

  const RightSideControlsWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min, // Add this to prevent overflow
      children: [
        // Flip camera
        _buildControlItem(
          icon: Assets.imagesFlip,
          label: 'Flip',
          onTap: controller.toggleCamera,
        ),

        // Speed control
        GetBuilder<CameraRecordingController>(
          id: 'speed',
          builder: (controller) {
            return _buildControlItem(
              icon: Assets.imagesSpeed,
              label: '${controller.recordingSpeed}x',
              onTap: controller.changeSpeed,
            );
          },
        ),

        // Filters
       
          Obx(() {
            return _buildControlItem(
              icon: Assets.imagesFilters,
              label: controller.currentFilter.id == 0
                  ? 'Filters'
                  : controller.currentFilter.name,
              onTap: controller.toggleFilters,
              iconColor:
                  controller.currentFilter.overlayColor == Colors.transparent
                      ? Colors.white
                      : Colors.white,
              labelColor:
                  controller.currentFilter.overlayColor == Colors.transparent
                      ? kPrimaryColor
                      : controller.getFilterDisplayColor(),
              hasFilterOverlay:
                  controller.currentFilter.overlayColor != Colors.transparent,
              filterColor: controller.currentFilter.overlayColor,
            );
          },
          ),
       

        // Timer
        _buildControlItem(
          icon: Assets.imagesTimers,
          label: 'Timer',
          onTap: () => _showTimerOptions(context, controller),
        ),

        // Flash
        GetBuilder<CameraRecordingController>(
          id: 'flash',
          builder: (controller) {
            return _buildControlItem(
              icon: Assets.imagesFlash,
              label: 'Flash',
              onTap: controller.toggleFlash,
              iconColor: controller.isFlashOn ? Colors.yellow : Colors.white,
              labelColor: controller.isFlashOn ? Colors.yellow : kPrimaryColor,
            );
          },
        ),
      ],
    );
  }

  Widget _buildControlItem({
    required String icon,
    required String label,
    required VoidCallback onTap,
    Color? iconColor,
    Color? labelColor,
    bool hasFilterOverlay = false,
    Color? filterColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: hasFilterOverlay
                  ? BoxDecoration(
                      color: filterColor?.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white, width: 1),
                    )
                  : null,
              child: Image.asset(
                icon,
                height: 22,
                color: iconColor ?? Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: labelColor ?? kPrimaryColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showTimerOptions(
      BuildContext context, CameraRecordingController controller) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Timer',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              const SizedBox(height: 8),
              Wrap(
                // Use Wrap instead of Row to prevent overflow
                alignment: WrapAlignment.spaceEvenly,
                children: [
                  _timerButton('Off', () => Navigator.pop(context)),
                  _timerButton('3s', () {
                    Navigator.pop(context);
                    controller.startCountdown(3);
                  }),
                  _timerButton('5s', () {
                    Navigator.pop(context);
                    controller.startCountdown(5);
                  }),
                  _timerButton('10s', () {
                    Navigator.pop(context);
                    controller.startCountdown(10);
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _timerButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: kSecondaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

class BottomControlsWidget extends StatelessWidget {
  final CameraRecordingController controller;
  final dynamic categoryId;
  final Map<String, dynamic>? category;

  const BottomControlsWidget({
    super.key,
    required this.controller,
    required this.categoryId,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSizes.HORIZONTAL,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Effects button
          GestureDetector(
            onTap: () => _openEffects(categoryId, category),
            child: Image.asset(Assets.imagesEffects, height: 50),
          ),

          // Record button
          GestureDetector(
            onTap: () => controller.isRecording
                ? controller.stopRecording()
                : controller.startRecording(),
            child: GetBuilder<CameraRecordingController>(
              id: 'record_button',
              builder: (controller) {
                return AnimatedBuilder(
                  animation: controller.recordButtonAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: controller.recordButtonAnimation.value,
                      child: Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: controller.isRecording
                                ? Colors.red
                                : controller.getFilterDisplayColor(),
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: controller.isRecording ? 30 : 65,
                            height: controller.isRecording ? 30 : 65,
                            decoration: BoxDecoration(
                              color: controller.isRecording
                                  ? Colors.red
                                  : controller.getFilterDisplayColor(),
                              shape: controller.isRecording
                                  ? BoxShape.rectangle
                                  : BoxShape.circle,
                              borderRadius: controller.isRecording
                                  ? BorderRadius.circular(4)
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Upload button
          Image.asset(Assets.imagesUpload, height: 50),
        ],
      ),
    );
  }

  void _openEffects(dynamic categoryId, Map<String, dynamic>? category) {
    print('Opening effects with fallback...');
    try {
      Get.to(
        () => ThemedCameraKitScreen(
          category: category,
          categoryId: categoryId,
          onBack: () {
            print('Returned from effects');
          },
        ),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 300),
      );
    } catch (e) {
      print('CameraKit failed, showing fallback: $e');
      _showEffectsComingSoonDialog();
    }
  }

  void _showEffectsComingSoonDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kSecondaryColor, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.auto_awesome_outlined,
                size: 60,
                color: kSecondaryColor,
              ),
              const SizedBox(height: 16),
              const Text(
                'Effects Coming Soon!',
                style: TextStyle(
                  fontSize: 20,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Amazing camera effects are being prepared for you. For now, use the regular camera to create awesome content!',
                style: TextStyle(
                  fontSize: 14,
                  color: kPrimaryColor.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [kSecondaryColor, kPurpleColor],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: MaterialButton(
                  onPressed: () => Get.back(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Text(
                    'Got it!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DraggableAIQuestionWidget extends StatelessWidget {
  final CameraRecordingController controller;
  final Map<String, dynamic> category;

  const DraggableAIQuestionWidget({
    super.key,
    required this.controller,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableFloatWidget(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              kSecondaryColor.withOpacity(0.9),
              kPurpleColor.withOpacity(0.9),
            ],
          ),
        ),
        child: Text(
          category['sample_question'] ??
              'Would you rather have to always wear shoes two sizes too big or one size too small?',
          style: TextStyle(
            fontSize: 16,
            fontFamily: GoogleFonts.chewy().fontFamily,
            color: kPrimaryColor,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      eventStreamController: controller.eventStreamController,
      config: const DraggableFloatWidgetBaseConfig(
        isFullScreen: true,
        initPositionYInTop: true,
        initPositionYMarginBorder: 100,
      ),
      width: 237,
      height: 130,
      onTap: () => print("Question tapped!"),
    );
  }
}
