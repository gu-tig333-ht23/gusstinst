import 'package:flutter/material.dart';
import 'add_page.dart';
import 'help_page.dart';
import 'list_page.dart';
import 'package:provider/provider.dart';
import 'chore_list.dart';

// For the popupButton, filtering chores
enum FilterItem { all, done, undone }

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              MyAppState(), // tracks the selected filter and the page index
        ),
        ChangeNotifierProvider(
          create: (context) => ChoreList(), // tracks the list with chores
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyAppState extends ChangeNotifier {
  var selectedIndex = 0;
  FilterItem selectedFilter = FilterItem.all; // shows all by default

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

  @override
  Widget build(BuildContext context) {
    final myAppState = Provider.of<MyAppState>(context);

    Widget
        page; // this widget switches between views when navigation rail is used
    switch (myAppState.selectedIndex) {
      case 0: // home
        page = ListPage();
        break;
      case 1: // help
        page = HelpPage();
        break;
      case 2: // add chore
        page = AddPage();
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
              /*
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.green),
                      padding: EdgeInsets.all(4),
                      child: Text('Chill'),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.yellow),
                      padding: EdgeInsets.all(4),
                      child: Text('Move on'),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.orange),
                      padding: EdgeInsets.all(4),
                      child: Text('Hurry'),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color.fromARGB(255, 79, 8, 3)),
                      padding: EdgeInsets.all(4),
                      child:
                          Text('Late', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            */
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
