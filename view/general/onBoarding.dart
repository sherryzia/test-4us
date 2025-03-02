import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/config/routes/routes.dart';
import 'package:quran_app/constants/app_colors.dart';
import 'package:quran_app/controllers/GlobalController.dart';
import 'package:quran_app/utilities/shared_preferences_util.dart';
import 'package:quran_app/view/widgets/my_button_widget.dart';
import 'package:quran_app/view/widgets/my_text_field_widget.dart';

class GeneralScreen extends StatefulWidget {
  GeneralScreen({super.key});

  @override
  State<GeneralScreen> createState() => _GeneralScreenState();
}

class _GeneralScreenState extends State<GeneralScreen> {
  final GlobalController globalController = Get.find<GlobalController>();

  // Controllers for form fields
  final TextEditingController nameController = TextEditingController();
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";

  // ✅ Save User Data to SharedPreferences & GlobalController
  Future<void> saveUserData() async {
    String name = nameController.text.trim();

    // ✅ Field Validations
    if (name.isEmpty) {
      Get.snackbar("Error", "Please enter your name.", snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (countryValue.isEmpty) {
      Get.snackbar("Error", "Please select your country.", snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (cityValue.isEmpty) {
      Get.snackbar("Error", "Please select your city.", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // ✅ Save Data in SharedPreferences
    await SharedPreferencesUtil.saveData("user_name", name);
    await SharedPreferencesUtil.saveData("user_country", countryValue);
    await SharedPreferencesUtil.saveData("user_city", cityValue);

    // ✅ Update GlobalController
    globalController.updateUserInfo(name, countryValue, cityValue);

    // ✅ Navigate to Main Screen
    Get.offAllNamed(AppLinks.mainScreen);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false, // ✅ Prevents layout from shifting
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    // Welcome Text
                    const Text(
                      "Tell us about yourself",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: kDarkPurpleColor,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      "Please fill in your details to get started",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF8789A3),
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Name Input
                    MyTextField(
                      controller: nameController,
                      label: "Your Name",
                      labelSize: 14,
                      labelWeight: FontWeight.w600,
                      hint: "Enter your name",
                      prefix: Icon(Icons.person_outline, color: Color(0xFF672CBC)),
                    ),

                    const SizedBox(height: 10),

                    // ✅ Country, State & City Picker with Search
                    CSCPickerPlus(
                      layout: Layout.vertical,
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE4E4E4)),
                      ),
                      showStates: true, // ✅ Enable state selection
                      showCities: true, // ✅ Enable city selection
                      flagState: CountryFlag.ENABLE, // ✅ Show country flags
                      countrySearchPlaceholder: "Search Country", // ✅ Searchable input
                      stateSearchPlaceholder: "Search State", // ✅ Searchable input
                      citySearchPlaceholder: "Search City", // ✅ Searchable input
                      selectedItemStyle: const TextStyle(color: Color(0xFF672CBC)),

                      // ✅ Get selected values
                      onCountryChanged: (value) {
                        setState(() {
                          countryValue = value.replaceAll(RegExp(r'[^A-Za-z ]'), '').trim();
                          stateValue = ""; // Reset state when country changes
                          cityValue = ""; // Reset city when country changes
                        });
                      },
                      onStateChanged: (value) {
                        setState(() {
                          stateValue = value ?? "";
                          cityValue = ""; // Reset city when state changes
                        });
                      },
                      onCityChanged: (value) {
                        setState(() {
                          cityValue = value ?? "";
                        });
                      },
                    ),

                    Expanded(child: Container()), // ✅ Keeps button fixed
                  ],
                ),
              ),

              // ✅ Fixed Get Started Button (Does NOT move)
              Positioned(
                bottom: 24.0,
                left: 24.0,
                right: 24.0,
                child: Center(
                  child: MyButton(
                    buttonText: "Get Started",
                    onTap: saveUserData, // ✅ Save user data on button tap
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
