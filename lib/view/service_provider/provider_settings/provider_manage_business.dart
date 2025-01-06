import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/constants/app_fonts.dart';
import 'package:forus_app/constants/app_sizes.dart';
import 'package:forus_app/generated/assets.dart';
import 'package:forus_app/view/widget/common_image_view_widget.dart';
import 'package:forus_app/view/widget/my_button_widget.dart';
import 'package:forus_app/view/widget/my_text_widget.dart';
import 'package:forus_app/view/widget/my_text_field.dart';

class ProviderManageBusinessScreen extends StatefulWidget {
  const ProviderManageBusinessScreen({super.key});

  @override
  State<ProviderManageBusinessScreen> createState() =>
      _ProviderManageBusinessScreenState();
}

class _ProviderManageBusinessScreenState
    extends State<ProviderManageBusinessScreen> {
  bool isToggled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemeColors.getTertiary(context),
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: CommonImageView(
              imagePath: Assets.imagesArrowLeft,
              height: 24,
            ),
          ),
        ),
        title: MyText(
          text: "Manage Business",
          size: 18,
          weight: FontWeight.w700,
        ),
        centerTitle: true,
      ),
   
   
      body: ListView(
        padding: AppSizes.DEFAULT2,
        children: [
          Column(
            children: [
              SizedBox(
                child: CommonImageView(
                  imagePath: Assets.imagesImagesSettingAvatar,
                  height: 88,
                ),
              ),
              MyText(
                text: "Change Profile Photo",
                size: 14,
                paddingTop: 10,
                paddingBottom: 17,
                weight: FontWeight.w500,
              ),
              MyTextField(
                hint: 'Grant Honey',
                hintColor: kTextGrey,
                labelColor: kWhite,
                radius: 8,
                suffix: Padding(
                  padding: const EdgeInsets.all(12),
                  child: CommonImageView(
                    imagePath: Assets.imagesPersongrey,
                    height: 22,
                  ),
                ),
                filledColor: kTransperentColor,
                kBorderColor: kBorderGrey,
                kFocusBorderColor: KColor1,
              ),
              MyTextField(
                hint: 'granthoney@gmail.com',
                hintColor: kTextGrey,
                labelColor: kWhite,
                radius: 8,
                suffix: Padding(
                  padding: const EdgeInsets.all(12),
                  child: CommonImageView(
                    imagePath: Assets.imagesPersongrey,
                    height: 22,
                  ),
                ),
                filledColor: kTransperentColor,
                kBorderColor: kBorderGrey,
                kFocusBorderColor: KColor1,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: kBorderGrey,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "+1",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.black),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: MyTextField(
                          marginBottom: 0,
                          hint: '000 0000 000',
                          hintColor: kTextGrey,
                          labelColor: kWhite,
                          radius: 8,
                          filledColor: kTransperentColor,
                          kBorderColor: kWhite,
                          kFocusBorderColor: kWhite,
                        ),
                      ),
                    ),
                    CommonImageView(
                      imagePath: Assets.imagesCall,
                      height: 22,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(18),
                margin: EdgeInsets.only(top: 16, bottom: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: kBorderGrey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: MyText(
                    text:
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text",
                    size: 15,
                    paddingBottom: 17,
                    weight: FontWeight.w500,
                  ),
                ),
              ),
              MyTextField(
                hint: 'www.bonton.com',
                hintColor: kTextGrey,
                labelColor: kWhite,
                radius: 8,
                suffix: Padding(
                  padding: const EdgeInsets.all(12),
                  child: CommonImageView(
                    imagePath: Assets.imagesGlobal,
                    height: 22,
                  ),
                ),
                filledColor: kTransperentColor,
                kBorderColor: kBorderGrey,
                kFocusBorderColor: KColor1,
              ),
              Container(
                padding: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: kBorderGrey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 10,
                  children: [
                    Row(
                      children: [
                        Gap(10),
                        CommonImageView(
                          imagePath: Assets.imagesPinLocation,
                          height: 22,
                        ),
                        Gap(5),
                        MyText(
                          text: "3719 Williams Mine Road Westfield, NJ 07090",
                          size: 14,
                          paddingTop: 20,
                          paddingBottom: 17,
                          weight: FontWeight.w500,
                        ),
                      ],
                    ),
                    CommonImageView(
                      imagePath: Assets.imagesEdit,
                      height: 22,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(
                    text: "Service Preferences",
                    size: 15,
                    paddingTop: 16,
                    weight: FontWeight.w800,
                  ),
                  MyText(
                    text: "Choose Other",
                    size: 14,
                    color: kTextOrange,
                    paddingTop: 16,
                    weight: FontWeight.w500,
                  ),
                ],
              ),
              Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Gap(20),
                  InkWell(
                    onTap: () {
                      // Get.to(() => ProviderSettingServicePreferenceScreen());
                    },
                    child: ImageTextWidget(
                      imagePath: Assets.imagesAttorneys,
                      text: "Attorneys",
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MyText(
                    text: "Availability",
                    size: 18,
                    paddingTop: 16,
                    weight: FontWeight.w800,
                  ),
                ],
              ),
              Container(
                padding: AppSizes.DEFAULT2,
                margin: EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(
                          text: "Monday",
                          weight: FontWeight.w800,
                          fontFamily: 'NunitoSans',
                        ),
                        Switch(
                          value: isToggled,
                          activeTrackColor: kTextDarkorange,
                          activeColor: kTextDarkorange,
                          inactiveThumbColor: kswtich,
                          inactiveTrackColor: kTextGrey,
                          onChanged: (value) {
                            setState(() {
                              isToggled = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: MyTextField(
                            height: 52,
                            hint: 'Start time',
                            hintColor: kTextGrey,
                            maxLines: 5,
                            labelColor: kWhite,
                            radius: 8,
                            suffix: Padding(
                              padding: const EdgeInsets.only(
                                  left: 12, right: 12, top: 12, bottom: 12),
                              child: CommonImageView(
                                imagePath: Assets.imagesClock,
                                height: 22,
                              ),
                            ),
                            kBorderColor: kBorderGrey,
                            kFocusBorderColor: KColor1,
                          ),
                        ),
                        Gap(13),
                        Expanded(
                          child: MyTextField(
                            height: 52,
                            hint: 'Start time',
                            hintColor: kTextGrey,
                            maxLines: 5,
                            labelColor: kWhite,
                            radius: 8,
                            suffix: Padding(
                              padding: const EdgeInsets.only(
                                  left: 12, right: 12, top: 12, bottom: 12),
                              child: CommonImageView(
                                imagePath: Assets.imagesClock,
                                height: 22,
                              ),
                            ),
                            kBorderColor: kBorderGrey,
                            kFocusBorderColor: KColor1,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SwitchWidget(text: 'Tuesday', isToggled: true),
              SwitchWidget(text: 'Wednesday', isToggled: false),
              SwitchWidget(text: 'Thursday', isToggled: false),
              SwitchWidget(text: 'Friday', isToggled: false),
              SwitchWidget(text: 'Saturday', isToggled: false),
              SwitchWidget(text: 'Sunday', isToggled: false),
              Gap(10),
              MyButton(
                buttonText: "Update & Save",
                radius: 14,
                textSize: 18,
                weight: FontWeight.w800,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ImageTextWidget extends StatelessWidget {
  final String imagePath;
  final String text;

  const ImageTextWidget({
    super.key,
    required this.imagePath,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonImageView(
          imagePath: imagePath,
          height: 66,
        ),
        MyText(
          text: text,
          size: 12,
          paddingTop: 8,
          fontFamily: AppFonts.NUNITO_SANS,
          weight: FontWeight.w800,
        ),
      ],
    );
  }
}

class SwitchWidget extends StatefulWidget {
  final String text;
  final bool isToggled;

  const SwitchWidget({
    Key? key,
    required this.text,
    this.isToggled = false,
  }) : super(key: key);

  @override
  _SwitchWidgetState createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  late bool _isToggled;

  @override
  void initState() {
    super.initState();
    _isToggled = widget.isToggled;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSizes.DEFAULT2,
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(
            text: widget.text,
            weight: FontWeight.w800,
            fontFamily: 'NunitoSans',
          ),
          Switch(
            value: _isToggled,
            // ignore: deprecated_member_use
            activeTrackColor: kTextDarkorange.withOpacity(0.4),
            activeColor: kTextDarkorange,
            inactiveThumbColor: kswtich,
            inactiveTrackColor: kTextGrey,
            onChanged: (value) {
              setState(() {
                _isToggled = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
