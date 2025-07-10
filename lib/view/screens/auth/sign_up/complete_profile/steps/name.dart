import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/utils/global_instances.dart';
import 'package:candid/view/widget/my_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Name extends StatefulWidget {
  const Name({super.key});

  @override
  State<Name> createState() => _NameState();
}

class _NameState extends State<Name> {
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with existing value
    nameController.text = profileController.name.value;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      padding: AppSizes.DEFAULT,
      children: [
        MyTextField(
          controller: nameController,
          labelText: 'Name',
          hintText: 'Thomas',
          prefixIcon: Assets.imagesUserName,
          onChanged: (value) {
            // Update ProfileController when user types
            profileController.name.value = value;
            print('Name updated: ${value}'); // Debug
          },
        ),
        // Debug display (remove in production)
        Obx(() => Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            'Controller value: "${profileController.name.value}"',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        )),
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}