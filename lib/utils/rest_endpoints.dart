class RestConstants {
  static const String baseUrl = 'https://dev.app.4us.co/api/';
  static const String storageBaseUrl = 'https://dev.app.4us.co/storage/';

  static const String versionChecker = 'app-version';
  static const String login = 'login';
  static const String register = 'register';
  static const String verifyOTP = 'verify-otp';
  static const String forgotPassword = "forgot-password";
  static const String resetPassword = "reset-password";

  // General
  static const String user = "user";

// *****************   Service Provider *****************
  static const String checkServiceProviderBusinessAvailability = "sp/business";
  static const String services = "sp/services";
  static const String registerServiceProviderBusiness= "sp/business";
  static const String businessListing = "sp/business-listing";


  // *****************  Event Organizer *****************
  static const String registerEventOrganizerBusiness= "eo/business";
  static const String checkEventOrganizerBusinessAvailability = "eo/business";
  static const String eventTypes = "eo/event-types";


}
