import 'package:flutter/material.dart';

class FAQ {
  String question;
  String answer;

  FAQ(this.question, this.answer);
}

FAQ f1 = FAQ('Do I have to set a deadline for my chore?',
    'No, the deadline is optional. Leaving the fields empty will result in a chore marked with "No deadline".');

FAQ f2 = FAQ('How is the chores listed?',
    'All the chores are listed by their deadlines, these with the nearest upcoming deadlines will be shown at the top of the list. By using the filter in the top right corner, you can choose to show all chores, only the done ones or the undone ones.');

FAQ f3 = FAQ('Can I edit my chores after they are created?',
    'Yes! By clicking on the chore text or the chore deadline, you will get a dialog window that allows you to edit the details as you wish.');

FAQ f4 = FAQ('How do I mark the chores as done?',
    'Each chore created has a checkbox at the left, by clicking it you can mark the chore as done or undone. Depending on the current filter, this can affect whether the chore is shown or not.');
// The list with all FAQ objects
List<FAQ> faqs = [f1, f2, f3, f4];

class FAQItem extends StatelessWidget {
  final FAQ faq;

  FAQItem(this.faq);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          Row(
            children: [
              Text('Q:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 2),
                  child: Text(
                    faq.question,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('A:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 2),
                  child: Text(
                    faq.answer,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontStyle: FontStyle.normal),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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
