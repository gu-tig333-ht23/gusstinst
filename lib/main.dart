import 'package:flutter/material.dart';
import 'chore_item.dart';
import 'chore.dart';

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
      case 0: // home icon
        page = ListPage();
        break;
      case 1: // help icon
        //page = Placeholder(); // just a X right now
        page = HelpPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: [
            IconButton(
              // Filter button
              icon: Icon(Icons.filter_alt),
              tooltip: 'Filter',
              onPressed: () {},
            ),
          ],
        ),
        body: Container(
          color: Theme.of(context).colorScheme.inversePrimary,
          child: Row(
            children: [
              SafeArea(
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const Placeholder(),
              ),
            );
          },
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

    List<Chore> chores = [
      Chore('Clean bathroom'),
      Chore('Fix the computer'),
      Chore('Do homework'),
      Chore('Vacuum bedroom'),
      Chore('Walk the dog'),
      Chore('Workout'),
      Chore('Grocery shopping'),
      Chore('Make the bed'),
      Chore('Make dinner'),
      Chore('Buy more wine'),
      Chore('Wash the car'),
      Chore('Help grandma'),
      Chore('Laundry'),
      Chore('Feed the cat')
    ];
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
    return ListView.builder(
      itemBuilder: (context, index) {
        //return _chore(context, chores[index % chores.length]);
        return ChoreItem(chores[index]);
      },
      itemCount: chores.length,
    );

    /*
    return ListView(
      children: chores.map((chore) => _chore(chore.text)).toList(),
    );
    */
  }
}

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('How does it work?'),
      ],
    );
  }
}
