import 'dart:io';
import 'package:dio/dio.dart';
import 'package:candid/utils/dio_util.dart';
import 'package:candid/utils/rest_endpoints.dart';
import 'package:http_parser/http_parser.dart';

class ReelUploadService {
  final String reelsUrl = '${RestConstants.baseUrl}/api/v1/social/reels/';
  final Dio _dio = DioUtil.dio;

  // Upload reel with progress tracking
  Future<Response<dynamic>> uploadReel({
    required File videoFile,
    required int categoryId,
    required String caption,
    required String filterId,
    required Function(int sent, int total) onProgress,
  }) async {
    try {
      // Check file size (100MB limit)
      final fileSizeInBytes = await videoFile.length();
      final fileSizeInMB = fileSizeInBytes / (1024 * 1024);
      
      print('Video file size: ${fileSizeInMB.toStringAsFixed(2)} MB');
      
      if (fileSizeInMB > 100) {
        throw Exception('Video file size exceeds 100MB limit. Current size: ${fileSizeInMB.toStringAsFixed(2)} MB');
      }

      // Get file name and ensure it has .mp4 extension
      String fileName = videoFile.path.split('/').last;
      print('Original filename: $fileName');
      
      // If file doesn't have a proper video extension, add .mp4
      if (!fileName.toLowerCase().contains('.mp4') && 
          !fileName.toLowerCase().contains('.mov') && 
          !fileName.toLowerCase().contains('.avi') && 
          !fileName.toLowerCase().contains('.mkv')) {
        // Add timestamp to make filename unique
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        fileName = 'video_${timestamp}.mp4';
        print('Updated filename: $fileName');
      }

      print('Final filename for upload: $fileName');

      // Create multipart form data
      print('Creating multipart form data...');
      FormData formData = FormData.fromMap({
        'video': await MultipartFile.fromFile(
          videoFile.path,
          filename: fileName,
          // Explicitly set content type for video files
          contentType: MediaType('video', 'mp4'),
        ),
        'category': categoryId.toString(),
        'caption': caption,
        'filter_id': filterId,
      });

      print('Uploading reel with data:');
      print('- Video file path: ${videoFile.path}');
      print('- Video filename: $fileName');
      print('- Category ID: $categoryId');
      print('- Caption: $caption');
      print('- Filter ID: $filterId');
      print('- File size: ${fileSizeInMB.toStringAsFixed(2)} MB');

      final response = await _dio.post(
        reelsUrl,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
          },
          // Set timeout for large file uploads
          sendTimeout: Duration(minutes: 10), // 10 minutes
          receiveTimeout: Duration(minutes: 5), // 5 minutes
        ),
        onSendProgress: (sent, total) {
          print('Upload progress: ${(sent / total * 100).toStringAsFixed(1)}% ($sent/$total bytes)');
          onProgress(sent, total);
        },
      );

      print('Upload response status: ${response.statusCode}');
      print('Upload response data: ${response.data}');

      return response;
    } catch (e) {
      print('Error uploading reel: $e');
      if (e is DioException) {
        print('DioException details:');
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
        print('Request data: ${e.requestOptions.data}');
        
        // Handle specific error cases
        if (e.response?.statusCode == 413) {
          throw Exception('File too large. Please select a smaller video file.');
        } else if (e.response?.statusCode == 400) {
          final errorData = e.response?.data;
          if (errorData is Map && errorData.containsKey('message')) {
            throw Exception(errorData['message']);
          } else {
            throw Exception('Invalid request. Please check your video file and try again.');
          }
        } else if (e.response?.statusCode == 401) {
          throw Exception('Authentication failed. Please login again.');
        } else if (e.response?.statusCode == 403) {
          throw Exception('You don\'t have permission to upload reels.');
        }
      }
      rethrow;
    }
  }

  // Get user's reels
  Future<Response<dynamic>> getUserReels({int page = 1, int limit = 20}) async {
    try {
      final response = await _dio.get(
        reelsUrl,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      print('Error fetching user reels: $e');
      rethrow;
    }
  }

  // Get reel by ID
  Future<Response<dynamic>> getReelById(int reelId) async {
    try {
      final response = await _dio.get(
        '$reelsUrl$reelId/',
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      print('Error fetching reel: $e');
      rethrow;
    }
  }

  // Delete reel
  Future<Response<dynamic>> deleteReel(int reelId) async {
    try {
      final response = await _dio.delete(
        '$reelsUrl$reelId/',
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      print('Error deleting reel: $e');
      rethrow;
    }
  }

  // Helper method to validate video file
  static bool isValidVideoFile(File file) {
    // Check if file exists first
    if (!file.existsSync()) {
      print('File does not exist: ${file.path}');
      return false;
    }

    final extension = file.path.toLowerCase();
    print('Checking file: ${file.path}');
    print('File extension check: $extension');
    
    // Accept common video formats and also files without extensions (camera recordings)
    bool isValidExtension = extension.endsWith('.mp4') || 
           extension.endsWith('.mov') || 
           extension.endsWith('.avi') || 
           extension.endsWith('.mkv') ||
           extension.endsWith('.3gp') ||
           extension.endsWith('.webm') ||
           // Also accept files that might not have extensions (common with camera recordings)
           !extension.contains('.') ||
           // Accept if file name contains 'mp4' even without proper extension
           extension.contains('mp4');
    
    print('Extension validation result: $isValidExtension');
    return isValidExtension;
  }

  // Helper method to format file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}