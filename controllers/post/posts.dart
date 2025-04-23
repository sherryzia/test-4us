import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class FirebasePostController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  static const String CREATE_POST = 'createPost';
  static const String GET_POSTS = 'getPosts';
  static const String GET_POST_BY_ID = 'getPostById';
  static const String GET_COMMENT_BY_ID = 'getCommentById';
  
  // Loading states
  final RxMap<String, bool> isLoading = {
    CREATE_POST: false,
    GET_POSTS: false,
    GET_POST_BY_ID: false,
    GET_COMMENT_BY_ID: false,
  }.obs;
  
  final RxBool isSuccessful = false.obs;
  final RxString errorMessage = "".obs;
  
  // Posts data
  final RxList<Map<String, dynamic>> posts = <Map<String, dynamic>>[].obs;
  final Rx<Map<String, dynamic>?> currentPost = Rx<Map<String, dynamic>?>(null);
  final RxList<Map<String, dynamic>> comments = <Map<String, dynamic>>[].obs;
  
  // Breaking news data
  final RxList<Map<String, dynamic>> breakingNews = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Load posts and breaking news when controller initializes
    getPosts();
    getBreakingNews();
  }

  // Get all posts
  Future<void> getPosts() async {
    isLoading[GET_POSTS] = true;
    
    try {
      // Clear existing posts
      posts.clear();
      
      // Get posts from Firestore, ordered by timestamp
      final QuerySnapshot postsSnapshot = await _firestore
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .get();
      
      // Process each post
      for (var doc in postsSnapshot.docs) {
        Map<String, dynamic> postData = doc.data() as Map<String, dynamic>;
        postData['id'] = doc.id;
        
        // Get author data
        if (postData.containsKey('authorId')) {
          try {
            final authorDoc = await _firestore
                .collection('users')
                .doc(postData['authorId'])
                .get();
            
            if (authorDoc.exists) {
              Map<String, dynamic> authorData = authorDoc.data() as Map<String, dynamic>;
              postData['authorName'] = authorData['fullName'] ?? 'Unknown';
              postData['authorUsername'] = authorData['username'] ?? 'Unknown';
              postData['authorPhotoURL'] = authorData['photoURL'] ?? '';
            }
          } catch (e) {
            print('Error fetching author data: $e');
          }
        }
        
        // Add to posts list
        posts.add(postData);
      }
    } catch (e) {
      errorMessage.value = "Failed to load posts: $e";
    } finally {
      isLoading[GET_POSTS] = false;
    }
  }

  // Get breaking news
  Future<void> getBreakingNews() async {
    try {
      // Clear existing news
      breakingNews.clear();
      
      // Get breaking news from Firestore
      final QuerySnapshot newsSnapshot = await _firestore
          .collection('breaking_news')
          .orderBy('publishedAt', descending: true)
          .limit(5)
          .get();
      
      // Process each news item
      for (var doc in newsSnapshot.docs) {
        Map<String, dynamic> newsData = doc.data() as Map<String, dynamic>;
        newsData['id'] = doc.id;
        breakingNews.add(newsData);
      }
    } catch (e) {
      print('Error fetching breaking news: $e');
    }
  }

  // Get a single post by ID
  Future<void> getPostById(String postId) async {
    isLoading[GET_POST_BY_ID] = true;
    
    try {
      // Clear current post
      currentPost.value = null;
      
      // Get post from Firestore
      final DocumentSnapshot postSnapshot = await _firestore
          .collection('posts')
          .doc(postId)
          .get();
      
      if (postSnapshot.exists) {
        Map<String, dynamic> postData = postSnapshot.data() as Map<String, dynamic>;
        postData['id'] = postSnapshot.id;
        
        // Get author data
        if (postData.containsKey('authorId')) {
          try {
            final authorDoc = await _firestore
                .collection('users')
                .doc(postData['authorId'])
                .get();
            
            if (authorDoc.exists) {
              Map<String, dynamic> authorData = authorDoc.data() as Map<String, dynamic>;
              postData['authorName'] = authorData['fullName'] ?? 'Unknown';
              postData['authorUsername'] = authorData['username'] ?? 'Unknown';
              postData['authorPhotoURL'] = authorData['photoURL'] ?? '';
            }
          } catch (e) {
            print('Error fetching author data: $e');
          }
        }
        
        // Set current post
        currentPost.value = postData;
      } else {
        errorMessage.value = "Post not found";
      }
    } catch (e) {
      errorMessage.value = "Failed to load post: $e";
    } finally {
      isLoading[GET_POST_BY_ID] = false;
    }
  }

  // Get comments for a post
  Future<void> getCommentsByPostId(String postId) async {
    isLoading[GET_COMMENT_BY_ID] = true;
    
    try {
      // Clear existing comments
      comments.clear();
      
      // Get comments from Firestore
      final QuerySnapshot commentsSnapshot = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .orderBy('createdAt', descending: true)
          .get();
      
      // Process each comment
      for (var doc in commentsSnapshot.docs) {
        Map<String, dynamic> commentData = doc.data() as Map<String, dynamic>;
        commentData['id'] = doc.id;
        
        // Get commenter data
        if (commentData.containsKey('userId')) {
          try {
            final userDoc = await _firestore
                .collection('users')
                .doc(commentData['userId'])
                .get();
            
            if (userDoc.exists) {
              Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
              commentData['userName'] = userData['fullName'] ?? 'Unknown';
              commentData['userPhotoURL'] = userData['photoURL'] ?? '';
            }
          } catch (e) {
            print('Error fetching commenter data: $e');
          }
        }
        
        // Add to comments list
        comments.add(commentData);
      }
    } catch (e) {
      errorMessage.value = "Failed to load comments: $e";
    } finally {
      isLoading[GET_COMMENT_BY_ID] = false;
    }
  }

  // Create a new post
  Future<void> createPost({
    required String description,
    Uint8List? imageBytes,
  }) async {
    isLoading[CREATE_POST] = true;
    isSuccessful.value = false;
    errorMessage.value = "";
    
    try {
      final User? currentUser = _auth.currentUser;
      
      if (currentUser == null) {
        errorMessage.value = "You must be logged in to create a post";
        return;
      }
      
      // Get user data from Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();
      
      if (!userDoc.exists) {
        errorMessage.value = "User profile not found";
        return;
      }
      
      // Prepare post data
      Map<String, dynamic> postData = {
        'description': description,
        'authorId': currentUser.uid,
        'likes': 0,
        'comments': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      // Upload image if provided
      if (imageBytes != null) {
        String imageUrl = await _uploadImage(imageBytes);
        postData['imageUrl'] = imageUrl;
      }
      
      // Add post to Firestore
      DocumentReference postRef = await _firestore
          .collection('posts')
          .add(postData);
      
      // Update user's posts list
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'posts': FieldValue.arrayUnion([postRef.id])
      });
      
      isSuccessful.value = true;
      
      // Refresh posts list
      await getPosts();
    } catch (e) {
      errorMessage.value = "Failed to create post: $e";
    } finally {
      isLoading[CREATE_POST] = false;
    }
  }

  // Add a comment to a post
  Future<void> addComment(String postId, String comment) async {
    try {
      final User? currentUser = _auth.currentUser;
      
      if (currentUser == null) {
        errorMessage.value = "You must be logged in to comment";
        return;
      }
      
      // Prepare comment data
      Map<String, dynamic> commentData = {
        'content': comment,
        'userId': currentUser.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'likes': 0,
      };
      
      // Add comment to Firestore
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .add(commentData);
      
      // Increment comment count on the post
      await _firestore
          .collection('posts')
          .doc(postId)
          .update({
        'comments': FieldValue.increment(1)
      });
      
      // Refresh comments list
      await getCommentsByPostId(postId);
    } catch (e) {
      errorMessage.value = "Failed to add comment: $e";
    }
  }

  // Toggle like on a post
  Future<void> toggleLike(String postId) async {
    try {
      final User? currentUser = _auth.currentUser;
      
      if (currentUser == null) {
        errorMessage.value = "You must be logged in to like posts";
        return;
      }
      
      // Check if user already liked the post
      final likeDoc = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(currentUser.uid)
          .get();
      
      // Toggle like
      if (likeDoc.exists) {
        // Remove like
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('likes')
            .doc(currentUser.uid)
            .delete();
        
        // Decrement like count on the post
        await _firestore
            .collection('posts')
            .doc(postId)
            .update({
          'likes': FieldValue.increment(-1)
        });
      } else {
        // Add like
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('likes')
            .doc(currentUser.uid)
            .set({
          'createdAt': FieldValue.serverTimestamp()
        });
        
        // Increment like count on the post
        await _firestore
            .collection('posts')
            .doc(postId)
            .update({
          'likes': FieldValue.increment(1)
        });
      }
      
      // Refresh post data
      await getPostById(postId);
      await getPosts();
    } catch (e) {
      errorMessage.value = "Failed to toggle like: $e";
    }
  }

  // Check if current user liked a post
  Future<bool> checkIfLiked(String postId) async {
    try {
      final User? currentUser = _auth.currentUser;
      
      if (currentUser == null) {
        return false;
      }
      
      // Check if user already liked the post
      final likeDoc = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(currentUser.uid)
          .get();
      
      return likeDoc.exists;
    } catch (e) {
      return false;
    }
  }

  // Delete a post
  Future<void> deletePost(String postId) async {
    try {
      final User? currentUser = _auth.currentUser;
      
      if (currentUser == null) {
        errorMessage.value = "You must be logged in to delete posts";
        return;
      }
      
      // Get post data to check ownership
      final postDoc = await _firestore
          .collection('posts')
          .doc(postId)
          .get();
      
      if (!postDoc.exists) {
        errorMessage.value = "Post not found";
        return;
      }
      
      final postData = postDoc.data() as Map<String, dynamic>;
      
      // Check if user is the author
      if (postData['authorId'] != currentUser.uid) {
        errorMessage.value = "You can only delete your own posts";
        return;
      }
      
      // Delete post image from storage if it exists
      if (postData.containsKey('imageUrl') && postData['imageUrl'] != null) {
        try {
          final Reference ref = _storage.refFromURL(postData['imageUrl']);
          await ref.delete();
        } catch (e) {
          print('Error deleting image: $e');
        }
      }
      
      // Delete all comments
      final commentsSnapshot = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .get();
      
      for (var doc in commentsSnapshot.docs) {
        await doc.reference.delete();
      }
      
      // Delete all likes
      final likesSnapshot = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .get();
      
      for (var doc in likesSnapshot.docs) {
        await doc.reference.delete();
      }
      
      // Delete the post
      await _firestore
          .collection('posts')
          .doc(postId)
          .delete();
      
      // Remove post from user's posts list
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'posts': FieldValue.arrayRemove([postId])
      });
      
      // Refresh posts list
      await getPosts();
    } catch (e) {
      errorMessage.value = "Failed to delete post: $e";
    }
  }

  // Upload image to Firebase Storage
  Future<String> _uploadImage(Uint8List imageBytes) async {
    // Generate unique filename
    String fileName = '${Uuid().v4()}.jpg';
    
    // Create reference to the file location
    Reference storageRef = _storage.ref().child('post_images/$fileName');
    
    // Upload the file
    await storageRef.putData(
      imageBytes,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    
    // Get download URL
    String downloadUrl = await storageRef.getDownloadURL();
    
    return downloadUrl;
  }

  // Add a new breaking news item (admin function)
  Future<void> addBreakingNews({
    required String title,
    required String summary,
    required String link,
    required Uint8List imageBytes,
  }) async {
    try {
      // Upload image
      String imageUrl = await _uploadImage(imageBytes);
      
      // Prepare news data
      Map<String, dynamic> newsData = {
        'title': title,
        'summary': summary,
        'link': link,
        'imageUrl': imageUrl,
        'publishedAt': FieldValue.serverTimestamp(),
      };
      
      // Add to Firestore
      await _firestore
          .collection('breaking_news')
          .add(newsData);
      
      // Refresh news list
      await getBreakingNews();
    } catch (e) {
      errorMessage.value = "Failed to add breaking news: $e";
    }
  }
}