// lib/view/screens/ticket_scanning_screen/instruction_screen.dart

import 'dart:async';
import 'dart:io';
import 'package:betting_app/constants/app_sizes.dart';
import 'package:betting_app/controllers/ticket_controller.dart';
import 'package:betting_app/view/widgets/common_image_view_widget.dart';
import 'package:betting_app/view/widgets/my_button.dart';
import 'package:betting_app/view/widgets/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants/app_colors.dart';
import '../../../generated/assets.dart';

class InstructionScreen extends StatelessWidget {
  const InstructionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TicketController _ticketController = Get.find<TicketController>();
    final ImagePicker _picker = ImagePicker();
    
    // Function to handle image picking and uploading
    // lib/view/screens/ticket_scanning_screen/instruction_screen.dart

// Function to handle image selection and uploading
// lib/view/screens/ticket_scanning_screen/instruction_screen.dart

Future<void> _handleImageSelection(ImageSource source) async {
  try {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      maxWidth: 1800,
      maxHeight: 1800,
      imageQuality: 80,
    );
    
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      
      // Check file exists and has content
      if (await imageFile.exists() && await imageFile.length() > 0) {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        );
        
        try {
          // Upload the ticket
          await _ticketController.uploadTicket(imageFile);
          
          // Always pop the loading dialog
          Navigator.of(context, rootNavigator: true).pop();
          
          // Go back to home screen
          Navigator.of(context).pop();
          
        } catch (e) {
          // Always pop the loading dialog
          Navigator.of(context, rootNavigator: true).pop();
          
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload: ${e.toString()}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selected image file is invalid or empty')),
        );
      }
    }
  } catch (e) {
    print("Error selecting/uploading image: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to process image: ${e.toString()}')),
    );
  }
}
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackGroundColor,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back_outlined, color: kBlackColor, size: 25),
        ),
        centerTitle: true,
        title: const Text(
          'Scan Ticket',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kBlackColor,
          ),
        ),
      ),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CommonImageView(imagePath: Assets.imagesMbl, height: 140,),
              const SizedBox(height: 30,),
              MyText(
                text: "Take a photo of your betting ticket or\nselect one from your gallery",
                size: 17,
                weight: FontWeight.w400,
                color: kSecondaryColor,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Camera button
                  SizedBox(
                    width: 140,
                    child: MyButton(
                      onTap: () => _handleImageSelection(ImageSource.camera),
                      buttonText: "Camera",
                      backgroundColor: kSecondaryColor,
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Gallery button
                  SizedBox(
                    width: 140,
                    child: MyBorderButton(
                      onTap: () => _handleImageSelection(ImageSource.gallery),
                      buttonText: "Gallery",
                      borderColor: kSecondaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}