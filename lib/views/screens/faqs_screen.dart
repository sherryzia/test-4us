// lib/views/screens/faqs_screen.dart
import 'package:expensary/constants/colors.dart';
import 'package:expensary/controllers/faqs_controller.dart';
import 'package:expensary/views/widgets/custom_app_bar.dart';
import 'package:expensary/views/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FAQsScreen extends StatelessWidget {
  const FAQsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FAQsController controller = Get.put(FAQsController());
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        title: 'FAQs',
        type: AppBarType.withBackButton,
        hasUnderline: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              backgroundColor,
              backgroundColor.withOpacity(0.8),
              Color(0xFF1A1A2E).withOpacity(0.9),
            ],
          ),
        ),
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: kwhite.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: kwhite.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: kwhite.withOpacity(0.7),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        onChanged: (value) => controller.searchQuery.value = value,
                        style: TextStyle(
                          color: kwhite,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search FAQs',
                          hintStyle: TextStyle(
                            color: kwhite.withOpacity(0.5),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    Obx(() => controller.searchQuery.value.isNotEmpty
                      ? GestureDetector(
                          onTap: controller.clearSearch,
                          child: Icon(
                            Icons.close,
                            color: kwhite.withOpacity(0.7),
                          ),
                        )
                      : SizedBox.shrink()
                    ),
                  ],
                ),
              ),
            ),
            
            // FAQ list
            Expanded(
              child: Obx(() {
                final faqs = controller.filteredFAQs;
                
                if (faqs.isEmpty && controller.searchQuery.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          color: kwhite.withOpacity(0.5),
                          size: 64,
                        ),
                        SizedBox(height: 16),
                        MyText(
                          text: 'No matching FAQs found',
                          size: 18,
                          color: kwhite.withOpacity(0.7),
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  itemCount: faqs.length,
                  itemBuilder: (context, index) {
                    return _buildFAQItem(
                      controller,
                      faq: faqs[index],
                      index: controller.faqItems.indexOf(faqs[index]),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFAQItem(FAQsController controller, {required FAQItem faq, required int index}) {
    return Obx(() {
      final isExpanded = index < controller.expandedStates.length ? controller.expandedStates[index] : false;
      
      return Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: kblack2.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: kwhite.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Theme(
          data: ThemeData(
            dividerColor: Colors.transparent, // Remove the divider
          ),
          child: ExpansionTile(
            initiallyExpanded: isExpanded,
            onExpansionChanged: (expanded) {
              controller.toggleExpanded(index);
            },
            collapsedIconColor: kwhite,
            iconColor: kpurple,
            title: MyText(
              text: faq.question,
              size: 16,
              weight: FontWeight.w600,
              color: kwhite,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: MyText(
                  text: faq.answer,
                  size: 14,
                  color: kwhite.withOpacity(0.8),
                  lineHeight: 1.5,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
