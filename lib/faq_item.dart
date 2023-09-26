import 'faq.dart';
import 'package:flutter/material.dart';

// widget for showing FAQ objects
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
