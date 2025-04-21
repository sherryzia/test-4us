import 'package:ecomanga/common/app_colors.dart';
import 'package:ecomanga/features/auth/screens/register_screen.dart';
import 'package:ecomanga/features/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnbordingScreen extends StatefulWidget {
  const OnbordingScreen({super.key});

  @override
  State<OnbordingScreen> createState() => _OnbordingScreenState();
}

class _OnbordingScreenState extends State<OnbordingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    _controller.addListener(() => setState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
    _pageController.addListener(
      () => setState(
        () {
          page = _pageController.page ?? 0;
        },
      ),
    );
  }

  double page = 0;
  List<Color> circleColors = [
    Colors.green,
    Colors.purple,
    Colors.amber,
    Colors.blue,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Stack(
          children: [
            Positioned.fill(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: [
                  _onboardingText(
                    imageAddress: "assets/images/img1.png",
                    title: "Earn Rewards for Eco-Actions",
                    subtitle:
                        'Complete challenges,earn point,and unlock rewards for making planet-friendly choices that benefits the community.',
                  ),
                  _onboardingText(
                    imageAddress: "assets/images/img2.png",
                    title: "Join the Eco-Community",
                    subtitle:
                        'Connect with like-minded individuals, share achievements, and inspire each other to live more sustainability every day.',
                  ),
                  _onboardingText(
                    imageAddress: "assets/images/img2.png",
                    title: "Shop Eco-Friendly Products",
                    subtitle:
                        'Discover sustainable products and exclusive discounts from eco-conscious brands, making it easy to shop green and live sustainabily',
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  const Spacer(flex: 4),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CircularProgressIndicator(
                            color: AppColors.buttonColor,
                            value: (page + 1) / 3,
                            strokeWidth: 4,
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Positioned.fill(
                          top: 5,
                          bottom: 5,
                          left: 5,
                          right: 5,
                          child: GestureDetector(
                            child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  // _animation.value,
                                ),
                                child: Center(
                                  child: Text(
                                    "${(page + 1).toInt().toString()}/3",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      // color: AppColors.buttonColor,
                                    ),
                                  ),
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.paddingOf(context).bottom + 30),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  const Spacer(flex: 4),
                  SizedBox(
                    width: 130,
                    height: 45,
                    child: GestureDetector(
                      onTap: () {
                        if (page.round() == 2) {
                          Utils.go(
                              context: context,
                              screen: const RegisterScreen(),
                              replace: true);
                        }
                        _controller.dispose();
                        _controller = AnimationController(
                          vsync: this,
                          duration: const Duration(milliseconds: 400),
                        );

                        _controller.forward();
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.fastEaseInToSlowEaseOut,
                        );
                      },
                      child: Container(
                        width: 130.w,
                        decoration: BoxDecoration(
                            color: AppColors.buttonColor,
                            borderRadius: BorderRadius.circular(5)
                            // _animation.value,
                            ),
                        child: Center(
                            child: page + 1 == 3
                                ? const Text(
                                    "Get Started",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Next  ",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                      )
                                    ],
                                  )),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.paddingOf(context).bottom + 30),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _onboardingText({
    // required String imgAddress,
    required String title,
    required String subtitle,
    required String imageAddress,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Image.asset(
          imageAddress,
        ),
        // const Spacer(flex: 1),
        Text(
          title,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 27.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.normal,
          ),
        ),
        SizedBox(
          height: MediaQuery.paddingOf(context).bottom + 150,
        )
      ],
    );
  }
}
