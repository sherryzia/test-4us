// signup_screen.dart
import 'package:affirmation_app/controllers/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:affirmation_app/constants/app_colors.dart';
import 'package:affirmation_app/constants/app_fonts.dart';
import 'package:affirmation_app/constants/app_images.dart';
import 'package:affirmation_app/constants/app_sizes.dart';
import 'package:affirmation_app/view/screens/auth/login/login.dart';
import 'package:affirmation_app/view/widget/headings_widget.dart';
import 'package:affirmation_app/view/widget/my_button_widget.dart';
import 'package:affirmation_app/view/widget/my_text_widget.dart';
import 'package:affirmation_app/view/widget/my_textfield_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:affirmation_app/controllers/login_controller.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final SignUpController _signUpController = Get.put(SignUpController());
  final LoginController _controller = Get.put(LoginController());

  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
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
                      automaticallyImplyLeading: false,
                      pinned: false,
                      floating: false,
                      backgroundColor: Colors.transparent,
                      expandedHeight: 125,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AuthHeading(
                              paddingTop: 0,
                              paddingBottom: 0,
                              title: 'Create an account,',
                              subTitle:
                                  'Please type full information below and we can create your account',
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
                              controller: _nameController,
                              hintText: 'Name',
                              havePrefix: true,
                              prefixIcon: Assets.imagesProfileIcon,
                            ),
                            MyTextField(
                              controller: _emailController,
                              hintText: 'Email address',
                              havePrefix: true,
                              prefixIcon: Assets.imagesMail,
                            ),
                            MyTextField(
                              controller: _passwordController,
                              hintText: 'Password',
                              havePrefix: true,
                              haveSuffix: true,
                              isObSecure: _obscurePassword,
                              prefixIcon: Assets.imagesLock,
                              suffixIcon: Assets.imagesEye,
                              onSuffixTap: _togglePasswordVisibility,
                            ),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 12.33,
                                  fontFamily: AppFonts.MONTSERRAT,
                                ),
                                children: [
                                  TextSpan(
                                      text: 'By signing up you agree to our '),
                                  TextSpan(
                                    text: 'Term of use and privacy ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontFamily:
                                          GoogleFonts.nunitoSans().fontFamily,
                                    ),
                                  ),
                                  TextSpan(text: 'notice'),
                                ],
                              ),
                            ),
                            SizedBox(height: 36),
                            MyButton(
                              buttonText: 'Sign up',
                              onTap: () {
                                final name = _nameController.text.trim();
                                final email = _emailController.text.trim();
                                final password =
                                    _passwordController.text.trim();
                                _signUpController.signUp(
                                    name, email, password, context);
                              },
                            ),
                            SizedBox(height: 12),
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
                            SizedBox(height: 18),
                            SocialLogin(
                              onFacebook: () {},
                              onGoogle: () =>
                                  _controller.signInWithGoogle(context),
                              onTwitter: () {},
                            ),
                            SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: kBlackColor.withOpacity(0.5),
                padding: AppSize.DEFAULT,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    MyText(
                      text: 'Already have an account? ',
                      size: 13.87,
                    ),
                    MyText(
                      text: 'Sign in',
                      size: 13.87,
                      weight: FontWeight.w600,
                      onTap: () => Get.back(),
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
