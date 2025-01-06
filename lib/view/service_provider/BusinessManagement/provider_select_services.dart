import 'package:flutter/material.dart';
import 'package:forus_app/controllers/service_provider/BusinessManagement/GetServicesController.dart';
import 'package:forus_app/view/service_provider/BusinessManagement/provider_business_details.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:forus_app/constants/app_colors.dart';
import 'package:forus_app/constants/app_fonts.dart';
import 'package:forus_app/constants/app_sizes.dart';
import 'package:forus_app/generated/assets.dart';
import 'package:forus_app/view/widget/common_image_view_widget.dart';
import 'package:forus_app/view/widget/my_button_widget.dart';
import 'package:forus_app/view/widget/my_text_widget.dart';

class ProviderSelectServicesScreen extends StatefulWidget {
  const ProviderSelectServicesScreen({super.key});

  @override
  State<ProviderSelectServicesScreen> createState() => _ProviderSelectServicesScreenState();
}

class _ProviderSelectServicesScreenState extends State<ProviderSelectServicesScreen> {
  final GetServicesController controller = Get.put(GetServicesController());
  final Set<String> selectedServices = {};

  void toggleService(int serviceId) {
    setState(() {
      if (selectedServices.contains(serviceId.toString())) {
        selectedServices.remove(serviceId.toString());
      } else {
        selectedServices.add(serviceId.toString());
      }
    });
  }



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
      ),
      backgroundColor: AppThemeColors.getTertiary(context),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: AppSizes.DEFAULT2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    MyText(
                      text: 'Choose Service Type',
                      size: 24,
                      textAlign: TextAlign.center,
                      fontFamily: AppFonts.NUNITO_SANS,
                      weight: FontWeight.w800,
                    ),
                    MyText(
                      text: 'Please choose your service type',
                      size: 16,
                      paddingTop: 5,
                      paddingBottom: 22,
                      textAlign: TextAlign.center,
                      color: kTextGrey,
                      fontFamily: AppFonts.NUNITO_SANS,
                      weight: FontWeight.w500,
                    ),
                    ...buildServiceRows(controller.services),
                  ],
                ),
              ),
              MyButton(
                buttonText: "Next",
                radius: 14,
                textSize: 18,
                weight: FontWeight.w800,
                onTap: () {
                  Get.to(() => ProviderBusinessDetailsScreen(
                        selectedServices: selectedServices.toList(),
                      ));
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  List<Widget> buildServiceRows(List<dynamic> services) {
    List<Widget> rows = [];
    for (int i = 0; i < services.length; i += 3) {
      rows.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: services
          .skip(i)
          .take(3)
          .map((service) => GestureDetector(
                onTap: () => toggleService(service['id']), // Use service ID here
                child: CircleImageTextWidget(
                  imagePath: service['image'],
                  text: service['name'],
                  isSelected: selectedServices.contains(service['id'].toString()), // Match by ID
                ),
              ))
          .toList(),
        ),
      ));
    }
    return rows;
  }
}

class CircleImageTextWidget extends StatelessWidget {
  final String imagePath;
  final String text;
  final bool isSelected;

  const CircleImageTextWidget({
    super.key,
    required this.imagePath,
    required this.text,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? KColor1 : Colors.transparent,
              width: 3,
            ),
          ),
          padding: const EdgeInsets.all(4),
          child: ClipOval(
            child: Image.network(
              imagePath,
              height: 66,
              width: 66,
              fit: BoxFit.cover,
            ),
          ),
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
