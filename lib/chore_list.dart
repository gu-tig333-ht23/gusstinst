import 'package:flutter/material.dart';
import 'chore.dart';
import 'package:provider/provider.dart';

// handles all changes to the list with chores
class ChoreList extends ChangeNotifier {
  final List<Chore> _chores = [];

  List<Chore> get chores => _chores;

  // function/method that adds new chores
  void addChore(Chore chore) {
    _chores.add(chore);
    notifyListeners();
  }

  // function that deletes chores from the list
  void deleteChore(Chore chore) {
    _chores.remove(chore);
    notifyListeners();
  }

  // function that changes the chore`s icon when clicked
  void toggleBox(Chore chore) {
    chore.isDone = !chore.isDone;
    notifyListeners();
  }

  // function that compares chores based on their deadlines
  int compareChoresByDeadline(Chore a, Chore b) {
    // converting the deadline parameters to DateTime format
    DateTime deadlineA = DateTime(
      int.tryParse(a.year) ?? 0,
      int.tryParse(a.month) ?? 0,
      int.tryParse(a.day) ?? 0,
      int.tryParse(a.hour) ?? 0,
      int.tryParse(a.minute) ?? 0,
    );
    DateTime deadlineB = DateTime(
      int.tryParse(b.year) ?? 0,
      int.tryParse(b.month) ?? 0,
      int.tryParse(b.day) ?? 0,
      int.tryParse(b.hour) ?? 0,
      int.tryParse(b.minute) ?? 0,
    );

    // compares the deadlines
    // if both chores does not have any deadline
    if (deadlineA.isAtSameMomentAs(DateTime(0, 0, 0, 0, 0)) &&
        deadlineB.isAtSameMomentAs(DateTime(0, 0, 0, 0, 0))) {
      return 0; // same value
    }
    // if one of the chores has no deadline, it comes after the other
    if (deadlineA.isAtSameMomentAs(DateTime(0, 0, 0, 0, 0))) {
      return 1;
    } else if (deadlineB.isAtSameMomentAs(DateTime(0, 0, 0, 0, 0))) {
      return -1;
    }
    // compares chores with valid deadlines
    return deadlineA.compareTo(deadlineB);
    // returns -1 if A is before B, 0 if A and B is the same
    // and 1 if B is before A
  }

  // function to sort the chores list according to deadlines
  void sortChoresByDeadline() {
    chores.sort(compareChoresByDeadline);
    notifyListeners();
  }

// function to filter the chores that are done
  List<Chore> filterDoneChores(List<Chore> chores) {
    List<Chore> doneChores = [];
    for (var c = 0; c < chores.length; c++) {
      if (chores[c].isDone) {
        doneChores.add(chores[c]);
      }
    }
    return doneChores;
  }

// function to filter the undone chores
  List<Chore> filterUndoneChores(List<Chore> chores) {
    List<Chore> undoneChores = [];
    for (var c = 0; c < chores.length; c++) {
      if (!chores[c].isDone) {
        undoneChores.add(chores[c]);
      }
    }
    return undoneChores;
  }

// function for editing the chore text in existing chores
  void editChoreText(BuildContext context, Chore chore, String newtxt) {
    TextEditingController textEditController =
        TextEditingController(text: chore.text); //showing current text

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit chore text'),
          content: TextField(
            controller: textEditController,
            decoration: InputDecoration(labelText: 'Chore Text'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                String newText = textEditController.text;
                print(newText); // control
                chore.text = newText;
                notifyListeners();

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

// function for editing the deadline in existing chores
  void editChoreDeadline(BuildContext context, Chore chore, String year) {
    TextEditingController deadlineEditController =
        //showing current deadline
        TextEditingController(
            text:
                '${chore.year}/${chore.month}/${chore.day}    ${chore.hour}:${chore.minute}');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit chore deadline'),
          content: TextField(
            controller: deadlineEditController,
            decoration:
                InputDecoration(labelText: 'Format YYYY/MM/DD    HH:MM'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                // saving new parameters as substrings of input
                String newYear = deadlineEditController.text.substring(0, 4);
                String newMonth = deadlineEditController.text.substring(5, 7);
                String newDay = deadlineEditController.text.substring(8, 10);
                String newHour = deadlineEditController.text.substring(
                    deadlineEditController.text.length - 5,
                    deadlineEditController.text.length - 3);
                String newMinute = deadlineEditController.text.substring(
                    deadlineEditController.text.length - 2,
                    deadlineEditController.text.length);

                // updates chore parameters
                chore.year = newYear;
                chore.month = newMonth;
                chore.day = newDay;
                chore.hour = newHour;
                chore.minute = newMinute;
                notifyListeners();

                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                  'No deadline'), // will empty the strings, builds the chore item with 'No deadline'
              onPressed: () {
                chore.year = '';
                chore.month = '';
                chore.day = '';
                chore.hour = '';
                chore.minute = '';
                notifyListeners();

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
