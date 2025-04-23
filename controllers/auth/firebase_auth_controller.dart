import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseAuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  final Rx<User?> firebaseUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxBool authSuccessful = false.obs;
  final RxString errorMessage = "".obs;
  SharedPreferences? _pref;

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
    initPrefs();
  }

  Future<void> initPrefs() async {
    _pref = await SharedPreferences.getInstance();
  }

  // Email & Password Registration
  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String username,
    required String phoneNo,
  }) async {
    isLoading.value = true;
    errorMessage.value = "";
    
    try {
      // First check if username is already taken
      QuerySnapshot usernameCheck = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();
      
      if (usernameCheck.docs.isNotEmpty) {
        errorMessage.value = "Username is already taken. Please choose another.";
        isLoading.value = false;
        return;
      }
      
      // Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
      
      // Update the user profile with display name
      await userCredential.user?.updateDisplayName("$firstName $lastName");
      
      // Store user data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'userId': userCredential.user!.uid,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'fullName': '$firstName $lastName',
        'username': username,
        'phoneNo': phoneNo,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isVerified': false,
        'role': 'user',
        'photoURL': userCredential.user!.photoURL ?? '',
        'badges': [],
        'communities': [],
        'followers': [],
        'following': [],
        'challenges': [],
        'points': 0,
      });
      
      // Send email verification
      await userCredential.user?.sendEmailVerification();
      
      authSuccessful.value = true;
      
      // Save user info in SharedPreferences
      await saveUserSession(userCredential.user);
      
    } on FirebaseAuthException catch (e) {
      handleFirebaseAuthError(e);
    } catch (e) {
      errorMessage.value = "An unexpected error occurred: ${e.toString()}";
    } finally {
      isLoading.value = false;
    }
  }

  // Email & Password Login
  Future<void> login({required String email, required String password}) async {
    isLoading.value = true;
    errorMessage.value = "";
    
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      
      // Update login timestamp in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).update({
        'lastLogin': FieldValue.serverTimestamp(),
      });
      
      authSuccessful.value = true;
      
      // Save user info in SharedPreferences
      await saveUserSession(userCredential.user);
      
    } on FirebaseAuthException catch (e) {
      handleFirebaseAuthError(e);
    } catch (e) {
      errorMessage.value = "An unexpected error occurred. Please try again.";
    } finally {
      isLoading.value = false;
    }
  }

  // Google Sign In
  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    errorMessage.value = "";
    
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // User canceled the sign-in flow
        isLoading.value = false;
        return;
      }
      
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      // Sign in to Firebase with the Google credential
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      // Check if this is a new user
      bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
      
      if (isNewUser) {
        // Generate a unique username based on display name
        String baseUsername = userCredential.user!.displayName?.toLowerCase().replaceAll(' ', '') ?? 'user';
        String username = baseUsername;
        
        // Check if username exists, if so, add a random number
        QuerySnapshot usernameCheck = await _firestore
            .collection('users')
            .where('username', isEqualTo: username)
            .get();
        
        if (usernameCheck.docs.isNotEmpty) {
          username = '$baseUsername${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}';
        }
        
        // Create a new user document in Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'userId': userCredential.user!.uid,
          'email': userCredential.user!.email,
          'fullName': userCredential.user!.displayName ?? '',
          'firstName': userCredential.user!.displayName?.split(' ').first ?? '',
          'lastName': (userCredential.user!.displayName?.split(' ').length ?? 1) > 1
                      ? userCredential.user!.displayName?.split(' ').last ?? '' 
                      : '',
          'username': username,
          'phoneNo': userCredential.user!.phoneNumber ?? '',
          'photoURL': userCredential.user!.photoURL ?? '',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
          'isVerified': userCredential.user!.emailVerified,
          'role': 'user',
          'badges': [],
          'communities': [],
          'followers': [],
          'following': [],
          'challenges': [],
          'points': 0,
          'signInMethod': 'google',
        });
      } else {
        // Update existing user's login timestamp
        await _firestore.collection('users').doc(userCredential.user!.uid).update({
          'lastLogin': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'photoURL': userCredential.user!.photoURL ?? '',
        });
      }
      
      authSuccessful.value = true;
      
      // Save user info in SharedPreferences
      await saveUserSession(userCredential.user);
      
    } catch (e) {
      errorMessage.value = "Failed to sign in with Google: ${e.toString()}";
    } finally {
      isLoading.value = false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      // Update last logout timestamp in Firestore
      if (_auth.currentUser != null) {
        await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
          'lastLogout': FieldValue.serverTimestamp(),
        });
      }
      
      await _googleSignIn.signOut(); // Sign out from Google
      await _auth.signOut(); // Sign out from Firebase
      clearUserSession();
    } catch (e) {
      errorMessage.value = "Failed to sign out. Please try again.";
    }
  }

  // Fetch current user data from Firestore
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    try {
      if (_auth.currentUser == null) return null;
      
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
      
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      errorMessage.value = "Failed to fetch user data: ${e.toString()}";
      return null;
    }
  }

  // Update user profile in Firestore
  Future<bool> updateUserProfile({
    String? firstName,
    String? lastName,
    String? phoneNo,
    String? username,
    String? photoURL,
  }) async {
    try {
      if (_auth.currentUser == null) return false;
      
      Map<String, dynamic> updateData = {};
      
      if (firstName != null) updateData['firstName'] = firstName;
      if (lastName != null) updateData['lastName'] = lastName;
      if (firstName != null || lastName != null) {
        updateData['fullName'] = '${firstName ?? ''} ${lastName ?? ''}'.trim();
      }
      if (phoneNo != null) updateData['phoneNo'] = phoneNo;
      if (photoURL != null) updateData['photoURL'] = photoURL;
      
      // Check if username is being updated and is unique
      if (username != null) {
        QuerySnapshot usernameCheck = await _firestore
            .collection('users')
            .where('username', isEqualTo: username)
            .where(FieldPath.documentId, isNotEqualTo: _auth.currentUser!.uid)
            .get();
        
        if (usernameCheck.docs.isNotEmpty) {
          errorMessage.value = "Username is already taken. Please choose another.";
          return false;
        }
        
        updateData['username'] = username;
      }
      
      updateData['updatedAt'] = FieldValue.serverTimestamp();
      
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update(updateData);
      
      return true;
    } catch (e) {
      errorMessage.value = "Failed to update profile: ${e.toString()}";
      return false;
    }
  }

  // Password Reset (no changes needed)
  Future<void> resetPassword(String email) async {
    isLoading.value = true;
    errorMessage.value = "";
    
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      handleFirebaseAuthError(e);
    } catch (e) {
      errorMessage.value = "Failed to send password reset email. Please try again.";
    } finally {
      isLoading.value = false;
    }
  }

  // Error Handler (no changes needed)
  void handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        errorMessage.value = "No user found with this email.";
        break;
      case 'wrong-password':
        errorMessage.value = "Incorrect password. Please try again.";
        break;
      case 'email-already-in-use':
        errorMessage.value = "Email already in use. Try signing in or use a different email.";
        break;
      case 'weak-password':
        errorMessage.value = "Password is too weak. Please use a stronger password.";
        break;
      case 'invalid-email':
        errorMessage.value = "Invalid email address. Please check your email.";
        break;
      case 'account-exists-with-different-credential':
        errorMessage.value = "An account already exists with the same email but different sign-in credentials.";
        break;
      case 'invalid-credential':
        errorMessage.value = "The credential provided is invalid. Please try again.";
        break;
      case 'operation-not-allowed':
        errorMessage.value = "This operation is not allowed. Contact support.";
        break;
      case 'user-disabled':
        errorMessage.value = "This user account has been disabled.";
        break;
      case 'too-many-requests':
        errorMessage.value = "Too many unsuccessful login attempts. Please try again later.";
        break;
      default:
        errorMessage.value = "Authentication failed: ${e.message}";
    }
  }

  // Save user session data (no changes needed)
  Future<void> saveUserSession(User? user) async {
    if (user != null && _pref != null) {
      await _pref!.setString('userId', user.uid);
      await _pref!.setString('email', user.email ?? '');
      await _pref!.setString('displayName', user.displayName ?? '');
      await _pref!.setString('photoURL', user.photoURL ?? '');
      await _pref!.setBool('isLoggedIn', true);
    }
  }

  // Clear user session data (no changes needed)
  Future<void> clearUserSession() async {
    if (_pref != null) {
      await _pref!.remove('userId');
      await _pref!.remove('email');
      await _pref!.remove('displayName');
      await _pref!.remove('photoURL');
      await _pref!.setBool('isLoggedIn', false);
    }
  }

  // Check if user is logged in (no changes needed)
  bool isLoggedIn() {
    return _pref?.getBool('isLoggedIn') ?? false;
  }

  // Get user ID (no changes needed)
  String get userId => _pref?.getString('userId') ?? '';

  // Get current user (no changes needed)
  User? get currentUser => _auth.currentUser;
}