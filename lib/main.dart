import 'package:flutter/material.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
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

class MyAppState extends ChangeNotifier {
  void toggleChore() {
    // adds, changes look and removes chores from the list
    // TODO
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of the application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget
        page; // this widget switches between views when navigation rail is used
    switch (selectedIndex) {
      case 0:
        //page = Placeholder(); // just a X right now
        page = ListPage();
        break;
      case 1:
        page = Placeholder(); // just a X right now
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      // decides when to extend rail with text labels for the navigation icons
      return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text(widget.title),
            actions: [
              IconButton(
                icon: Icon(Icons.filter_alt),
                tooltip: 'Filter',
                onPressed: () {
                  // nothing happens here yet
                },
              )
            ]),
        body: Row(
          children: [
            SafeArea(
              // Secures that other things don`t overlap this area
              child: NavigationRail(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.add),
                    label: Text('New List'),
                  ),
                  // Put more destinations/icons here (must be at least two!)
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(bottom: 70), // in order to be able
                // to delete the last chore in the list
                child: Container(
                  color: Theme.of(context).colorScheme.onPrimary,
                  child:
                      page, // switches between different pages according to the widget 'page'
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {}, // does nothing right now
          tooltip: 'Add chore',
          child: const Icon(Icons.add),
        ),
      );
    });
  }
}

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<MyAppState>();

/*
    void toggleBox() {
      setState(() {
        if (iconData == Icons.check_box_outline_blank_outlined) {
          iconData = Icons.check_box;
        } else {
          iconData = Icons.check_box_outline_blank_outlined;
        }
      });
    }
*/
    return ListView(
      children: [
        _chore('Clean bathroom'),
        _chore('Fix the computer'),
        _chore('Do homework'),
        _chore('Vacuum bedroom'),
        _chore('Walk the dog'),
        _chore('Workout'),
        _chore('Grocery shopping'),
        _chore('Make the bed'),
        _chore('Make dinner'),
        _chore('Buy more wine'),
        _chore('Wash the car'),
        _chore('Help grandma'),
        _chore('Laundry'),
      ],
    );
  }
}

Widget _chore(String text) {
  return Column(
    children: [
      Padding(
        padding: EdgeInsets.all(3),
        child: Row(
          children: [
            IconButton(
                icon: Icon(Icons.check_box_outline_blank_outlined),
                tooltip: 'Mark as done',
                onPressed: () {}
                //toggleBox();, // Does nothing right now
                ),
            Text(text,
                style: TextStyle(fontSize: 18, fontFamily: 'Times New Roman')),
            Spacer(),
            IconButton(
              icon: Icon(Icons.delete),
              tooltip: 'Delete',
              onPressed: () {}, // does nothing right now
            ),
          ],
        ),
      ),
    ],
  );
}

/*
class Chore extends StatelessWidget {
  Chore(this.text, this.deadline);

  
}

class ChoreCard extends StatelessWidget {
  final String text;
  final DateTime deadline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(text),
      ),
    );
  }
}
*/
