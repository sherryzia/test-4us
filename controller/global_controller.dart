// lib/controller/global_controller.dart

import 'package:get/get.dart';
import 'package:restaurant_finder/model/session_model.dart';
import 'package:restaurant_finder/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GlobalController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  
  // User data
  var userId = ''.obs;
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userPhoneNumber = ''.obs;
  var isAuthenticated = false.obs;
  
  // Session model
  Rxn<SessionModel> currentSession = Rxn<SessionModel>();
  
  // Initialize controller and check for existing session
  @override
  void onInit() {
    super.onInit();
    checkAndLoadSession();
  }
  
  // Check for existing session and load user data
  Future<void> checkAndLoadSession() async {
    try {
      final Session? session = supabase.auth.currentSession;
      
      if (session != null) {
        // Set user ID
        userId.value = session.user.id;
        isAuthenticated.value = true;
        
        // Fetch and load user data
        await fetchUserData();
        
        // Create session model
        if (isAuthenticated.value) {
          currentSession.value = SessionModel(
            sessionId: session.user.id,
            accessToken: session.accessToken,
            refreshToken: session.refreshToken,
            expiresAt: session.expiresAt != null 
                ? DateTime.fromMillisecondsSinceEpoch(session.expiresAt! * 1000)
                : null,
            user: UserModel(
              id: userId.value,
              name: userName.value,
              email: userEmail.value,
              phoneNumber: userPhoneNumber.value,
            ),
          );
        }
      } else {
        clearUserData();
      }
    } catch (e) {
      print("Error in GlobalController.checkAndLoadSession: $e");
      clearUserData();
    }
  }
  
  // Fetch user data from database
  Future<void> fetchUserData() async {
    try {
      if (userId.value.isEmpty) return;
      
      final userData = await supabase
          .from('users')
          .select()
          .eq('id', userId.value)
          .single();
      
      if (userData != null) {
        // Update controller with user data
        userName.value = userData['name'] ?? '';
        userEmail.value = userData['email'] ?? '';
        userPhoneNumber.value = userData['phone_number'] ?? '';
        
        print("User data loaded in GlobalController:");
        printUserData();
      }
    } catch (e) {
      print("Error fetching user data in GlobalController: $e");
    }
  }
  
  // Get current session model
  SessionModel? getSessionModel() {
    return currentSession.value;
  }
  
  // Check if session is valid
  bool isSessionValid() {
    return currentSession.value?.isValid ?? false;
  }
  
  // Update user data after profile update
  Future<void> updateUserData(UserModel updatedUser) async {
    userName.value = updatedUser.name;
    userEmail.value = updatedUser.email;
    userPhoneNumber.value = updatedUser.phoneNumber;
  }
  
  // Clear user data on logout
  void clearUserData() {
    userId.value = '';
    userName.value = '';
    userEmail.value = '';
    userPhoneNumber.value = '';
    currentSession.value = null;
    isAuthenticated.value = false;
  }
  
  // Print user data (for debugging)
  void printUserData() {
    print("User ID: ${userId.value}");
    print("User Name: ${userName.value}");
    print("User Email: ${userEmail.value}");
    print("User Phone: ${userPhoneNumber.value}");
    print("Is Authenticated: ${isAuthenticated.value}");
    print("Session Valid: ${isSessionValid()}");
    print("Session Expires: ${currentSession.value?.expiresAt}");
  }
}