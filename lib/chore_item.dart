import 'package:flutter/material.dart';
import 'chore.dart';

// class for making the chore items in the list
class ChoreItem extends StatelessWidget {
  final Chore chore;
  final Function(Chore) deleteChore;
  final Function(Chore) toggleBox;
  final Function(Chore, String) editChoreText;

  ChoreItem(this.chore,
      {super.key,
      required this.deleteChore,
      required this.toggleBox,
      required this.editChoreText});

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
                icon: Icon(chore.isDone
                    ? Icons.check_box
                    : Icons.check_box_outline_blank_outlined),
                tooltip: 'Mark as done',
                onPressed: () {
                  toggleBox(chore);
                },
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    // the chore text
                    onTap: () {
                      //print(chore.text);
                      editChoreText(chore, chore.text);
                    }, // will be able to edit the text later
                    child: Text(
                      style: TextStyle(
                          decoration: chore.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none),
                      chore.text,
                      textScaleFactor: 1.2,
                    ),
                  ),
                  InkWell(
                    onTap:
                        () {}, // does nothing rn, edit the date later when clicked
                    child: Text(chore.year.isEmpty &&
                            chore.month.isEmpty &&
                            chore.day.isEmpty &&
                            chore.hour.isEmpty &&
                            chore.minute.isEmpty
                        ? 'No deadline'
                        : '${chore.year}/${chore.month}/${chore.day}    ${chore.hour}:${chore.minute}'),
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
