// lib/controllers/ticket_controller.dart

import 'dart:io';
import 'package:betting_app/services/ticket_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TicketController extends GetxController {
  final TicketService _ticketService = TicketService();
  
  // Reactive variables
  final RxBool isLoading = false.obs;
  final RxList tickets = [].obs;
  final RxList favoriteTickets = [].obs;
  final RxList historyTickets = [].obs;
  final Rx<Map<String, dynamic>> selectedTicket = Rx<Map<String, dynamic>>({});
  
  // Pagination variables
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxBool hasMorePages = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchTickets();
  }
  // lib/controllers/ticket_controller.dart
void refreshControllerOnUserUpdate() {
  // Make sure to call this when needed
  update();
}
// Update the uploadTicket method to handle ticket ID
Future<void> uploadTicket(File imageFile, {int? ticketId}) async {
  try {
    isLoading.value = true;
    
    final result = await _ticketService.uploadTicket(imageFile, ticketId: ticketId);
    
    // Show success message
    Get.snackbar(
      'Success', 
      ticketId == null 
          ? 'Ticket uploaded successfully' 
          : 'Ticket re-uploaded successfully'
    );
    
    // If it's a re-upload, update the ticket details
    if (ticketId != null) {
      getTicketDetails(ticketId);
    } else {
      // If it's a new upload, refresh tickets list
      fetchTickets();
    }
    
  } catch (e) {
    print("Error in uploadTicket: $e");
    Get.snackbar('Error', 'Failed to upload ticket');
  } finally {
    isLoading.value = false;
  }
}
  // Fetch all tickets
  Future<void> fetchTickets({int page = 1}) async {
    try {
      isLoading.value = true;
      
      final result = await _ticketService.getTickets(page: page);
      
      // Update tickets list
      if (page == 1) {
        tickets.value = result['data'];
      } else {
        tickets.addAll(result['data']);
      }
      
      // Update pagination info
      currentPage.value = result['meta']['current_page'];
      totalPages.value = result['meta']['last_page'];
      hasMorePages.value = currentPage.value < totalPages.value;
      
    } catch (e) {
      Get.snackbar('Error', 'Failed to load tickets');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Load more tickets (pagination)
  Future<void> loadMoreTickets() async {
    if (hasMorePages.value && !isLoading.value) {
      await fetchTickets(page: currentPage.value + 1);
    }
  }
  
  // Fetch favorite tickets
  Future<void> fetchFavoriteTickets({int page = 1}) async {
    try {
      isLoading.value = true;
      
      final result = await _ticketService.getFavoriteTickets(page: page);
      
      // Update favorites list
      if (page == 1) {
        favoriteTickets.value = result['data'];
      } else {
        favoriteTickets.addAll(result['data']);
      }
      
    } catch (e) {
      Get.snackbar('Error', 'Failed to load favorite tickets');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Fetch ticket history
  Future<void> fetchTicketHistory({int page = 1}) async {
    try {
      isLoading.value = true;
      
      final result = await _ticketService.getTicketHistory(page: page);
      
      // Update history list
      if (page == 1) {
        historyTickets.value = result['data'];
      } else {
        historyTickets.addAll(result['data']);
      }
      
    } catch (e) {
      Get.snackbar('Error', 'Failed to load ticket history');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Get ticket details
  Future<void> getTicketDetails(int ticketId) async {
    try {
      isLoading.value = true;
      
      final result = await _ticketService.getTicketDetails(ticketId);
      
      // Update selected ticket
      selectedTicket.value = result;
      
    } catch (e) {
      Get.snackbar('Error', 'Failed to load ticket details');
    } finally {
      isLoading.value = false;
    }
  }
  

  Future<void> clearHistory() async {
  try {
    isLoading.value = true;
    
    final result = await _ticketService.clearHistory();
    
    if (result['success']) {
      // Clear local history lists
      historyTickets.clear();
      
      Get.snackbar(
        'Success',
        'History cleared successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Error',
        result['message'],
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    Get.snackbar(
      'Error',
      'An unexpected error occurred',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    isLoading.value = false;
  }
}
  // Toggle favorite status
  Future<void> toggleFavorite(int ticketId) async {
    try {
      await _ticketService.toggleFavorite(ticketId);
      
      // Update UI - Find and update the ticket in all lists
      _updateTicketFavoriteStatus(ticketId);
      
      Get.snackbar('Success', 'Favorite status updated');
      
    } catch (e) {
      Get.snackbar('Error', 'Failed to update favorite status');
    }
  }
  
  // Helper method to update ticket favorite status in all lists
  void _updateTicketFavoriteStatus(int ticketId) {
    // Update in main tickets list
    final ticketIndex = tickets.indexWhere((ticket) => ticket['id'] == ticketId);
    if (ticketIndex != -1) {
      final updatedTicket = Map<String, dynamic>.from(tickets[ticketIndex]);
      updatedTicket['is_favorite'] = !updatedTicket['is_favorite'];
      tickets[ticketIndex] = updatedTicket;
    }
    
    // Update in favorites list - remove if it was a favorite
    final favIndex = favoriteTickets.indexWhere((ticket) => ticket['id'] == ticketId);
    if (favIndex != -1) {
      favoriteTickets.removeAt(favIndex);
    }
    
    // Update in history list
    final historyIndex = historyTickets.indexWhere((ticket) => ticket['id'] == ticketId);
    if (historyIndex != -1) {
      final updatedTicket = Map<String, dynamic>.from(historyTickets[historyIndex]);
      updatedTicket['is_favorite'] = !updatedTicket['is_favorite'];
      historyTickets[historyIndex] = updatedTicket;
    }
    
    // Update selected ticket if it's the same
    if (selectedTicket.value['ticket'] != null && 
        selectedTicket.value['ticket']['id'] == ticketId) {
      final updatedTicket = Map<String, dynamic>.from(selectedTicket.value);
      updatedTicket['ticket']['is_favorite'] = !updatedTicket['ticket']['is_favorite'];
      selectedTicket.value = updatedTicket;
    }
  }
  
  // Delete ticket
  Future<void> deleteTicket(int ticketId) async {
    try {
      await _ticketService.deleteTicket(ticketId);
      
      // Remove from all lists
      tickets.removeWhere((ticket) => ticket['id'] == ticketId);
      favoriteTickets.removeWhere((ticket) => ticket['id'] == ticketId);
      historyTickets.removeWhere((ticket) => ticket['id'] == ticketId);
      
      Get.snackbar('Success', 'Ticket deleted successfully');
      
      // If we were viewing this ticket, go back
      if (selectedTicket.value['ticket'] != null && 
          selectedTicket.value['ticket']['id'] == ticketId) {
        Get.back();
      }
      
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete ticket');
    }
  }
}