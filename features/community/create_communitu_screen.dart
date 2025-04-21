// create_community_page.dart
import 'package:ecomanga/common/buttons/dynamic_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateCommunityPage extends StatefulWidget {
  const CreateCommunityPage({super.key});

  @override
  _CreateCommunityPageState createState() => _CreateCommunityPageState();
}

class _CreateCommunityPageState extends State<CreateCommunityPage> {
  String communityPrivacy = 'Public';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.lightGreen[100],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.image, size: 40, color: Colors.grey),
                  SizedBox(
                    height: 15.h,
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Text("Choose File"),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Name of Community",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 5.h,
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Name of community',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Community privacy",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 5.h,
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                hintText: 'Community privacy',
                border: OutlineInputBorder(),
              ),
              value: communityPrivacy,
              items: ['Public', 'Private'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    communityPrivacy = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 10),
            Text(
              "Description",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
            ),
            const Text("Give a detailed description of your community"),
            SizedBox(
              height: 5.h,
            ),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Community guidelines",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
            ),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            DynamicButton.fromText(
              text: "Create Community",
              onPressed: () {},
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom + 10,
            ),
          ],
        ),
      ),
    );
  }
}
