import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomanga/controllers/controllers.dart';
import 'package:ecomanga/controllers/post/posts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class SocialPostScreen extends StatefulWidget {
  final String image;
  final String tag;
  final String profileImg;
  final String postId;

  const SocialPostScreen({
    super.key,
    required this.image,
    required this.profileImg,
    required this.tag,
    required this.postId,
  });

  @override
  State<SocialPostScreen> createState() => _SocialPostScreenState();
}

class _SocialPostScreenState extends State<SocialPostScreen> {
  final TextEditingController _commentController = TextEditingController();
  final RxBool _isSubmittingComment = false.obs;

  @override
  void initState() {
    super.initState();
    // Load post details and comments
    _loadPostData();
  }

  Future<void> _loadPostData() async {
    await Controllers.posts.getPostById(widget.postId);
    await Controllers.posts.getCommentsByPostId(widget.postId);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text("Post"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Main content in a scrollable area
              Expanded(
                child: Obx(() {
                  final post = Controllers.posts.currentPost.value;
                  final isLoading = Controllers.posts.isLoading[FirebasePostController.GET_POST_BY_ID] ?? false;
                  
                  if (isLoading || post == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPostHeader(post),
                        _buildPostContent(post),
                        _buildPostImage(),
                        _buildPostActions(post),
                        const Divider(thickness: 1),
                        _buildCommentsList(),
                      ],
                    ),
                  );
                }),
              ),
              
              // Comment input section at the bottom
              _buildCommentInputSection(),
            ],
          ),
        ),
      ),
    );
  }

  // Post Header with Author Info
  Widget _buildPostHeader(Map<String, dynamic> post) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(
          post['authorPhotoURL'] ?? widget.profileImg,
        ),
      ),
      title: Text(
        post['authorName'] ?? 'Unknown',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        post['createdAt'] != null 
            ? _formatPostDate(post['createdAt'])
            : "Recent",
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      ),
      trailing: _buildPostMenu(post),
    );
  }

  // Post Content (Text)
  Widget _buildPostContent(Map<String, dynamic> post) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(
        post['description'] ?? '',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  // Post Image
  Widget _buildPostImage() {
    return Hero(
      tag: widget.tag,
      child: Container(
        width: double.infinity,
        height: 200,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: CachedNetworkImage(
          imageUrl: widget.image,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey[300],
            child: const Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[300],
            child: const Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  // Post Actions (Like, Comment, Share)
  Widget _buildPostActions(Map<String, dynamic> post) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          _buildLikeButton(post),
          const SizedBox(width: 16),
          Icon(Icons.comment_outlined, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '${post['comments'] ?? 0}',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            color: Colors.grey[600],
            onPressed: _sharePost,
          ),
        ],
      ),
    );
  }

  // Like Button
  Widget _buildLikeButton(Map<String, dynamic> post) {
    return FutureBuilder<bool>(
      future: Controllers.posts.checkIfLiked(post['id']),
      builder: (context, snapshot) {
        final bool isLiked = snapshot.data ?? false;
        
        return Row(
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                Controllers.posts.toggleLike(post['id']);
              },
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border_outlined,
                color: isLiked ? Colors.red : Colors.grey[600],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${post['likes'] ?? 0}',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        );
      },
    );
  }

  // Comments List
  Widget _buildCommentsList() {
    return Obx(() {
      final comments = Controllers.posts.comments;
      final isLoading = Controllers.posts.isLoading[FirebasePostController.GET_COMMENT_BY_ID] ?? false;
      
      if (isLoading) {
        return const SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        );
      }
      
      if (comments.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Center(
            child: Text(
              "No comments yet. Be the first to comment!",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        );
      }
      
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: comments.length,
        itemBuilder: (context, index) {
          final comment = comments[index];
          return _buildCommentItem(comment);
        },
      );
    });
  }

  // Individual Comment Item
  Widget _buildCommentItem(Map<String, dynamic> comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
              comment['userPhotoURL'] ?? 'https://via.placeholder.com/150',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment['userName'] ?? 'Unknown',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        comment['content'] ?? '',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                  child: Row(
                    children: [
                      Text(
                        comment['createdAt'] != null
                            ? _formatCommentDate(comment['createdAt'])
                            : 'Just now',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Like',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Reply',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Comment Input Section
  Widget _buildCommentInputSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
              Controllers.global.profileImageUrl,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Write a comment...',
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (value) => _submitComment(),
            ),
          ),
          const SizedBox(width: 8),
          Obx(() => IconButton(
            onPressed: _isSubmittingComment.value ? null : _submitComment,
            icon: _isSubmittingComment.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send, color: Colors.green),
          )),
        ],
      ),
    );
  }

  // Post Menu (Delete, Report)
  Widget _buildPostMenu(Map<String, dynamic> post) {
    final currentUser = Controllers.auth.currentUser;
    final isAuthor = currentUser != null && post['authorId'] == currentUser.uid;
    
    if (!isAuthor) {
      return IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () {
          _showReportDialog();
        },
      );
    }
    
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        if (value == 'delete') {
          _showDeleteConfirmation(post);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem<String>(
          value: 'delete',
          child: Text('Delete'),
        ),
        const PopupMenuItem<String>(
          value: 'edit',
          child: Text('Edit'),
        ),
      ],
    );
  }

  // Submit Comment
  Future<void> _submitComment() async {
    final comment = _commentController.text.trim();
    if (comment.isEmpty) return;
    
    _isSubmittingComment.value = true;
    
    try {
      await Controllers.posts.addComment(widget.postId, comment);
      _commentController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post comment: $e')),
      );
    } finally {
      _isSubmittingComment.value = false;
    }
  }

  // Delete Confirmation Dialog
  void _showDeleteConfirmation(Map<String, dynamic> post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await Controllers.posts.deletePost(post['id']);
              Navigator.of(context).pop(); // Return to previous screen
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Report Dialog
  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Post'),
        content: const Text('Why are you reporting this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Post reported')),
              );
            },
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }

  // Share Post
  void _sharePost() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing not implemented yet')),
    );
  }

  // Format Post Date
  String _formatPostDate(dynamic timestamp) {
    if (timestamp is! Timestamp) return "Recent";
    
    final date = timestamp.toDate();
    return timeago.format(date);
  }

  // Format Comment Date
  String _formatCommentDate(dynamic timestamp) {
    if (timestamp is! Timestamp) return "Just now";
    
    final date = timestamp.toDate();
    return timeago.format(date, locale: 'en_short');
  }
}