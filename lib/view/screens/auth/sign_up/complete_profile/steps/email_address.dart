import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/utils/global_instances.dart';
import 'package:candid/view/widget/my_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailAddress extends StatefulWidget {
  const EmailAddress({super.key});

  @override
  State<EmailAddress> createState() => _EmailAddressState();
}

class _EmailAddressState extends State<EmailAddress> {
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with existing value
    emailController.text = profileController.email.value;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppSizes.DEFAULT,
      children: [
        MyTextField(
          controller: emailController,
          labelText: 'Email Address',
          hintText: 'thomas@gmail.com',
          prefixIcon: Assets.imagesMail,
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            // Update ProfileController when user types
            profileController.email.value = value;
            print('Email updated: ${value}'); // Debug
          },
        ),
        // Debug display (remove in production)
        Obx(() => Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            'Controller value: "${profileController.email.value}"',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        )),
      ],
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}