import 'package:affirmation_app/services/firebase_auth_services.dart';
import 'package:affirmation_app/view/screens/auth/sign_up/signup_view.dart';
import 'package:affirmation_app/view/screens/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:affirmation_app/view/screens/homescreen/premium_sub.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:affirmation_app/constants/app_colors.dart';
import 'package:affirmation_app/constants/app_images.dart';
import 'package:affirmation_app/constants/app_sizes.dart';
import 'package:affirmation_app/controllers/login_controller.dart';
import 'package:affirmation_app/view/widget/headings_widget.dart';
import 'package:affirmation_app/view/widget/my_button_widget.dart';
import 'package:affirmation_app/view/widget/my_text_widget.dart';
import 'package:affirmation_app/view/widget/my_textfield_widget.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController _controller = Get.put(LoginController());
  bool obscurePassword = true;

  void togglePasswordVisibility() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.imagesBgImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: kBlackColor.withOpacity(0.75),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      pinned: false,
                      floating: false,
                      backgroundColor: Colors.transparent,
                      expandedHeight: 200,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AuthHeading(
                              paddingTop: 0,
                              paddingBottom: 0,
                              title: 'Welcome back,',
                              subTitle:
                                  'Glad to meet you again! Please login to use the app.',
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
                            SizedBox(
                              height: 40,
                            ),
                            MyTextField(
                              hintText: 'Email',
                              havePrefix: true,
                              prefixIcon: Assets.imagesMail,
                              controller: _controller.emailController,
                            ),
                            MyTextField(
                              hintText: 'Password',
                              havePrefix: true,
                              haveSuffix: true,
                              isObSecure: obscurePassword,
                              prefixIcon: Assets.imagesLock,
                              suffixIcon: Assets.imagesEye,
                              onTap: () => togglePasswordVisibility(),
                              controller: _controller.passwordController,
                            ),
                            TextButton(
                              onPressed: () =>
                                  _controller.resetPassword(context),
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            MyButton(
                              buttonText: 'Sign in',
                              onTap: () => _controller
                                  .signInWithEmailAndPassword(context),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1.12,
                                    color: kPrimaryColor,
                                  ),
                                ),
                                MyText(
                                  text: 'or',
                                  size: 18,
                                  paddingLeft: 38,
                                  paddingRight: 38,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1.12,
                                    color: kPrimaryColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 18,
                            ),
                            SocialLogin(
                              onFacebook: () {},
                              onGoogle: () =>
                                  _controller.signInWithGoogle(context),
                              onTwitter: () {},
                            ),
                            SizedBox(
                              height: 150,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: AppSize.DEFAULT,
                color: kBlackColor.withOpacity(0.5),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    MyText(
                      text: 'Don’t have an account? ',
                      size: 13.87,
                    ),
                    MyText(
                      text: 'Join Now',
                      size: 13.87,
                      weight: FontWeight.w600,
                      onTap: () => Get.to(() => SignUp()),
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

class SocialLogin extends StatelessWidget {
  final VoidCallback onFacebook, onTwitter, onGoogle;
  const SocialLogin({
    Key? key,
    required this.onFacebook,
    required this.onTwitter,
    required this.onGoogle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SocialButton(
          buttonText: 'Join with Google',
          icon: Assets.imagesGoogle,
          onTap: onGoogle,
        ),
        SizedBox(
          height: 12,
        ),
        // SocialButton(
        //   buttonText: 'Sign In with Twitter',
        //   icon: Assets.imagesTwitter,
        //   onTap: onTwitter,
        // ),
        // SizedBox(
        //   height: 12,
        // ),
        // SocialButton(
        //   buttonText: 'Sign In with Facebook',
        //   icon: Assets.imagesFacebook,
        //   onTap: onFacebook,
        // ),
      ],
    );
  }
}
