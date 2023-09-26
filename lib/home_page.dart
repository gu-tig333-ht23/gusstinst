import 'package:flutter/material.dart';
import 'list_page.dart';
import 'help_page.dart';
import 'add_page.dart';
import 'main.dart';
import 'package:provider/provider.dart';

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
          toolbarHeight: kToolbarHeight + 6,
          actions: [
            Column(
              children: [
                Expanded(
                  child: PopupMenuButton<FilterItem>(
                    tooltip: 'Filter chores',
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
                Padding(
                  padding: const EdgeInsets.only(right: 10.0, bottom: 3),
                  child: Text(
                      'Current filter: ${myAppState.selectedFilter.name}',
                      style: TextStyle(fontSize: 12)),
                ),
              ],
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
                    child: page, // here goes listpage, addpage or helppage
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
