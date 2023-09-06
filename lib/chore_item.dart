import 'package:flutter/material.dart';

import 'chore.dart';

// class for making the chore items in the list
class ChoreItem extends StatelessWidget {
  final Chore chore;
  ChoreItem(this.chore, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(3),
          child: Row(
            children: [
              IconButton(
                  icon: Icon(Icons.check_box_outline_blank_outlined),
                  tooltip: 'Mark as done',
                  onPressed: () {}
                  //toggleBox();, // Does nothing right now
                  ),
              TextButton(
                  child: Text(chore.text),
                  onPressed: () {}), // does nothing right now, will be able to
              // edit the text later when clicked
              Spacer(), // to push the delete button to rightmost end of the row
              IconButton(
                icon: Icon(Icons.delete),
                tooltip: 'Delete',
                onPressed: () {}, // does nothing right now
              ),
            ],
          ),
        ),
      ],
    );
  }
}
