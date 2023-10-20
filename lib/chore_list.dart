import 'package:flutter/material.dart';
import 'chore.dart';
import 'api.dart';

// handles all changes to the list with chores
class ChoreList extends ChangeNotifier {
  List<Chore> _chores = [];

  List<Chore> get chores => _chores;

  // fetch chores and sorts them
  Future<void> fetchChores() async {
    var chores = await getChoresFromAPI();
    _chores = chores;
    sortChoresByDeadline(); //sorts the chores by deadline
    notifyListeners();
  }

  // add chores to API
  Future<bool> addNewChore(Chore chore) async {
    return await addChoreToAPI(chore);
  }

  // delete chores from API
  Future<bool> removeChore(Chore chore, int index) async {
    var choreID = _chores[index].id;
    return await deleteChoreFromAPI(choreID!);
  }

  // update the chore text in API
  Future<bool> editChoreTitle(Chore chore, String newtext, int index) async {
    var choreID = _chores[index].id; // identificates the chore ID
    return await updateAPIChore(choreID!, chore, newText: newtext);
  }

  // update the chore deadline
  Future<bool> editChoreDeadline(Chore chore, int index) async {
    var choreID = _chores[index].id; // identificates the chore ID
    return await updateAPIChore(choreID!, chore);
  }

  Future<bool> changeChoreStatus(Chore chore, int index) async {
    var choreID = _chores[index].id; // identificates the chore ID
    return await updateAPIStatus(choreID!, chore);
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
              onPressed: () async {
                bool apiresponse = await removeChore(chore, index);
                if (apiresponse) {
                  notifyListeners();
                  await fetchChores();
                  Navigator.of(context).pop();
                } else {
                  print('API call failed');
                }
              },
            ),
          ],
        );
      },
    );
  }

  // function that changes the chore`s icon when clicked, if API call is successful
  void toggleBox(Chore chore, int index) async {
    bool apiResponse = await changeChoreStatus(chore, index);
    if (apiResponse) {
      // API call successful/returns true
      chore.isDone = !chore.isDone;
      notifyListeners();
    } else {
      print('API call failed');
    }
  }

// function for editing the chore text in existing chores
  void editChoreText(BuildContext context, Chore chore, int index) {
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
              onPressed: () async {
                String newText = textEditController.text;
                bool apiresponse = await editChoreTitle(chore, newText, index);
                if (apiresponse) {
                  // Successful API call returns true
                  notifyListeners();
                  await fetchChores(); // retrieves new, sorted list with the newly added chore
                  Navigator.of(context).pop();
                } else {
                  print('API call failed');
                }
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

// function for editing the deadline in existing chores
  void editChoreDeadlineDialog(BuildContext context, Chore chore, int index) {
    TextEditingController dateController = TextEditingController(
        text: '${chore.day}/${chore.month}/${chore.year}'); // current date
    TextEditingController timeController = TextEditingController(
        text: '${chore.hour}:${chore.minute}'); // current time

    // function to show date picker
    Future<void> selectDate() async {
      final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 5),
      );
      if (selectedDate != null) {
        dateController.text =
            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
      }
    }

    // function to show time picker with current time
    Future<void> selectTime() async {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(
          hour: int.parse(chore.hour),
          minute: int.parse(chore.minute),
        ),
      );
      if (selectedTime != null) {
        timeController.text =
            '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit chore deadline'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () => selectDate(),
                child: IgnorePointer(
                  child: TextField(
                    controller: dateController,
                    decoration: InputDecoration(
                      labelText: 'Select Date',
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => selectTime(),
                child: IgnorePointer(
                  child: TextField(
                    controller: timeController,
                    decoration: InputDecoration(
                      labelText: 'Select Time',
                    ),
                  ),
                ),
              ),
            ],
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
              onPressed: () async {
                // retrieving date and time parameters from the text controllers
                final dateParts = dateController.text.split('/');
                final timeParts = timeController.text.split(':');

                String newDay = dateParts[0];
                String newMonth = dateParts[1];
                String newYear = dateParts[2];

                String newHour = timeParts[0];
                String newMinute = timeParts[1];

                // updates chore parameters
                chore.year = newYear;
                chore.month = newMonth;
                chore.day = newDay;
                chore.hour = newHour;
                chore.minute = newMinute;

                bool apiresponse = await editChoreDeadline(chore, index);
                if (apiresponse) {
                  // Successful API call
                  notifyListeners();
                  await fetchChores(); // retrieves new, sorted list with the newly added chore
                  Navigator.of(context).pop();
                } else {
                  print('API call failed');
                }
              },
            ),
            TextButton(
              child: Text(
                  'No deadline'), // will empty the strings, builds the chore item with 'No deadline'
              onPressed: () async {
                chore.year = '0000';
                chore.month = '00';
                chore.day = '00';
                chore.hour = '00';
                chore.minute = '00';

                bool apiresponse = await editChoreDeadline(chore, index);
                if (apiresponse) {
                  notifyListeners();
                  await fetchChores();
                  Navigator.of(context).pop();
                } else {
                  print('API call failed');
                }
              },
            ),
          ],
        );
      },
    );
  }
}
