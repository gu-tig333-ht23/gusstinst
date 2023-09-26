import 'package:flutter/material.dart';
import 'faq.dart';
import 'faq_item.dart';

// view for FAQs
class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // secures that itemCount isn`t below 0
    final itemCount = faqs.isEmpty ? 0 : faqs.length * 2 - 1;

    return Column(
      children: [
        Text('How does it work?'),
        Text('FAQ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Expanded(
          child: ListView.builder(
            itemCount: itemCount,
            itemBuilder: (context, index) {
              final faqIndex = index ~/ 2;
              if (index.isEven) {
                if (faqIndex < faqs.length) {
                  return Column(
                    children: [
                      FAQItem(faqs[faqIndex]),
                    ],
                  );
                }
              }
              return Divider(); // Display a Divider for odd indices
            },
          ),
        ),
      ],
    );
  }
}
