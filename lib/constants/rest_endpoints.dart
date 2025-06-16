// lib/utils/rest_endpoints.dart

class RestConstants {
  // Base URL
  static const String baseUrl = 'https://electric-wrongly-troll.ngrok-free.app';
  
  // Endpoints
  static const String ticketsEndpoint = '/api/ticket';
  static const String favoriteTicketsEndpoint = '/api/ticket/favorites';
  static const String historyTicketsEndpoint = '/api/ticket/history';
  
  // Helper methods for constructing URLs
  static String ticketDetails(int ticketId) => '$ticketsEndpoint/$ticketId';
  static String toggleFavorite(int ticketId) => '$ticketsEndpoint/$ticketId/favorite';
  static String deleteTicket(int ticketId) => '$ticketsEndpoint/$ticketId/delete';
}