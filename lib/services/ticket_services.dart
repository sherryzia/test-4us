// lib/services/ticket_service.dart

import 'dart:io';
import 'package:betting_app/services/auth_service.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:betting_app/utils/dio_util.dart';
import 'package:betting_app/constants/rest_endpoints.dart';

class TicketService extends GetxService {
  
  // Upload a new ticket
  // lib/services/ticket_service.dart

Future<Map<String, dynamic>> uploadTicket(File imageFile, {int? ticketId}) async {
  try {
    // Debug logs
    print("Image file path: ${imageFile.path}");
    print("Image file exists: ${imageFile.existsSync()}");
    print("Image file size: ${await imageFile.length()} bytes");
    
    // Create form data with the correct parameter name
    dio.FormData formData = dio.FormData.fromMap({
      'ticket_image': await dio.MultipartFile.fromFile(
        imageFile.path, 
        filename: imageFile.path.split('/').last
      ),
      // Include ticket_id if it's a re-upload
      if (ticketId != null) 'ticket_id': ticketId.toString(),
    });
    
    // Make request
    final response = await DioUtil.dio.post(
      RestConstants.ticketsEndpoint,
      data: formData,
      options: dio.Options(
        contentType: 'multipart/form-data',
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Get.find<AuthService>().token}',
        },
      ),
    );
    
    // Return response data
    return response.data;
  } catch (e) {
    print("Upload ticket error: $e");
    // Error will be handled by DioUtil
    rethrow;
  }
}
  
  // Get all tickets (paginated)
  Future<Map<String, dynamic>> getTickets({int page = 1}) async {
    try {
      final response = await DioUtil.dio.get(
        '${RestConstants.ticketsEndpoint}?page=$page',
      );
      
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
  
  // Get ticket history (paginated)
  Future<Map<String, dynamic>> getTicketHistory({int page = 1}) async {
    try {
      final response = await DioUtil.dio.get(
        '${RestConstants.historyTicketsEndpoint}?page=$page',
      );
      
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
  
  // Get favorite tickets
  Future<Map<String, dynamic>> getFavoriteTickets({int page = 1}) async {
    try {
      final response = await DioUtil.dio.get(
        '${RestConstants.favoriteTicketsEndpoint}?page=$page',
      );
      
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
  


  Future<Map<String, dynamic>> clearHistory() async {
  try {
    final response = await DioUtil.dio.request(
      '/api/ticket/clear-history',
      options: dio.Options(
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-api-key': '',
        },
      ),
    );
    
    if (response.statusCode == 200) {
      return {
        'success': true,
        'message': 'History cleared successfully',
        'data': response.data
      };
    } else {
      return {
        'success': false,
        'message': response.data['message'] ?? 'Failed to clear history',
        'data': response.data
      };
    }
  } catch (e) {
    print("Error clearing history: $e");
    return {
      'success': false,
      'message': 'An error occurred while clearing history',
      'data': null
    };
  }
}
  // Get ticket details
  Future<Map<String, dynamic>> getTicketDetails(int ticketId) async {
    try {
      final response = await DioUtil.dio.get(
        RestConstants.ticketDetails(ticketId),
      );
      
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
  
  // Toggle favorite status
  Future<Map<String, dynamic>> toggleFavorite(int ticketId) async {
    try {
      final response = await DioUtil.dio.post(
        RestConstants.toggleFavorite(ticketId),
      );
      
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
  
  // Delete ticket
  Future<Map<String, dynamic>> deleteTicket(int ticketId) async {
    try {
      final response = await DioUtil.dio.get(
        RestConstants.deleteTicket(ticketId),
      );
      
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}