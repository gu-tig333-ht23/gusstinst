import 'package:flutter/material.dart';
import 'add_page.dart';
import 'chore.dart';
import 'help_page.dart';
import 'list_page.dart';
import 'package:provider/provider.dart';
import 'chore_item.dart';

// For the popupButton, filtering chores
enum FilterItem { all, done, undone }

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MyAppState(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChoreList(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChoreItem(chore),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyAppState extends ChangeNotifier {
  var selectedIndex = 0;
  FilterItem selectedFilter = FilterItem.all;

  // function for setting index when switching pages/views
  void setIndex(var index) {
    selectedIndex = index;
    notifyListeners();
  }

  // function for setting filter when chosen
  void setFilter(FilterItem item) {
    selectedFilter = item;
    notifyListeners();
  }
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
      home: MyHomePage(title: 'ToDo - get it done!'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  //List<Chore> chores = []; // list for all chores
  //List<Chore> filteredChores = [];

  @override
  Widget build(BuildContext context) {
    final myAppState = Provider.of<MyAppState>(context);

    //final choreList = Provider.of<ChoreList>(context);

    //updateFilteredLists(); // updates the filtered chore lists
    //sortChoresByDeadline(); // sorts the chores before building the page

    Widget
        page; // this widget switches between views when navigation rail is used
    switch (myAppState.selectedIndex) {
      case 0: // home
        page = Placeholder();
        //page = ListPage(
        //getChores: getChores,
        //deleteChore: deleteChore,
        //toggleBox: toggleBox,
        //editChoreText: editChoreText,
        //editChoreDeadline: editChoreDeadline);

        //page = ListPage();

        break;
      case 1: // help
        page = HelpPage();
        break;
      case 2: // add chore
        //page = AddPage(addChore); // old version
        //page = AddPage();
        page = Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for ${myAppState.selectedIndex}');
    }

    // builds the main layout surrounding all the pages/views
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: PopupMenuButton<FilterItem>(
                icon: Icon(Icons.filter_alt),
                onSelected: (FilterItem item) {
                  myAppState.setFilter(item);
                  //updateFilteredLists();
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
                  selectedIndex: myAppState.selectedIndex,
                  onDestinationSelected: (value) {
                    myAppState.setIndex(value);
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

// handles all changes to the list with chores
class ChoreList extends ChangeNotifier {
  final List<Chore> _chores = [];

  List<Chore> get chores => _chores;

  // function/method that adds new chores
  void addChore(Chore chore) {
    _chores.add(chore);
    notifyListeners();
    //updateFilteredLists();
  }

  // function that deletes chores from the list
  void deleteChore(Chore chore) {
    _chores.remove(chore);
    notifyListeners();
    //updateFilteredLists();
  }

  // function that changes the chore`s icon when clicked
  void toggleBox(Chore chore) {
    chore.isDone = !chore.isDone;
    notifyListeners();
    //updateFilteredLists(); // update the filter list
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
}

  /*
  // function to update filtered chores
  void updateFilteredLists() {
    _filteredChores.clear(); // clears the lists first to avoid duplicates

    if (selectedFilter == FilterItem.all) {
      _filteredChores = List.from(chores);
    } else if (selectedFilter == FilterItem.done) {
      _filteredChores = filterDoneChores(chores);
    } else if (selectedFilter == FilterItem.undone) {
      _filteredChores = filterUndoneChores(chores);
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
  */
/*
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
    //return getFilteredChores();
    return chores;
  }

  */