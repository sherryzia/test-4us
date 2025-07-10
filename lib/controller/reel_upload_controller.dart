import 'dart:io';
import 'package:candid/view/widget/upload_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:candid/services/reel_upload_service.dart';
import 'package:candid/controller/GlobalController.dart';
import 'package:dio/dio.dart';

class ReelUploadController extends GetxController {
  final ReelUploadService _reelUploadService = ReelUploadService();
  final GlobalController globalController = Get.find<GlobalController>();

  // Upload state
  final RxBool isUploading = false.obs;
  final RxDouble uploadProgress = 0.0.obs;
  final RxString uploadStatus = ''.obs;
  final RxBool uploadCompleted = false.obs;
  final RxBool uploadError = false.obs;
  final RxString errorMessage = ''.obs;

  // File info
  final RxString fileName = ''.obs;
  final RxString fileSize = ''.obs;

  // Cancel token for upload
  CancelToken? _cancelToken;

  // Method to upload reel
  Future<void> uploadReel({
    required BuildContext context,
    required File videoFile,
    required int categoryId,
    required String caption,
    required int filterId,
  }) async {
    try {
      // Reset state
      isUploading.value = true;
      uploadProgress.value = 0.0;
      uploadCompleted.value = false;
      uploadError.value = false;
      errorMessage.value = '';
      
      // Set file info
      fileName.value = videoFile.path.split('/').last;
      final fileSizeBytes = await videoFile.length();
      fileSize.value = ReelUploadService.formatFileSize(fileSizeBytes);
      
      print('Starting reel upload...');
      print('File: ${fileName.value}');
      print('Size: ${fileSize.value}');
      print('Category ID: $categoryId');
      print('Filter ID: $filterId');

      // Create cancel token
      _cancelToken = CancelToken();

      // Show upload dialog
      _showUploadDialog(context);

      // Start upload
      uploadStatus.value = 'Preparing upload...';
      
      final response = await _reelUploadService.uploadReel(
        videoFile: videoFile,
        categoryId: categoryId,
        caption: caption,
        filterId: filterId.toString(),
        onProgress: (sent, total) {
          uploadProgress.value = sent / total;
          uploadStatus.value = 'Uploading... ${(uploadProgress.value * 100).toStringAsFixed(1)}%';
          print('Upload progress: ${(uploadProgress.value * 100).toStringAsFixed(1)}%');
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Upload successful
        uploadCompleted.value = true;
        uploadStatus.value = 'Upload completed successfully!';
        
        print('Upload successful!');
        print('Response: ${response.data}');

        // Show success message
        Get.snackbar(
          'Success',
          'Your reel has been uploaded successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        // Auto-close dialog after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          if (Get.isDialogOpen == true) {
            Get.back(); // Close dialog
          }
        });

      } else {
        throw Exception('Upload failed with status: ${response.statusCode}');
      }

    } catch (e) {
      print('Upload error: $e');
      
      uploadError.value = true;
      uploadCompleted.value = false;
      
      String errorMsg = 'Upload failed. Please try again.';
      
      if (e is DioException) {
        if (e.type == DioExceptionType.cancel) {
          errorMsg = 'Upload was cancelled.';
        } else if (e.response?.statusCode == 413) {
          errorMsg = 'File too large. Please select a smaller video.';
        } else if (e.response?.statusCode == 400) {
          errorMsg = 'Invalid file format or missing information.';
        } else if (e.response?.statusCode == 401) {
          errorMsg = 'Authentication failed. Please login again.';
        } else if (e.response?.statusCode == 403) {
          errorMsg = 'You don\'t have permission to upload reels.';
        } else if (e.response?.statusCode == 500) {
          errorMsg = 'Server error. Please try again later.';
        } else if (e.type == DioExceptionType.connectionTimeout || 
                   e.type == DioExceptionType.sendTimeout) {
          errorMsg = 'Upload timeout. Please check your connection and try again.';
        }
      } else if (e.toString().contains('100MB')) {
        errorMsg = e.toString();
      }
      
      errorMessage.value = errorMsg;
      uploadStatus.value = 'Upload failed';

      Get.snackbar(
        'Upload Failed',
        errorMsg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isUploading.value = false;
      _cancelToken = null;
    }
  }

  // Show upload progress dialog
  void _showUploadDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Obx(() => UploadProgressDialog(
        progress: uploadProgress.value,
        statusText: uploadStatus.value,
        fileName: fileName.value,
        fileSize: fileSize.value,
        isCompleted: uploadCompleted.value,
        hasError: uploadError.value,
        errorMessage: errorMessage.value,
        onCancel: isUploading.value ? cancelUpload : null,
        onRetry: uploadError.value ? () {
          Get.back(); // Close current dialog
          // Note: Retry would need the original parameters passed again
          // This should be handled by the calling widget
        } : null,
        onClose: (uploadCompleted.value || uploadError.value) ? () {
          Get.back(); // Close dialog
        } : null,
      )),
    );
  }

  // Cancel upload
  void cancelUpload() {
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken!.cancel('Upload cancelled by user');
      uploadStatus.value = 'Cancelling upload...';
      
      // Close dialog after cancellation
      Future.delayed(const Duration(milliseconds: 500), () {
        if (Get.isDialogOpen == true) {
          Get.back();
        }
      });
    }
  }

  // Validate video file before upload
  bool validateVideoFile(File videoFile) {
    print('=== Video File Validation ===');
    print('File path: ${videoFile.path}');
    print('File exists: ${videoFile.existsSync()}');
    
    // Check if file exists
    if (!videoFile.existsSync()) {
      print('ERROR: File does not exist');
      Get.snackbar(
        'Error',
        'Video file not found. Please try recording again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    // Get file size for debugging
    try {
      final fileSize = videoFile.lengthSync();
      print('File size: ${ReelUploadService.formatFileSize(fileSize)}');
      
      if (fileSize == 0) {
        print('ERROR: File is empty');
        Get.snackbar(
          'Error',
          'Video file is empty. Please try recording again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      print('ERROR getting file size: $e');
    }

    // For camera recordings, we'll be more lenient with format validation
    // Most camera apps save as MP4 or MOV regardless of extension
    print('File validation passed - assuming camera recording is valid video format');
    return true;
  }

  // Get file size in a human readable format
  Future<String> getFormattedFileSize(File file) async {
    try {
      final bytes = await file.length();
      return ReelUploadService.formatFileSize(bytes);
    } catch (e) {
      return 'Unknown size';
    }
  }

  // Check if file size is within limit
  Future<bool> isFileSizeValid(File file) async {
    try {
      final bytes = await file.length();
      final sizeInMB = bytes / (1024 * 1024);
      return sizeInMB <= 100;
    } catch (e) {
      return false;
    }
  }

  @override
  void onClose() {
    // Cancel any ongoing upload
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken!.cancel('Controller disposed');
    }
    super.onClose();
  }
}