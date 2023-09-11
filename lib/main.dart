import 'package:flutter/material.dart';
import 'add_page.dart';
import 'chore.dart';
import 'help_page.dart';
import 'list_page.dart';

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
  var selectedIndex = 0;
  List<Chore> chores = [];

  // function/method that adds new chores
  void addChore(Chore chore) {
    setState(() {
      chores.add(chore);
    });
  }

  // function that deletes chores from the list
  void deleteChore(Chore chore) {
    setState(() {
      chores.remove(chore);
    });
  }

  // function that changes the chore`s icon when clicked
  void toggleBox(Chore chore) {
    setState(() {
      chore.isDone = !chore.isDone;
    });
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

  @override
  Widget build(BuildContext context) {
    Widget
        page; // this widget switches between views when navigation rail is used
    switch (selectedIndex) {
      case 0: // home
        page = ListPage(chores,
            deleteChore: deleteChore,
            toggleBox: toggleBox,
            editChoreText: editChoreText,
            editChoreDeadline: editChoreDeadline);
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
                  setState(() {});
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
