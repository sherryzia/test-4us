import 'dart:typed_data';

import 'package:ecomanga/common/buttons/dynamic_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ecomanga/common/buttons/scale_button.dart';
import 'package:ecomanga/features/home/root_screen.dart';
import 'package:ecomanga/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  @override
  void initState() {
    Controllers.profileController.getProfile();

    super.initState();
  }

  final TextEditingController _descriptionController = TextEditingController();
  Uint8List? imageBytes;

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
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: const NetworkImage(
                      'https://images.unsplash.com/photo-1657306607237-3eab445c4a84?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8c2V4eSUyMGdpcmx8ZW58MHx8MHx8fDA%3D', // Replace with your profile image URL
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        Controllers.profileController
                                    .isLoading[keys.getProfile] ??
                                false
                            ? "--"
                            : Controllers.profileController.profile!.fullName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.sp),
                      ),
                      Text(
                        'Community',
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
            SizedBox(height: 20.h),
            TextField(
              maxLines: 7,
              controller: _descriptionController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'What do you think?',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.h),
            ScaleButton(
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                print("Help");
                final XFile? image =
                    await picker.pickImage(source: ImageSource.gallery);
                if (image == null) return;
                imageBytes = await image.readAsBytes();
                print(" is ${imageBytes.toString()}");
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 7.h),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(7)),
                child: Center(
                  child: Text(
                    "Add photos and videos",
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Obx(() {
              return DynamicButton(
                isLoading:
                    Controllers.postController.isLoading[keys.createPost],
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
                    if (Controllers.postController.isLoading[keys.createPost] ??
                        false)
                      SizedBox(
                        height: 17,
                        width: 17,
                        child: CircularProgressIndicator(strokeWidth: 3),
                      )
                  ],
                ),
                onPressed: () {
                  Controllers.postController
                      .createPost(
                          _descriptionController.text,
                          Controllers.profileController.profile!.username,
                          imageBytes)
                      .then((_) {
                    _descriptionController.text = "";
                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (_) {
                      return RootScreen();
                    }));
                  });
                },
              );
            }),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
