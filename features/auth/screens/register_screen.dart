import 'package:ecomanga/common/app_colors.dart';
import 'package:ecomanga/common/buttons/dynamic_button.dart';
import 'package:ecomanga/common/buttons/scale_button.dart';
import 'package:ecomanga/common/widgets/custom_text_field.dart';
import 'package:ecomanga/controllers/controllers.dart';
import 'package:ecomanga/features/auth/screens/login_screen.dart';
import 'package:ecomanga/features/auth/screens/verify_mail_screen.dart';
import 'package:ecomanga/features/home/root_screen.dart';
import 'package:ecomanga/features/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _agreed = false;

  @override
  void dispose() {
    _phone.dispose();
    _email.dispose();
    _name.dispose();
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.h,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top + 30,
                ),
                Image.asset(
                  "assets/icons/app_icon.png",
                  height: 120.h,
                  width: 120,
                ),
                _headingText(
                  "Get Started",
                ),
                _normalText(
                  "by creating a free account",
                ),
                SizedBox(
                  height: 20.h,
                ),
                CustomTextField(
                    hintText: "Full Name",
                    controller: _name,
                    autofocus: true,
                    removeFocusOutside: true,
                    iconData: Icons.person_2_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your full name";
                      } else if (value.length < 3) {
                        return "Name length should be 3 character";
                      }
                      return null;
                    }),
                CustomTextField(
                    hintText: "Username",
                    controller: _username,
                    autofocus: false,
                    removeFocusOutside: true,
                    iconData: Icons.person_2_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your username";
                      } else if (value.length < 3) {
                        return "Name length should be, at least, 3 characters";
                      }
                      return null;
                    }),
                CustomTextField(
                  hintText: "Email Address",
                  controller: _email,
                  autofocus: false,
                  removeFocusOutside: true,
                  iconData: Icons.email,
                  validator: (value) {
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email address';
                    } else if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: _phone,
                  hintText: "Enter Phone no",
                  iconData: Icons.call,
                  removeFocusOutside: true,
                  isNumber: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Phone cannot be null";
                    } else if (value.length != 10) {
                      return "Phone should be of 10 digits";
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  hintText: 'Password',
                  controller: _password,
                  autofocus: false,
                  removeFocusOutside: true,
                  iconData: Icons.lock_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    } else if (value.length < 6) {
                      return "Password length should be at least 6 characters";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 5.h,
                ),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Center(
                    child: FittedBox(
                      child: Flex(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        direction: Axis.horizontal,
                        children: [
                          Checkbox(
                            activeColor: AppColors.buttonColor,
                            focusColor: Colors.indigoAccent,
                            hoverColor: Colors.indigoAccent,
                            value: _agreed,
                            onChanged: (_) {
                              setState(() {
                                _agreed = !_agreed;
                              });
                            },
                          ),
                          _normalText(
                            "By checking the box you agree to our ",
                          ),
                          ScaleButton(
                            onTap: () {
                              // Show terms and conditions
                              _showTermsAndConditions(context);
                            },
                            child: Text(
                              "Terms & Conditions",
                              style: TextStyle(
                                fontSize: 14.sp,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                decorationThickness: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Obx(() {
                  if (Controllers.auth.authSuccessful.value) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Utils.go(context: context, screen: VerifyEmailScreen());
                    });
                  }
                  if (Controllers.auth.errorMessage.value != "") {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.red[900],
                          title: Text(
                            "Error",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          content: Text(
                            Controllers.auth.errorMessage.value.trim(),
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ).then((_) {
                        Controllers.auth.errorMessage.value = "";
                      });
                    });
                  }
                  return DynamicButton(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Sign up",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 12),
                        if (Controllers.auth.isLoading.value)
                          SizedBox(
                            height: 17,
                            width: 17,
                            child: CircularProgressIndicator(strokeWidth: 3),
                          )
                      ],
                    ),
                    onPressed: () {
                      if (!_agreed) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Please agree to the Terms & Conditions"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      
                      if (_formKey.currentState!.validate()) {
                        // Split full name into first and last name
                        List<String> nameParts = _name.text.split(" ");
                        String firstName = nameParts[0];
                        String lastName = nameParts.length > 1 
                            ? nameParts.sublist(1).join(" ") 
                            : "";
                        
                        Controllers.auth.register(
                          email: _email.text,
                          password: _password.text,
                          firstName: firstName,
                          lastName: lastName,
                          username: _username.text,
                          phoneNo: _phone.text,
                        );
                      }
                    },
                    isLoading: Controllers.auth.isLoading.value,
                  );
                }),
                SizedBox(
                  height: 15.h,
                ),
                _buildSeparator("or"),
                SizedBox(
                  height: 15.h,
                ),
                Obx(() {
                  return ScaleButton(
                    onTap: Controllers.auth.isLoading.value
                        ? null
                        : () async {
                            await Controllers.auth.signInWithGoogle();
                            if (Controllers.auth.authSuccessful.value) {
                              Utils.go(context: context, screen: const RootScreen(), replace: true);
                            }
                          },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/icons/google.png",
                            height: 25.h,
                            fit: BoxFit.cover,
                          ),
                          const Spacer(),
                          Text(
                            "Sign up with Google",
                            style: TextStyle(
                              fontSize: 16.h,
                              color: Colors.black,
                            ),
                          ),
                          const Spacer(),
                          if (Controllers.auth.isLoading.value)
                            SizedBox(
                              height: 15,
                              width: 15,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
                SizedBox(
                  height: 50.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _normalText("Already a member? "),
                    ScaleButton(
                      onTap: () {
                        Utils.go(
                          context: context,
                          screen: const LoginScreen(),
                        );
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14.sp,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                _buildSeparator("or"),
                SizedBox(
                  height: 10.h,
                ),
                ScaleButton(
                  onTap: () {
                    // Sign in as guest with Firebase anonymous authentication
                    _signInAsGuest(context);
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.green,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        "Access as guest",
                        style: TextStyle(
                          fontSize: 16.h,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTermsAndConditions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Terms & Conditions"),
        content: SingleChildScrollView(
          child: Text(
            "By using our application, you agree to abide by our terms and conditions. "
            "This includes respecting user privacy, providing accurate information, and "
            "using the platform responsibly.\n\n"
            "We collect basic user information to provide our services and improve user experience. "
            "Your personal data will be handled according to our privacy policy.\n\n"
            "EcoManga reserves the right to modify these terms at any time, with notice provided "
            "to users through the application or via email.",
            style: TextStyle(fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  // Helper method for guest sign in
  void _signInAsGuest(BuildContext context) async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );
      
      // Sign in anonymously with Firebase
      await FirebaseAuth.instance.signInAnonymously();
      
      // Navigate to home screen
      Navigator.pop(context); // Close loading dialog
      Utils.go(context: context, screen: const RootScreen(), replace: true);
      
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to sign in as guest. Please try again."))
      );
    }
  }

  Widget _buildSeparator(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey,
            height: 1.5.h,
          ),
        ),
        SizedBox(
          width: 10.h,
        ),
        _normalText(text),
        SizedBox(
          width: 10.h,
        ),
        Expanded(
          child: Divider(
            color: Colors.grey,
            height: 1.5.h,
          ),
        )
      ],
    );
  }

  _headingText(String text) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 25.sp, fontWeight: FontWeight.bold, color: Colors.black),
    );
  }

  _normalText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 14.sp, color: Colors.black),
    );
  }
}