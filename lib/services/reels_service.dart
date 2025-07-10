import 'package:dio/dio.dart';
import 'package:candid/utils/dio_util.dart';
import 'package:candid/utils/rest_endpoints.dart';

class ReelsService {
  final String reelsUrl = '/api/v1/social/reels/';
  final String usersUrl = '/api/v1/authentication/users/';
  final Dio _dio = DioUtil.dio;

  // Get reels with pagination and filtering
  Future<Response<dynamic>> getReels({
    int? category,
    int? createdBy,
    String? ordering,
    int page = 1,
    int size = 10,
    String? search,
  }) async {
    try {
      Map<String, dynamic> queryParams = {
        'page': page,
        'size': size,
      };

      if (category != null) queryParams['category'] = category;
      if (createdBy != null) queryParams['created_by'] = createdBy;
      if (ordering != null) queryParams['ordering'] = ordering;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      print('Fetching reels with params: $queryParams');

      final response = await _dio.get(
        reelsUrl,
        queryParameters: queryParams,
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      print('Reels response status: ${response.statusCode}');
      print('Reels response data: ${response.data}');

      return response;
    } catch (e) {
      print('Error fetching reels: $e');
      rethrow;
    }
  }

  // Get user details by ID - Updated to match your API format
  Future<Response<dynamic>> getUserById(int userId) async {
    try {
      print('Fetching user data for ID: $userId');
      final response = await _dio.get(
        '$usersUrl$userId',  // Remove trailing slash to match your API format
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      print('User response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('User data for ID $userId: ${response.data['name']}');
      }
      return response;
    } catch (e) {
      print('Error fetching user $userId: $e');
      if (e is DioException) {
        print('DioException details:');
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
        print('Request URL: ${e.requestOptions.uri}');
      }
      rethrow;
    }
  }

  // Get multiple users by IDs - Improved error handling
  Future<Map<int, Map<String, dynamic>>> getUsersByIds(List<int> userIds) async {
    Map<int, Map<String, dynamic>> users = {};
    
    print('Fetching ${userIds.length} users...');
    
    // Fetch users individually with proper error handling
    for (int userId in userIds) {
      try {
        final userResponse = await getUserById(userId);
        if (userResponse.statusCode == 200 && userResponse.data != null) {
          users[userId] = userResponse.data;
          print('Successfully fetched user $userId: ${userResponse.data['name']}');
        } else {
          print('Failed to fetch user $userId: Status ${userResponse.statusCode}');
        }
      } catch (e) {
        print('Error fetching user $userId: $e');
        // Continue with other users even if one fails
      }
      
      // Add a small delay to avoid overwhelming the API
      await Future.delayed(Duration(milliseconds: 100));
    }
    
    print('Successfully fetched ${users.length} out of ${userIds.length} users');
    return users;
  }

  // Alternative batch user fetching method (if your API supports it)
  Future<Map<int, Map<String, dynamic>>> getUsersByIdsBatch(List<int> userIds) async {
    Map<int, Map<String, dynamic>> users = {};
    
    try {
      // If your API supports batch user fetching, use this approach
      final response = await _dio.get(
        usersUrl,
        queryParameters: {
          'ids': userIds.join(','), // Adjust based on your API
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          for (var user in data) {
            if (user['id'] != null) {
              users[user['id']] = user;
            }
          }
        } else if (data['results'] is List) {
          for (var user in data['results']) {
            if (user['id'] != null) {
              users[user['id']] = user;
            }
          }
        }
      }
    } catch (e) {
      print('Batch user fetch failed, falling back to individual requests: $e');
      // Fallback to individual requests
      return await getUsersByIds(userIds);
    }
    
    return users;
  }

  // Like a reel
  Future<Response<dynamic>> likeReel(int reelId) async {
    try {
      final response = await _dio.post(
        '$reelsUrl$reelId/like/',
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      print('Error liking reel $reelId: $e');
      rethrow;
    }
  }

  // Unlike a reel
  Future<Response<dynamic>> unlikeReel(int reelId) async {
    try {
      final response = await _dio.delete(
        '$reelsUrl$reelId/like/',
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      print('Error unliking reel $reelId: $e');
      rethrow;
    }
  }

  // View a reel (track views)
  Future<Response<dynamic>> viewReel(int reelId) async {
    try {
      final response = await _dio.post(
        '$reelsUrl$reelId/view/',
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );
      return response;
    } catch (e) {
      print('Error viewing reel $reelId: $e');
      rethrow;
    }
  }

  // Get detailed reel information including user and category data
  Future<Response<dynamic>> getReelWithDetails(int reelId) async {
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
      print('Error fetching reel details $reelId: $e');
      rethrow;
    }
  }

  // Helper method to validate user data structure
  bool isValidUserData(Map<String, dynamic> userData) {
    return userData.containsKey('id') && 
           userData.containsKey('name') && 
           userData['name'] != null;
  }

  // Helper method to get user display name safely
  String getUserDisplayName(Map<String, dynamic> user) {
    final name = user['name']?.toString().trim() ?? '';
    if (name.isNotEmpty) {
      return name;
    }

    final firstName = user['first_name']?.toString().trim() ?? '';
    final lastName = user['last_name']?.toString().trim() ?? '';
    
    if (firstName.isNotEmpty) {
      return firstName + (lastName.isNotEmpty ? ' ${lastName[0]}.' : '');
    }

    final username = user['username']?.toString().trim() ?? '';
    if (username.isNotEmpty) {
      return username;
    }

    return 'User ${user['id'] ?? 'Unknown'}';
  }
}