import 'dart:ui';
import 'package:affirmation_app/constants/app_colors.dart';
import 'package:affirmation_app/constants/app_images.dart';
import 'package:affirmation_app/constants/app_sizes.dart';
import 'package:affirmation_app/view/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:affirmation_app/view/widget/custom_drop_down_widget.dart';
import 'package:affirmation_app/view/widget/headings_widget.dart';
import 'package:affirmation_app/view/widget/my_button_widget.dart';
import 'package:affirmation_app/view/widget/my_text_widget.dart';
import 'package:affirmation_app/view/widget/my_textfield_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({Key? key}) : super(key: key);

  @override
  _CompleteProfileState createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  Map<String, dynamic>? _userData;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageGroupController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _desiredOccupationController =
      TextEditingController();

  final TextEditingController _currentIncomeController =
      TextEditingController();
  final TextEditingController _desiredIncomeController =
      TextEditingController();
  final TextEditingController _debtAmountController = TextEditingController();

  final TextEditingController _debtTypeController = TextEditingController();

  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _selectedOccupation;
  String? _selectedDesiredOccupation;
  String? _selectedDebtType;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      DocumentSnapshot snapshot =
          await _firestore.collection('userData').doc(_user!.uid).get();
      setState(() {
        _userData = snapshot.data() as Map<String, dynamic>?;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
  resizeToAvoidBottomInset: true, // Set this to true to allow the body to resize
      body: CustomBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    pinned: false,
                    floating: false,
                    backgroundColor: Colors.transparent,
                    expandedHeight: 155,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AuthHeading(
                            paddingTop: 0,
                            paddingBottom: 0,
                            title: 'Let’s set your first money goal',
                            subTitle:
                                'Below are some questions which can help you with that',
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: AppSize.HORIZONTAL,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 40),
                          MyTextField(
                            hintText: 'Name',
                            controller: _nameController,
                          ),
                          MyTextField(
                            hintText: 'Age',
                            keyboardType: TextInputType.number,
                            controller: _ageGroupController,
                          ),
                          MyTextField(
                            hintText: 'Occupation',
                            controller: _occupationController,
                          ),
                          MyTextField(
                            hintText: 'Current Income',
                            controller: _currentIncomeController,
                          ),
                          MyTextField(
                            hintText: 'Desired Occupation',
                            controller: _desiredOccupationController,
                          ),
                          MyTextField(
                            hintText: 'Desired Income',
                            controller: _desiredIncomeController,
                          ),
                          MyTextField(
                            hintText: 'Debt Amount',
                            controller: _debtAmountController,
                          ),
                          MyTextField(
                            hintText: 'Debt Type',
                            controller: _debtTypeController,
                          ),
                          MyTextField(
                            hintText: 'Mobile Number',
                            keyboardType: TextInputType.phone,
                            controller: _mobileNumberController,
                          ),
                          MyTextField(
                            hintText: 'Address',
                            controller: _addressController,
                            maxLines: 3,
                          ),
                          MyTextField(
                            hintText: 'Savings Goals',
                            maxLines: 5,
                            controller: _goalController,
                            radius: 27,
                            marginBottom: 4,
                          ),
                          MyText(
                            text:
                                'i.e. buy a new house, buy a new car, go on vacation, etc',
                            size: 12,
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: AppSize.DEFAULT,
              color: kGreyColor.withOpacity(0.28),
              child: MyButton(
                buttonText: 'Save Data',
                onTap: _saveData,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _validateFields() {
    List<TextEditingController> controllers = [
      _nameController,
      _ageGroupController,
      _occupationController,
      _currentIncomeController,
      _desiredOccupationController,
      _desiredIncomeController,
      _debtAmountController,
      _debtTypeController,
      _mobileNumberController,
      _addressController,
      _goalController
    ];

    return controllers.every((controller) => controller.text.trim().isNotEmpty);
  }

  Future<void> _saveData() async {
    if (!_validateFields()) {
      Get.snackbar(
        'Incomplete Data',
        'Please fill out all the fields before saving.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("No user logged in");
      }
      String userId = user.uid;

      await FirebaseFirestore.instance.collection('userData').doc(userId).set({
        'name': _nameController.text,
        'ageGroup': _ageGroupController.text,
        'selectedOccupation': _occupationController.text,
        'currentIncome': _currentIncomeController.text,
        'selectedDesiredOccupation': _desiredOccupationController.text,
        'desiredIncome': _desiredIncomeController.text,
        'debtAmount': _debtAmountController.text,
        'selectedDebtType': _debtTypeController.text,
        'mobileNumber': _mobileNumberController.text,
        'address': _addressController.text,
        'goal': _goalController.text,
        'email': user.email, // Ensure to use user.email directly here
        'premium': false,
      });

      Get.snackbar(
        'Success',
        'Data saved successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.to(() => BottomNavBar());
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save data: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    // Clean up controllers
    _nameController.dispose();
    _ageGroupController.dispose();
    _occupationController.dispose();
    _currentIncomeController.dispose();
    _desiredOccupationController.dispose();
    _debtTypeController.dispose();
    _debtAmountController.dispose();
    _mobileNumberController.dispose();
    _addressController.dispose();
    _goalController.dispose();
    super.dispose();
  }
}

class CustomBackground extends StatelessWidget {
  final Widget child;

  const CustomBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.imagesBgImage),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 8,
          sigmaY: 8,
        ),
        child: Container(
          color: kBlackColor.withOpacity(0.75),
          child: child,
        ),
      ),
    );
  }
}
