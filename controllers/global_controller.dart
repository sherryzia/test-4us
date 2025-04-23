import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalController extends GetxController {
  static GlobalController get to => Get.find();
  
  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // User data
  final Rx<User?> firebaseUser = Rx<User?>(null);
  final Rx<Map<String, dynamic>> userData = Rx<Map<String, dynamic>>({});
  final RxBool isUserLoading = false.obs;
  
  // App state
  final RxBool isAppReady = false.obs;
  final RxString errorMessage = "".obs;
  
  // Session
  SharedPreferences? _prefs;
  
  @override
  void onInit() {
    super.onInit();
    // Initialize prefs and set up auth state listener
    _initSession();
  }
  
  Future<void> _initSession() async {
    // Initialize SharedPreferences
    _prefs = await SharedPreferences.getInstance();
    
    // Set up listener for authentication state changes
    firebaseUser.bindStream(_auth.authStateChanges());
    
    // When auth state changes, update user data
    ever(firebaseUser, _handleAuthChanged);
    
    // Mark app as ready
    isAppReady.value = true;
  }
  
  // Handle auth state changes
  void _handleAuthChanged(User? user) async {
    if (user == null) {
      // User signed out
      userData.value = {};
      
      // Clear stored session if it exists
      if (_prefs?.getBool('isLoggedIn') ?? false) {
        await clearUserSession();
      }
    } else {
      // User signed in, fetch and store their data
      await refreshUserData();
    }
  }
  
  // Fetch latest user data from Firestore and update local storage
  Future<void> refreshUserData() async {
    if (firebaseUser.value == null) return;
    
    isUserLoading.value = true;
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(firebaseUser.value!.uid)
          .get();
      
      if (doc.exists) {
        // Update the local user data
        userData.value = doc.data() as Map<String, dynamic>;
        
        // Save to SharedPreferences
        await saveUserSession();
      }
    } catch (e) {
      errorMessage.value = "Failed to fetch user data: $e";
    } finally {
      isUserLoading.value = false;
    }
  }
  
  // Save user session data to SharedPreferences
  Future<void> saveUserSession() async {
    if (_prefs == null || firebaseUser.value == null) return;
    
    try {
      await _prefs!.setString('userId', firebaseUser.value!.uid);
      await _prefs!.setString('email', firebaseUser.value!.email ?? '');
      await _prefs!.setString('displayName', firebaseUser.value!.displayName ?? '');
      await _prefs!.setString('photoURL', firebaseUser.value!.photoURL ?? '');
      
      // Store user role
      await _prefs!.setString('role', userData.value['role'] ?? 'user');
      
      // Store username
      await _prefs!.setString('username', userData.value['username'] ?? '');
      
      // Mark as logged in
      await _prefs!.setBool('isLoggedIn', true);
      
      // Store last login timestamp
      await _prefs!.setString('lastLogin', DateTime.now().toIso8601String());
    } catch (e) {
      print("Error saving session: $e");
    }
  }
  
  // Clear user session data from SharedPreferences
  Future<void> clearUserSession() async {
    if (_prefs == null) return;
    
    try {
      await _prefs!.remove('userId');
      await _prefs!.remove('email');
      await _prefs!.remove('displayName');
      await _prefs!.remove('photoURL');
      await _prefs!.remove('role');
      await _prefs!.remove('username');
      await _prefs!.remove('lastLogin');
      await _prefs!.setBool('isLoggedIn', false);
    } catch (e) {
      print("Error clearing session: $e");
    }
  }
  
  // Check if the user is logged in
  bool checkIfLoggedIn() {
    final isLoggedIn = _prefs?.getBool('isLoggedIn') ?? false;
    final userId = _prefs?.getString('userId') ?? '';
    
    // Check if logged in according to prefs AND Firebase auth state
    return isLoggedIn && userId.isNotEmpty && firebaseUser.value != null;
  }
  
  // Check if session is expired (optional, based on your requirements)
  bool isSessionExpired() {
    final lastLoginStr = _prefs?.getString('lastLogin');
    if (lastLoginStr == null) return true;
    
    try {
      final lastLogin = DateTime.parse(lastLoginStr);
      final now = DateTime.now();
      
      // Example: Session expires after 30 days
      return now.difference(lastLogin).inDays > 30;
    } catch (e) {
      return true;
    }
  }
  
  // Get username from session
  String get username => userData.value['username'] ?? _prefs?.getString('username') ?? '';
  
  // Get user role from session
  String get userRole => userData.value['role'] ?? _prefs?.getString('role') ?? 'user';
  
  // Get full name
  String get fullName => userData.value['fullName'] ?? firebaseUser.value?.displayName ?? '';
  
  // Get profile image URL
  String get profileImageUrl => userData.value['photoURL'] ?? firebaseUser.value?.photoURL ?? '';
  
  // Get user points
  int get userPoints => userData.value['points'] ?? 0;
  
  // Check if user is admin
  bool get isAdmin => userRole == 'admin';
  
  // Check if email is verified
  bool get isEmailVerified => firebaseUser.value?.emailVerified ?? false;
}
