import 'package:flutter/material.dart';
import 'chore.dart';
import 'chore_list.dart';
import 'package:provider/provider.dart';

// class for making the chore items in the list
class ChoreItem extends StatelessWidget {
  final Chore chore;

  ChoreItem(this.chore);

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
                  Provider.of<ChoreList>(context, listen: false)
                      .toggleBox(chore);
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
                      // dialog box to edit the text
                      //editChoreText(chore, chore.text);
                    },
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
                    onTap: () {
                      //editChoreDeadline(chore, chore.year);
                    },
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
                  Provider.of<ChoreList>(context, listen: false)
                      .deleteChore(chore);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
