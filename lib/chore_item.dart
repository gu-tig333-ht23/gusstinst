import 'package:flutter/material.dart';
import 'chore.dart';

// class for making the chore items in the list
class ChoreItem extends StatelessWidget {
  final Chore chore;
  final Function(Chore) deleteChore;

  ChoreItem(this.chore, {super.key, required this.deleteChore});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(3),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  icon: Icon(Icons.check_box_outline_blank_outlined),
                  tooltip: 'Mark as done',
                  onPressed: () {}
                  //toggleBox();, // Does nothing right now
                  ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {}, // will be able to edit the text later
                    child: Text(
                      chore.text,
                      textScaleFactor: 1.2,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Text(
                        '${chore.year}/${chore.month}/${chore.day}    ${chore.hour}:${chore.minute}'),
                    // does nothing rn, edit the date later when clicked
                  ),
                ],
              ),

              Spacer(), // to push the delete button to rightmost end of the row
              IconButton(
                icon: Icon(Icons.delete),
                tooltip: 'Delete',
                onPressed: () {
                  deleteChore(chore);
                }, // does nothing right now, will be able to delete from list
              ),
            ],
          ),
        ),
      ],
    );
  }
}
