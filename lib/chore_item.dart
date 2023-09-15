import 'package:flutter/material.dart';
import 'chore.dart';
import 'chore_list.dart';
import 'package:provider/provider.dart';

// class/widget for viewing the chore items in the list
class ChoreItem extends StatelessWidget {
  final Chore chore;

  ChoreItem(this.chore);

  @override
  Widget build(BuildContext context) {
    Color getColorForChoreStatus(chore) {
      final now = DateTime.now();
      final choreDeadline = Provider.of<ChoreList>(context, listen: false)
          .convertDeadlineToDT(chore);
      final timeDifference = choreDeadline.difference(now);
      print(timeDifference);

      if (timeDifference.inDays >= 2 ||
          chore.year.isEmpty &&
              chore.month.isEmpty &&
              chore.day.isEmpty &&
              chore.hour.isEmpty &&
              chore.minute.isEmpty) {
        // two or more days left or no deadline set
        return Colors.green;
      } else if (timeDifference.inDays < 2 && timeDifference.inHours >= 4) {
        // less than two days left but more than 4 hours
        return Colors.yellow;
      } else if (timeDifference.inHours < 4 && timeDifference.inHours >= 0) {
        // less than four hours left
        return Colors.orange;
      } else if (timeDifference.isNegative) {
        // deadline passed
        return const Color.fromARGB(255, 79, 8, 3);
      } else {
        print('Default color');
        return Colors.green;
      }
    }

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
                      Provider.of<ChoreList>(context, listen: false)
                          .editChoreText(context, chore, chore.text);
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
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: getColorForChoreStatus(chore),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: InkWell(
                        onTap: () {
                          // dialog box to edit the deadline
                          Provider.of<ChoreList>(context, listen: false)
                              .editChoreDeadline(context, chore, chore.year);
                        },
                        child: Text(
                          chore.year.isEmpty &&
                                  chore.month.isEmpty &&
                                  chore.day.isEmpty &&
                                  chore.hour.isEmpty &&
                                  chore.minute.isEmpty
                              ? 'No deadline'
                              : '${chore.year}/${chore.month}/${chore.day}    ${chore.hour}:${chore.minute}',
                          style: TextStyle(
                              color: getColorForChoreStatus(chore) ==
                                      const Color.fromARGB(255, 79, 8, 3)
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Spacer(), // to push the delete button to rightmost end of the row
              IconButton(
                icon: Icon(Icons.delete),
                tooltip: 'Delete',
                onPressed: () {
                  Provider.of<ChoreList>(context, listen: false)
                      .deleteChore(context, chore);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
