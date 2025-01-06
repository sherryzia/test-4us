import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:forus_app/constants/app_fonts.dart';
import 'package:forus_app/controllers/service_provider/ListingManagement/BusinessListingController.dart';
import 'package:forus_app/utils/image_picker_util.dart';
import 'package:forus_app/utils/rest_endpoints.dart';
import 'package:forus_app/view/general/location_picker_screen.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/constants/app_sizes.dart';
import 'package:forus_app/generated/assets.dart';
import 'package:forus_app/view/widget/common_image_view_widget.dart';
import 'package:forus_app/view/widget/my_text_widget.dart';
import 'package:forus_app/view/widget/my_text_field.dart';
import 'package:forus_app/view/widget/my_button_widget.dart';

class EditBusinessListingScreen extends StatefulWidget {
  EditBusinessListingScreen({super.key});
  final BusinessListingController _controller = Get.put(BusinessListingController());

  @override
  State<EditBusinessListingScreen> createState() => _EditBusinessListingScreenState();
}

class _EditBusinessListingScreenState extends State<EditBusinessListingScreen> {
  File? _selectedImage;

  final TextEditingController serviceNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();


  String serviceId = "${Get.arguments['serviceId']}";
  final servicePhoto = "${RestConstants.storageBaseUrl}${Get.arguments['servicePhoto']}";
  final serviceName = Get.arguments['serviceName'];
  final about = Get.arguments['serviceAbout'];
  final includes = Get.arguments['serviceIncludes'];
  late double latitude;
  late double longitude;
  late String address;

  List<String> serviceDetails = [];
  String selectedCountryCode = ""; // Initialize with an empty string

  // Availability data
  final Map<String, Map<String, dynamic>> availability = {
    'Monday': {'isToggled': false, 'startTime': '', 'endTime': ''},
    'Tuesday': {'isToggled': false, 'startTime': '', 'endTime': ''},
    'Wednesday': {'isToggled': false, 'startTime': '', 'endTime': ''},
    'Thursday': {'isToggled': false, 'startTime': '', 'endTime': ''},
    'Friday': {'isToggled': false, 'startTime': '', 'endTime': ''},
    'Saturday': {'isToggled': false, 'startTime': '', 'endTime': ''},
    'Sunday': {'isToggled': false, 'startTime': '', 'endTime': ''},
  };

  // Validation method
  bool validateInputs() {

    if (serviceNameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Service name is required.',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    if (phoneNumberController.text.trim().isEmpty ||
        !GetUtils.isPhoneNumber(phoneNumberController.text.trim())) {
      Get.snackbar('Error', 'A valid contact number is required.',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (aboutController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Service description is required.',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    if(address.isEmpty){
      Get.snackbar('Error', 'Address is required.',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();

    selectedCountryCode = Get.arguments['serviceCountryCode']; // Initialize with the country code
    phoneNumberController.text = Get.arguments['servicePhoneNumber'];

    latitude = double.parse(Get.arguments['serviceLatitude']) ;
    longitude = double.parse(Get.arguments['serviceLongitude']);
    address =  Get.arguments['serviceAddress'];

    // Initialize service details with includes or empty fields
    if (includes.isNotEmpty && includes is List<String>) {
      serviceDetails = List<String>.from(includes);
    } else {
      serviceDetails = ['']; // Default to one empty field if includes is empty
    }

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
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
          title: MyText(
            text: "Edit Service",
            size: 18,
            weight: FontWeight.w700,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: AppSizes.DEFAULT2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  SizedBox(
                    child: GestureDetector(
                      onTap: () async {
                        final image =
                            await ImagePickerUtil.showImageSourceBottomSheet(
                                context);
                        if (image != null) {
                          setState(() {
                            _selectedImage = image;
                          });
                          print("Selected Image Path: ${image.path}");
                        } else {
                          print("No image selected");
                        }
                      },
                      child: _selectedImage != null
                          ? ClipOval(
                              child: Image.file(
                                _selectedImage!,
                                height: 88,
                                width: 88,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipOval(
                              child: CommonImageView(
                                //imagePath: Assets.imagesAddservice,
                                url: servicePhoto,
                                height: 88,
                                width: 88,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                  MyText(
                    text: "Service Photo",
                    size: 14,
                    paddingTop: 10,
                    paddingBottom: 17,
                    weight: FontWeight.w500,
                  ),
                  MyTextField(
                    hint: 'Service Name',
                    initialValue: serviceName,
                    controller: serviceNameController,
                    hintColor: kTextGrey,
                    labelColor: kWhite,
                    radius: 8,
                    filledColor: kTransperentColor,
                    kBorderColor: kBorderGrey,
                    kFocusBorderColor: KColor1,
                  ),
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
                              // decoration: BoxDecoration(
                              //   border: Border.all(color: kBorderGrey),
                              //   borderRadius: BorderRadius.circular(12),
                              // ),
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
  controller: phoneNumberController, // Ensure this is initialized with an initial value
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


MyTextField(
  hint: 'About the service',
  initialValue: about,
  controller: aboutController,
  hintColor: kTextGrey,
  labelColor: kWhite,
  radius: 8,
  filledColor: kTransperentColor,
  kBorderColor: kBorderGrey,
  kFocusBorderColor: KColor1,
  keyboardType: TextInputType.phone,
),

                  Gap(17),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(
                        text: "What it includes?",
                        size: 15,
                        weight: FontWeight.w600,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            serviceDetails.add(''); // Add a new empty line
                          });
                        },
                        child: Row(
                          children: [
                            CommonImageView(
                              imagePath: Assets.imagesAddOrange,
                              height: 18,
                            ),
                            MyText(
                              text: "Add Another line",
                              size: 13,
                              color: kTextOrange2,
                              weight: FontWeight.w800,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Gap(10),
                  ListView.builder(
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
  itemCount: serviceDetails.length,
  itemBuilder: (context, index) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.20,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 8, left: 8, right: 8),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    serviceDetails.removeAt(index); // Remove field
                  });
                },
                child: CommonImageView(
                  imagePath: Assets.imagesMinus,
                  height: 34,
                ),
              ),
            ),
          ),
        ],
      ),
      child: MyTextField(
        marginBottom: 8,
        hint: 'Enter things to include in the service',
        hintColor: kTextGrey,
        labelColor: kWhite,
        radius: 8,
        filledColor: kTransperentColor,
        kBorderColor: kBorderGrey,
        kFocusBorderColor: KColor1,
        initialValue: serviceDetails[index], // Populate with initial value
        onChanged: (value) {
          serviceDetails[index] = value; // Update field value
        },
      ),
    ),
  ),
),


                ],
              ),
              MyText(
                text: "Availability",
                size: 15,
                paddingBottom: 17,
                textAlign: TextAlign.center, // Center-align the text
                weight: FontWeight.w500,
              ),
              ...availability.keys
                  .map((day) => availabilityWidget(day))
                  .toList(),
              SizedBox(height: 20),

              GestureDetector(
                onTap: () async {
                  // Navigate to location addition
                  final result = await Get.to(() => LocationPickerScreen());
                  if (result != null) {
                    // Ensure the result is not null and process the returned data
                    latitude = result['lat'];
                    longitude = result['lng'];
                    address = result['address'];
                    Get.snackbar("Location Selected", address, snackPosition: SnackPosition.BOTTOM,);
                  } else {
                    // Handle the case where no data is returned
                    Get.snackbar("Error", "No Location selected.", snackPosition: SnackPosition.BOTTOM,);
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 16),
                  padding:
                  EdgeInsets.symmetric(horizontal: 87, vertical: 13),
                  decoration: BoxDecoration(
                    color: kContainerColor,
                    border: Border.all(color: kborderOrange2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CommonImageView(
                        imagePath: Assets.imagesPin,
                        height: 24,
                      ),
                      MyText(
                        text: 'Add Business Location',
                        size: 15,
                        paddingLeft: 5,
                        color: kTextDarkorange,
                        textAlign: TextAlign.center,
                        fontFamily: AppFonts.NUNITO_SANS,
                        weight: FontWeight.w800,
                      ),
                    ],
                  ),
                ),
              ),
              Gap(6),

              MyButton(
                  buttonText: widget._controller.isLoading.value ? "Updating ..." : "Update Listing",
                  radius: 14,
                  textSize: 18,
                  weight: FontWeight.w800,
                  onTap: widget._controller.isLoading.value ? () => {} // Disable the button when loading
                      : () {
                    if (validateInputs()) {

                      showConfirmationDialog(
                        context: context,
                        title: "Are you sure?",
                        message: "Do you want to update this listing?",
                        onConfirm: () {
                          // Call the controller
                          widget._controller.editBusinessListing(
                            serviceId: serviceId,
                            name: serviceNameController.text.trim(),
                            countryCode: selectedCountryCode.trim(),
                            phoneNumber: phoneNumberController.text.trim(),
                            about: aboutController.text.trim(),
                            includes: serviceDetails,
                            address: address.trim(),
                            latitude: latitude,
                            longitude: longitude,
                            photos: _selectedImage != null ? [_selectedImage!] : [], // Conditionally send image,
                            availability: availability,
                          );
                        }
                      );
                    }
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  required VoidCallback onConfirm,
}) async {

    await showDialog(
      context: context,
      barrierDismissible: false, // Prevent accidental dismiss
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icon and Title
              Column(
                children: [
                  Icon(
                    Icons.warning_rounded,
                    color: kTextDarkorange2,
                    size: 48,
                  ),
                  SizedBox(height: 12),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: MyButton(
                      buttonText: "No",
                      bgColor: Colors.grey[300],
                      textColor: Colors.black87,
                      radius: 14,
                      textSize: 16,
                      weight: FontWeight.w600,
                      onTap: () {
                          Navigator.of(context).pop(false); // Close the dialog
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: MyButton(
                      buttonText: "Yes",
                      bgColor: kTextDarkorange2,
                      textColor: Colors.white,
                      radius: 14,
                      textSize: 16,
                      weight: FontWeight.w600,
                      onTap: () {
                        Navigator.of(context).pop(true); // Close the dialog
                        onConfirm(); // Trigger the confirmation callback
                      }
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

  Widget availabilityWidget(String day) {
    return Container(
      padding: AppSizes.DEFAULT2,
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(
                text: day,
                weight: FontWeight.w800,
                fontFamily: 'NunitoSans',
              ),
              Switch(
                value: availability[day]!['isToggled'],
                activeTrackColor: kTextDarkorange,
                activeColor: kTextDarkorange,
                inactiveThumbColor: kswtich,
                inactiveTrackColor: kTextGrey,
                onChanged: (value) {
                  setState(() {
                    availability[day]!['isToggled'] = value;
                  });
                },
              ),
            ],
          ),
          if (availability[day]!['isToggled'] == true)
            Row(
              children: [
                Expanded(
                  child: MyTextField(
                    height: 52,
                    hint: availability[day]!['startTime'].isEmpty
                        ? 'Start time'
                        : availability[day]!['startTime'],
                    hintColor: kTextGrey,
                    radius: 8,
                    suffix: Padding(
                      padding: const EdgeInsets.all(12),
                      child: CommonImageView(
                        imagePath: Assets.imagesClock,
                        height: 22,
                      ),
                    ),
                    kBorderColor: kBorderGrey,
                    kFocusBorderColor: KColor1,
                    isReadOnly: true,
                    onTap: () async {
                      TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (selectedTime != null) {
                        setState(() {
                          availability[day]!['startTime'] =
                              selectedTime.format(context);
                        });
                      }
                    },
                  ),
                ),
                Gap(13),
                Expanded(
                  child: MyTextField(
                    height: 52,
                    hint: availability[day]!['endTime'].isEmpty
                        ? 'End time'
                        : availability[day]!['endTime'],
                    hintColor: kTextGrey,
                    radius: 8,
                    suffix: Padding(
                      padding: const EdgeInsets.all(12),
                      child: CommonImageView(
                        imagePath: Assets.imagesClock,
                        height: 22,
                      ),
                    ),
                    kBorderColor: kBorderGrey,
                    kFocusBorderColor: KColor1,
                    isReadOnly: true,
                    onTap: () async {
                      TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (selectedTime != null) {
                        setState(() {
                          availability[day]!['endTime'] =
                              selectedTime.format(context);
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}