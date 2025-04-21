import 'package:ecomanga/common/app_colors.dart';
import 'package:ecomanga/common/buttons/scale_button.dart';
import 'package:ecomanga/features/challenges/challenge_screen.dart';
import 'package:ecomanga/features/community/community_screen.dart';
import 'package:ecomanga/features/home/home_screen.dart';
import 'package:ecomanga/features/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({
    super.key,
  });

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final List<Widget> screenList = [
    const HomeScreen(),
    const ChallengeScreen(),
    const CommunityScreen(),
    ProfileScreen(),
  ];
  int selectedIndex = 0;
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const HomeScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        child: SizedBox(
          height: 40.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ScaleButton(
                scale: .97,
                onTap: () {
                  setState(() {
                    currentScreen = const HomeScreen();
                    selectedIndex = 0;
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 7.h),
                  padding:
                      EdgeInsets.symmetric(vertical: 7.h, horizontal: 10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: selectedIndex == 0 ? AppColors.buttonColor : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Iconsax.home,
                        color: selectedIndex == 0
                            ? Colors.white
                            : AppColors.buttonColor,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      if (selectedIndex == 0)
                        Text(
                          "Home",
                          style: TextStyle(
                            color: selectedIndex == 0
                                ? Colors.white
                                : AppColors.buttonColor,
                          ),
                        )
                    ],
                  ),
                ),
              ),
              ScaleButton(
                scale: .97,
                onTap: () {
                  setState(() {
                    currentScreen = const ChallengeScreen();
                    selectedIndex = 1;
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 7.h),
                  padding:
                      EdgeInsets.symmetric(vertical: 7.h, horizontal: 10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: selectedIndex == 1 ? AppColors.buttonColor : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.diamond_outlined,
                        color: selectedIndex == 1
                            ? Colors.white
                            : AppColors.buttonColor,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      if (selectedIndex == 1)
                        Text(
                          "Challenges",
                          style: TextStyle(
                            color: selectedIndex == 1
                                ? Colors.white
                                : AppColors.buttonColor,
                          ),
                        )
                    ],
                  ),
                ),
              ),
              ScaleButton(
                scale: .97,
                onTap: () {
                  setState(() {
                    currentScreen = const CommunityScreen();
                    selectedIndex = 2;
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 7.h),
                  padding:
                      EdgeInsets.symmetric(vertical: 7.h, horizontal: 10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: selectedIndex == 2 ? AppColors.buttonColor : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Iconsax.people,
                        color: selectedIndex == 2
                            ? Colors.white
                            : AppColors.buttonColor,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      if (selectedIndex == 2)
                        Text(
                          "Community",
                          style: TextStyle(
                            color: selectedIndex == 2
                                ? Colors.white
                                : AppColors.buttonColor,
                          ),
                        )
                    ],
                  ),
                ),
              ),
              ScaleButton(
                scale: .97,
                onTap: () {
                  setState(() {
                    currentScreen = ProfileScreen();
                    selectedIndex = 3;
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 7.h),
                  padding:
                      EdgeInsets.symmetric(vertical: 7.h, horizontal: 10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: selectedIndex == 3 ? AppColors.buttonColor : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.person,
                        color: selectedIndex == 3
                            ? Colors.white
                            : AppColors.buttonColor,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      if (selectedIndex == 3)
                        Text(
                          "profile",
                          style: TextStyle(
                            color: selectedIndex == 3
                                ? Colors.white
                                : AppColors.buttonColor,
                          ),
                        )
                    ],
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
