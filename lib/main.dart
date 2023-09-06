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

  void addChore(Chore chore) {
    setState(() {
      chores.add(chore);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget
        page; // this widget switches between views when navigation rail is used
    switch (selectedIndex) {
      case 0: // home
        page = ListPage(chores);
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
