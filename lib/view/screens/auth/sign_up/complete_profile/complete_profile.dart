import 'package:candid/constants/app_images.dart';
import 'package:candid/utils/global_instances.dart';
import 'package:candid/view/screens/auth/sign_up/complete_profile/steps/gender.dart';
import 'package:candid/view/screens/auth/sign_up/complete_profile/steps/looking_for.dart';
import 'package:candid/view/widget/custom_background.dart';
import 'package:flutter/material.dart';
import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/view/widget/my_button_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({super.key});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (profileController.currentStep.value == 3) {
        return Gender();
      } else if (profileController.currentStep.value == 4) {
        return LookingFor();
      } else {
        return PopScope(
          canPop: false,
          onPopInvoked: (isPop) {
            if (isPop) return;
            profileController.onBack();
          },
          child: CustomBackground(
            bgImage: Assets.imagesBg,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 60,
                      bottom: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Obx(
                          () => ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: StepProgressIndicator(
                              totalSteps: profileController.items.length,
                              currentStep:
                                  profileController.currentStep.value + 1,
                              padding: 0,
                              selectedSize: 9,
                              unselectedSize: 9,
                              roundedEdges: Radius.circular(50),
                              selectedColor: kSecondaryColor,
                              unselectedColor: kPrimaryColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Obx(
                          () => Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  profileController.onBack();
                                },
                                child: Image.asset(
                                  Assets.imagesBack,
                                  height: 30,
                                ),
                              ),
                              Expanded(
                                child: MyText(
                                  text: profileController.items[
                                          profileController.currentStep.value]
                                      ['title'],
                                  size: 24,
                                  color: kPrimaryColor,
                                  weight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                  paddingLeft: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        profileController.currentStep.value == 2
                            ? SizedBox()
                            : Obx(
                                () => MyText(
                                  text: profileController.items[
                                          profileController.currentStep.value]
                                      ['subTitle'],
                                  size: 16,
                                  lineHeight: 1.5,
                                  color: kPrimaryColor.withOpacity(0.9),
                                  weight: FontWeight.w500,
                                  paddingTop: 16,
                                ),
                              )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(
                      () => IndexedStack(
                        index: profileController.currentStep.value,
                        children: profileController.steps,
                      ),
                    ),
                  ),
                  Padding(
                    padding: AppSizes.DEFAULT,
                    child: Obx(() => MyButton(
                      buttonText: profileController.currentStep.value == profileController.items.length - 1 
                          ? (profileController.isLoading.value ? 'Completing...' : 'Complete Profile')
                          : 'Continue',
                      // isLoading: profileController.isLoading.value,
                      onTap: () {
                        if (profileController.validateCurrentStep()) {
                          profileController.onNext();
                        }
                      },
                    )),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    });
  }
}