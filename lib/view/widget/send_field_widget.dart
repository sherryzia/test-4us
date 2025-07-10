import 'dart:ui';

import 'package:candid/constants/app_colors.dart';
import 'package:candid/constants/app_images.dart';
import 'package:candid/constants/app_sizes.dart';
import 'package:candid/view/widget/my_button_widget.dart';
import 'package:candid/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class SendField extends StatefulWidget {
  SendField({
    Key? key,
    this.dateType,
    this.controller,
    this.onChanged,
    this.validator,
    this.onSendTap,
    this.onImagePick,
    this.onOfferTap,
    this.isOnTourGuide = false,
  }) : super(key: key);

  String? dateType;
  TextEditingController? controller;
  ValueChanged<String>? onChanged;
  FormFieldValidator<String>? validator;
  VoidCallback? onSendTap;
  VoidCallback? onImagePick;
  VoidCallback? onOfferTap;
  bool? isOnTourGuide;

  @override
  State<SendField> createState() => _SendFieldState();
}

class _SendFieldState extends State<SendField> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 80,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.bottomSheet(
                      _PlayGame(),
                      isScrollControlled: true,
                      barrierColor: Colors.transparent,
                    );
                  },
                  child: Image.asset(
                    Assets.imagesGame,
                    height: 46,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: kPrimaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: kBlackColor.withOpacity(0.05),
                          offset: Offset(0, 4),
                          blurRadius: 100,
                        ),
                      ],
                    ),
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      onChanged: widget.onChanged,
                      controller: widget.controller,
                      validator: widget.validator,
                      cursorColor: kQuaternaryColor,
                      style: TextStyle(
                        fontSize: 12,
                        color: kQuaternaryColor,
                      ),
                      decoration: InputDecoration(
                        suffixIcon: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              children: [
                                Image.asset(
                                  Assets.imagesVoice,
                                  height: 20,
                                ),
                                Image.asset(
                                  Assets.imagesCamera,
                                  height: 20,
                                ),
                                Container(
                                  height: 44,
                                  width: 44,
                                  padding: EdgeInsets.only(left: 3),
                                  margin: EdgeInsets.only(right: 3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: kSecondaryColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: kBlackColor.withOpacity(0.05),
                                        offset: Offset(0, 4),
                                        blurRadius: 100,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.send,
                                    color: kPrimaryColor,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 0,
                        ),
                        hintText: 'Type here...',
                        hintStyle: TextStyle(
                          fontSize: 12,
                          color: kQuaternaryColor.withOpacity(0.8),
                        ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayGame extends StatelessWidget {
  const _PlayGame({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 30,
            sigmaY: 30,
          ),
          child: Container(
            height: Get.height * 0.66,
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 12),
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: kSecondaryColor,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    padding: AppSizes.DEFAULT,
                    physics: BouncingScrollPhysics(),
                    children: [
                      Center(
                        child: Image.asset(
                          Assets.imagesLetsplay,
                          height: 45,
                        ),
                      ),
                      MyText(
                        paddingTop: 16,
                        text: 'Keep the chat lively by playing the ',
                        size: 20,
                        weight: FontWeight.w600,
                        textAlign: TextAlign.center,
                        paddingBottom: 20,
                      ),
                      MyText(
                        text: 'Curiosity Game',
                        size: 32,
                        weight: FontWeight.w600,
                        textAlign: TextAlign.center,
                        paddingBottom: 20,
                      ),
                      Center(
                        child: Image.asset(
                          Assets.imagesGameIcon,
                          height: 63,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              kSecondaryColor,
                              kPurpleColor,
                            ],
                          ),
                        ),
                        child: Column(
                          children: [
                            MyText(
                              text:
                                  'If you could instantly master any skill or talent, what would it be and why?',
                              size: 16,
                              weight: FontWeight.w600,
                              color: kPrimaryColor,
                              lineHeight: 1.5,
                              paddingBottom: 16,
                              textAlign: TextAlign.center,
                            ),
                            Image.asset(
                              Assets.imagesRegenerate,
                              height: 30,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding: AppSizes.HORIZONTAL,
                              child: MyButton(
                                height: 45,
                                textSize: 14,
                                weight: FontWeight.w600,
                                buttonText: 'Send Message',
                                bgColor: kPrimaryColor,
                                textColor: kSecondaryColor,
                                onTap: () {
                                  Get.back();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
