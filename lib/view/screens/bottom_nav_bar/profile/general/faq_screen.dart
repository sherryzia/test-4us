import 'package:affirmation_app/constants/app_sizes.dart';
import 'package:affirmation_app/view/screens/auth/sign_up/complete_profile.dart';
import 'package:affirmation_app/view/widget/simple_app_bar_widget.dart';
import 'package:affirmation_app/view/widget/my_text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  Future<List<Map<String, dynamic>>> _fetchFAQs() async {
    final snapshot = await FirebaseFirestore.instance.collection('faqs').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'question': data['question'] ?? 'No question',
        'answer': data['answer'] ?? 'No answer',
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: CustomBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SimpleAppBar(
              title: 'FAQ',
              haveLeading: true,
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchFAQs(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No FAQs available.'));
                  }

                  final faqs = snapshot.data!;
                  return ListView(
                    padding: AppSize.DEFAULT,
                    physics: BouncingScrollPhysics(),
                    children: faqs.map((faq) {
                      return FAQItem(
                        question: faq['question'] ?? 'No question',
                        answer: faq['answer'] ?? 'No answer',
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const FAQItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: question,
          size: 18,
          weight: FontWeight.w600,
          paddingTop: 16,
          paddingBottom: 8,
        ),
        MyText(
          text: answer,
          size: 16,
          weight: FontWeight.w400,
          paddingBottom: 16,
        ),
        Divider(color: Colors.grey),
      ],
    );
  }
}
