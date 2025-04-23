import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecomanga/common/buttons/dynamic_button.dart';
import 'package:ecomanga/common/buttons/scale_button.dart';
import 'package:ecomanga/controllers/controllers.dart';
import 'package:ecomanga/controllers/post/posts.dart';
import 'package:ecomanga/features/home/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _descriptionController = TextEditingController();
  Uint8List? _imageBytes;
  String? _imageName;
  final RxBool _isImageSelected = false.obs;
  final RxBool _isProcessing = false.obs;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Create post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildUserInfoSection(),
            SizedBox(height: 20.h),
            _buildDescriptionTextField(),
            SizedBox(height: 20.h),
            _buildImageSection(),
            const Spacer(),
            _buildPostButton(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            ),
          ],
        ),
      ),
    );
  }

  // User Info Section
  Widget _buildUserInfoSection() {
    return Obx(() {
      // Get current user from Firebase Auth
      final currentUser = Controllers.auth.currentUser;
      
      // Get display name and photo URL
      final displayName = currentUser?.displayName ?? "Anonymous";
      final photoURL = currentUser?.photoURL ?? "https://via.placeholder.com/150";
      
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[300],
            backgroundImage: NetworkImage(photoURL),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                displayName,
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 16.sp
                ),
              ),
              Text(
                'Public',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  // Description Text Field
  Widget _buildDescriptionTextField() {
    return TextField(
      maxLines: 7,
      controller: _descriptionController,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'What\'s on your mind?',
        border: OutlineInputBorder(),
      ),
    );
  }

  // Image Selection Section
  Widget _buildImageSection() {
    return Obx(() {
      if (_isImageSelected.value) {
        return Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      _imageBytes!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _imageBytes = null;
                          _imageName = null;
                          _isImageSelected.value = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            if (_imageName != null)
              Text(
                _imageName!,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        );
      } else {
        return ScaleButton(
          onTap: _pickImage,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.image,
                  color: Colors.white,
                ),
                SizedBox(width: 10.w),
                Text(
                  "Add photos",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });
  }

  // Post Button
  Widget _buildPostButton() {
    return Obx(() {
      final bool isLoading = Controllers.posts.isLoading[FirebasePostController.CREATE_POST] ?? false;
      final bool isFormValid = _descriptionController.text.trim().isNotEmpty || _isImageSelected.value;
      
      return DynamicButton(
        isLoading: isLoading || _isProcessing.value,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Post",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 12),
            if (isLoading || _isProcessing.value)
              SizedBox(
                height: 17,
                width: 17,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              )
          ],
        ),
        onPressed: isFormValid ? _createPost : null,
      );
    });
  }

  // Pick Image from Gallery
  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      
      if (image == null) return;
      
      _isProcessing.value = true;
      
      final Uint8List bytes = await image.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _imageName = image.name;
        _isImageSelected.value = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    } finally {
      _isProcessing.value = false;
    }
  }

  // Create Post
  Future<void> _createPost() async {
    if (_descriptionController.text.trim().isEmpty && !_isImageSelected.value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add some text or an image to your post')),
      );
      return;
    }
    
    try {
      await Controllers.posts.createPost(
        description: _descriptionController.text.trim(),
        imageBytes: _imageBytes,
      );
      
      if (Controllers.posts.isSuccessful.value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RootScreen()),
        );
      } else {
        final errorMessage = Controllers.posts.errorMessage.value;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage.isNotEmpty ? errorMessage : 'Failed to create post')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating post: $e')),
      );
    }
  }
}