import 'package:flutter/material.dart';
import 'chore.dart';

// handles all changes to the list with chores
class ChoreList extends ChangeNotifier {
  List<Chore> _chores = [];

  List<Chore> get chores => _chores;

  // fetch chores from API
  Future<void> fetchChores() async {
    var chores = await getChoresFromAPI();
    _chores = chores;
    notifyListeners();
  }

  // add chores to API
  void addNewChore(Chore chore) async {
    await addChoreToAPI(chore);
    _chores = await getChoresFromAPI();
    notifyListeners();
  }

  // delete chores from API
  void removeChore(Chore chore, int index) async {
    var choreID = _chores[index].id;

    await deleteChoreFromAPI(choreID!);
    notifyListeners();
  }

  // update the chore text in API
  void editChoreTitle(Chore chore, String newtext, int index) async {
    var choreID = _chores[index].id; // identificates the chore ID
    await updateChoreTextInAPI(choreID!, chore, newtext);
    notifyListeners();
  }

  void changeChoreStatus(Chore chore, int index) async {
    var choreID = _chores[index].id; // identificates the chore ID
    await updateAPIStatus(choreID!, chore);
    notifyListeners();
  }

  // function that deletes chores from the list
  void deleteChore(BuildContext context, Chore chore, int index) {
    // dialog box checks if user is sure about deleting
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete this chore?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                removeChore(chore, index);
                notifyListeners();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // function that changes the chore`s icon when clicked
  void toggleBox(Chore chore, int index) {
    chore.isDone = !chore.isDone;
    changeChoreStatus(chore, index);
    notifyListeners();
  }

// function for editing the chore text in existing chores
  void editChoreText(
      BuildContext context, Chore chore, String newtxt, int index) {
    TextEditingController textEditController =
        TextEditingController(text: chore.text); //showing current chore text

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
                editChoreTitle(chore, newText, index);

                notifyListeners();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // function that converts the deadline parameters to DateTime format
  DateTime convertDeadlineToDT(Chore chore) {
    DateTime deadlineAsDT = DateTime(
      int.tryParse(chore.year) ?? 0,
      int.tryParse(chore.month) ?? 0,
      int.tryParse(chore.day) ?? 0,
      int.tryParse(chore.hour) ?? 0,
      int.tryParse(chore.minute) ?? 0,
    );
    return deadlineAsDT;
  }

  // function that compares chores based on their deadlines
  int compareChoresByDeadline(Chore a, Chore b) {
    // converting the deadline parameters to DateTime format
    DateTime deadlineA = convertDeadlineToDT(a);
    DateTime deadlineB = convertDeadlineToDT(b);

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
    _chores.sort(compareChoresByDeadline);
    notifyListeners();
  }
}

/*
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
*/
