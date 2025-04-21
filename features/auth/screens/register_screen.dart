import 'package:ecomanga/common/app_colors.dart';
import 'package:ecomanga/common/buttons/dynamic_button.dart';
import 'package:ecomanga/common/buttons/scale_button.dart';
import 'package:ecomanga/common/widgets/custom_text_field.dart';
import 'package:ecomanga/controllers/auth/auth.dart';
import 'package:ecomanga/features/auth/screens/login_screen.dart';
import 'package:ecomanga/features/auth/screens/verify_mail_screen.dart';
import 'package:ecomanga/features/home/root_screen.dart';
import 'package:ecomanga/features/utils/utils.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fKey1 = GlobalKey<FormState>();
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
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GoogleController googleController = Get.find();
    FacebookController facebookController = Get.find();
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
                    autofocus: true,
                    removeFocusOutside: true,
                    iconData: Icons.person_2_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your username";
                      } else if (value.length < 3) {
                        return "Name length should be, at leaast, 3 characters";
                      }
                      return null;
                    }),
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
                  controller: _phone,
                  hintText: "Enter Phone no",
                  iconData: Icons.call,
                  removeFocusOutside: true,
                  isNumber: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "phone can not ve null";
                    } else if (value.length != 10) {
                      return "phone should be of 10 chars";
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
                            onTap: () {},
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
                  RegisterController controller = Get.find();
                  if (controller.authSuccessful.value) {
                    Utils.go(context: context, screen: VerifyEmailScreen());
                  }
                  if (controller.errorMessage.value != "") {
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
                            controller.errorMessage.value.trim(),
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ).then((_) {
                        controller.errorMessage.value = "";
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
                        if (controller.isLoading.value)
                          SizedBox(
                            height: 17,
                            width: 17,
                            child: CircularProgressIndicator(strokeWidth: 3),
                          )
                      ],
                    ),
                    onPressed: () {
                      controller.register(
                        _password.text,
                        _name.text.split(" ")[0],
                        _name.text.split(" ")[1],
                        _username.text,
                        _email.text,
                        _phone.text,
                      );
                    },
                    isLoading: controller.isLoading.value,
                  );
                }),
                SizedBox(
                  height: 10.h,
                ),
                SocialLoginButton(
                  controller: googleController,
                  icon: "assets/icons/google.png",
                  text: "Sign up with Google",
                ),
                SizedBox(
                  height: 10.h,
                ),
                SocialLoginButton(
                  controller: facebookController,
                  icon: "assets/icons/facebook.png",
                  text: "Sign up with Facebook",
                ),
                // ScaleButton(
                //   onTap: () {},
                //   child: Container(
                //     padding: EdgeInsets.symmetric(
                //       horizontal: 10.w,
                //       vertical: 5.h,
                //     ),
                //     decoration: BoxDecoration(
                //       border: Border.all(
                //         color: Colors.grey,
                //       ),
                //       borderRadius: BorderRadius.circular(4),
                //     ),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [
                //         Image.asset(
                //           "assets/icons/facebook.png",
                //           height: 25.h,
                //           fit: BoxFit.cover,
                //         ),
                //         const Spacer(),
                //         Text(
                //           "Sign up with Facebook",
                //           style: TextStyle(
                //             fontSize: 16.h,
                //             color: Colors.black,
                //           ),
                //         ),
                //         const Spacer(),
                //       ],
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 70.h,
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

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    super.key,
    required this.controller,
    required this.icon,
    required this.text,
  });

  final controller;
  final String icon, text;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.authSuccessful.value) {
        Utils.go(context: context, screen: RootScreen());
      }
      if (controller.errorMessage.value != "") {
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
                controller.errorMessage.value.trim(),
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ).then((_) {
            controller.errorMessage.value = "";
          });
        });
      }
      return ScaleButton(
        onTap: () {
          controller.login();
        },
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
                icon,
                height: 25.h,
                fit: BoxFit.cover,
              ),
              const Spacer(),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16.h,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      );
    });
  }
}
