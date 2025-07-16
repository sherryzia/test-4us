import 'package:affirmation_app/constants/app_colors.dart';
import 'package:affirmation_app/constants/app_images.dart';
import 'package:affirmation_app/constants/app_sizes.dart';
import 'package:affirmation_app/controllers/login_controller.dart';
import 'package:affirmation_app/main.dart';
import 'package:affirmation_app/view/screens/bottom_nav_bar/profile/favourite_affirmations/favourite_Affirmation.dart';
import 'package:affirmation_app/view/screens/bottom_nav_bar/profile/general/general.dart';
import 'package:affirmation_app/view/screens/bottom_nav_bar/profile/personal_details.dart';
import 'package:affirmation_app/view/screens/profile_settings/add_widget_to_home_screen.dart';
import 'package:affirmation_app/view/screens/bottom_nav_bar/profile/set_affirmation_reminder.dart';
import 'package:affirmation_app/view/screens/profile_settings/subscription.dart';
import 'package:affirmation_app/view/widget/common_image_view_widget.dart';
import 'package:affirmation_app/view/widget/my_button_widget.dart';
import 'package:affirmation_app/view/widget/my_text_widget.dart';
import 'package:affirmation_app/view/widget/simple_app_bar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  Map<String, dynamic>? _userData;
  String? _profileImageUrl;
  final LoginController _controller = Get.put(LoginController());

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
        _profileImageUrl = _userData?['profileImageUrl'];
      });
    }
  }

  String capitalizeEachWord(String input) {
    if (input.isEmpty) return input;
    return input.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    bool? premium = _userData?['premium'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SimpleAppBar(
          title: 'Profile',
        ),
        Expanded(
          child: ListView(
            padding: AppSize.DEFAULT,
            physics: BouncingScrollPhysics(),
            children: [
              Row(
                children: [
                  CommonImageView(
                    height: 80,
                    width: 80,
                    url: _profileImageUrl ?? dummyImg,
                    radius: 100,
                  ),
                  SizedBox(
                    width: 18,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MyText(
                          text:
                              "${_userData?['name'] != null ? capitalizeEachWord(_userData!['name']) : ''}",
                          size: 21,
                          weight: FontWeight.w600,
                          paddingBottom: 4,
                        ),
                        MyText(
                          text: " ${_user!.email}",
                        ),
                      ],
                    ),
                  )
                ],
              ),
              MyText(
                text: 'Settings',
                size: 21,
                weight: FontWeight.w600,
                paddingTop: 43,
                paddingBottom: 28,
              ),
              SettingTile(
                title: 'Personal Details',
                onTap: () {
                  Get.to(
                    () => PersonalDetails(),
                  );
                },
              ),
              SettingTile(
                title: 'General',
                onTap: () {
                  Get.to(
                    () => General(),
                  );
                },
              ),
              SettingTile(
                title: 'Payment Method',
                onTap: () {
                  Get.to(
                    () => Subscription(),
                  );
                },
              ),
              SettingTile(
                title: 'Reminder',
                onTap: () {
                  Get.to(
                    () => SetAffirmationReminder(),
                  );
                },
              ),
              SettingTile(
                title: 'Widgets',
                onTap: () {
                  Get.to(
                    () => AddWidgetToHomeScreen(),
                  );
                },
              ),
              MyText(
                text: 'Affirmation',
                size: 21,
                weight: FontWeight.w700,
                paddingTop: 30,
                paddingBottom: 30,
              ),
              SettingTile(
                title: 'Favorites',
                onTap: () {
                  Get.to(
                    () => FavAffirmationsView(isPremium: premium ?? false),
                  );
                },
              ),
              SizedBox(
                height: 30,
              ),
              MyButton(
                buttonText: 'Sign out',
                onTap: () => _controller.signOut(context),
              ),
              MyText(
                text: 'Follow us',
                size: 21,
                weight: FontWeight.w600,
                paddingTop: 30,
                paddingBottom: 22,
              ),
              Wrap(
                spacing: 12,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final Uri instagramUrl = Uri.parse(
                              'https://www.instagram.com/ocularvision_/');
                          if (await launchUrl(instagramUrl)) {
                            await launchUrl(instagramUrl,
                                mode: LaunchMode.externalApplication);
                          } else {
                            await launchUrl(instagramUrl,
                                mode: LaunchMode.externalApplication);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Could not launch Instagram')),
                            );
                          }
                        },
                        child: Image.asset(
                          Assets.imagesInstagramRounded,
                          height: 58,
                        ),
                      ),
                      MyText(
                        text: 'Instagram',
                        size: 8.19,
                        paddingTop: 1,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final Uri twitterUrl =
                              Uri.parse('https://x.com/OcularVision/');
                          if (await canLaunchUrl(twitterUrl)) {
                            await launchUrl(twitterUrl,
                                mode: LaunchMode.externalApplication);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Could not launch X')),
                            );
                          }
                        },
                        child: Image.asset(
                          Assets.imagesTwitterRounded,
                          height: 58,
                        ),
                      ),
                      MyText(
                        text: 'X',
                        size: 8.19,
                        paddingTop: 1,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final Uri facebookUrl = Uri.parse(
                              'https://www.facebook.com/61564434536637/');
                          if (await canLaunchUrl(facebookUrl)) {
                            await launchUrl(facebookUrl,
                                mode: LaunchMode.externalApplication);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Could not launch Facebook')),
                            );
                          }
                        },
                        child: Image.asset(
                          Assets.imagesFacebookRounded,
                          height: 58,
                        ),
                      ),
                      MyText(
                        text: 'Facebook',
                        size: 8.19,
                        paddingTop: 1,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SettingTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const SettingTile({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: kGreyColor7,
              width: 0.61,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Expanded(
                child: MyText(
                  text: title,
                  size: 15,
                ),
              ),
              Image.asset(
                Assets.imagesArrowRight2,
                height: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
