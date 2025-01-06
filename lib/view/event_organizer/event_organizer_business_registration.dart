import 'dart:io';
import 'package:flutter/material.dart';
import 'package:forus_app/view/widget/my_text_field.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/constants/app_fonts.dart';
import 'package:forus_app/constants/app_sizes.dart';
import 'package:forus_app/generated/assets.dart';
import 'package:forus_app/view/widget/common_image_view_widget.dart';
import 'package:forus_app/view/widget/my_button_widget.dart';
import 'package:forus_app/view/widget/my_text_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:country_picker/country_picker.dart';
import '../../controllers/EventOrganizer/BusinessManagement/EventOrganizerBusinessController.dart';

class EventOrganizerBusinessRegistrationScreen extends StatefulWidget {

  const EventOrganizerBusinessRegistrationScreen({super.key});

  @override
  State<EventOrganizerBusinessRegistrationScreen> createState() => _ProviderBusinessDetailsScreenState();
}

class _ProviderBusinessDetailsScreenState extends State<EventOrganizerBusinessRegistrationScreen> {
  // Form field controllers
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController businessEmailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController businessDescriptionController = TextEditingController();
  final TextEditingController businessWebsiteController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController twitterController = TextEditingController();
  final TextEditingController linkedInController = TextEditingController();

  final EventOrganizerBusinessController controller = Get.put(EventOrganizerBusinessController());


  // State for country code and image
  String selectedCountryCode = '+1';
  String? uploadedPhotoPath;
  File? _selectedImage;
  late double latitude;
  late double longitude;
  String address = "";

  // Validation method
  bool validateInputs() {
    if (businessNameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Business name is required.',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (businessEmailController.text.trim().isEmpty ||
        !GetUtils.isEmail(businessEmailController.text.trim())) {
      Get.snackbar('Error', 'A valid business email is required.',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (phoneNumberController.text.trim().isEmpty ||
        !GetUtils.isPhoneNumber(phoneNumberController.text.trim())) {
      Get.snackbar('Error', 'A valid contact number is required.',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (businessDescriptionController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Business description is required.',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    return true;
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Un-focus the current text field
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppThemeColors.getTertiary(context),
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: CommonImageView(
                imagePath: Assets.imagesArrowLeft,
                height: 24,
              ),
            ),
          ),
        ),
        backgroundColor: AppThemeColors.getTertiary(context),
        body: Padding(
          padding: AppSizes.DEFAULT,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    MyText(
                      text: 'Business Detail ',
                      size: 24,
                      textAlign: TextAlign.center,
                      paddingTop: 20,
                      fontFamily: AppFonts.NUNITO_SANS,
                      weight: FontWeight.w800,
                    ),
                    MyText(
                      text: 'Please fill your business details.',
                      size: 16,
                      paddingTop: 5,
                      paddingBottom: 30,
                      textAlign: TextAlign.center,
                      color: kTextGrey,
                      fontFamily: AppFonts.NUNITO_SANS,
                      weight: FontWeight.w500,
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: _showImageSourceActionSheet,
                          child: _selectedImage != null
                              ? ClipOval(
                                  child: Image.file(
                                    _selectedImage!,
                                    height: 86,
                                    width: 86,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : ClipOval(
                                  child: CommonImageView(
                                    imagePath: Assets
                                        .imagesEditProfile, // Default image
                                    height: 86,
                                    width: 86,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        MyText(
                          text: 'Upload Business Photo',
                          size: 14,
                          textAlign: TextAlign.center,
                          paddingTop: 10,
                          fontFamily: AppFonts.NUNITO_SANS,
                          weight: FontWeight.w500,
                        ),
                      ],
                    ),

                    Gap(14),
                    MyTextField(
                      controller: businessNameController,
                      hint: 'Business Name',
                      hintColor: kTextGrey,
                      labelColor: kWhite,
                      radius: 8,
                      suffix: Padding(
                        padding: const EdgeInsets.all(12),
                        child: CommonImageView(
                          imagePath: Assets.imagesBriefcase,
                          height: 22,
                        ),
                      ),
                      filledColor: kTransperentColor,
                      kBorderColor: kBorderGrey,
                      kFocusBorderColor: KColor1,
                    ),
                    Gap(9),
                    MyTextField(
                      controller: businessEmailController,
                      hint: 'Business Email address',
                      hintColor: kTextGrey,
                      labelColor: kWhite,
                      radius: 8,
                      suffix: Padding(
                        padding: const EdgeInsets.all(12),
                        child: CommonImageView(
                          imagePath: Assets.imagesGreyemail,
                          height: 22,
                        ),
                      ),
                      filledColor: kTransperentColor,
                      kBorderColor: kBorderGrey,
                      kFocusBorderColor: KColor1,
                    ),
                    Gap(9),
                    Container(
                      margin: EdgeInsets.only(bottom: 16),
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: kBorderGrey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showCountryPicker(
                                context: context,
                                showPhoneCode: true,
                                onSelect: (Country country) {
                                  setState(() {
                                    selectedCountryCode =
                                        '+${country.phoneCode}';
                                  });
                                },
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                mainAxisSize: MainAxisSize
                                    .min, // Allow the Row to shrink-wrap its children
                                children: [
                                  MyText(
                                    text: selectedCountryCode,
                                    size: 14,
                                    color: kTextGrey,
                                    fontFamily: AppFonts.NUNITO_SANS,
                                  ),
                                  SizedBox(
                                      width:
                                          10), // Replace Spacer with SizedBox
                                  Icon(Icons.keyboard_arrow_down_outlined,
                                      color: kBlack),
                                ],
                              ),
                            ),
                          ),
                          Gap(10),
                          Expanded(
                            child: TextField(
                              controller: phoneNumberController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Contact Number',
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  fontFamily: AppFonts.NUNITO_SANS,
                                  color: kTextGrey,
                                ),
                              ),
                            ),
                          ),
                          CommonImageView(
                            imagePath: Assets.imagesCall,
                            height: 22,
                          ),
                        ],
                      ),
                    ),
                    Gap(9),
                    MyTextField(
                      controller: businessDescriptionController,
                      hint: 'Business Description',
                      maxLines: 5,
                      hintColor: kTextGrey,
                      labelColor: kWhite,
                      radius: 8,
                      kBorderColor: kBorderGrey,
                      kFocusBorderColor: KColor1,
                    ),
                    Gap(9),
                    MyTextField(
                      controller: businessWebsiteController,
                      hint: 'Business Website Link',
                      hintColor: kTextGrey,
                      labelColor: kWhite,
                      radius: 8,
                      suffix: Padding(
                        padding: const EdgeInsets.all(12),
                        child: CommonImageView(
                          imagePath: Assets.imagesGlobal,
                          height: 22,
                        ),
                      ),
                      filledColor: kTransperentColor,
                      kBorderColor: kBorderGrey,
                      kFocusBorderColor: KColor1,
                    ),
                    Gap(9),
                    MyTextField(
                      controller: facebookController,
                      hint: 'Facebook Link',
                      hintColor: kTextGrey,
                      labelColor: kWhite,
                      radius: 8,
                      suffix: Padding(
                        padding: const EdgeInsets.all(12),
                        child: CommonImageView(
                          imagePath: Assets.imagesGlobal,
                          height: 22,
                        ),
                      ),
                      filledColor: kTransperentColor,
                      kBorderColor: kBorderGrey,
                      kFocusBorderColor: KColor1,
                    ),
                    Gap(9),
                    MyTextField(
                      controller: instagramController,
                      hint: 'Instagram Website Link',
                      hintColor: kTextGrey,
                      labelColor: kWhite,
                      radius: 8,
                      suffix: Padding(
                        padding: const EdgeInsets.all(12),
                        child: CommonImageView(
                          imagePath: Assets.imagesGlobal,
                          height: 22,
                        ),
                      ),
                      filledColor: kTransperentColor,
                      kBorderColor: kBorderGrey,
                      kFocusBorderColor: KColor1,
                    ),
                    Gap(9),
                    MyTextField(
                      controller: twitterController,
                      hint: 'Twitter Website Link',
                      hintColor: kTextGrey,
                      labelColor: kWhite,
                      radius: 8,
                      suffix: Padding(
                        padding: const EdgeInsets.all(12),
                        child: CommonImageView(
                          imagePath: Assets.imagesGlobal,
                          height: 22,
                        ),
                      ),
                      filledColor: kTransperentColor,
                      kBorderColor: kBorderGrey,
                      kFocusBorderColor: KColor1,
                    ),
                    Gap(9),
                    MyTextField(
                      controller: linkedInController,
                      hint: 'LinkedIn Link',
                      hintColor: kTextGrey,
                      labelColor: kWhite,
                      radius: 8,
                      suffix: Padding(
                        padding: const EdgeInsets.all(12),
                        child: CommonImageView(
                          imagePath: Assets.imagesGlobal,
                          height: 22,
                        ),
                      ),
                      filledColor: kTransperentColor,
                      kBorderColor: kBorderGrey,
                      kFocusBorderColor: KColor1,
                    ),
                    Gap(9),
                    // GestureDetector(
                    //   onTap: () async {
                    //     // Navigate to location addition
                    //     final result = await Get.to(() => LocationPickerScreen());
                    //     if (result != null) {
                    //       // Ensure the result is not null and process the returned data
                    //       latitude = result['lat'];
                    //       longitude = result['lng'];
                    //       address = result['address'];
                    //       Get.snackbar("Location Selected", address, snackPosition: SnackPosition.BOTTOM,);
                    //     } else {
                    //       // Handle the case where no data is returned
                    //       Get.snackbar("Error", "No Location selected.", snackPosition: SnackPosition.BOTTOM,);
                    //     }
                    //   },
                    //   child: Container(
                    //     margin: EdgeInsets.only(bottom: 16),
                    //     padding:
                    //         EdgeInsets.symmetric(horizontal: 87, vertical: 13),
                    //     decoration: BoxDecoration(
                    //       color: kContainerColor,
                    //       border: Border.all(color: kborderOrange2),
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         CommonImageView(
                    //           imagePath: Assets.imagesPin,
                    //           height: 24,
                    //         ),
                    //         MyText(
                    //           text: 'Add Business Location',
                    //           size: 15,
                    //           paddingLeft: 5,
                    //           color: kTextDarkorange,
                    //           textAlign: TextAlign.center,
                    //           fontFamily: AppFonts.NUNITO_SANS,
                    //           weight: FontWeight.w800,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Gap(6),
                    MyButton(
                      buttonText: "Save",
                      radius: 14,
                      textSize: 18,
                      weight: FontWeight.w800,
                      onTap: () {
                        if (validateInputs()) {
                          // Collect form data
                          final businessDetails = {
                            'businessName': businessNameController.text.trim(),
                            'businessEmail': businessEmailController.text.trim(),
                            'contactNumber': phoneNumberController.text.trim(), // Only the number
                            'businessDescription': businessDescriptionController.text.trim(),
                            'businessWebsite': businessWebsiteController.text.trim(),
                            'businessPhoto': _selectedImage, // Add the image file to the details
                            'countryCode': selectedCountryCode, // Pass country code separately
                          };

                          // Call the controller to send data
                          controller.registerEventOrganizerBusiness(
                            name: businessNameController.text.trim(),
                            email: businessEmailController.text.trim(),
                            countryCode: selectedCountryCode,
                            phoneNumber: phoneNumberController.text.trim(),
                            about: businessDescriptionController.text.trim(),
                            website: businessWebsiteController.text.trim(),
                            facebook: facebookController.text.trim(),
                            instagram: instagramController.text.trim(),
                            twitter: twitterController.text.trim(),
                            linkedIn: linkedInController.text.trim(),
                            address: "address",
                            latitude: 22,
                            longitude: 42,
                            filePaths: [_selectedImage!.path], // Pass the file path

                          );


                        }
                      },
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
