import 'package:flutter/material.dart';
import 'add_page.dart';
import 'chore.dart';
import 'help_page.dart';
import 'list_page.dart';
import 'package:provider/provider.dart';

// For the popupButton, filtering chores
enum FilterItem { all, done, undone }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo',
      theme: ThemeData(
        // This is the theme of the application.
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 4, 169, 106)),
        useMaterial3: true,

        // Theme for the App Bar
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
              fontFamily: 'Times New Roman', fontSize: 22, color: Colors.black),
        ),
      ),
      home: const MyHomePage(title: 'ToDo - get it done!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0; // home as default
  FilterItem selectedFilter =
      FilterItem.all; // initializes with the "all" filter

  List<Chore> chores = []; // list for all chores
  List<Chore> filteredChores = [];

  // function/method that adds new chores
  void addChore(Chore chore) {
    setState(() {
      chores.add(chore);
      updateFilteredLists();
    });
  }

  // function that deletes chores from the list
  void deleteChore(Chore chore) {
    setState(() {
      chores.remove(chore);
      updateFilteredLists();
    });
  }

  // function that changes the chore`s icon when clicked
  void toggleBox(Chore chore) {
    setState(() {
      chore.isDone = !chore.isDone;
      updateFilteredLists(); // update the filter list
    });
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
    setState(() {
      chores.sort(compareChoresByDeadline);
    });
  }

  // function to update filtered chores
  void updateFilteredLists() {
    filteredChores.clear(); // clears the lists first to avoid duplicates

    if (selectedFilter == FilterItem.all) {
      filteredChores = List.from(chores);
    } else if (selectedFilter == FilterItem.done) {
      filteredChores = filterDoneChores(chores);
    } else if (selectedFilter == FilterItem.undone) {
      filteredChores = filterUndoneChores(chores);
    }
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
  void editChoreText(Chore chore, String newtxt) {
    TextEditingController textEditController =
        TextEditingController(text: chore.text); //showing current text

    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                setState(() {
                  chore.text = newText;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

// function for editing the deadline in existing chores
  void editChoreDeadline(Chore chore, String year) {
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
                setState(() {
                  chore.year = newYear;
                  chore.month = newMonth;
                  chore.day = newDay;
                  chore.hour = newHour;
                  chore.minute = newMinute;
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                  'No deadline'), // will empty the strings, builds the chore item with 'No deadline'
              onPressed: () {
                setState(() {
                  chore.year = '';
                  chore.month = '';
                  chore.day = '';
                  chore.hour = '';
                  chore.minute = '';
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<Chore> getFilteredChores() {
    switch (selectedFilter) {
      case FilterItem.all:
        return chores;
      case FilterItem.done:
        return filterDoneChores(chores);
      case FilterItem.undone:
        return filterUndoneChores(chores);
      default:
        return chores;
    }
  }

  List<Chore> getChores() {
    return getFilteredChores();
  }

  // Här byggs sidinhållet, anropas vid varje setState
  @override
  Widget build(BuildContext context) {
    updateFilteredLists(); // updates the filtered chore lists
    sortChoresByDeadline(); // sorts the chores before building the page

    Widget
        page; // this widget switches between views when navigation rail is used
    switch (selectedIndex) {
      case 0: // home
        page = ListPage(
          getChores,
          deleteChore: deleteChore,
          toggleBox: toggleBox,
          editChoreText: editChoreText,
          editChoreDeadline: editChoreDeadline,
        );
        break;
      case 1: // help
        page = HelpPage();
        break;
      case 2: // add chore
        page = AddPage(addChore);
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    // builds the main layout surrounding all the pages/views
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: PopupMenuButton<FilterItem>(
                icon: Icon(Icons.filter_alt),
                onSelected: (FilterItem item) {
                  setState(() {
                    selectedFilter = item;
                    updateFilteredLists();
                  });
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<FilterItem>>[
                  const PopupMenuItem<FilterItem>(
                    value: FilterItem.all,
                    child: Text('all chores'),
                  ),
                  const PopupMenuItem<FilterItem>(
                    value: FilterItem.done,
                    child: Text('done'),
                  ),
                  const PopupMenuItem<FilterItem>(
                    value: FilterItem.undone,
                    child: Text('undone'),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Container(
          color: Theme.of(context).colorScheme.inversePrimary,
          child: Row(
            children: [
              SafeArea(
                // will not be overlapped
                child: NavigationRail(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.help),
                      label: Text('Help'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.add_task),
                      label: Text('Add chore'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),

              // padded card with round edges with
              // the page/view inside it
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 70, right: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: page,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
