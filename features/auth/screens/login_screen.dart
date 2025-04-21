import 'package:ecomanga/common/app_colors.dart';
import 'package:ecomanga/common/buttons/dynamic_button.dart';
import 'package:ecomanga/common/buttons/scale_button.dart';
import 'package:ecomanga/common/widgets/custom_text_field.dart';
import 'package:ecomanga/controllers/controllers.dart';
import 'package:ecomanga/features/auth/screens/register_screen.dart';

import 'package:ecomanga/features/home/root_screen.dart';
import 'package:ecomanga/features/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _fKey1 = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();

  final TextEditingController _password = TextEditingController();

  bool _agreed = false;

  @override
  void dispose() {
    _email.dispose();

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
          key: _fKey1,
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

                  // fit: BoxFit.cover,
                ),
                _headingText(
                  "Welcome back",
                ),
                _normalText(
                  "Sign in to continue",
                ),
                SizedBox(
                  height: 20.h,
                ),
                CustomTextField(
                  hintText: "Email Address",
                  controller: _email,
                  autofocus: true,
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
                  hintText: 'Password',
                  controller: _password,
                  autofocus: false,
                  removeFocusOutside: true,
                  iconData: Icons.lock_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    } else if (value.length < 6) {
                      return "Password length should be 6 character";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
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
                    Text(
                      "Remember me",
                      style: TextStyle(
                        fontSize: 12.sp,
                      ),
                    ),
                    const Spacer(),
                    ScaleButton(
                        onTap: () {},
                        child: Text(
                          "forgot password?",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.red,
                          ),
                        ))
                  ],
                ),
                SizedBox(
                  height: 3.h,
                ),
                Obx(() {
                  if (Controllers.loginController.errorMessage.value != "") {
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
                            Controllers.loginController.errorMessage.value
                                .trim(),
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ).then((_) {
                        Controllers.loginController.errorMessage.value = "";
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
                        if (Controllers.loginController.isLoading.value)
                          SizedBox(
                            height: 17,
                            width: 17,
                            child: CircularProgressIndicator(strokeWidth: 3),
                          )
                      ],
                    ),
                    onPressed: () async {
                      await Controllers.loginController.login(
                        password: _password.text,
                        email: _email.text,
                      );
                      if (Controllers.loginController.authSuccessful.value) {
                        Utils.go(context: context, screen: const RootScreen());
                      }
                    },
                    isLoading: Controllers.loginController.isLoading.value,
                  );
                }),
                SizedBox(
                  height: 10.h,
                ),
                ScaleButton(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
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
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                ScaleButton(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
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
                          "assets/icons/facebook.png",
                          height: 25.h,
                          fit: BoxFit.cover,
                        ),
                        const Spacer(),
                        Text(
                          "Sign up with Facebook",
                          style: TextStyle(
                            fontSize: 16.h,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 195.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _normalText("New member? "),
                    ScaleButton(
                      onTap: () {
                        Utils.go(
                          context: context,
                          screen: const RegisterScreen(),
                        );
                      },
                      child: Text(
                        "Create an account",
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
                  height: 10.h,
                ),
                Row(
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
                      width: 5.h,
                    ),
                    _normalText("or"),
                    SizedBox(
                      width: 5.h,
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        height: 1.5.h,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                ScaleButton(
                  onTap: () {},
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
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
